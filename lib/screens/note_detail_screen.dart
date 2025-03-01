import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/customDiscripInput.dart';
import 'package:todo_list_app/widgets/customTitleInput.dart';

class NoteDetailScreen extends StatefulWidget {
  final Todo todo;

  const NoteDetailScreen({super.key, required this.todo});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late TodoProvider todoProvider;

  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(
      text: widget.todo.description,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void updateTodo() {
    if (formState.currentState!.validate()) {
      final updatedTodo = Todo(
        id: widget.todo.id,
        title: titleController.text,
        description: descriptionController.text,
        isCompleted: widget.todo.isCompleted,
        category: '',
        deadline: null,
        priority: 1, time: null,
      );
      todoProvider.updateTodo(updatedTodo);
      Navigator.pop(context);
    }
  }

  void deleteTodo() {
    if (widget.todo.id != null) {
      todoProvider.deleteTodo(widget.todo.id!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
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
              border: Border.all(
                color: Colors.red,
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.delete, size: 30),
              color: Colors.red,
              onPressed: deleteTodo,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: updateTodo,
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
                      child: Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
