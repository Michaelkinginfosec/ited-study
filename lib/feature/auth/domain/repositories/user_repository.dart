import 'package:ited_study/feature/auth/data/models/users.dart';

abstract class UsersRepository {
  Future<void> updateUser(String fullName, String department, String level);
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
}
