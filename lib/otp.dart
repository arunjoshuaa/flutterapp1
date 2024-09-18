import 'package:app3/bottom_navbar.dart';
import 'package:app3/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class Otp extends StatefulWidget {
  String? userid;
  String? deviceid;
  Otp({super.key, required userid, required deviceid});

  @override
  State<Otp> createState() => _OtpState();
}

@override
void initState() {}

class _OtpState extends State<Otp> {
  final TextEditingController otpController = TextEditingController();
  final String apiUrl =
      "http://devapiv4.dealsdray.com/api/v2/user/otp/verification";
  bool isLoading = false;

  Future<void> verifyOtp(String otp) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "otp": otp,
          "deviceId": widget.deviceid,
          "userId": widget.userid,
        }),
      );
      print("otpresponse=${response.body}");
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavbar()));
      }
    } catch (error) {
      showError("An error occurred. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
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
            Row(
              children: [
                Image.asset(
                  "lib/assets/images/otp_logo.jpg",
                  height: 200,
                  width: 200,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 50, right: 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "OTP Verification!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "We have sent a unique OTP number to your mobile +91 7025665207",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        OtpTextField(
                          numberOfFields: 4,
                          fieldWidth: 60,
                          fieldHeight: 60,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderColor: Colors.black,
                          margin: EdgeInsets.all(11),
                          showFieldAsBox: true,
                          onSubmit: (String otp) {
                            verifyOtp(otp);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 23, left: 20),
                          child: TimerCountdown(
                            minutesDescription: "",
                            secondsDescription: "",
                            format: CountDownTimerFormat.minutesSeconds,
                            endTime: DateTime.now().add(
                              Duration(
                                minutes: 2,
                                seconds: 0,
                              ),
                            ),
                            onEnd: () {
                              print("Timer finished");
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 120),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "SEND AGAIN",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(),
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
