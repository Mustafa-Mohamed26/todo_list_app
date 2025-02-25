import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final Todo todo;

  const NoteDetailScreen({super.key, required this.todo});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  late TodoProvider todoProvider;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void updateTodo() {
    final updatedTodo = Todo(
      id: widget.todo.id,
      title: titleController.text,
      description: descriptionController.text,
      isCompleted: widget.todo.isCompleted,
    );
    todoProvider.updateTodo(updatedTodo);
    Navigator.pop(context);
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
        title: Text('Note Details'),
        actions: [IconButton(icon: Icon(Icons.delete), onPressed: deleteTodo)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              minLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateTodo, child: Text('Update')),
          ],
        ),
      ),
    );
  }
}
