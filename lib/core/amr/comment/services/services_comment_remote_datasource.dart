import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_app/core/services/firebase/repository/firebase_repository.dart';
import 'package:demo_app/core/network/failure_model.dart';
import 'package:demo_app/core/network/api_constants.dart'; // ✅ Import ApiConstants

class ServicesCommentRemoteDataSource {
  /// ✅ Get dynamic collection path based on current company
  String get _commentsCollectionPath {
    // ApiConstants.baseUri is set during login as "Demo/{companyId}"
    // Example: "Demo/75440689" → "Demo/75440689/Comments"
    return '${ApiConstants.baseUri}/Comments';
  }

  /// ✅ Get dynamic company ID from ApiConstants.baseUri
  String get _companyId {
    // Extract company ID from "Demo/75440689" → "75440689"
    return ApiConstants.baseUri.split('/').last;
  }

  // Submit comment to Firestore
  Future<Either<Failure, void>> submitComment(
      Map<String, dynamic> commentData, String commentId) async {
    print("📝 Submitting comment to: $_commentsCollectionPath");
    print("   Comment ID: $commentId");

    return await FirebaseRepository.setDocumentWithId(
      collection: _commentsCollectionPath, // ✅ Dynamic path
      data: commentData,
      documentId: commentId,
    );
  }

  // Upload media file
  Future<Either<Failure, String>> uploadMedia(String mediaPath) async {
    print("📤 Uploading media for company: $_companyId");
    print("   File path: $mediaPath");

    return await FirebaseRepository.uploadFile(
      filePath: mediaPath,
      collectionName: _commentsCollectionPath, // ✅ Dynamic path
      documentName: mediaPath.split('/').last,
    );
  }

  // Get stream of comments filtered by Request_Id
  Stream<Either<Failure, List<dynamic>>> getStreamOfComments({
    required String requestId,
  }) async* {
    print("🔍 Setting up comment stream");
    print("   Collection: $_commentsCollectionPath");
    print("   Request ID: $requestId");
    print("   Company ID: $_companyId");

    yield* FirebaseFirestore.instance
        .collection(_commentsCollectionPath) // ✅ Dynamic path
        .where('Request_Id', isEqualTo: requestId)
        .snapshots()
        .map((snapshot) {
      try {
        print("📨 Received snapshot: ${snapshot.docs.length} documents");

        final comments = snapshot.docs.map((doc) {
          final data = doc.data();
          data['_documentId'] = doc.id;
          print("   - Comment: ${doc.id} (${data['Comment_Text']})");
          return data;
        }).toList();

        // Sort by Comment_Date in memory
        comments.sort((a, b) {
          final aDate = a['Comment_Date'] as Timestamp?;
          final bDate = b['Comment_Date'] as Timestamp?;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return aDate.compareTo(bDate);
        });

        print("✅ Returning ${comments.length} sorted comments");
        return Right<Failure, List<dynamic>>(comments);
      } catch (e, stack) {
        print("❌ Error in stream mapping: $e");
        print("Stack: $stack");
        return Left<Failure, List<dynamic>>(
          FirebaseFailure('Error loading comments: $e'),
        );
      }
    });
  }
}