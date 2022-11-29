import 'package:camera/camera.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalori/screen/auth/login_screen.dart';
import 'package:kalori/screen/tips/tips_view_model.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'screen/calculator/calculator_screen.dart';
import 'screen/detection/detection_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/profile/profile_screen.dart';
import 'screen/tips/tips_screen.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TipsViewModel()),
    ChangeNotifierProvider(create: (_) => AuthService()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalori',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/bottom_nav_bar': (context) => const MainBody(),
        '/login': (context) => const LoginScreen(),
      },
      home: const LoginScreen(),
    );
  }
}

class MainBody extends StatefulWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  int selectedPage = 0;
  final _page = const [
    HomeScreen(),
    CalculatorScreen(),
    DetectionScreen(),
    TipsScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _page[selectedPage],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: kSecondaryBlue,
          style: TabStyle.fixedCircle,
          initialActiveIndex: selectedPage,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.calculate_outlined, title: 'BMI'),
            TabItem(icon: Icons.camera_alt, title: 'Scan'),
            TabItem(icon: Icons.public, title: 'Tips'),
            TabItem(icon: Icons.person, title: 'Profile')
          ],
          onTap: (int index) {
            setState(() {
              selectedPage = index;
            });
          },
        ));
  }
}
