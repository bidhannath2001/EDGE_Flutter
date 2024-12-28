import 'package:flutter/material.dart';

class counter extends StatefulWidget {
  const counter({super.key});

  @override
  State<counter> createState() => _counterState();
}

class _counterState extends State<counter> {
  var count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Counter",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.black12,
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Counter: $count",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        count++;
                        print("Counter: $count");
                      });
                    },
                    child: Text("Increase"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          count = 0;
                          print("Counter Reset!");
                        });
                      },
                      child: Text("Reset")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
