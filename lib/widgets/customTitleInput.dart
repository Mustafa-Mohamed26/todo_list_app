import 'package:flutter/material.dart';

class CustomTitleInput extends StatelessWidget {
  final TextEditingController myController;
  final String? Function(String?)? valid;
  const CustomTitleInput({
    super.key,
    required this.myController,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: valid,
      controller: myController,
      cursorColor: Colors.blue, // Set cursor color to blue
      decoration: InputDecoration(
        labelText: "Title",
        labelStyle: TextStyle(
          color: Colors.blue,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
