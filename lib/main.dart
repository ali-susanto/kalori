import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalori/view/calculator_screen.dart';
import 'package:kalori/view/detection/detection_info_screen.dart';
import 'package:kalori/view/detection/detection_screen.dart';
import 'package:kalori/view/history_screen.dart';
import 'package:kalori/view/home_screen.dart';
import 'package:kalori/view/login_screen.dart';
import 'package:kalori/view/profile_screen.dart';

import 'package:kalori/view_models/detection_view_models.dart';
import 'package:kalori/view_models/tips_view_model.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'constants.dart';


late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AuthService().autoLogin();
  final isLogin = await AuthService().autoLogin();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Gagal mendeteksi camera' + e.toString());
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => TipsViewModel()),
                ChangeNotifierProvider(create: (_) => AuthService()),
                ChangeNotifierProvider(create: (_) => DetectionViewModel()),
              ],
              child: MyApp(
                isLogin: isLogin,
              ))));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLogin}) : super(key: key);
  final bool isLogin;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalori App',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/root_page': (context) => const RootPage(),
        '/login': (context) => const LoginScreen(),
        '/info': (context) => const DetectionInfoScreen(),
      },
      // home: const LoginScreen(),
      initialRoute: isLogin ? '/root_page' : '/login',
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  //List of the pages
  List<Widget> _widgetOptions() {
    return [
      const HomeScreen(),
      const HistoryScreen(),
      const CalculatorScreen(),
      const ProfileScreen()
    ];
  }

  //List of the pages icons
  List<IconData> iconList = [
    Icons.home,
    Icons.history,
    Icons.calculate_outlined,
    Icons.person,
  ];

  //List of the pages titles
  List<String> titleList = [
    'Home',
    'History',
    'Calculator',
    'Profile',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _widgetOptions(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: const DetectionScreen(),
                  type: PageTransitionType.bottomToTop));
        },
        child: Image.asset(
          'assets/icons/code-scan.png',
          height: 30.0,
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: kPrimaryBlue,
          activeColor: kPrimaryBlue,
          inactiveColor: Colors.black.withOpacity(.5),
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          }),
    );
  }
}
