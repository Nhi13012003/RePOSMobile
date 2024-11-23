import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/bodyMenu.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          child: BodyMenu()),
    );
  }

}