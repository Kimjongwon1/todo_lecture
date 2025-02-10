import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final void Function({required String todoText}) addTodo;
  const AddTask({super.key, required this.addTodo});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var todoText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Add Task"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            autofocus: true,
            onSubmitted: (value) {
              if (todoText.text != "") {
                widget.addTodo(todoText: todoText.text);
              }
              todoText.clear();
            },
            controller: todoText,
            decoration: InputDecoration(hintText: "Add Task"),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              if (todoText.text != "") {
                widget.addTodo(todoText: todoText.text);
              }
              todoText.clear();
            },
            child: Text("Add")),
      ],
    );
  }
}
