import 'package:flutter/material.dart';
import 'package:kalori/constants.dart';
import 'package:kalori/screen/detection/camera_detection_screen.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
    } else if ((timeNow > 16) && (timeNow < 18)) {
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
                        Text(greetingMessage(),
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 24)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${viewModel.user.name}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: viewModel.user.photoUrl! == "noimage"
                                ? Image.asset(
                                    "assets/logo/noimage.png",
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    viewModel.user.photoUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
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
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'kalori hari ini',
                      style: txtGeneralBoldWhite,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('50',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 46,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Kalori',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SleekCircularSlider(
                          initialValue: 24,
                          appearance: CircularSliderAppearance(
                            size: size.width * 0.35,
                            customColors: CustomSliderColors(
                                trackColor: Colors.greenAccent,
                                progressBarColors: [
                                  Colors.lightGreen,
                                  Colors.amberAccent
                                ],
                                shadowMaxOpacity: 20.0),
                            infoProperties: InfoProperties(
                                topLabelText: 'Karbohidrat',
                                topLabelStyle: txtLabelCircularSlider,
                                modifier: (double value) {
                                  final gram = value.toDouble();
                                  return '$gram g';
                                }),
                          ),
                        ),
                        SleekCircularSlider(
                          initialValue: 44.50,
                          min: 0,
                          max: 100,
                          appearance: CircularSliderAppearance(
                            size: size.width * 0.35,
                            customColors: CustomSliderColors(
                                trackColor: Colors.orangeAccent,
                                progressBarColors: [
                                  Colors.lightGreen,
                                  const Color(0xffFFBF00)
                                ],
                                shadowMaxOpacity: 20.0),
                            infoProperties: InfoProperties(
                                topLabelText: 'Protein',
                                topLabelStyle: txtLabelCircularSlider,
                                modifier: (double value) {
                                  final gram = value.toDouble();
                                  return '$gram g';
                                }),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CameraDetectionScreen()));
                  },
                  icon: Icon(Icons.camera)),
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
