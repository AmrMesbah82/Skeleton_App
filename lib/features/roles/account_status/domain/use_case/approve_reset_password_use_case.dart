import 'package:dartz/dartz.dart';
import 'package:demo_app/features/notification/notification_controller.dart';
import 'package:get/get.dart';
// REMOVED_MODULE: import 'package:demo_app/features/skeleton/controllers/notification_controller.dart';
import 'package:demo_app/features/roles/account_status/domain/entity/account_status_access_entity.dart';

import '../../../../../core/network/failure_model.dart';
import '../../data/repository/account_status_repository.dart';

class ApproveResetPasswordUseCase {
  final AccountStatusRepository repository;

  ApproveResetPasswordUseCase(this.repository);

  Future<Either<Failure, dynamic>> execute(
      AccountStatusAccessEntity accountStatusAccessEntity) async {
    Either<Failure, dynamic> result =
        await repository.approveResetPassword(accountStatusAccessEntity);
    Get.find<AppNotificationController>().sendNotification(
        type: 'employee',
        topic: accountStatusAccessEntity.email,
        title: 'Request Reset Password',
        arabicTitle: 'طلب إعادة تعيين كلمة المرور',
        body:
            'Your Request Has Been Approved By Admin, You Can Login With Your New Password Now',
        arabicBody:
            'لقد تمت الموافقة على طلبك من قبل المشرف، يمكنك تسجيل الدخول باستخدام كلمة المرور الجديدة الخاصة بك الآن'

    );
    return result;
  }
}
