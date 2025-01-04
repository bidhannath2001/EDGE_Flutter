import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _formKey = GlobalKey<FormState>();
  // Collection reference
  final database = FirebaseFirestore.instance.collection('task');
  //trash collection
  final trashDatabase = FirebaseFirestore.instance.collection('trash');
  // Controller for adding new tasks
  final TextEditingController newTaskController = TextEditingController();

  //move to trash
  Future<void> _moveToTrash(String docId, Map<String, dynamic> data) async {
    //set to the trash collection
    await trashDatabase.doc(docId).set(data);
    //remove from the task collection
    await database.doc(docId).delete();
  }

  // Delete data
  Future<void> _deleteData(String docId) async {
    await database.doc(docId).delete();
  }

  // Update data
  Future<void> _updateData(String docId, String task) async {
    await database.doc(docId).update({'task': task});
  }

  void _addTaskWithUndo() {
    if (newTaskController.text.isNotEmpty) {
      // Add task to Firestore
      database
          .add({'task': newTaskController.text.trimLeft()}).then((reference) {
        // Show Snackbar with Undo functionality
        final snackBar = SnackBar(
          content: Text('Task added'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Delete the added task on Undo
              _deleteData(reference.id);
            },
          ),
          duration: const Duration(seconds: 3),
        );

        // Show the Snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      // Clear the text field
      newTaskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded),
              title: const Text('Trash'),
              onTap: () {
                Navigator.pushNamed(context, 'trash');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "Menu",
            );
          },
        ),
        title: const Text(
          "To Do List",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                maxLength: 200,
                controller: newTaskController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Add a new task",
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addTaskWithUndo();
                      }
                    },
                    icon: const Icon(Icons.add),
                    tooltip: "Add task",
                  ),
                ),
                validator: (value) {
                  // Validation logic
                  if (value == null || value.trimLeft().isEmpty) {
                    return 'Field can\'t be empty';
                  }
                  return null;
                },
                // onChanged: (value) {
                //   setState(() {});
                // },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: database.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  if (snapshot.hasData) {
                    final documents = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final doc = documents[index];
                        final content = doc.data() as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(content['task'] ?? "No task"),
                            tileColor: Colors.grey[200],
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _editData(context, doc.id, content['task']);
                                  },
                                  icon: const Icon(Icons.edit),
                                  tooltip: "Edit",
                                ),
                                IconButton(
                                  onPressed: () {
                                    _moveToTrash(doc.id, content);
                                    // _deleteData(doc.id);
                                  },
                                  icon: const Icon(Icons.delete),
                                  tooltip: "Delete",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(
                    child: Text("No data available"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editData(BuildContext context, String docId, String task) {
    TextEditingController editTaskController = TextEditingController();
    editTaskController.text = task;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 15,
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            1,
          ),
          title: const Text(
            'Edit',
            style: TextStyle(fontSize: 15),
          ),
          content: TextField(
            maxLength: 200,
            controller: editTaskController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "Edit item",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editTaskController.text.trimLeft().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Field can't be empty"),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
                if (editTaskController.text.trimLeft().isNotEmpty) {
                  _updateData(docId, editTaskController.text.trimLeft());
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                  foregroundColor: WidgetStatePropertyAll(Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
