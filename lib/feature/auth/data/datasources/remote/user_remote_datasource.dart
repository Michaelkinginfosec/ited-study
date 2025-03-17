import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/auth/domain/entities/user_entity.dart';
import '../../../../../core/errors/errors.dart';
import '../../../../notes/domain/model/topics.dart';
import '../../models/update_data.dart';

abstract class UsersRemoteDataSource {
  Future<void> updateUser(UpdateUserData updateData);
  Future<String> signUp(Users user);
  Future<String> verifyOTP(String otp);
  Future<String> login(String email, String password);
  Future<void> storeToken(String token);
  Future<void> storeUserId(String userId);
  Future<String> logOut();
  Future<void> clearUser();
  Future<Users> getUser(String userId);
  Future<void> storeUser(Users user);
  Future<String> resendVerificationCode(String email);
  Future<String> changePassword(String oldPassword, String newPassword);
  Future<List<String>> countries();
  Future<void> createSchool(String schoolName, String country);
  Future<String> uploadImage(Uint8List? image);
  Future<String> activateApp(String code, String device, String model,
      String osVersion, String uniqueId, String semester);
  Future<String?> resetPassword(String otp, String newPassword);

  Future<void> getCountries();
  Future<String?> sendResetOTP(String email);
}

class UserRemoteDatasourceImp implements UsersRemoteDataSource {
  final Dio dio;

  UserRemoteDatasourceImp(this.dio);

