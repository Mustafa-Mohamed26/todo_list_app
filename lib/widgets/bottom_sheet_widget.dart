import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/customDiscripInput.dart';
import 'package:todo_list_app/widgets/customTitleInput.dart';
import 'package:todo_list_app/widgets/priority_radio_button.dart';

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
      deadline: deadlineController.text.isNotEmpty
          ? DateTime.parse(deadlineController.text)
          : null,
      priority: selectedPriority ?? 1,
    );

    todoProvider.addTodo(newTodo);
    
    titleController.clear();
    descriptionController.clear();
    deadlineController.clear();

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
                  runSpacing: 5,
                  children:
                      [
                        'Work',
                        'Education',
                        'Shopping',
                        'Personal',
                        'Home',
                      ].map((category) {
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(category, style: TextStyle(fontSize: 16,)),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = selected ? category : null;
                            });
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: null,
                          side: BorderSide(color: Colors.blue),
                          labelStyle: TextStyle(
                            color:
                                selectedCategory == category
                                    ? Colors.white
                                    : Colors.blue,
                          ),
                        );
                      }).toList(),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Set Deadline',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
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
                      setState(() {
                        deadlineController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a deadline';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Set Priority',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PriorityRadioButton(
                        label: 'Low',
                        value: 1,
                        selectedPriority: selectedPriority,
                        onChanged: (value) {
                          setState(() {
                            selectedPriority = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: PriorityRadioButton(
                        label: 'Medium',
                        value: 2,
                        selectedPriority: selectedPriority,
                        onChanged: (value) {
                          setState(() {
                            selectedPriority = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: PriorityRadioButton(
                        label: 'High',
                        value: 3,
                        selectedPriority: selectedPriority,
                        onChanged: (value) {
                          setState(() {
                            selectedPriority = value;
                          });
                        },
                      ),
                    ),
                  ],
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
