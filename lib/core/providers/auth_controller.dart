
import 'package:dataplug/core/repository/auth_repo.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  AuthRepo authRepo;

  AuthController({required this.authRepo});

  Future<void> signIn({required String email, required String password}) async {
    try {
      final user = await authRepo.signIn(email: email, password: password);
    } catch (e) {}
  }

  Future<void> changeTransactionPin({
    required String oldPin,
    required String newPin,
    Function()? onSuccess, Function(String)? onError
  }) async {
    try {
      final res = await authRepo.changeTransactionPin(oldPin: oldPin, newPin: newPin);
      onSuccess?.call();
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  Future<void> resetPassword({
   required String email,
      required String otp,
      required String password,
      Function()? onSuccess, Function(String)? onError
  }) async{
    try {
      await authRepo.resetPassword(email: email, otp: otp, password: password);
      onSuccess?.call();

    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
