import 'package:flutter/material.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List items = ["item1", "item2", "item3"];
  TextEditingController newItem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "To Do List",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: newItem,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: "Add an item",
                suffixIcon: IconButton(
                    onPressed: () {
                      if (newItem.text.isNotEmpty) {
                        setState(() {
                          items.add("${newItem.text}");
                          newItem.clear();
                        });
                      }
                    },
                    icon: Icon(Icons.add)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          items[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        tileColor: Colors.grey[200],
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _showEdit(context, index);
                              },
                              icon: Icon(Icons.edit),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                _deleteWarningPopup(context, index);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEdit(BuildContext context, int index) {
    TextEditingController editData = TextEditingController(text: items[index]);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Edit Data",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: editData,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: "Item name Can not be empty"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  if (editData.text.isNotEmpty) {
                    setState(() {
                      items[index] = editData.text;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  "Save",
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          );
        });
  }

  void _deleteWarningPopup(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text("You are about to delete item parmanently"),
            content: Text(
              "Are you want to delete this item parmanently?",
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("NO"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    items.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text("YES"),
              ),
            ],
          );
        });
  }
}
