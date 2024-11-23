import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/bodySplash.dart';
import '../sizeConfig.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }

}