  @override
  Future<String> signUp(Users user) async {
    try {
      final response = await dio.post(
        '/users/create-account',
        data: user.toEntity().toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;

          dynamic message = responseData['message'];

          if (message is String) {
            return message;
          } else if (message is List) {
            return message.join(', ');
          } else {
            throw SignUpException('Unexpected message format');
          }
        } else {
          throw SignUpException('Unexpected response format');
        }
      } else {
        throw SignUpException(
            'Sign up failed with status code: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        if (dioError.response!.statusCode == 409) {
          throw SignUpException('Email already exists');
        } else {
          dynamic message = dioError.response!.data['message'];

          if (message is String) {
            throw SignUpException(message);
          } else if (message is List) {
            throw SignUpException(message.join(', '));
          } else {
            throw SignUpException(
                'Sign up failed with an unexpected message format');
          }
        }
      } else {
        throw SignUpException('Network or server error');
      }
    } catch (e) {
      throw SignUpException('Unexpected error occurred: $e');
    }
  }

  Future<void> storeSchoolId(String schoolId) async {
    var box = Hive.box('school');
    await box.put('schoolId', schoolId);
  }

  @override
  Future<void> createSchool(String schoolName, String country) async {
    try {
      final countryData = await createCountry(country);

      final String countryId = countryData['countryId'];

      final response = await dio.post(
        '/notes/create-school/',
        data: {
          "school": schoolName,
          "countryId": countryId,
        },
      );

      if (response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData['message'] != null &&
              responseData['message'] == "school created") {
            final schoolId = responseData['schoolId'];

            if (schoolId != null) {
              await storeSchoolId(schoolId);
            }
          } else if (responseData['message'] != null &&
              responseData['message'] == "school already exist") {
            final schoolId = responseData['schoolId'];

            if (schoolId != null) {
              await storeSchoolId(schoolId);
            }
          }
        } else {
          throw SignUpException('Unexpected response format');
        }
      } else {
        throw SignUpException(
            'Failed to create school with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          throw SignUpException('School already exists');
        } else {
          throw SignUpException('Unexpected error occurred');
        }
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> createCountry(String countryName) async {
    try {
      final response = await dio.post(
        '/notes/create-country',
        data: {
          "country": countryName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData['message'] != null &&
              responseData['message'] == "country created") {
            final country = responseData['country'];
            final countryId = responseData['countryId'];
            return {
              'country': country,
              'countryId': countryId,
            };
          } else if (responseData['message'] != null &&
              responseData['message'] == "country already exist") {
            final country = responseData['country'];
            final countryId = responseData['countryId'];

            return {
              'country': country,
              'countryId': countryId,
            };
          } else {
            throw SignUpException('Unexpected response format');
          }
        } else {
          throw SignUpException('Unexpected response format');
        }
      } else {
        throw SignUpException(
            'Failed to create country with status code: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        if (dioError.response!.statusCode == 409) {
          throw SignUpException('Country already exists');
        } else {
          final errorMessage = dioError.response!.data['message'] as String? ??
              'Failed to create country';
          throw SignUpException(errorMessage);
        }
      } else {
        throw SignUpException('Network or server error');
      }
    } catch (e) {
      throw SignUpException('Unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<String> verifyOTP(String otp) async {
    try {
      final response = await dio.post(
        '/users/verify-otp',
        data: {'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final message =
              responseData['message'] as String? ?? 'No message available';
          return message;
        } else {
          throw VerifyOTPException('Unexpected response format');
        }
      } else {
        throw VerifyOTPException(
            'Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        if (dioError.response!.statusCode == 401) {
          throw VerifyOTPException('Invalid or expired OTP');
        } else {
          final errorMessage = dioError.response!.data['message'] as String? ??
              'Failed to verify OTP';
          throw VerifyOTPException(errorMessage);
        }
      } else {
        throw VerifyOTPException('Network or server error');
      }
    } catch (e) {
      throw VerifyOTPException('Unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final userId = responseData['userId'] as String?;

          if (userId != null) {
            await storeUserId(userId);

            final user = await getUser(userId);

            await storeUser(user);
          }
          final token = responseData['accessToken'] as String?;

          if (token != null) {
            await storeToken(token);
          }

          final message =
              responseData['message'] as String? ?? 'Logged in successfully';
          return message;
        } else {
          throw LoginException('Unexpected response format');
        }
      } else {
        throw LoginException(
            'Failed with status code: ${response.statusCode} ');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        if (dioError.response!.statusCode == 401 &&
            dioError.response!.statusMessage ==
                "User is not verified, verify your account to login") {
          throw LoginException('verify your email to continue');
        } else if (dioError.response!.statusCode == 401 &&
            dioError.response!.statusMessage == "Unauthorized") {
          throw LoginException("Invalid Credentials");
        } else {
          throw LoginException('Failed to login');
        }
      } else {
        throw LoginException('Network or server error');
      }
    } catch (e) {
      throw LoginException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<Users> getUser(String userId) async {
    try {
      final response = await dio.get('/users/$userId');
      if (response.statusCode == 200) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final userEntity =
              UserEntity.fromMap(response.data as Map<String, dynamic>);

          return Users.fromEntity(userEntity);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        if (dioError.response!.statusCode == 404 ||
            dioError.response!.statusCode == 400) {
          throw Exception('User not found');
        } else {
          throw Exception(dioError.response!.data['message'] as String? ??
              'Failed to fetch user');
        }
      } else {
        throw Exception('Network or server error');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<String> resendVerificationCode(String email) async {
    try {
      final response =
          await dio.post("/users/resend-verification", data: {"email": email});
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final message = responseData['message'] as String? ?? 'otp sent';
          return message;
        } else {
          throw ResendCodeException("Unexpected response format!");
        }
      } else {
        throw ResendCodeException("Resend OTP failed:  ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        if (dioError.response!.statusCode == 404) {
          throw ResendCodeException("User not found!");
        } else if (dioError.response!.statusCode == 400) {
          throw ResendCodeException("User verified");
        } else {
          throw Exception(dioError.response!.data['message'] as String? ??
              "can't send OTP code");
        }
      } else {
        throw ResendCodeException("Network or server error");
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<void> storeUser(Users user) async {
    var box = Hive.box("usersBox");
    await box.put("users", user);
  }

  @override
  Future<void> storeToken(String token) async {
    var box = Hive.box("sessionBox");
    await box.put("token", token);
  }

  @override
  Future<void> storeUserId(String userId) async {
    var box = Hive.box("sessionBox");
    await box.put("userId", userId);
  }

  @override
  Future<void> clearUser() async {
    var box = Hive.box("sessionBox");
    await box.delete("token");
    await box.delete('userId');
  }

  @override
  Future<String> logOut() async {
    await clearUser();
    return 'Logged out successfully';
  }

  @override
  Future<String> updateUser(UpdateUserData updateData) async {
    var box = Hive.box('sessionBox');
    var userId = box.get('userId');
    var token = box.get('token');

    if (userId == null) {
      throw Exception('User not found');
    }
    if (token == null) {
      throw Exception('Unauthorized');
    }

    try {
      final response = await dio.patch(
        '/users/update/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: updateData.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final message =
              responseData['message'] as String? ?? 'Updated successfully';

          final user = await getUser(userId);

          await storeUser(user);
          return message;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          throw Exception('User not found');
        } else if (e.response!.statusCode == 401) {
          throw Exception('Unauthorized: Invalid token or session expired');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<String> changePassword(String oldPassword, String newPassword) async {
    var box = Hive.box('sessionBox');
    var userId = box.get('userId');

    if (userId == null) {
      throw Exception('User not found');
    }

    try {
      final response = await dio.patch(
        '/users/change-password/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final message = responseData['message'] as String? ??
              'Password Changed  successfully';
          return message;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          throw Exception('User not found');
        } else if (e.response!.statusCode == 401) {
          throw Exception('Unauthorized: Invalid token or session expired');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<String>> countries() async {
    try {
      final response = await dio.get('/users/country');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is List) {
          final responseData = response.data as Map<String, dynamic>;
          final countries = responseData['country'] as List;

          return countries.map((country) => country as String).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404 || e.response!.statusCode == 400) {
          throw Exception('Failed to get countries');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<void> getTopics() async {
    try {
      final response = await dio.get('/notes/course-topics');
      if (response.statusCode == 200) {
        if (response.data is List) {
          List<Topics> topics = (response.data as List)
              .map((json) => Topics.fromJson(json as Map<String, dynamic>))
              .toList();

          await storeTopics(topics);
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404 || e.response!.statusCode == 400) {
          throw Exception('No topics available');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> storeTopics(List<Topics> topics) async {
    var box = await Hive.openBox<Topics>('topics');
    for (var topic in topics) {
      await box.put(topic.courseId, topic);
    }
  }

  @override
  Future<String> uploadImage(Uint8List? imageBytes) async {
    var box = Hive.box('sessionBox');
    var userId = box.get('userId');
    var token = box.get('token');

    if (userId == null) {
      throw Exception('User not found');
    }
    if (token == null) {
      throw Exception('Unauthorized');
    }
    if (imageBytes == null) {
      throw Exception("Image is empty");
    }

    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        imageBytes,
        filename: 'course_image.jpg',
      ),
    });

    try {
      final response = await dio.post(
        '/users/upload-image/',
        data: formData,
      );

      if (response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final imageUrl = responseData['url'] as String?;
          if (imageUrl != null) {
            await dio.patch(
              '/users/update/$userId',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ),
              data: {'imageUrl': imageUrl},
            );
            final user = await getUser(userId);
            await storeUser(user);
            return imageUrl;
          } else {
            throw Exception('Image URL is missing in the response');
          }
        } else {
          throw Exception('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'The request took too long to complete. Please try again later.');
      } else if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Unknown error occurred';
        throw Exception(message);
      } else {
        throw Exception('Network error occurred: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<String> activateApp(String code, String device, String model,
      String osVersion, String uniqueId, String semester) async {
    var box = Hive.box('sessionBox');
    var userId = box.get('userId');
    var token = box.get('token');

    if (userId == null) {
      throw Exception('User not found');
    }
    if (token == null) {
      throw Exception('Unauthorized');
    }

    try {
      final response = await dio.post(
        '/users/activate',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "code": code,
          "userId": userId,
          "device": device,
          "deviceModel": model,
          "osVersion": osVersion,
          "uniqueId": uniqueId,
          "semester": semester,
        },
      );

      if (response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final message = responseData['message'] as String? ??
              'App activated successfully';

          final user = await getUser(userId);
          await storeUser(user);
          return message;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          final errorMessage = e.response!.data['message'] as String?;
          if (errorMessage == "This device is already activated") {
            throw Exception('This device is already activated');
          } else if (errorMessage == "Activation Code Already Used") {
            throw Exception('Invalid code');
          } else if (errorMessage == "Invalid Activation Code") {
            throw Exception(errorMessage);
          } else {
            throw Exception(
                'Failed with status code1: ${e.response!.statusCode}');
          }
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<void> getCountries() async {
    try {
      final response = await dio.get('/notes/countries');

      if (response.statusCode == 200) {
        if (response.data != null && response.data is List) {
          final countryList = List<String>.from(response.data);
          for (String country in countryList) {
            await getSchools(country);
          }

          var box = Hive.box('countries');
          await box.put('countryList', countryList);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        final errorMessage = e.response!.data['message'] as String?;
        if (errorMessage != null) {
          throw Exception(errorMessage);
        }
      }
      throw Exception('Failed with status code: ${e.response?.statusCode}');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<void> getSchools(String country) async {
    try {
      final response = await dio.get('/notes/schools');

      if (response.statusCode == 200) {
        if (response.data != null && response.data is List) {
          final schoolList = List<String>.from(response.data);

          var box = Hive.box('countries');
          await box.put(country, schoolList);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        final errorMessage = e.response!.data['message'] as String?;
        if (errorMessage != null) {
          throw Exception(errorMessage);
        }
      }
      throw Exception('Failed with status code: ${e.response?.statusCode}');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<String?> sendResetOTP(String email) async {
    try {
      final response =
          await dio.post("/users/send-reset-link", data: {"email": email});
      if (response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final message = responseData['message'] as String? ??
              'If the email exist you will receive an reset OTP';
          return message;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          throw Exception('Email is required');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<String?> resetPassword(String otp, String password) async {
    try {
      final response = await dio.patch("/users/reset-password",
          data: {"otp": otp, "newPassword": password});
      if (response.statusCode == 200) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final message = responseData['message'] as String? ??
              'Password successfully reset';
          return message;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          throw Exception('OTP is Required');
        } else if (e.response!.statusCode == 401) {
          throw Exception('Invalid or EXpired Code');
        } else {
          throw Exception(
              'Failed with status code: ${e.response!.statusCode} and ${e.response!.statusMessage}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
