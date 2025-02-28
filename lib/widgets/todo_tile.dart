import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/screens/note_detail_screen.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    return Card(
      margin: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.blue, width: 2),
      ),
      child: ListTile(
        title: Text(
          todo.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(todo.description, style: TextStyle(fontSize: 16)),
        trailing: Transform.scale(
          scale: 1.2, // Adjust the scale factor to make the checkbox bigger
          child: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.blue,
            side: BorderSide(width: 2, color: Colors.blue),
            value: todo.isCompleted,
            onChanged: (value) {
              final updatedTodo = Todo(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                isCompleted: value!,
                category: '',
                deadline: null,
                priority: 1,
              );
              todoProvider.updateTodo(updatedTodo);
            },
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(todo: todo),
            ),
          );
        },
      ),
    );
  }
}
