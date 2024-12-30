import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_conn/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  //textEditingController
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dob = TextEditingController();

  String username = "";
  String useremail = "";
  String userphone = "";
  String userdob = "";
  bool ok = false;
  //Snackbar
  final snackbar = SnackBar(
    content: const Text('Data has been stored successfully!'),
    duration: Duration(seconds: 4),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Sign In",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter your name',
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Enter your Email',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phone,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone),
                    hintText: 'Enter your Phone',
                    labelText: 'Phone',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dob,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    hintText: 'Enter your date of birth',
                    labelText: 'DOB',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_formkey.currentState!.validate()) {
                            ok = true;
                            username = name.text;
                            useremail = email.text;
                            userphone = phone.text;
                            userdob = dob.text;
                            CollectionReference store =
                                FirebaseFirestore.instance.collection('client');
                            store.add({
                              'name': name.text,
                              'email': email.text,
                              'phone': phone.text,
                              'dob': dob.text,
                            });
                            //display in the console
                            print("Data has been stored successfully!");
                            //display snackbar
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          }
                        });
                        //clearance
                        name.clear();
                        email.clear();
                        phone.clear();
                        dob.clear();
                      },
                      child: Text('Submit')),
                ),
                //if all the textFields are filled up with data
                if (ok) ...[
                  Text("Name: $username"),
                  Text("Email: $useremail"),
                  Text("Phone: $userphone"),
                  Text("DOB: $userdob"),
                ],
              ],
            ),
          )),
    );
  }
}
