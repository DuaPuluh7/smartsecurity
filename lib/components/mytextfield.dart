import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import InputFormatter

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String fontFamily;
  final IconData icon;
  final bool isObscure; // Add the property to control obscureText
  final List<TextInputFormatter>? inputFormatter; // Tambahkan inputFormatter

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.fontFamily,
    required this.icon,
    this.isObscure = false,
    this.inputFormatter, // Tambahkan inputFormatter sebagai parameter opsional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isObscure,
              inputFormatters: inputFormatter, // Gunakan inputFormatter di sini
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontFamily: fontFamily,
                ),
                prefixIcon: Icon(
                  icon,
                  color: Colors.grey[600],
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
