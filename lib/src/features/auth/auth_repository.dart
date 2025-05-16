import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit_user/src/common/model/user_authentication_model.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //! ################### SIGN UP WITH EMAIL AND PASSWORD ###################
  Future<Either<String, UserAuthenticationModel>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final adminCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (adminCredential.user != null) {
        final admin = adminCredential.user!;
        final adminModel = UserAuthenticationModel(
          id: admin.uid,
          imageUrl: '',
          phoneNumber: phoneNumber,

          name: name,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(admin.uid)
            .set(adminModel.toJson());
        return Right(adminModel);
      } else {
        return const Left('User not created');
      }
    } on FirebaseAuthException catch (e) {
      log("Sign Up Error: ${e.message}");
      return Left(e.message ?? 'An error occurred');
    }
  }

  //! ################### LOGIN WITH EMAIL AND PASSWORD ###################
  Future<Either<String, UserAuthenticationModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        final userModel = UserAuthenticationModel.fromJson(userDoc.data()!);
        return Right(userModel);
      } else {
        return const Left('user not found');
      }
    } on FirebaseAuthException catch (e) {
      log("Login Error: ${e.message}");
      return Left(e.message ?? 'An error occurred');
    }
  }

  //! ################### FORGOT PASSWORD ###################
  Future<Either<String, bool>> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      log("Forgot Password Error: ${e.message}");
      return Left(e.message ?? 'An error occurred');
    }
  }

  //! ################### LOGOUT ###################
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //! ################### GET USER DATA ###################
  Future<Either<String, UserAuthenticationModel>> getUserData({
    required String id,
  }) async {
    try {
      final userDoc = await _firestore.collection('users').doc(id).get();
      return Right(UserAuthenticationModel.fromJson(userDoc.data()!));
    } catch (e) {
      log("Get User Data Error: $e");
      return Left(e.toString());
    }
  }

  //! ################### UPDATE USER DATA ###################
  Future<Either<String, UserAuthenticationModel>> updateUserData({
    required String id,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(id).update(({
        'name': name,
        'phoneNumber': phoneNumber,
        'updatedAt': DateTime.now(),
      }));
      final userDoc = await _firestore.collection('users').doc(id).get();
      return Right(UserAuthenticationModel.fromJson(userDoc.data()!));
    } catch (e) {
      log("Update User Data Error: $e");
      return Left(e.toString());
    }
  }
}
