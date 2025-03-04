import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String label;
  final int count;
  final int selectedIndex;
  final int tabIndex;

  const CustomTab({
    Key? key,
    required this.label,
    required this.count,
    required this.selectedIndex,
    required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$label "),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: selectedIndex == tabIndex ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text("$count", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
