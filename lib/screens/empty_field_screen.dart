import 'package:flutter/material.dart';
import 'package:krishi/models/circle_data.dart';
import 'package:krishi/data/list.dart';

class EmptyFieldScreen extends StatefulWidget {
  const EmptyFieldScreen({super.key});

  @override
  State<EmptyFieldScreen> createState() => _EmptyFieldScreenState();
}

class _EmptyFieldScreenState extends State<EmptyFieldScreen> {
  final TextEditingController acresController = TextEditingController();
  CircleData? selectedCrop;

  void _saveField() {
    if (selectedCrop != null && acresController.text.isNotEmpty) {
      Navigator.pop(context, {
        "name": selectedCrop!.name,
        "asset": selectedCrop!.imageUrl,
        "acres": "${acresController.text} acres"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Field")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a Crop",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Crop Selection Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: availableCircles.length,
              itemBuilder: (context, index) {
                CircleData crop = availableCircles[index];
                bool isSelected = crop == selectedCrop;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCrop = crop;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          crop.imageUrl,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported,
                                  color: Colors.grey, size: 30),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          crop.name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Field Size Input
            TextField(
              controller: acresController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Field Size (Acres)",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Save Field", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
