class SignUpException implements Exception {
  final String message;

  SignUpException(this.message);

  @override
  String toString() => ' $message';
}

class VerifyOTPException implements Exception {
  final String message;

  VerifyOTPException(this.message);

  @override
  String toString() => ' $message';
}

class LoginException implements Exception {
  final String message;

  LoginException(this.message);

  @override
  String toString() => ' $message';
}

class ResendCodeException implements Exception {
  final String message;

  ResendCodeException(this.message);

  @override
  String toString() => ' $message';
}
