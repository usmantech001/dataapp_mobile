import '../../../../../core/model/core/user.dart';

class SignInArg {
  final User? user;
  final bool biometricAvailable;

  SignInArg({this.user, this.biometricAvailable = false});
}
