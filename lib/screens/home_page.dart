import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HomePage")),
      body: const Center(
        child: Text(
          "Click on any ics file from fileManager or gmail then select this app",
        ),
      ),
    );
  }
}
