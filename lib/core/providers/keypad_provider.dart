import 'package:flutter/material.dart';

class KeypadProvider extends ChangeNotifier{
  String enteredPin = '';

  void addPin(String value, Function(String) onComplete){
    if(enteredPin.length<4){
      enteredPin+=value;
    notifyListeners();
    if(enteredPin.length ==4){
      onComplete(enteredPin);
     //enteredPin = '';
      
    }
    }
  }
  void setEnterPinEmpty(){
    enteredPin = '';
    notifyListeners();
  }

  void deletePin(){
    if(enteredPin.isNotEmpty){
     // enteredPin--;
     enteredPin = enteredPin.substring(0, enteredPin.length-1);
      notifyListeners();
    }
  }
}