import 'package:flutter/material.dart';

class EmptyFieldScreen extends StatelessWidget {
  const EmptyFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Field")),
      body: const Center(
        child: Text(
          "Google Map Field Selection Coming Soon...",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
