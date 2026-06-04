import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_app/core/amr/comment/services/services_comment_remote_datasource.dart';
import 'package:demo_app/core/network/failure_model.dart';

class ServicesCommentRepository {
  final ServicesCommentRemoteDataSource _remoteDataSource = ServicesCommentRemoteDataSource();

  Future<Either<Failure, void>> addComment({
    required String requestId,
    required String currentUserId,
    String? commentText,
    String? mediaPath,
  }) async {
    try {
      print("📝 Adding comment to request: $requestId");
      print("   Text: $commentText");
      print("   Media: $mediaPath");

      String? uploadedMediaUrl;
      String? fileName;
      String? fileSize;

      // Upload media if provided
      if (mediaPath != null) {
        final result = await _remoteDataSource.uploadMedia(mediaPath);
        if (result.isRight()) {
          uploadedMediaUrl = result.getOrElse(() => '');
          fileName = mediaPath.split('/').last;
          fileSize = '0 MB';
        }
      }

      // Create comment data
      final commentData = {
        'Request_Id': requestId,
        'Comment_Id': '${currentUserId}_${DateTime.now().millisecondsSinceEpoch}',
        'Comment_Text': commentText,
        'Commenter_Id': currentUserId,
        'Comment_Date': Timestamp.now(),
        'Comment_Link': uploadedMediaUrl,
        'File_Name': fileName,
        'File_Size': fileSize,
      };

      final commentId = commentData['Comment_Id'] as String;

      print("✅ Submitting comment with ID: $commentId");

      return await _remoteDataSource.submitComment(commentData, commentId);
    } catch (e) {
      print("❌ Error adding comment: $e");
      return Left(FirebaseFailure('Failed to add comment: $e')); // ✅ Use FirebaseFailure
    }
  }

  Stream<Either<Failure, List<Map<String, dynamic>>>> getStreamOfComments({
    required String requestId,
  }) async* {
    print("🔄 Starting comment stream for request: $requestId");

    await for (final result in _remoteDataSource.getStreamOfComments(requestId: requestId)) {
      if (result.isLeft()) {
        yield Left(result.fold(
              (l) => l,
              (r) => const FirebaseFailure('Unknown error'), // ✅ Use FirebaseFailure
        ));
        continue;
      }

      final commentsData = result.getOrElse(() => []);
      final comments = commentsData
          .map((e) => e as Map<String, dynamic>)
          .toList();

      print("📨 Received ${comments.length} comments");
      yield Right(comments);
    }
  }
}