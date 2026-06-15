import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:demo_app/core/network/services_management/failure_model.dart';
import 'package:demo_app/core/services/services_management/firebase/models/query_data_model.dart';

class FirebaseRepository {
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
          required bool value1,
          required String field2,
          required bool value2}) async {
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
      required String filePath}) async {
    Either<FirebaseFailure, String> result;
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final file = storageRef
          .child(collectionName)
          .child( documentName);
      final ref = await file.putFile(File(filePath));
      final String url = await ref.ref.getDownloadURL();
      result = Right(url);
      print("success at uploading media is $url");
    } catch (e) {

      print("error at uploading media is $e");
      result = Left(FirebaseFailure(e.toString()));
    }
    return result;
  }

  static uploadFileWithoutHandlingError(
      {required String collectionName,
        required String documentName,
        required String filePath}
      ) async
  {
    final storageRef = FirebaseStorage.instance.ref();
    final file = storageRef
        .child(collectionName)
        .child( documentName);
    final ref = await file.putFile(File(filePath));
    final String url = await ref.ref.getDownloadURL();
    return url;
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
      required String filterValue}) async
  {
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
}
