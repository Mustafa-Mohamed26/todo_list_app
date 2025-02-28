import 'package:flutter/material.dart';

class PriorityRadioButton extends StatelessWidget {
  final String label;
  final int value;
  final int? selectedPriority;
  final ValueChanged<int> onChanged;

  const PriorityRadioButton({
    super.key,
    required this.label,
    required this.value,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedPriority == value ? Colors.blue : Colors.grey,
                width: 2,
              ),
              color: selectedPriority == value ? Colors.blue : Colors.white,
            ),
            child: selectedPriority == value
                ? Icon(Icons.check, size: 20.0, color: Colors.white)
                : null,
          ),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}