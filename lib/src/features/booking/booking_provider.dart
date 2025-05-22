import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:rentit_user/src/common/model/booking_model.dart';
import 'package:rentit_user/src/common/model/notification_model.dart';
import 'package:rentit_user/src/common/widgets/custom_snackbar.dart';
import 'package:rentit_user/src/features/booking/booking_repository.dart';
import 'package:rentit_user/src/features/car/car_provider.dart';
import 'package:rentit_user/src/features/notification/notification_provider.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();
  // final List<BookingModel> _bookingList = [];
  // List<BookingModel> get bookingList => _bookingList;

  //! ----------------- ADD BOOKING -----------------
  Future<void> addBooking({
    required BookingModel booking,
    required String pickupLocation,
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _bookingRepository.addBooking(booking: booking);
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (success) async {
          final carProvider = Provider.of<CarProvider>(context, listen: false);
          await carProvider.updateCarStatus(
            carId: booking.carId,
            isBooked: true,
            context: context,
          );

          final NotificationModel notificationModel = NotificationModel(
            id: booking.id,
            carId: booking.carId,
            userId: booking.userId,

            pickupLocation: pickupLocation,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),

            isRead: false,
          );
          final notificationProvider = Provider.of<NotificationProvider>(
            context,
            listen: false,
          );
          await notificationProvider.addNotification(
            notificationModel: notificationModel,
          );

          CustomSnackbar.success(context: context, message: success);
          await onSuccess();
        },
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  //! --------------- UPDATE BOOKING ---------------
  Future<void> updateBooking({
    required BookingModel booking,
    required String pickupLocation,
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _bookingRepository.editBooking(booking: booking);
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (success) async {
          final NotificationModel notificationModel = NotificationModel(
            id: booking.id,
            carId: booking.carId,
            userId: booking.userId,

            pickupLocation: pickupLocation,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),

            isRead: false,
          );
          final notificationProvider = Provider.of<NotificationProvider>(
            context,
            listen: false,
          );
          await notificationProvider.addNotification(
            notificationModel: notificationModel,
          );

          CustomSnackbar.success(context: context, message: success);
          onSuccess();
        },
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  //! --------------- DELETE BOOKING ---------------
  Future<void> deleteBooking({
    required String bookingId,
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _bookingRepository.deleteBooking(
        bookingId: bookingId,
      );
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (success) {
          CustomSnackbar.success(context: context, message: success);
          onSuccess();
        },
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }
}
