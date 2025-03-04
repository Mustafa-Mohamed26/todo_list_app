import 'package:flutter/material.dart';
import 'package:todo_list_app/core/db_helper.dart';
import 'package:todo_list_app/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  /// Loads all todos from the database and updates the local list of todos.
  ///
  /// This method fetches the list of todos from the database using the
  /// [DBHelper.getTodos] method and assigns it to the `_todos` list. After
  /// updating the list, it notifies listeners to inform them about the change.

  Future<void> loadTodos() async {
    _todos = await DBHelper.getTodos();
    notifyListeners();
  }

  /// Adds a todo to the database and updates the local list of todos.
  ///
  /// This method adds the given [Todo] object to the database using the
  /// [DBHelper.insertTodo] method. After adding the todo, it calls the
  /// [loadTodos] method to update the local list of todos and notify its
  /// listeners about the change.
  Future<void> addTodo(Todo todo) async {
    await DBHelper.insertTodo(todo);
    await loadTodos();
  }

  /// Updates a todo in the database and refreshes the local list of todos.
  ///
  /// This method updates the given [Todo] object in the database using the
  /// [DBHelper.updateTodo] method. After updating the todo, it calls the
  /// [loadTodos] method to refresh the local list of todos and notify its
  /// listeners about the change.

  Future<void> updateTodo(Todo todo) async {
    await DBHelper.updateTodo(todo);
    await loadTodos();
  }

  /// Deletes a todo from the database and refreshes the local list of todos.
  ///
  /// This method deletes the todo with the given [id] from the database using the
  /// [DBHelper.deleteTodo] method. After deleting the todo, it calls the
  /// [loadTodos] method to refresh the local list of todos and notify its
  /// listeners about the change.
  Future<void> deleteTodo(int id) async {
    await DBHelper.deleteTodo(id);
    await loadTodos();
  }
}
