import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krishi/main.dart';
import 'package:krishi/screens/about_screen.dart';
import 'package:krishi/screens/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:krishi/screens/analytics_screen.dart';
import 'package:krishi/screens/community_screen.dart';
import 'package:krishi/screens/home_screen.dart';
import 'package:krishi/screens/profile_screen.dart';
import 'package:krishi/screens/notification_screen.dart';

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String name = "Loading...";
  String email = "Loading...";
  String imagePath = "assets/Happy_farmer.png"; // Default profile image

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
    const NotificationScreen(),
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// Load user data from JSON file
  Future<void> loadUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userinfo.json');

      if (await file.exists()) {
        final jsonData = jsonDecode(await file.readAsString());

        setState(() {
          name = jsonData['name'] ?? "Unknown User";
          email = jsonData['email'] ?? "No Email";
          String profileImagePath = jsonData['profile_image'] ?? "";

          if (profileImagePath.isNotEmpty &&
              File(profileImagePath).existsSync()) {
            imagePath = profileImagePath;
          }
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "KRISHI",
            style: TextStyle(
              fontFamily: 'krishi-font',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/krishi_logo.png",
              width: 30, // Adjust the size as needed
              height: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: File(imagePath).existsSync()
                    ? FileImage(File(imagePath)) // Load from file
                    : AssetImage("assets/happy_farmer.png")
                        as ImageProvider, // Default image
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/profile_bg.webp"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Analytics"),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Community"),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('logged in'); // ✅ Remove "logged in" flag

                  // ✅ Sign Out from Firebase
                  await FirebaseAuth.instance.signOut();

                  // ✅ Sign Out from Google
                  await GoogleSignIn().disconnect();
                  await GoogleSignIn().signOut();

                  // ✅ Sign Out from Facebook
                  await FacebookAuth.instance.logOut();

                  debugPrint("🚪 User Completely Logged Out from Facebook & Google");

                  // ✅ Redirect to splash screen and remove all previous routes
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                        (route) => false, // Clears Navigation History
                  );
                } catch (e) {
                  debugPrint("❌ Logout Error: $e");
                }
              },
            )

          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: SizedBox(
                  width: 30,
                  height: 30,
                  child: ImageIcon(AssetImage("assets/icons/home_tab.png"))),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: SizedBox(
                  width: 30,
                  height: 30,
                  child: ImageIcon(AssetImage("assets/icons/market_tab.png"))),
              label: 'Analytics'),
          BottomNavigationBarItem(
              icon: SizedBox(
                  width: 30,
                  height: 30,
                  child:
                      ImageIcon(AssetImage("assets/icons/community_tab.png"))),
              label: 'Community'),
          BottomNavigationBarItem(
              icon: SizedBox(
                  width: 30,
                  height: 30,
                  child: ImageIcon(AssetImage("assets/icons/profile_tab.png"))),
              label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
