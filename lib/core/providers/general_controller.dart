
import 'package:dataplug/core/model/core/discount.dart';
import 'package:dataplug/core/model/core/service_charge.dart';
import 'package:dataplug/core/repository/general_repo.dart';
import 'package:flutter/material.dart';

class GeneralController extends ChangeNotifier{
  GeneralRepo generalRepo;

  GeneralController({required this.generalRepo});

  ServiceCharge? serviceCharge;
  

  Future<void> getServicesCharge() async{
    try {
      final response = await generalRepo.getServicesCharge();
      serviceCharge = response;
    } catch (e) {
      
    }
  }

  Future<void> getDiscount({
    required String type,
    required String provider,
     String? amount,
     String? code,
     Function(Discount)? onSuccess,
     Function(String)? onError
  }) async{
    try {
      final response = await generalRepo.getDiscount(type: type, provider: provider, amount: amount, code: code);
      print('..discount ${response.toJson()}');
      onSuccess?.call(response);
    } catch (e) {
      print('..faled to get discount ${e.toString()}');
      onError?.call(e.toString());
    }
  }
}