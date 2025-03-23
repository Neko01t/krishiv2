import 'package:flutter/material.dart';
import 'package:krishi/screens/log_in_screen.dart';
import 'package:krishi/screens/otp_verification_screen.dart';
import 'package:krishi/widgets/top_bar_getstarted_widget.dart';
import 'package:flutter/services.dart';

class NumberVerificationLoginScreen extends StatefulWidget {
  const NumberVerificationLoginScreen({super.key});

  @override
  _NumberVerificationLoginScreenState createState() =>
      _NumberVerificationLoginScreenState();
}

class _NumberVerificationLoginScreenState
    extends State<NumberVerificationLoginScreen> {
  final TextEditingController _mobileController = TextEditingController();

  void _navigateToVerification() {
    String mobileNumber = _mobileController.text.trim();
    print(mobileNumber);

    if (mobileNumber.length == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpVerificationScreen(mobileNumber: mobileNumber),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit number")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6AE), // Light green background
      body: Column(
        children: [
          const TopBarGetStarted(), // Black top bar

          const SizedBox(height: 100),

          // Mobile number input section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mobile Number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.white,
                      ),
                      child: const Text("+91",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Allows only numbers
                          LengthLimitingTextInputFormatter(
                              10), // Limits input to 10 digits
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter Your Mobile No.",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Confirm Button
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
              ),
              onPressed: _navigateToVerification,
              child: const Text("CONFIRM",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),

          const SizedBox(height: 40),

          // OR Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("OR"),
              ),
              Expanded(child: Divider(color: Colors.grey, thickness: 1)),
            ],
          ),

          const SizedBox(height: 40),

          // Social Login Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                // google login button
                GestureDetector(
                  onTap: () {
                    debugPrint("Google Sign-Up Clicked");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/google_icon.png", height: 24),
                        SizedBox(width: 10),
                        Text("Sign up with Google",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                // facebook login button
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    debugPrint("Facebook Sign-Up Clicked");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFF1877F2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/facebook_icon.webp", height: 24),
                        SizedBox(width: 10),
                        Text("Sign up with Facebook",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSocialButton(String text, String iconPath, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          // Handle social login
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 24), // Replace with correct icon
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class NumberVerificationScreen extends StatelessWidget {
  final String mobileNumber;

  const NumberVerificationScreen({super.key, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Your Number")),
      body: Center(
        child: Text(
          "Entered Mobile Number: $mobileNumber",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
