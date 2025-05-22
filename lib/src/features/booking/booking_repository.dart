import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit_user/src/common/model/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! ------------------ ADD BOOKING --------------------
  Future<Either<String, String>> addBooking({
    required BookingModel booking,
  }) async {
    try {
      _firestore.collection('booking').doc(booking.id).set(booking.toJson());

      return Right("Booking added successfully");
    } catch (e) {
      log("Error Add Booking: ${e.toString()}");
      return Left("Error Add Booking: ${e.toString()}");
    }
  }

  //! ------------------ EDIT BOOKING --------------------
  Future<Either<String, String>> editBooking({
    required BookingModel booking,
  }) async {
    try {
      _firestore.collection('booking').doc(booking.id).update(booking.toJson());

      return Right("Booking updated successfully");
    } catch (e) {
      log("Error Edit Booking: ${e.toString()}");
      return Left("Error Edit Booking: ${e.toString()}");
    }
  }

  //! ------------------ DELETE BOOKING --------------------
  Future<Either<String, String>> deleteBooking({
    required String bookingId,
  }) async {
    try {
      await _firestore.collection('booking').doc(bookingId).delete();

      return Right("Booking deleted successfully");
    } catch (e) {
      log("Error Delete Booking: ${e.toString()}");
      return Left("Error Delete Booking: ${e.toString()}");
    }
  }
}
