import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_lecture/add_task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<MainScreen> {
  List<String> todoList = [];

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Already Exists"),
            content: const Text("This task already exists"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      todoList.insert(0, todoText);
    });

    writeLocalData();
    Navigator.pop(context);
  }

  void writeLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todolist', todoList);
  }

  void readLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = (prefs.getStringList('todolist') ?? []).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    readLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Text("Drawer"),
      ),
      appBar: AppBar(
        title: const Text("TODO App"),
        centerTitle: true,
      ),
      body: (todoList.isEmpty)
          ? Center(
              child:
                  Text("No items on the List", style: TextStyle(fontSize: 20)),
            )
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.all(8.0)),
                        Icon(Icons.check),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    // 여기서 항목 삭제 및 setState 호출
                    setState(() {
                      todoList.removeAt(index);
                    });
                    writeLocalData(); // 로컬 데이터 갱신
                  },
                  child: ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  todoList.removeAt(index);
                                });
                                writeLocalData();
                                Navigator.pop(context);
                              },
                              child: Text("Task Done!"),
                            ),
                          );
                        },
                      );
                    },
                    title: Text(todoList[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  height: 250,
                  child: AddTask(
                    addTodo: addTodo,
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
