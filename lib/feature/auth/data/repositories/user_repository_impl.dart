import 'dart:typed_data';

import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

import '../datasources/local/user_local_datasource.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../models/update_data.dart';

class UserRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;
  final UserLocalDatasource userLocalDatasource;

  UserRepositoryImpl(this.remoteDataSource, this.userLocalDatasource);

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
      String osVersion, String uniqueId, String semester) {
    return remoteDataSource.activateApp(
        code, device, model, osVersion, uniqueId, semester);
  }

  @override
  Future<void> getCountries() async {
    return remoteDataSource.getCountries();
  }

  @override
  Future<String?> sendResetOTP(String email) async {
    return remoteDataSource.sendResetOTP(email);
  }

  @override
  Future<String?> resetPassword(String otp, String newPassword) async {
    return remoteDataSource.resetPassword(otp, newPassword);
  }
  //Local Database

  @override
  Future<Users> getStoredUser() async {
    return userLocalDatasource.getStoredUser();
  }

  @override
  Future<List<String>> getStoredCountries() async {
    throw UnimplementedError();
  }
}
