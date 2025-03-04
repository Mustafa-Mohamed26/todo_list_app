import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/customCategory.dart';
import 'package:todo_list_app/widgets/customDeadline.dart';
import 'package:todo_list_app/widgets/customDiscripInput.dart';
import 'package:todo_list_app/widgets/customPriority.dart';
import 'package:todo_list_app/widgets/customTime.dart';
import 'package:todo_list_app/widgets/customTitleInput.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  // Controllers to control the data input coming from the Text Fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // Key for validation
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  // Selected category and priority
  String? selectedCategory;
  int? selectedPriority;

  // This method controls the save todos operation in the application
  void saveTodo() {
    if (formState.currentState!.validate()) {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      final newTodo = Todo(
        title: titleController.text,
        description: descriptionController.text,
        category: selectedCategory ?? '',
        deadline:
            deadlineController.text.isNotEmpty
                ? DateTime.parse(deadlineController.text)
                : null,
        time:
            timeController.text.isNotEmpty
                ? TimeOfDay(
                  hour: int.parse(timeController.text.split(':')[0]),
                  minute: int.parse(timeController.text.split(':')[1]),
                )
                : null,
        priority: selectedPriority ?? 1,
      );

      todoProvider.addTodo(newTodo);

      titleController.clear();
      descriptionController.clear();
      deadlineController.clear();
      timeController.clear();

      // Show success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        desc: 'Your task has been saved successfully!',
        btnOkOnPress: () {
          Navigator.pop(context); // Close the screen after confirmation
        },
      ).show();
    }
  }

  // After closing the bottom sheet, the controllers delete their data
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // This method builds the UI of the bottom sheet
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 50.0,
          ),
          child: Form(
            key: formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =========================Title=========================
                SizedBox(
                  width: double.infinity,
                  child: CustomTitleInput(
                    myController: titleController,
                    valid: (val) {
                      if (val!.isEmpty) {
                        return "Field is empty";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                // =========================Description=========================
                CustomDiscripinput(myController: descriptionController),
                SizedBox(height: 20),
                // =========================Category=========================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                CustomCategory(
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
                SizedBox(height: 20),
                // =========================Deadline=========================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Set Deadline',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                CustomDeadline(
                  deadlineController: deadlineController,
                  onDateSelected: (pickedDate) {
                    setState(() {
                      deadlineController.text =
                          "${pickedDate!.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  },
                ),
                SizedBox(height: 20),
                // =========================Time=========================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Set Time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                CustomTime(
                  timeController: timeController,
                  onTimeSelected: (pickedTime) {
                    setState(() {
                      timeController.text =
                          "${pickedTime!.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                    });
                  },
                ),
                SizedBox(height: 20),
                // =========================Priority=========================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Set Priority',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                CustomPriority(
                  selectedPriority: selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                // =========================Save Button=========================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: saveTodo,
                    child: Text("Save", style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
