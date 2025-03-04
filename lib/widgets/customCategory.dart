import 'package:flutter/material.dart';

class CustomCategory extends StatefulWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CustomCategory({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CustomCategoryState createState() => _CustomCategoryState();
}

class _CustomCategoryState extends State<CustomCategory> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 15,
      runSpacing: 5,
      children:
          ['Work', 'Education', 'Shopping', 'Personal', 'Home'].map((category) {
            return ChoiceChip(
              showCheckmark: false,
              label: Text(category, style: TextStyle(fontSize: 16)),
              selected: widget.selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  widget.onCategorySelected(selected ? category : null);
                });
              },
              selectedColor: Colors.blue,
              backgroundColor: null,
              side: BorderSide(color: Colors.blue),
              labelStyle: TextStyle(
                color:
                    widget.selectedCategory == category
                        ? Colors.white
                        : Colors.blue,
              ),
            );
          }).toList(),
    );
  }
}
