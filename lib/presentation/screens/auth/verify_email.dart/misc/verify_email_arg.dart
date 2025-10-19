import '../../../../../core/enum.dart';
import '../../../../../core/model/core/user.dart';

class VerifyEmailArg {
  final EmailVerificationType emailVerificationType;
  final User user;
  final String token;
  final String? password;
  final LoginProvider? loginProvider;

  VerifyEmailArg({
    required this.emailVerificationType,
    required this.user,
    required this.token,
    this.password,
    this.loginProvider,
  });

  //
}
