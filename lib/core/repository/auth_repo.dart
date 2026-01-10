import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/helpers/auth_helper.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/user.dart';

class AuthRepo {

  Future<User> signIn({required String email, required String password}) async{
    return await AuthHelper.signIn(LoginProvider.password, email: email, password: password);
  }
}