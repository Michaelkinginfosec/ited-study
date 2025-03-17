import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/feature/auth/data/repositories/user_repository_impl.dart';
import 'package:ited_study/feature/auth/domain/usecases/get_countries_usecase.dart';
import 'package:ited_study/feature/auth/domain/usecases/login_usecase.dart';
import 'package:ited_study/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:ited_study/feature/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:ited_study/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ited_study/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:ited_study/feature/notes/data/datasource/course_datasource.dart';
import 'package:ited_study/feature/notes/data/repository/course_repository_impl.dart';
import 'package:ited_study/feature/notes/domain/repository/course_repository.dart';
import 'package:ited_study/feature/notes/domain/usecase/course_usecase.dart';
import 'package:ited_study/feature/notes/domain/usecase/topic_usecase.dart';
import '../../feature/auth/data/datasources/local/user_local_datasource.dart';
import '../../feature/auth/data/datasources/remote/user_remote_datasource.dart';
import '../../feature/auth/domain/repositories/user_repository.dart';
import '../../feature/auth/domain/usecases/change_password_usecase.dart';
import '../../feature/auth/domain/usecases/create_school_usecase.dart';
import '../../feature/auth/domain/usecases/get_stored_user_usecase.dart';
import '../../feature/auth/domain/usecases/resend_verification_code_usecase.dart';
import '../../feature/auth/domain/usecases/sign_up_usecase.dart';
import '../../feature/auth/domain/usecases/update_user_usecase.dart';
import '../../feature/auth/domain/usecases/activate_app_usecase.dart';
import '../../feature/auth/domain/usecases/upload_image_usecase.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) {
    return UserRepositoryImpl(
      ref.read(usersRemoteDataSourceProvider),
      ref.read(userLocalDataSourceProvider),
    );
  },
);

final dioProvider = Provider<Dio>(
  (ref) {
    return Dio(
      BaseOptions(
        baseUrl: 'https://ited-admin-server.onrender.com/api/v1',
      ),
    );
  },
);
final usersRemoteDataSourceProvider = Provider<UsersRemoteDataSource>(
  (ref) {
    return UserRemoteDatasourceImp(
      ref.read(dioProvider),
    );
  },
);
final userLocalDataSourceProvider = Provider<UserLocalDatasource>(
  (ref) {
    return UserLocalDatasource();
  },
);

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) {
    return CourseRepositoryImpl(
      ref.read(courseDatasourceProvider),
    );
  },
);

final courseDatasourceProvider = Provider<CourseDatasource>(
  (ref) {
    return CourseDatasourceImp(
      ref.read(dioProvider),
    );
  },
);

final signUpUseCaseProvider = Provider<SignUpUseCase>(
  (ref) {
    return SignUpUseCase(
      ref.read(usersRepositoryProvider),
    );
  },
);
final getStoredUserUsecaseProvidr = Provider<GetStoredUserUsecase>(
  (ref) {
    return GetStoredUserUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);

final loginUsecaseProvider = Provider<LoginUsecase>(
  (ref) {
    return LoginUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);

final updateUserUsecaseProvidr = Provider<UpdateUserUsecase>(
  (ref) {
    return UpdateUserUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);

final verifyOTPUsecaseProvider = Provider<VerifyOTPUsecase>(
  (ref) {
    return VerifyOTPUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);

final resendOTPUsecaseProvider = Provider<ResendOTPUsecase>(
  (ref) {
    return ResendOTPUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);

final resendVerificationUsecaseProvider = Provider<SendVerificationCodeUsecase>(
  (ref) {
    return SendVerificationCodeUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);
final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>(
  (ref) {
    return ResetPasswordUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);
final logoutUsecaseProvider = Provider<LogoutUsecase>(
  (ref) {
    return LogoutUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);
final countryUsecaseProvider = Provider<GetCountriesUsecase>(
  (ref) {
    return GetCountriesUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);

final changePasswordUsecaseProvider = Provider<ChangePasswordUsecase>(
  (ref) {
    return ChangePasswordUsecase(
      ref.read(usersRepositoryProvider),
    );
  },
);

final createSchoolUsecaseProvider = Provider<CreateSchoolUsecase>(
  (ref) {
    return CreateSchoolUsecase(ref.read(usersRepositoryProvider));
  },
);

final courseUsecaseProvider = Provider<CourseUsecase>(
  (ref) {
    return CourseUsecase(
      ref.read(courseRepositoryProvider),
    );
  },
);
final uploadImageUsecaseProvider = Provider<UploadImageUsecase>((ref) {
  return UploadImageUsecase(ref.read(usersRepositoryProvider));
});
final activateAppUsecaseProvider = Provider<ActivateApp>((ref) {
  return ActivateApp(ref.read(usersRepositoryProvider));
});

final topicUsecaseProvider = Provider<TopicUsecase>(
  (ref) {
    return TopicUsecase(
      ref.read(courseRepositoryProvider),
    );
  },
);
