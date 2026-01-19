import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void pushNamed(String routeName, {Object? arguments}){
  final context = navigatorKey.currentContext!;
  Navigator.pushNamed(context, routeName, arguments: arguments);
}

void popScreen(){
  
  final context = navigatorKey.currentContext!;
  Navigator.pop(context);
}

void popAndPushScreen(String routeName, {Object? arguments}){
   final context = navigatorKey.currentContext!;
  Navigator.popAndPushNamed(
          context, routeName, arguments: arguments);
}
void removeAllAndPushScreen(String routeName, {Object? arguments}){
   final context = navigatorKey.currentContext!;
  Navigator.pushNamedAndRemoveUntil(
          context, routeName, (Route<dynamic> route) => false, arguments: arguments);
}

void removeUntilAndPushScreen(String routeName,String routeToKeep ,{Object? arguments}){
   final context = navigatorKey.currentContext!;
  Navigator.pushNamedAndRemoveUntil(
          context, routeName, (Route<dynamic> route) {
            print('....route ${route.settings.name}. route to keep $routeToKeep');
            return route.settings.name == routeToKeep;
          }, arguments: arguments);
}