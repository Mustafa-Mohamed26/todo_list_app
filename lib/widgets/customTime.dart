import 'package:flutter/material.dart';

class CustomTime extends StatelessWidget {
  final TextEditingController timeController;
  final Function(TimeOfDay?) onTimeSelected;

  const CustomTime({
    Key? key,
    required this.timeController,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: timeController,
      decoration: InputDecoration(
        labelText: 'Time',
        labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        prefixIcon: Icon(Icons.access_time, color: Colors.blue),
      ),
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
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
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a time';
        }
        return null;
      },
    );
  }
}
