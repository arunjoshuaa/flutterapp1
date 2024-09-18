import 'dart:convert';
import 'package:app3/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _sendDeviceInfo();
  }

  Future<void> _sendDeviceInfo() async {
    // Get device info
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    // Get location
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    // Get app version info
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    // Get or save install timestamp
    String? installTimeStamp = box.read('installTimeStamp');
    if (installTimeStamp == null) {
      DateTime now = DateTime.now();
      installTimeStamp = now.toUtc().toIso8601String();
      box.write('installTimeStamp', installTimeStamp);
    }

    // Get current timestamp for download
    String downloadTimeStamp = DateTime.now().toUtc().toIso8601String();

    // Get device's public IP address
    final ipResponse = await http.get(Uri.parse('https://api.ipify.org'));
    String deviceIPAddress = ipResponse.body;
    // API payload
    Map<String, dynamic> payload = {
      "deviceType": "android",
      "deviceId": androidInfo.id,
      "deviceName": androidInfo.model,
      "deviceOSVersion": androidInfo.version.release,
      "deviceIPAddress": deviceIPAddress, // Use fetched public IP
      "lat": locationData.latitude,
      "long": locationData.longitude,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": version, // Use dynamically fetched version
        "installTimeStamp": installTimeStamp,
        "uninstallTimeStamp": "Not Available", // This isn't detectable
        "downloadTimeStamp": downloadTimeStamp
      }
    };

    // Make API call
    final response = await http.post(
      Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    print("splashscreen response.body:${response.body}");
    if (response.statusCode == 200) {
      box.write("deviceid", androidInfo.id);
      // API call success, navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    } else {
      // Handle error or retry
      print('Failed to send device info: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'lib/assets/images/splash_screen.jpg',
            fit: BoxFit.cover,
          ),
          // Centered content (e.g., logo or progress indicator)
          Center(
            child: SpinKitCircle(
              color: Colors.red, // Adjust color as per your theme
              size: 50.0, // Adjust the size of the spinner
            ),
          )
        ],
      ),
    );
  }
}
