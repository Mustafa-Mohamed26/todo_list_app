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
        subtitle: Text(
          todo.deadline != null
              ? todo.formattedDeadlineWithMonthName
              : 'No deadline',
          style: TextStyle(fontSize: 16),
        ),
        leading: Transform.scale(
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
                category: todo.category,
                deadline: todo.deadline,
                priority: todo.priority,
              );
              todoProvider.updateTodo(updatedTodo);
            },
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getPriorityColor(todo.priority),
              ),
            ),
            SizedBox(height: 6),
            Text(
              todo.category,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
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

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
