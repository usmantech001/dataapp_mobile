import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/helpers/auth_helper.dart';
import 'package:dataplug/core/helpers/user_helper.dart';
import 'package:dataplug/core/model/core/user.dart';

class AuthRepo {
  Future<User> signIn({required String email, required String password}) async {
    return await AuthHelper.signIn(LoginProvider.password,
        email: email, password: password);
  }

  Future<String> getResetPasswordOtp(String email) async {
    return await AuthHelper.resendPasswordResetOtp(email: email);
  }

  Future<String> resetPassword(
      {required String email,
      required String otp,
      required String password}) async {
    return await AuthHelper.completePasswordReset(
        email: email, otp: otp, password: password);
  }

  Future<String> changePassword(
      {required String oldPassword, required String newPassword}) async {
    return await UserHelper.updatePassword(
        old_password: oldPassword, password: newPassword);
  }

  Future<Map<String, dynamic>> signUp(
      {required String firstname,
      required String lastname,
      required String email,
      required String password,
      required String phone,
      required String phoneCode}) async {
    return await AuthHelper.signUp(
        firstname: firstname,
        lastname: lastname,
        email: email,
        password: password,
        phone: phone,
        phoneCode: phoneCode);
  }

  Future<String> changeTransactionPin({
    required String oldPin,
    required String newPin,
  }) async{
    return await AuthHelper.updateTransactionPin(old_pin: oldPin, new_pin: newPin);
  }
}
