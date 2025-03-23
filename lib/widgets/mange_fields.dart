import 'package:flutter/material.dart';
import 'package:krishi/screens/empty_field_screen.dart';
import 'package:krishi/screens/farm_detail_screen.dart';

class ManageFieldsWidget extends StatelessWidget {
  const ManageFieldsWidget({super.key});

  final List<Map<String, String>> fields = const [
    {
      "name": "Potato",
      "asset": "assets/images/potato.png",
      "acres": "2.5 acres"
    },
    {
      "name": "Tomato",
      "asset": "assets/images/tomato.png",
      "acres": "3.0 acres"
    },
    {"name": "Wheat", "asset": "assets/images/wheat.png", "acres": "4.2 acres"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 350, // Adjust height to fit grid properly
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: fields.length + 1, // +1 for add field button
              itemBuilder: (context, index) {
                if (index < fields.length) {
                  return _fieldBlock(
                    context,
                    fields[index]['name']!,
                    fields[index]['asset']!,
                    fields[index]['acres']!,
                  );
                } else {
                  return _addFieldBlock(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldBlock(
      BuildContext context, String name, String assetPath, String acres) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FarmDetailScreen(
                fieldName: name, acres: acres, assetPath: assetPath),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 45,
              height: 45,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(acres,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _addFieldBlock(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmptyFieldScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: const Center(
          child: Icon(Icons.add, size: 45, color: Colors.blue),
        ),
      ),
    );
  }
}
