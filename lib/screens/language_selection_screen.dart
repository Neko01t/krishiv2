import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishi/widgets/top_bar_getstarted_widget.dart';
import 'package:krishi/screens/get_started_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  LanguageSelectionScreenState createState() => LanguageSelectionScreenState();
}

class LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'English'; // Default language
  String searchQuery = ''; // For searching languages

  final List<String> languages = [
    'English',
    'हिन्दी',
    'বাংলা',
    'मराठी',
    'ગુજરાતી',
    'ಕನ್ನಡ',
    'தமிழ்',
    'اردو',
    'తెలుగు',
    'മലയാളം',
    'ਪੰਜਾਬੀ',
    'ଓଡ଼ିଆ',
    'অসমীয়া',
    'संस्कृतम्'
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Load saved language
  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('preferred_language') ?? 'English';
    });
  }

  // Update language and navigate to Get Started Screen
  void updateLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_language', language);

    setState(() {
      selectedLanguage = language;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(milliseconds: 200),
          content: Text('Language updated to $language')),
    );

    // Navigate to Get Started Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GetStartedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBarGetStarted(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Your Language",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: languages
                    .where((lang) => lang.toLowerCase().contains(searchQuery))
                    .map((lang) => RadioListTile(
                          title: Text(lang,
                              style: const TextStyle(color: Colors.white)),
                          value: lang,
                          groupValue: selectedLanguage,
                          onChanged: (value) {
                            updateLanguage(value!);
                          },
                          activeColor: Colors.green,
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  updateLanguage(selectedLanguage);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GetStartedScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Confirm",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
