import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/customDiscripInput.dart';
import 'package:todo_list_app/widgets/customTitleInput.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:todo_list_app/widgets/priority_radio_button.dart';

class NoteDetailScreen extends StatefulWidget {
  final Todo todo;

  const NoteDetailScreen({super.key, required this.todo});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController deadlineController;
  late TextEditingController timeController;

  late TodoProvider todoProvider;

  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  late Todo originalTodo;

  int? selectedPriority;

  List<String> categories = [
    'Work',
    'Education',
    'Shopping',
    'Personal',
    'Home',
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(
      text: widget.todo.description,
    );
    deadlineController = TextEditingController(
      text:
          widget.todo.deadline != null
              ? "${widget.todo.deadline!.year}-${widget.todo.deadline!.month.toString().padLeft(2, '0')}-${widget.todo.deadline!.day.toString().padLeft(2, '0')}"
              : '',
    );
    timeController = TextEditingController(
      text:
          widget.todo.time != null
              ? "${widget.todo.time!.hour.toString().padLeft(2, '0')}:${widget.todo.time!.minute.toString().padLeft(2, '0')}"
              : '',
    );
    originalTodo = Todo(
      id: widget.todo.id,
      title: widget.todo.title,
      description: widget.todo.description,
      isCompleted: widget.todo.isCompleted,
      category: widget.todo.category,
      deadline: widget.todo.deadline,
      priority: widget.todo.priority,
      time: widget.todo.time,
    );
    selectedPriority = widget.todo.priority;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    timeController.dispose();
    super.dispose();
  }

  bool hasChanges() {
    return originalTodo.title != titleController.text ||
        originalTodo.description != descriptionController.text ||
        originalTodo.category != widget.todo.category ||
        originalTodo.deadline != widget.todo.deadline ||
        originalTodo.time != widget.todo.time ||
        originalTodo.priority != selectedPriority;
  }

  void updateTodo() {
    if (formState.currentState!.validate()) {
      final updatedTodo = Todo(
        id: widget.todo.id,
        title: titleController.text,
        description: descriptionController.text,
        isCompleted: widget.todo.isCompleted,
        category: widget.todo.category,
        deadline: widget.todo.deadline,
        priority: selectedPriority ?? 1,
        time: widget.todo.time,
      );
      todoProvider.updateTodo(updatedTodo);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Updated',
        desc: 'The todo has been updated successfully!',
        btnOkOnPress: () {
          Navigator.pop(context); // Close the screen after confirmation
        },
      ).show();
    }
  }

  void deleteTodo() {
    if (widget.todo.id != null) {
      todoProvider.deleteTodo(widget.todo.id!);
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Deleted',
      desc: 'The todo has been deleted successfully!',
      btnOkOnPress: () {
        Navigator.pop(context); // Close the screen after confirmation
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    todoProvider = Provider.of<TodoProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (hasChanges()) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: 'Changes Made',
            desc: 'You have made changes to the todo item.',
            btnOkOnPress: () {
              updateTodo();
            },
            btnCancelOnPress: () {
              Navigator.pop(context);
            },
          ).show();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Note Details",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: IconButton(
                icon: Icon(Icons.delete, size: 30),
                color: Colors.red,
                onPressed: deleteTodo,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTitleInput(
                    myController: titleController,
                    valid: (val) {
                      if (val!.isEmpty) {
                        return "Field is empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomDiscripinput(myController: descriptionController),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: widget.todo.category,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.todo.category = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: deadlineController,
                    decoration: InputDecoration(
                      labelText: 'Deadline',
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: widget.todo.deadline ?? DateTime.now(),
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
                          widget.todo.deadline = pickedDate;
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
                  TextFormField(
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.access_time, color: Colors.blue),
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: widget.todo.time ?? TimeOfDay.now(),
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
                        setState(() {
                          widget.todo.time = pickedTime;
                          timeController.text =
                              "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Set Priority',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
