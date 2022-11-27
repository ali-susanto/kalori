import 'package:flutter/material.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Selamat pagi';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Selamat siang';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Selamat sore';
    } else {
      return 'Selamat malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AuthService>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingMessage(),
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${viewModel.user.name}',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: ClipOval(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),

                              //45:00 min
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('129 Calories'),
                        Text('129 Calories'),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('129 Calories')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: const ScanButton(),
      // bottomNavigationBar: BottomNavbar(
      //   index: 0,
      //   onTap: (int index) {
      //     setState(() {
      //       _selectedPage = index;
      //     });
      //   },
      // ),
    );
  }
}
