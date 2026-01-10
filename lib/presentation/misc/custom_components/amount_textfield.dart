
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField(
      {super.key, required this.controller, required this.onChanged, this.readOnly = false});
  final Function(String) onChanged;
  final TextEditingController controller;
  final bool readOnly;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
         readOnly? 'Amount' : 'Enter Amount',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              cursorHeight: 30,
              readOnly: readOnly,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
