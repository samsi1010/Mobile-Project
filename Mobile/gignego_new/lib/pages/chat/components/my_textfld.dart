import 'package:flutter/material.dart';

class MyTextfld extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextfld({
    super.key, 
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black,), 
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          ),
          
      ),
    );
  }
}