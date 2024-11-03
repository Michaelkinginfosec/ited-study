// lib/feature/auth/data/repositories/auth_repository_impl.dart

import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

import '../datasources/remoteDataSource/user_remote_datasource.dart';

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
  Future<void> updateUser(
      String fullName, String department, String level) async {
    return await remoteDataSource.updateUser(fullName, department, level);
  }

  @override
  Future<String> changePassword(String oldPassword, String newPassword) async {
    return await remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<void> createSchool(String schoolName, String country) {
    return remoteDataSource.createSchool(schoolName, country);
  }
}
