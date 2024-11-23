import 'package:client_restaurant/screens/loginScreen.dart';
import 'package:client_restaurant/screens/welcomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../sizeConfig.dart';
class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Chào mừng đến với ResNA",
      "image": "assets/splash/logoFlash.jpg"
    },
    {
      "text": "Nơi ăn ngon nhất",
      "image": "assets/splash/spl1.jpg"
    },
    {
      "text": "Có thể nói rằng, nơi đây ăn rất ngon",
      "image": "assets/splash/spl2.jpg"
    },

  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(itemBuilder: (context,index) => SplashContent(
                image: splashData[index]["image"],
                text: splashData[index]["text"],
              ),
                itemCount: splashData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:  EdgeInsets.symmetric(
                    horizontal: SizeConfig().getScreenWidth(20)
                ),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                              (index) => buildDot(index: index),
                        )
                    ),
                    Spacer(flex: 3,),
                    DefaultButton(
                      text: "Tiếp tục",
                      press: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>WelcomePage()),
                        );
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.deepOrange : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key, required this.text, required this.press,
  });
  final String text;
  final void Function() press;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: SizeConfig().getScreenHeight(56),
        child: TextButton(
          onPressed: press, child:
        Text(text, style: TextStyle(color: Colors.white,
          fontSize: SizeConfig().getScreenWidth(18),
        ),),
          style: TextButton.styleFrom(backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),),
        ));
  }
}

class SplashContent extends StatelessWidget{
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }): super(key: key);
  final String? text,image;
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Gap(SizeConfig().getScreenHeight(10)),
          Text("Restaurant", style: TextStyle(fontSize: SizeConfig().getScreenWidth(36),
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold),),
          Text(text == null ? "" : text!,),
          Image.asset(image== null ? "" : image!,
            height: SizeConfig().getScreenHeight(265),
            width: SizeConfig().getScreenWidth(235),)
        ]
    );
  }

}
