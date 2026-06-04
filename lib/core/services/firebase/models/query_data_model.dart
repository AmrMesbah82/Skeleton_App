class QueryDataModel {
  String documentId;
  String collectionPath;
  Map<String, dynamic>? equalFieldsValues = {};
  Map<String, dynamic> queryData;
  QueryDataModel(
      {required this.documentId,
      required this.collectionPath,
      this.equalFieldsValues,
      required this.queryData});
}
