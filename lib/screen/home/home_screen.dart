import 'package:flutter/material.dart';
import 'package:kalori/components/home_screen_shimmer.dart';
import 'package:kalori/components/small_content_shimmer.dart';
import 'package:kalori/constants.dart';
import 'package:kalori/enums.dart';
import 'package:kalori/screen/detection/camera_detection_screen.dart';
import 'package:kalori/view_models/detection_view_models.dart';
import 'package:kalori/screen/home/detail_tips.dart';
import 'package:kalori/view_models/tips_view_model.dart';
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
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<AuthService>(context, listen: false).autoLogin();
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<TipsViewModel>(context, listen: false).getData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AuthService>(context, listen: false);
    var tipsViewModel = Provider.of<TipsViewModel>(context, listen: false);
    var detectionViewModel =
        Provider.of<DetectionViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<AuthService>(
                  builder: (context, state, child) {
                    if (state.stateType == DataState.loading) {
                      return const HomeScreenShimmeer();
                    }
                    if (state.stateType == DataState.error) {
                      return const Center(
                        child: Text('Gagal Mendapatkan Data'),
                      );
                    }
                    return Column(
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
                                          fontWeight: FontWeight.w700,
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
                                      child: viewModel.user.photoUrl == null ||
                                              viewModel.user.photoUrl!.isEmpty
                                          ? Image.asset(
                                              "assets/logo/noimage.png",
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              viewModel.user.photoUrl ?? '',
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'kalori hari ini',
                                style: Styles.txtGeneralBoldWhite,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(detectionViewModel.kalori ?? '0',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 46,
                                        color: Colors.white,
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text('Kcal',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SleekCircularSlider(
                                    initialValue: double.parse(
                                        detectionViewModel.karbohidrat ??
                                            "0.0"),
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
                                          topLabelStyle: Styles.txtLabelCircularSlider,
                                          modifier: (double value) {
                                            final gram = value.toDouble();
                                            return '$gram g';
                                          }),
                                    ),
                                  ),
                                  SleekCircularSlider(
                                    initialValue: double.parse(
                                        detectionViewModel.protein ?? "0.0"),
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
                                          topLabelStyle: Styles.txtLabelCircularSlider,
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
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Tips kesehatan ',
                  style: TextStyle(
                      fontSize: 17,
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<TipsViewModel>(builder: (context, state, child) {
                  if (state.stateType == DataState.loading) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(
                              4, (index) => SmallContentShimmer(size: size))
                        ],
                      ),
                    );
                  }
                  if (state.stateType == DataState.error) {
                    return const Center(
                      child: Text('Gagal Mendapatkan Data'),
                    );
                  }
                  return Column(
                    children: [
                      ...List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailTipsScreen(
                                          image: tipsViewModel
                                              .tipsData[index].image!,
                                          title: tipsViewModel
                                              .tipsData[index].title!,
                                          headline: tipsViewModel
                                              .tipsData[index].headline!,
                                          content: tipsViewModel
                                              .tipsData[index].content!,
                                          id: tipsViewModel
                                              .tipsData[index].id!)));
                            },
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: 2, color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: size.width * 0.35,
                                      height: size.height * 0.12,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        child: Image.network(
                                          tipsViewModel.tipsData[index].image!,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: SizedBox(
                                      width: size.width * 0.48,
                                      child: Text(
                                        tipsViewModel.tipsData[index].title!,
                                        maxLines: 4,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
