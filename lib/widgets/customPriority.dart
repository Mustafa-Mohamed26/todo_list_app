import 'package:flutter/material.dart';
import 'package:todo_list_app/widgets/priority_radio_button.dart';

class CustomPriority extends StatefulWidget {
  final int? selectedPriority;
  final Function(int?) onChanged;

  const CustomPriority({
    Key? key,
    required this.selectedPriority,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomPriorityState createState() => _CustomPriorityState();
}

class _CustomPriorityState extends State<CustomPriority> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PriorityRadioButton(
            label: 'Low',
            value: 1,
            selectedPriority: widget.selectedPriority,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: PriorityRadioButton(
            label: 'Medium',
            value: 2,
            selectedPriority: widget.selectedPriority,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: PriorityRadioButton(
            label: 'High',
            value: 3,
            selectedPriority: widget.selectedPriority,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
              });
            },
          ),
        ),
      ],
    );
  }
}
