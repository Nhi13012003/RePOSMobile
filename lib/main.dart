import 'package:client_restaurant/screens/loginScreen.dart';
import 'package:client_restaurant/screens/sendOtpScreen.dart';
import 'package:client_restaurant/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:client_restaurant/screens/contactScreen.dart';
import 'package:client_restaurant/screens/menuScreen.dart';
import 'package:client_restaurant/screens/profileScreen.dart';
import 'package:client_restaurant/screens/signupScreen.dart';
import 'package:client_restaurant/screens/tableScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/splash', page: () => SplashScreen())
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // List các screen
  final List<Widget> _screens = [
    MenuScreen(),
    TableScreen(),
    ContactScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: _screens[_selectedIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.restaurant_menu, size: 30, color: Colors.white),
          Icon(Icons.table_bar, size: 30, color: Colors.white),
          Icon(Icons.support_agent, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
