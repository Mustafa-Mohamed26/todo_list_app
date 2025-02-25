import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/todo_model.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/todo_tile.dart';
import 'package:todo_list_app/widgets/bottom_sheet_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late TodoProvider todoProvider;
  bool isFabVisible = true;

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    todoProvider = Provider.of<TodoProvider>(context, listen: false);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "TO-DO List",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (FocusScope.of(context).hasFocus) {
            _dismissKeyboard();
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: todoProvider.loadTodos(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: todoProvider.todos.length,
                itemBuilder: (context, index) {
                  return TodoTile(todo: todoProvider.todos[index]);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton:
          isFabVisible
              ? FloatingActionButton(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                child: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    isFabVisible = false; // Hide the FAB when clicked
                  });
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => BottomSheetWidget(),
                  ).whenComplete(() {
                    setState(() {
                      isFabVisible =
                          true; // Show the FAB again after the bottom sheet is closed
                    });
                  });
                },
              )
              : null,
    );
  }
}
