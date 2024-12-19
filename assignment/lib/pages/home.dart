import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Layout Design",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
