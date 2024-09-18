import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  bool isvisible = false;
  bool isloading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  checkemail() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String referal = referralController.text.trim();
    String apiurl = "http://devapiv4.dealsdray.com/api/v2/user/email/referral";

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter your email"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() {
      isloading = true;
    });

    try {
      final response = await http.post(Uri.parse(apiurl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": email,
            "password": password,
            "referral_code": referal.isEmpty ? null : referal,
          }));

      final responseData = jsonDecode(response.body);
      print("ooooooooo${responseData}");
      if (response.statusCode == 200 && responseData['status'] == 0) {
        final message = responseData['data']['message'];

        if (message == "Email already exists") {
          // Display error if email already exists
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Email already exists! Please use a different email."),
            backgroundColor: Colors.red,
          ));
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to check email. Please try again."),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {
      isloading = false;
    });
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
            Image.asset(
              "lib/assets/images/login_logo.jpg",
              height: 200,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 35, right: 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's Begin!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please enter your credentials to proccedd",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 50),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Your Email",
                          contentPadding: EdgeInsets.only(top: 20, bottom: 20)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isvisible,
                      decoration: InputDecoration(
                          hintText: "Create Password",
                          contentPadding: EdgeInsets.only(bottom: 20, top: 6),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isvisible = !isvisible;
                                });
                              },
                              icon: Icon(isvisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: referralController,
                      decoration: InputDecoration(
                        hintText: "Referral Code (Optional)",
                        contentPadding: EdgeInsets.only(bottom: 20, top: 6),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.17,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 255),
                          child: SizedBox(
                            height: 60,
                            width: 62,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 34,
                              ),
                              onPressed: () {
                                checkemail();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
