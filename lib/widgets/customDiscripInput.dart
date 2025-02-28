import 'package:flutter/material.dart';

class CustomDiscripinput extends StatelessWidget {
  final TextEditingController myController;

  const CustomDiscripinput({super.key, required this.myController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      cursorColor: Colors.blue, // Set cursor color to blue
      decoration: InputDecoration(
        labelText: "Description",
        alignLabelWithHint: true,
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
      maxLines: null,
      minLines: 5,
      expands: false,
    );
  }
}
