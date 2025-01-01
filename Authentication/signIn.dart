import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  //textEditingController
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> loginwithEmailandPassword() async {
    try {
      final UserCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      print(UserCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

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
                  controller: email,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Enter your Email',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your Email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone),
                    hintText: 'Enter your password',
                    labelText: 'password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter password';
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
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          await loginwithEmailandPassword();
                          Navigator.pushNamed(context, 'homePage');
                        }

                        email.clear();
                        password.clear();
                      },
                      child: Text('Sign In')),
                ),
              ],
            ),
          )),
    );
  }
}
