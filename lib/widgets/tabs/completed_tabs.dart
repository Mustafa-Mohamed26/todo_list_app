import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/todo_tile.dart';

class CompletedTabs extends StatelessWidget {
  const CompletedTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final completedTodos =
        todoProvider.todos.where((todo) => todo.isCompleted).toList();
    return Container(
      margin: EdgeInsets.all(10),
      child: FutureBuilder(
        future: todoProvider.loadTodos(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: completedTodos.length,
            itemBuilder: (context, index) {
              return TodoTile(todo: completedTodos[index]);
            },
          );
        },
      ),
    );
  }
}
