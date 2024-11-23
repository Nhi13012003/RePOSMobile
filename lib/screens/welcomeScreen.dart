import 'package:client_restaurant/screens/loginScreen.dart';
import 'package:client_restaurant/screens/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // SVG background image
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/logo/logo.svg',
                fit: BoxFit.cover,
              ),
            ),

            // Content on top of the background
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Padding between the image and the buttons
                  SizedBox(height: 40.0),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      Get.to(()=>LoginScreen());
                    },
                    child: const Text('Đăng nhập',),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),

                  // Padding between the buttons
                  SizedBox(height: 20.0),

                  // Signup Button
                  ElevatedButton(
                    onPressed: () {
                      Get.to(()=>SignupScreen());
                    },
                    child: const Text('Đăng ký'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 18,color: Colors.blueAccent),
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
