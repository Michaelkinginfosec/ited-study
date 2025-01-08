// lib/feature/auth/data/repositories/auth_repository_impl.dart

import 'dart:typed_data';

import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

import '../datasources/remoteDataSource/user_remote_datasource.dart';
import '../models/update_data.dart';

class UserRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> signUp(Users user) async {
    return await remoteDataSource.signUp(user);
  }

  @override
  Future<String> verifyOTP(String otp) async {
    return await remoteDataSource.verifyOTP(otp);
  }

  @override
  Future<String> logout() async {
    return await remoteDataSource.logOut();
  }

  @override
  Future<void> storeToken(String token) async {
    await remoteDataSource.storeToken(token);
  }

  @override
  Future<String> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<Users> getUser(String userId) async {
    return await remoteDataSource.getUser(userId);
  }

  @override
  Future<void> storeUser(Users user) async {
    return await remoteDataSource.storeUser(user);
  }

  @override
  Future<String> resendVerificationCode(String email) async {
    return await remoteDataSource.resendVerificationCode(email);
  }

  @override
  Future<void> updateUser(UpdateUserData updateData) async {
    return await remoteDataSource.updateUser(updateData);
  }

  @override
  Future<String> changePassword(String oldPassword, String newPassword) async {
    return await remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<void> createSchool(String schoolName, String country) {
    return remoteDataSource.createSchool(schoolName, country);
  }

  @override
  Future<String> uploadImage(Uint8List? image) {
    return remoteDataSource.uploadImage(image);
  }

  @override
  Future<String> activateApp(String code, String device, String model,
      String osVersion, String uniqueId) {
    return remoteDataSource.activateApp(
        code, device, model, osVersion, uniqueId);
  }
}
