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
}