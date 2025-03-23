import 'package:flutter/material.dart';

class TopBarGetStarted extends StatelessWidget {
  const TopBarGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15),
      color: Colors.black,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "KRISHI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Grow Smarter, Harvest Better!",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
