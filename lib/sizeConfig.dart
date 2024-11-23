import 'package:flutter/cupertino.dart';

class SizeConfig{
  static late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context)
  {
    mediaQueryData = MediaQuery.of(context);
    screenHeight = mediaQueryData.size.height;
    screenWidth = mediaQueryData.size.width;
    orientation =  mediaQueryData.orientation;
  }
  double getScreenHeight(double height)
  {
    double screenHeight = SizeConfig.screenHeight;
    return (height/812.0)*screenHeight;
  }
  double getScreenWidth(double width)
  {
    double screenHeight = SizeConfig.screenWidth;
    return (width/375.0)*screenWidth;
  }
}