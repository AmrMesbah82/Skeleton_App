class ItemData {
  final String itemId;
  final String itemName;
  String itemStatus;

  ItemData({
    required this.itemId,
    required this.itemName,
    required this.itemStatus,
  });

  Map<String, dynamic> toMap() => {
        'itemId': itemId,
        'itemName': itemName,
        'itemStatus': itemStatus,
      };

  factory ItemData.fromMap(Map<String, dynamic> map) => ItemData(
        itemId: map['itemId'] ?? '',
        itemName: map['itemName'] ?? '',
        itemStatus: map['itemStatus'] ?? 'to_do',
      );
}
