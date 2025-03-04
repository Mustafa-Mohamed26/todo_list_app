import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/todo_tile.dart';

class TimeOutTabs extends StatelessWidget {
  const TimeOutTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final DateTime now = DateTime.now();
    final timeOutTodos =
        todoProvider.todos.where((todo) {
          if (todo.deadline != null) {
            return todo.deadline!.isBefore(now) && !todo.isCompleted;
          }
          return false;
        }).toList();

    return Container(
      margin: EdgeInsets.all(10),
      child: FutureBuilder(
        future: todoProvider.loadTodos(),
        builder: (context, snapshot) {
          
            return ListView.builder(
              itemCount: timeOutTodos.length,
              itemBuilder: (context, index) {
                return TodoTile(todo: timeOutTodos[index]);
              },
            );
          
        },
      ),
    );
  }
}
