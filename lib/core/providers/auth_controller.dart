import 'package:dataplug/core/repository/auth_repo.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier{
  AuthRepo authRepo;

  AuthController({required this.authRepo});

  Future<void> signIn({
    required String email,
    required String password
  }) async{
    try {
      final user = await authRepo.signIn(email: email, password: password);
    } catch (e) {
      
    }
  }
}