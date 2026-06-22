import 'package:flutter/material.dart';
import 'package:demo_app/core/theme/app_colors.dart';


class MarketResearchServiceTablet extends StatefulWidget {
  const MarketResearchServiceTablet({super.key});

  @override
  State<MarketResearchServiceTablet> createState() => _MarketResearchServiceTabletState();
}

class _MarketResearchServiceTabletState extends State<MarketResearchServiceTablet> {
  bool showAll = false;

  List<Service> services = List.generate(
    10,
        (index) => Service(
      title: 'Market Research Service',
      doneServices: 20,
      totalHours: 40,
      startDate: '28 May 2020',
    ),
  );

  @override
  Widget build(BuildContext context) {
    int displayCount = showAll ? services.length : 4;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(displayCount, (index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 18,
                    child: ServiceCard(service: services[index]),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() => showAll = !showAll);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showAll ? 'Show less' : 'See all',
                    style:  TextStyle(
                      color: AppColors.blue,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class Service {
  final String title;
  final int doneServices;
  final int totalHours;
  final String startDate;

  Service({
    required this.title,
    required this.doneServices,
    required this.totalHours,
    required this.startDate,
  });
}

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFEAEAEA),
                  child: Icon(Icons.headphones, color: AppColors.black),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    service.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text(
                      "Start Date:",
                      style: TextStyle(color: AppColors.grey, fontSize: 12),
                    ),
                    Text(
                      service.startDate,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            // Stats Row
            Row(
              children: [
                 Text(
                  "Done Services",
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(width: 6),
                Text(
                  service.doneServices.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                 Text(
                  "Total Hours",
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(width: 6),
                Text(
                  service.totalHours.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
