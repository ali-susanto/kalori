import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../components/loading_toast.dart';
import '../main.dart';
import '../service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.7,
                  height: size.width * 0.7,
                  child: Lottie.asset("assets/lottie/login.json"),
                ),
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      var loginService =
                          Provider.of<AuthService>(context, listen: false);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            const LoadingToast(message: 'Tunggu sebentar'),
                      );
                      await loginService
                          .login()
                          .then((value) => Navigator.pop(context));

                      loginService.isAuth == true
                          ? Fluttertoast.showToast(msg: 'User Log In').then(
                              (value) => Navigator.pushReplacementNamed(
                                  context, '/root_page'))
                          : Navigator.pushNamed(context, '/login');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/icons/google_icon.png'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Sign In dengan Google",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[900],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
