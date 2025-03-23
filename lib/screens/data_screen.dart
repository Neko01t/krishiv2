import 'package:flutter/material.dart';
import 'package:krishi/models/circle_data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DataScreen extends StatelessWidget {
  final CircleData circle;

  const DataScreen({super.key, required this.circle});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(circle.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'hero-${circle.name}',
              child: SvgPicture.asset(circle.imageUrl, width: 100, height: 100),
            ),
            const SizedBox(height: 20),
            Text(
              "Details about ${circle.name}",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
