import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit_user/src/common/model/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! ############ ADD NOTIFICATION ############
  Future<Either<String, String>> addNotification({
    required NotificationModel notificationModel,
  }) async {
    try {
      await _firestore
          .collection('notifications')
          .add(notificationModel.toJson());
      return right('Notification send successfully');
    } catch (e) {
      return left('Failed to send notification: $e');
    }
  }

  //! ############ GET NOTIFICATION  BY ID ############
  Future<Either<String, NotificationModel>> getNotificationById({
    required String notificationId,
  }) async {
    try {
      final doc =
          await _firestore
              .collection('notifications')
              .doc(notificationId)
              .get();
      if (doc.exists) {
        final notification = NotificationModel.fromJson(doc.data()!);
        return right(notification);
      } else {
        return left('Notification not found');
      }
    } catch (e) {
      return left('Failed to get notification: $e');
    }
  }
}
