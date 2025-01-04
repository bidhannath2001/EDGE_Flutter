import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Trash extends StatefulWidget {
  const Trash({super.key});

  @override
  State<Trash> createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  final database = FirebaseFirestore.instance.collection('task');
  final trashDatabase = FirebaseFirestore.instance.collection('trash');

  //restore data
  Future<void> _restoreData(String docId, Map<String, dynamic> data) async {
    //set to the task collection
    await database.doc(docId).set(data);
    //remove from the trash collection
    await trashDatabase.doc(docId).delete();
  }

  // Delete data
  Future<void> _deleteData(String docId) async {
    await trashDatabase.doc(docId).delete();
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
                Navigator.pushNamed(context, 'home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded),
              title: const Text('Trash', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
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
        backgroundColor: Colors.blue,
        title: const Text(
          'Trash',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: trashDatabase.snapshots(),
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
                      title: Text(
                        content['task'] ?? "No task",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      tileColor: Colors.grey[300],
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _restoreData(doc.id, content);
                            },
                            icon: const Icon(Icons.restore_from_trash),
                            color: Colors.green,
                            tooltip: "Restore",
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "want to delete parmanently?",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteData(doc.id);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Task deleted parmanently"),
                                                duration: Duration(seconds: 5),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            tooltip: "Delete",
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: Text("Trash is empty"),
          );
        },
      ),
    );
  }
}
