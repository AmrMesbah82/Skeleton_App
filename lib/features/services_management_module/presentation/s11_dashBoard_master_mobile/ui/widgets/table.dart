import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/custom/1-custom_dropdwon.dart';

/// ---------- Model ----------
class RequestServiceRow {
  final String id;
  final String department;
  final String serviceName;
  final DateTime? requestedAt;
  final String status;
  final String requester; // optional if you have it denormalized
  final String providerName; // from selectedServiceProvider map

  RequestServiceRow({
    required this.id,
    required this.department,
    required this.serviceName,
    required this.status,
    required this.providerName,
    this.requestedAt,
    this.requester = '',
  });
}

/// ---------- Table Widget ----------
class RequestServicesTable extends StatefulWidget {
  const RequestServicesTable({
    super.key,
    this.pageSize = 50,
    this.collectionPath = 'RequestServices', // wrap with your getBaseUrl if needed
  });

  final int pageSize;
  final String collectionPath;

  @override
  State<RequestServicesTable> createState() => _RequestServicesTableState();
}

class _RequestServicesTableState extends State<RequestServicesTable> {
  final List<RequestServiceRow> _rows = [];
  final ScrollController _scroll = ScrollController();

  // filters
  String? _department;
  String? _status;
  DateTime? _day; // filter by day on serviceNameEnglishTimestamp
  String _search = '';

  // paging
  bool _initialLoading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDoc;

  @override
  void initState() {
    super.initState();
    _fetchFirstPage();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _initialLoading) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      _fetchNextPage();
    }
  }

  Future<void> _fetchFirstPage() async {
    setState(() {
      _initialLoading = true;
      _rows.clear();
      _lastDoc = null;
      _hasMore = true;
    });
    await _loadPage();
    setState(() => _initialLoading = false);
  }

  Future<void> _fetchNextPage() async {
    if (!_hasMore) return;
    setState(() => _loadingMore = true);
    await _loadPage();
    setState(() => _loadingMore = false);
  }

  Query _buildBaseQuery() {
    // Order by the timestamp you already use in your code
    Query q = FirebaseFirestore.instance
        .collection(widget.collectionPath)
        .orderBy('serviceNameEnglishTimestamp', descending: true);

    if (_department != null && _department!.isNotEmpty) {
      q = q.where('departmentRequester', isEqualTo: _department);
    }

    if (_status != null && _status!.isNotEmpty) {
      // you already store top-level 'state'
      q = q.where('state', isEqualTo: _status);
    }

    if (_day != null) {
      // start/end of the selected day on serviceNameEnglishTimestamp
      final start = DateTime(_day!.year, _day!.month, _day!.day);
      final end = start.add(const Duration(days: 1));
      q = q.where('serviceNameEnglishTimestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start));
      q = q.where('serviceNameEnglishTimestamp', isLessThan: Timestamp.fromDate(end));
    }

    return q.limit(widget.pageSize);
  }

  Future<void> _loadPage() async {
    Query q = _buildBaseQuery();
    if (_lastDoc != null) q = q.startAfterDocument(_lastDoc!);

    final snap = await q.get();
    if (snap.docs.isEmpty) {
      _hasMore = false;
      return;
    }

    _lastDoc = snap.docs.last;

    final newRows = <RequestServiceRow>[];
    for (final d in snap.docs) {
      final data = d.data() as Map<String, dynamic>;

      // Denormalized fields (expected to exist to avoid N+1 queries)
      final dept = (data['departmentRequester'] ?? '').toString();
      final name = (data['serviceNameEnglish'] ?? '').toString();
      final status = (data['state'] ?? '').toString().toLowerCase().trim();

      // If you have Arabic/English, swap here as needed
      // final serviceNameArabic = (data['serviceNameArabic'] ?? '').toString();

      DateTime? requestedAt;
      final ts = data['serviceNameEnglishTimestamp'];
      if (ts is Timestamp) requestedAt = ts.toDate();

      // Provider (denormalized in the doc)
      final sp = (data['selectedServiceProvider'] ?? {}) as Map<String, dynamic>;
      final providerName =
      '${(sp['firstName'] ?? '').toString()} ${(sp['lastName'] ?? '').toString()}'.trim();

      // Searchable text
      final searchable = [
        dept,
        name,
        status,
        providerName,
        (data['requestor'] ?? '').toString(),
        (data['serviceNameArabic'] ?? '').toString(),
      ].join(' ').toLowerCase();

      if (_search.isEmpty || searchable.contains(_search)) {
        newRows.add(RequestServiceRow(
          id: d.id,
          department: dept,
          serviceName: name,
          requestedAt: requestedAt,
          status: status,
          providerName: providerName.isEmpty ? 'N/A' : providerName,
          requester: (data['requestor'] ?? '').toString(),
        ));
      }
    }

    _rows.addAll(newRows);
    if (newRows.length < widget.pageSize) _hasMore = false;

    if (mounted) setState(() {});
  }

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _day ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _day = picked);
      _fetchFirstPage();
    }
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '-';
    return DateFormat('yyyy-MM-dd – HH:mm').format(d);
  }

  Color _statusColor(String s, bool light) {
    final key = s.trim().toLowerCase();
    final map = <String, Color>{
      'done': AppColors.green,
      'approved': AppColors.green,
      'inprogress': Colors.amber.shade700,
      'pending': AppColors.orange,
      'rejected': AppColors.darkRed,
      'breached sla': AppColors.red,
      'branchsla': AppColors.red,
      'cancel': AppColors.red,
      'canceled': AppColors.red,
      'cancelled': AppColors.red,
    };
    return map[key] ?? (light ? AppColors.mediumGrey : AppColors.lightGrey);
  }

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --------- Controls: Search + Filters ---------
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: TextField(
                onChanged: (v) {
                  _search = v.trim().toLowerCase();
                  _fetchFirstPage();
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search…',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: _DepartmentDropdown(
                value: _department,
                onChanged: (v) {
                  setState(() => _department = v);
                  _fetchFirstPage();
                },
              ),
            ),
            SizedBox(
              width: 220,
              child: _StatusDropdown(
                value: _status,
                onChanged: (v) {
                  setState(() => _status = v);
                  _fetchFirstPage();
                },
              ),
            ),
            OutlinedButton.icon(
              onPressed: _pickDay,
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(_day == null ? 'Request date' : DateFormat('yyyy-MM-dd').format(_day!)),
            ),
            if (_department != null || _status != null || _day != null || _search.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _department = null;
                    _status = null;
                    _day = null;
                    _search = '';
                  });
                  _fetchFirstPage();
                },
                icon: const Icon(Icons.clear),
                label: Text(S.of(context).Reset),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // --------- Table / Skeleton ---------
        Container(
          decoration: BoxDecoration(
            color: light ? AppColors.white : const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: light ? const Color(0xFFE5E5E5) : const Color(0xFF2A2A2A)),
          ),
          child: _initialLoading
              ? _SkeletonTable(rows: 8)
              : _rows.isEmpty
              ? Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text(S.of(context).noResults)),
          )
              : Scrollbar(
            controller: _scroll,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scroll,
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 16,
                headingRowHeight: 44,
                dataRowMinHeight: 48,
                dataRowMaxHeight: 56,
                columns: [
                  DataColumn(label: Text(S.of(context).no)),
                  DataColumn(label: Text(S.of(context).department)),
                  DataColumn(label: Text(S.of(context).ServiceName)),
                  DataColumn(label: Text(S.of(context).RequestedDate)),
                  DataColumn(label: Text(S.of(context).status)),
                  DataColumn(label: Text(S.of(context).serviceProvider)),
                ],
                rows: List.generate(_rows.length, (i) {
                  final r = _rows[i];
                  return DataRow(
                    cells: [
                      DataCell(Text('${i + 1}')),
                      DataCell(Text(r.department.isEmpty ? '-' : r.department)),
                      DataCell(Text(r.serviceName.isEmpty ? '-' : r.serviceName)),
                      DataCell(Text(_fmtDate(r.requestedAt))),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(r.status, light).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _statusColor(r.status, light)),
                        ),
                        child: Text(
                          r.status.isEmpty ? '-' : r.status,
                          style: TextStyle(
                            color: _statusColor(r.status, light),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                      DataCell(Text(r.providerName)),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),

        // --------- Load more / Progress ---------
        if (!_initialLoading) ...[
          const SizedBox(height: 12),
          if (_loadingMore)
            const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
          else if (_hasMore)
            Center(
              child: OutlinedButton(
                onPressed: _fetchNextPage,
                child: Text(S.of(context).loadMore),
              ),
            )
          else
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(S.of(context).noMoreResults),
              ),
            ),
        ],
      ],
    );
  }
}

