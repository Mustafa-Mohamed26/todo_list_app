import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/customDiscripInput.dart';
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

  // Key for validation
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  // Selected category
  String? selectedCategory;

  // This method controls the save todos operation in the application
  void saveTodo() {
    if (formState.currentState!.validate()) {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      final newTodo = Todo(
        title: titleController.text,
        description: descriptionController.text,
        category: selectedCategory ?? '',
        deadline: null,
        priority: 1,
      ); // create a Todo object
      todoProvider.addTodo(
        newTodo,
      ); // add the new object to the provider and the database
      titleController.clear(); // Clear the title text field
      descriptionController.clear(); // Clear the description text field
      Navigator.pop(context);
    }
  }

  // After closing the bottom sheet, the controllers delete their data
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
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
            top: 16.0,
          ),
          child: Form(
            key: formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                CustomDiscripinput(myController: descriptionController),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 15,
                  children:
                      ['Work', 'Education', 'Shopping', 'Personal', 'Home'].map(
                        (category) {
                          return ChoiceChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = selected ? category : null;
                              });
                            },
                            selectedColor: Colors.blue,
                            backgroundColor: Colors.grey,
                            labelStyle: TextStyle(
                              color:
                                  selectedCategory == category
                                      ? Colors.white
                                      : Colors.black,
                              fontSize: 16,
                            ),
                          );
                        },
                      ).toList(),
                ),
                SizedBox(height: 20),
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
