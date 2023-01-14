import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalori/components/home_screen_shimmer.dart';
import 'package:kalori/components/small_content_shimmer.dart';
import 'package:kalori/constants.dart';
import 'package:kalori/enums.dart';
import 'package:kalori/view_models/tips_view_model.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'detail_tips.dart';

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
      Provider.of<AuthService>(context, listen: false)
          .autoLogin()
          .whenComplete(() => initDataMakanan());
    });

    initDataMakanan();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<TipsViewModel>(context, listen: false).getData();
    });
    super.initState();
  }

  initDataMakanan() async {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<AuthService>(context, listen: false).getDataMakanan();
      Provider.of<TipsViewModel>(context, listen: false).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AuthService>(context, listen: false);
    var tipsViewModel = Provider.of<TipsViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: RefreshIndicator(
            onRefresh: () async {
              Provider.of<AuthService>(context, listen: false).getDataMakanan();
              Provider.of<TipsViewModel>(context, listen: false).getData();
            },
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
                                      '${viewModel.user.fullName}',
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
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        child: viewModel.user.photoUrl ==
                                                    null ||
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
                          dataCalorie(size, viewModel),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Artikel',
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
                                            tipsViewModel
                                                .tipsData[index].image!,
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
      ),
    );
  }

  Widget dataCalorie(Size size, AuthService authViewModel) {
    double protein =
        double.parse(authViewModel.dataHariIni.protein ?? '0') / 100;
    double karbohidrat =
        double.parse(authViewModel.dataHariIni.karbohidrat ?? '0') / 100;
    double lemak = double.parse(authViewModel.dataHariIni.lemak ?? '0') / 100;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          color: kSecondryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 15),
              blurRadius: 27,
              color: Colors.black12, // Black color with 12% opacity
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 10, 10),
            child: Text(
              DateFormat('dd MMMM yyyy').format(DateTime.now()),
              style: Styles.txtRegularWhite,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SleekCircularSlider(
                initialValue:
                    double.parse(authViewModel.dataHariIni.kalori ?? '0'),
                max:
                    double.parse(authViewModel.dataHariIni.kalori ?? '0') < 2300
                        ? 2300
                        : 5000,
                appearance: CircularSliderAppearance(
                  size: size.width * 0.45,
                  startAngle: 270,
                  angleRange: 360,
                  customWidths: CustomSliderWidths(
                      trackWidth: 10, progressBarWidth: 20, shadowWidth: 8),
                  customColors: CustomSliderColors(
                      shadowColor: Colors.grey.withOpacity(0.5),
                      trackColor: kTertiaryColor,
                      progressBarColors: double.parse(
                                  authViewModel.dataHariIni.kalori ?? '0') <=
                              2300
                          ? [Colors.white, Colors.white]
                          : [Colors.red, Colors.red],
                      shadowMaxOpacity: 20.0),
                  infoProperties: InfoProperties(
                    topLabelText: 'Kalori',
                    topLabelStyle: Styles.txtLabelCircularSlider,
                    bottomLabelText: 'Kcal',
                    bottomLabelStyle: Styles.txtLabelCircularSlider,
                    mainLabelStyle:
                        double.parse(authViewModel.dataHariIni.kalori ?? '0') <=
                                2300
                            ? Styles.txtMainLabelWhite
                            : Styles.txtMainLabelRed,
                    modifier: (double value) {
                      final data = value.toInt();
                      return '$data ';
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Karbohidrat',
                              style: Styles.txtLabelCardWhite,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              height: 10,
                              child: LinearProgressIndicator(
                                  value: karbohidrat,
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blueAccent)),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${authViewModel.dataHariIni.karbohidrat} /100',
                              style: Styles.txtLabelCardWhite,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: 10,
                        width: size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Protein',
                              style: Styles.txtLabelCardWhite,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              height: 10,
                              child: LinearProgressIndicator(
                                  value: protein,
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.pinkAccent)),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${authViewModel.dataHariIni.protein} /100',
                              style: Styles.txtLabelCardWhite,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lemak',
                              style: Styles.txtLabelCardWhite,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              height: 10,
                              child: LinearProgressIndicator(
                                  value: lemak,
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.orangeAccent)),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${authViewModel.dataHariIni.lemak} /100',
                              style: Styles.txtLabelCardWhite,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