/// ---------- Skeleton (instant paint) ----------
class _SkeletonTable extends StatelessWidget {
  const _SkeletonTable({required this.rows});
  final int rows;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final base = light ? AppColors.lightGrey : AppColors.white.withOpacity(0.10);

    Widget bar([double w = 80]) => Container(
      height: 14,
      width: w,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(4),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(rows, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                bar(36),
                const SizedBox(width: 16),
                bar(120),
                const SizedBox(width: 16),
                bar(200),
                const SizedBox(width: 16),
                bar(160),
                const SizedBox(width: 16),
                bar(100),
                const SizedBox(width: 16),
                bar(160),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// ---------- Department filter ----------
class _DepartmentDropdown extends StatelessWidget {
  const _DepartmentDropdown({required this.value, required this.onChanged});
  final String? value;
  final ValueChanged<String?> onChanged;

  // Put the departments you actually have indexed
  static const _items = <String>[
    'Executive',
    'Customer Support',
    'Finance',
    'Operations',
    'Information Technology',
    'Human Resources',
    'Marketing',
    'Sales',
    'Data Management',
    'Compliance & Legal',
    'Software',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      value: value != null && _items.contains(value) ? value : null,
      label: 'Department',
      hint: 'Department',
      items: _items
          .map((d) => DropdownItem<String>(value: d, label: d))
          .toList(),
      onChanged: (v) => onChanged(v),
    );
  }
}

/// ---------- Status filter ----------
class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({required this.value, required this.onChanged});
  final String? value;
  final ValueChanged<String?> onChanged;

  static const _statuses = <String>[
    'approved',
    'done',
    'cancel',
    'rejected',
    'inprogress',
    'branchsla',
    'pending',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      value: value != null && _statuses.contains(value) ? value : null,
      label: 'Status',
      hint: 'Status',
      items: _statuses
          .map((s) => DropdownItem<String>(value: s, label: s))
          .toList(),
      onChanged: (v) => onChanged(v),
    );
  }
}
