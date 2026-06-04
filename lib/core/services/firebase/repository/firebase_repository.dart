import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import '../../../network/failure_model.dart';
import '../models/query_data_model.dart';

class FirebaseRepository {
  static Future<Either<FirebaseFailure, dynamic>>
      getDocumentsWithOneIsNotEqualToFilter(
          {required String collectionPath,
          required String filterKey,
          required dynamic filterValue}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where(filterKey, isNotEqualTo: filterValue)
          .get();
      print(
          "getDocumentsWithOneIsNotEqualToFilter data is ${myData.docs.length}");
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static Future<Either<FirebaseFailure, void>> setMultipleDocuments(
      {required List<QueryDataModel> queryDataModels}) async {
    Either<FirebaseFailure, void> result;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      for (QueryDataModel queryDataModel in queryDataModels) {
        if (queryDataModel.equalFieldsValues == null ||
            queryDataModel.equalFieldsValues!.isEmpty) {
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection(queryDataModel.collectionPath)
              .doc(queryDataModel.documentId);
          batch.set(documentReference, queryDataModel.queryData,
              SetOptions(merge: true));
        } else {
          CollectionReference collectionReference = FirebaseFirestore.instance
              .collection(queryDataModel.collectionPath);
          Query query = collectionReference;
          for (String key in queryDataModel.equalFieldsValues!.keys) {
            query = query.where(key,
                isEqualTo: queryDataModel.equalFieldsValues![key]);
          }
          final querySnapshot = await query.get();

          for (var document in querySnapshot.docs) {
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection(queryDataModel.collectionPath)
                .doc(document.id);
            batch.set(documentReference, queryDataModel.queryData,
                SetOptions(merge: true));
          }
        }
      }
      await batch.commit();
      result = const Right(null);
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static Future<Either<FirebaseFailure, List<Map<String, dynamic>>>>
      getDocumentsWithTwoFieldsValue(
          {required String collectionPath,
          required String field1,
          required dynamic value1,
          required String field2,
          required dynamic value2}) async {
    Either<FirebaseFailure, List<Map<String, dynamic>>> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where(field1, isEqualTo: value1)
          .where(field2, isEqualTo: value2)
          .get();
      List<Map<String, dynamic>> data = _convertQuerySnapshotToMap(myData);
      result = Right(data);
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static List<Map<String, dynamic>> _convertQuerySnapshotToMap(
      QuerySnapshot<Map<String, dynamic>> myData) {
    List<Map<String, dynamic>> data = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> document in myData.docs) {
      data.add(document.data());
    }
    return data;
  }

  static setDocumentWithId(
      {required String collection,
      required Map<String, dynamic> data,
      required String documentId}) async {
    Either<FirebaseFailure, void> result;
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .set(data, SetOptions(merge: true));
      result = const Right(null);
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
      print('Error Adding Document $e');
    }
    return result;
  }

  static uploadFileWithoutHandlingError(
      {required String collectionName,
      required String documentName,
      required String filePath}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final file = storageRef.child(collectionName).child(documentName);
    final ref = await file.putFile(File(filePath));
    final String url = await ref.ref.getDownloadURL();
    return url;
  }

  static getStreamOfCollection(
      {required String collectionPath, required String sortedBy}) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .orderBy(sortedBy)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  static Stream<Either<Failure, List<Map<String, dynamic>>>>
      getStreamOfCollectionSorted(
          {required String collectionPath, required String sortedBy}) async* {
    try {
      final snapshots = FirebaseFirestore.instance
          .collection(collectionPath)
          .orderBy(sortedBy)
          .snapshots();

      await for (final snapshot in snapshots) {
        List<Map<String, dynamic>> data = _convertQuerySnapshotToMap(snapshot);
        yield Right(data);
      }
    } catch (e) {
      print("error in stream");
      yield Left(FirebaseFailure(e.toString()));
    }
  }

  static uploadFile(
      {required String collectionName,
        required String documentName,
        required String filePath}) async
  {
    print('🔥 [uploadFile] ENTERED — collectionName: $collectionName, filePath: $filePath');


    Either<FirebaseFailure, String> result;
    try {
      // 1️⃣ Get the file name safely with unique timestamp to avoid "already finalized" errors
      final rawName = _sanitizeFileName(basename(filePath));
      final ext = rawName.contains('.') ? '.${rawName.split('.').last}' : '';
      final nameWithoutExt = rawName.contains('.') ? rawName.substring(0, rawName.lastIndexOf('.')) : rawName;
      String fileName = '${nameWithoutExt}_${DateTime.now().millisecondsSinceEpoch}$ext';
      // 2️⃣ Create a reference in Firebase Storage
      print("📂 Uploading file: $collectionName/$fileName");
      final storageRef =
      FirebaseStorage.instance.ref().child("$collectionName/$fileName");

      // 3️⃣ Upload based on platform
      UploadTask uploadTask;
      if (kIsWeb) {
        // On web, read as bytes
        final bytes = await File(filePath).readAsBytes();
        uploadTask = storageRef.putData(bytes);
      } else {
        // On mobile/desktop
        uploadTask = storageRef.putFile(File(filePath));
      }

      // 4️⃣ Wait for completion
      final snapshot = await uploadTask;

      // 5️⃣ Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print("✅ File uploaded successfully: $downloadUrl");

      return result = Right(downloadUrl);
    } on FirebaseException catch (e) {
      print("❌ Firebase error: ${e.code} - ${e.message}");
      return result = Left(FirebaseFailure(e.message ?? "Firebase error"));
    } catch (e) {
      print("❌ Unknown error: $e");
      return result = Left(FirebaseFailure(e.toString()));
    }
  }

  static setDocumentWithIdWithBatch(
      {required String collection,
      required Map<String, dynamic> data,
      required String documentId,
      required WriteBatch batch}) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collection).doc(documentId);
    batch.set(documentReference, data, SetOptions(merge: true));
  }

  static updateDocumentWithIdWithBatch(
      {required String collection,
      required Map<String, dynamic> data,
      required String documentId,
      required WriteBatch batch}) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collection).doc(documentId);
    batch.update(documentReference, data);
  }

  static getDocumentWithId(
      {required String collection, required String documentId}) async {
    Either<FirebaseFailure, dynamic> result;

    try {
      final myData = await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .get();
      result = Right(_convertDataToMap(myData));
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }

    return result;
  }

  static _convertDataToMap(DocumentSnapshot<Map<String, dynamic>> myData) {
    return myData.data() as Map<String, dynamic>?;
  }

  static commitBatch({required WriteBatch batch}) async {
    Either<FirebaseFailure, void> result;
    try {
      await batch.commit();
      result = const Right(null);
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static Stream<Either<FirebaseFailure, dynamic>> getStreamDocumentWithId(
      {required String collection, required String documentId}) async* {
    try {
      final snapshots = FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .snapshots(includeMetadataChanges: true);
      await for (final snapshot in snapshots) {
        Map<String, dynamic>? data = snapshot.data();
        yield Right(data);
      }
    } catch (e) {
      yield Left(FirebaseFailure(e.toString()));
    }
  }

  static Stream<Either<FirebaseFailure, dynamic>>
      getStreamOfDocumentsWithOneFieldValueAndHasValueOfList(
          {required String collectionPath,
          required String fieldKey,
          required bool fieldValue,
          required String specificValueInList,
          required String listKey}) async* {
    try {
      final snapshots = FirebaseFirestore.instance
          .collection(collectionPath)
          .where(fieldKey, isEqualTo: fieldValue)
          .where(listKey, arrayContains: specificValueInList)
          .snapshots();
      await for (final snapshot in snapshots) {
        List<Map<String, dynamic>> data = _convertQuerySnapshotToMap(snapshot);
        yield Right(data);
      }
    } catch (e) {
      yield Left(FirebaseFailure(e.toString()));
    }
  }

  static Future<Either<FirebaseFailure, dynamic>> getCollection(
      {required String collectionPath}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData =
          await FirebaseFirestore.instance.collection(collectionPath).get();

      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getEmployee({required String employeeId}) {}

  static Future<Either<FirebaseFailure, dynamic>> getDocumentsWithOneFilter(
      {required String collectionPath,
      required String filterKey,
      required String filterValue}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where(filterKey, isEqualTo: filterValue)
          .get();
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getDocumentWithFieldLasValue(
      {required String collection,
      required String field,
      required String value}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collection)
          .where(field, arrayContains: value)
          .get();

      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getDocumentsContainsFieldValue(
      {required String collectionPath,
      required String field,
      required List<String> values}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where(field, arrayContainsAny: values)
          .get();
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getDocumentsWithThreeConditionsSortedByOneFieldWithLimitOne(
      {required String collectionName,
      required String fieldName1,
      required String fieldValue1,
      required String fieldName2,
      required String fieldValue2,
      required String fieldName3,
      required String fieldValue3,
      required String sortFieldName}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionName)
          .where(fieldName1, isEqualTo: fieldValue1)
          .where(fieldName2, isEqualTo: fieldValue2)
          .where(fieldName3, isEqualTo: fieldValue3)
          .orderBy(sortFieldName, descending: true)
          .limit(1)
          .get();
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      print(
          "Error in getDocumentsWithThreeConditionsSortedByOneFieldWithLimitOne: $e");
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getDocumentsWithThreeConditionsSortedByOneField(
      {required collectionName,
      required fieldName1,
      required fieldValue1,
      required fieldName2,
      required fieldValue2,
      required fieldName3,
      required fieldValue3,
      required sortFieldName}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionName)
          .where(fieldName1, isEqualTo: fieldValue1)
          .where(fieldName2, isEqualTo: fieldValue2)
          .where(fieldName3, isEqualTo: fieldValue3)
          .orderBy(sortFieldName, descending: true)
          .get();
      print(
          "Data fetched with three conditions sorted by one field: ${myData.docs.length} documents");
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      print("Error in getDocumentsWithThreeConditionsSortedByOneField: $e");
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getDocumentsWithTwoConditionsSortedByOneFieldWithLimitOne(
      {required String collectionName,
      required String fieldName1,
      required String fieldValue1,
      required String fieldName2,
      required String fieldValue2,
      required String sortFieldName}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionName)
          .where(fieldName1, isEqualTo: fieldValue1)
          .where(fieldName2, isEqualTo: fieldValue2)
          .orderBy(sortFieldName, descending: true)
          .limit(1)
          .get();
      print(
          "Data fetched with two conditions sorted by one field: ${myData.docs.length} documents");
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      print(
          "Error in getDocumentsWithTwoConditionsSortedByOneFieldWithLimitOne: $e");
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static Stream<Either<Failure, List<dynamic>>>
      getStreamOfDocumentsWithTwoFieldsSortedSorted(
          {required String collectionPath,
          required String firstField,
          required String firstValue,
          required String secondField,
          required String secondValue,
          required String sortedBy}) async* {
    try {
      final snapshots = FirebaseFirestore.instance
          .collection(collectionPath)
          .where(firstField, isEqualTo: firstValue)
          .where(secondField, isEqualTo: secondValue)
          .orderBy(sortedBy)
          .snapshots();

      await for (final snapshot in snapshots) {
        List<Map<String, dynamic>> data = _convertQuerySnapshotToMap(snapshot);
        yield Right(data);
      }
    } catch (e) {
      print("error in stream of documents with two fields sorted: $e");
      yield Left(FirebaseFailure(e.toString()));
    }
  }

  static getNumberOfDocumentsInACollection({required String collection}) async {
    Either<FirebaseFailure, int> result;
    try {
      final myData =
          await FirebaseFirestore.instance.collection(collection).count().get();
      int count = myData.count ?? 0;

      print("Number of documents in collection '$collection': $count");
      result = Right(count);
    } catch (e) {
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getDocumentsWithTwoConditionsSortedByOneField(
      {required String collectionName,
      required String fieldName1,
      required String fieldValue1,
      required String fieldName2,
      required String fieldValue2,
      required String sortFieldName}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      final myData = await FirebaseFirestore.instance
          .collection(collectionName)
          .where(fieldName1, isEqualTo: fieldValue1)
          .where(fieldName2, isEqualTo: fieldValue2)
          .orderBy(sortFieldName, descending: true)
          .get();
      print(
          "Data fetched with two conditions sorted by one field: ${myData.docs.length} documents");
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      print("Error in getDocumentsWithTwoConditionsSortedByOneField: $e");
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static getDocumentsContainsFieldValueWithFilter(
      {required String collectionPath,
      required String field,
      required List<String> values,
      required String filterField,
      required String filterValue}) async {
    Either<FirebaseFailure, dynamic> result;
    try {
      print("values to search: $values");
      final myData = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where(field, arrayContainsAny: values)
          .where(filterField, isEqualTo: filterValue)
          .get();
      print("Data fetched with filter: ${myData.docs.length} documents");
      result = Right(_convertQuerySnapshotToMap(myData));
    } catch (e) {
      print("Error in getDocumentsContainsFieldValueWithFilter: $e");
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static String _sanitizeFileName(String fileName) {
    final illegalChars = RegExp(r'[\\#\$\[\]\*\?\{\}%~]');
    return fileName
        .replaceAll(illegalChars, '_')
        .replaceAll(' ', '_')
        .replaceAll(':', '_'); // Also replace colons for safety
  }
}
