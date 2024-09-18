import 'package:app3/otp.dart';
import 'package:app3/register.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toggle_switch/toggle_switch.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _currentIndex = 1; // Start with the 'Email' tab selected
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final box = GetStorage();
  bool isloading = false;
  String? _userId;
  String message = "otp send successfully";
  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Function to send OTP request to API
  Future<void> sendOtp() async {
    String? _deviceId = box.read("deviceid");

    final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp');
    String mobile = _phoneController.text.trim(); // Trim spaces

    if (mobile.isEmpty || mobile.length < 10) {
      // Check if the phone number is valid (assuming a minimum of 10 digits)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "mobileNumber": mobile,
          "deviceId": _deviceId // Ensure deviceId is set
        }),
      );

      print("Response: ${response.body}"); // For debugging

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 1) {
          // Extract userId and deviceId from the response
          setState(() {
            _userId = jsonResponse['data']['userId'];
            _deviceId = jsonResponse['data']['deviceId'];
          });

          // Save userId and deviceId to storage
          box.write('userId', _userId);
          box.write('deviceId', _deviceId);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent successfully!')),
          );

          // Navigate to OTP screen with the required values
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otp(
                userid: _userId,
                deviceid: _deviceId,
              ),
            ),
          );
        } else {
          // Show error message from the API
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to send OTP: user not registered, please register}')),
          );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Register()));
        }
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "lib/assets/images/login_logo.jpg",
                height: 300,
                width: 300,
              ),
            ),
            ToggleSwitch(
              minWidth: 90.0,
              cornerRadius: 20.0,
              activeBgColors: [
                [Colors.red[800]!],
                [Colors.red[800]!]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              initialLabelIndex: _currentIndex,
              totalSwitches: 2,
              labels: ['Phone', 'Email'],
              radiusStyle: true,
              onToggle: (index) {
                setState(() {
                  _currentIndex = index ?? 0;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 35, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Glad to see you!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _currentIndex == 0
                        ? "Please provide your phone number"
                        : "Please provide your email address",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    key: ValueKey(_currentIndex),
                    controller: _currentIndex == 0
                        ? _phoneController
                        : _emailController,
                    decoration: InputDecoration(
                      hintText: _currentIndex == 0 ? "Phone" : "Email",
                    ),
                    keyboardType: _currentIndex == 0
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                  ),
                  SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: sendOtp, // Call the function to send OTP
                      child: Text(
                        "SEND CODE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
