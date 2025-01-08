import 'dart:typed_data';

import 'package:ited_study/feature/auth/data/models/users.dart';

import '../../data/models/update_data.dart';

abstract class UsersRepository {
  Future<void> updateUser(UpdateUserData updateData);
  Future<String> signUp(Users user);
  Future<String> verifyOTP(String otp);
  Future<String> login(String email, String password);
  Future<void> storeToken(String token);
  Future<String> logout();
  Future<Users> getUser(String userId);
  Future<void> storeUser(Users user);
  Future<String> resendVerificationCode(String email);
  Future<String> changePassword(String oldPassword, String newPassword);
  Future<void> createSchool(String schoolName, String country);
  Future<String> uploadImage(Uint8List? image);
  Future<String> activateApp(String code, String device, String model,
      String osVersion, String uniqueId);
}
