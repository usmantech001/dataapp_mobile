import 'package:flutter/material.dart';

class NullPointerScreen extends StatelessWidget {
  const NullPointerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? nullableString;

    // This line will throw a Flutter null error (NoSuchMethodError)
    // because we try to call toUpperCase() on a null object.
    return Scaffold(
    
      body: Center(
        child: Text(nullableString!.toUpperCase()), // <-- throws here
      ),
    );
  }
}
