import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';

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
        side: BorderSide(
          color: Colors.blue,
          width: 2,
        )
      ),
      child: ListTile(
        title: Text(todo.title),
        subtitle: Text(todo.description),
        trailing: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.blue,
          value: todo.isCompleted,
          onChanged: (value) {
            final updatedTodo = Todo(
              id: todo.id,
              title: todo.title,
              description: todo.description,
              isCompleted: value!,
            );
            todoProvider.updateTodo(updatedTodo);
          },
        ),
      ),
    );
  }
}
