import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/providers/theme_provider.dart';
import 'package:todo_list_app/widgets/tabs/customTab.dart';
import 'package:todo_list_app/widgets/tabs/all_tabs.dart';
import 'package:todo_list_app/widgets/tabs/completed_tabs.dart';
import 'package:todo_list_app/widgets/bottom_sheet_widget.dart';
import 'package:todo_list_app/widgets/tabs/time_out_tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int _selectedIndex = 0;

  late TodoProvider todoProvider;
  bool isFabVisible = true;

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    todoProvider = Provider.of<TodoProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: 3, // Updated length to 3 to include the "Time Out" tab
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            "TO-DO List",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              children: [
                Icon(
                  themeProvider.themeMode == ThemeMode.dark
                      ? Icons.nights_stay
                      : Icons.wb_sunny,
                ),
                Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                  activeColor: Colors.blue, // Set the active color
                  inactiveThumbColor:
                      Colors.grey, // Set the inactive thumb color
                ),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                final DateTime now = DateTime.now();
                final allTasksCount =
                    todoProvider.todos
                        .where(
                          (todo) =>
                              !todo.isCompleted &&
                              (todo.deadline == null ||
                                  todo.deadline!.isAfter(now)),
                        )
                        .length;
                final completedTasksCount =
                    todoProvider.todos.where((todo) => todo.isCompleted).length;
                final timeOutTasksCount =
                    todoProvider.todos
                        .where(
                          (todo) =>
                              todo.deadline != null &&
                              todo.deadline!.isBefore(now) &&
                              !todo.isCompleted,
                        )
                        .length;
                return TabBar(
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    CustomTab(
                      label: "All",
                      count: allTasksCount,
                      selectedIndex: _selectedIndex,
                      tabIndex: 0,
                    ),
                    CustomTab(
                      label: "Completed",
                      count: completedTasksCount,
                      selectedIndex: _selectedIndex,
                      tabIndex: 1,
                    ),
                    CustomTab(
                      label: "Time Out",
                      count: timeOutTasksCount,
                      selectedIndex: _selectedIndex,
                      tabIndex: 2,
                    ),
                  ],
                );
              },
            ),
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
          child: TabBarView(
            children: [AllTabs(), CompletedTabs(), TimeOutTabs()],
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
      ),
    );
  }
}
