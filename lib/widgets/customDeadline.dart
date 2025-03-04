import 'package:flutter/material.dart';

class CustomDeadline extends StatelessWidget {
  final TextEditingController deadlineController;
  final Function(DateTime?) onDateSelected;

  const CustomDeadline({
    super.key,
    required this.deadlineController,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: deadlineController,
      decoration: InputDecoration(
        labelText: 'Deadline',
        labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  onSurface: Colors.blue,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a deadline';
        }
        return null;
      },
    );
  }
}
