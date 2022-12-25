import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalori/components/custom_button.dart';

import '../constants.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool isMale = true;
  double height = 180;
  int weight = 60;
  int age = 20;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kWhiteColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'BMI Calculator',
            style: TextStyle(color: kBlackColor),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 13),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isMale = true;
                      });
                    },
                    child: Container(
                      height: size.width * 0.45,
                      width: size.width * 0.42,
                      decoration: BoxDecoration(
                          color: kWhiteColor,
                          border: Border.all(
                              width: isMale ? 3 : 2,
                              color: isMale
                                  ? const Color(0xFF0c0f21)
                                  : const Color(0xFF969bb2)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.male,
                              size: 110,
                              color: Color(0xFFeb9161),
                            ),
                            Spacer(),
                            Text(
                              'Pria',
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isMale = false;
                      });
                    },
                    child: Container(
                      height: size.width * 0.45,
                      width: size.width * 0.42,
                      decoration: BoxDecoration(
                          color: kWhiteColor,
                          border: Border.all(
                              width: isMale ? 2 : 3,
                              color: isMale
                                  ? const Color(0xFF969bb2)
                                  : const Color(0xFF0c0f21)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.female,
                              size: 110,
                              color: Color(0xFFc5416f),
                            ),
                            Spacer(),
                            Text(
                              'Wanita',
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: size.width * 0.5,
                width: size.width,
                decoration: BoxDecoration(
                    color: kWhiteColor,
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    children: [
                      const Text(
                        'Tinggi',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            height.round().toString(),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            ' cm',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Spacer(),
                      Slider(
                          value: height,
                          min: 80,
                          max: 220,
                          onChanged: (value) {
                            setState(() {
                              height = value;
                            });
                          }),
                      const Spacer()
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: size.width * 0.45,
                    width: size.width * 0.42,
                    decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        children: [
                          const Text('Berat',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          const Spacer(
                            flex: 2,
                          ),
                          Text(
                            weight.toString(),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        weight--;
                                      });
                                    },
                                    icon: const Icon(Icons.remove)),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              CircleAvatar(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        weight++;
                                      });
                                    },
                                    icon: const Icon(Icons.add)),
                              )
                            ],
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: size.width * 0.45,
                    width: size.width * 0.42,
                    decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        children: [
                          const Text('Umur',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          const Spacer(
                            flex: 2,
                          ),
                          Text(
                            age.toString(),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        age--;
                                      });
                                    },
                                    icon: const Icon(Icons.remove)),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              CircleAvatar(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        age++;
                                      });
                                    },
                                    icon: const Icon(Icons.add)),
                              )
                            ],
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                  size: size,
                  color: Colors.blueAccent,
                  text: 'Hitung',
                  onPressed: () {
                    double result = weight / pow(height / 100, 2);
                    showModalBottomSheet(
                      backgroundColor: const Color(0xFF2566cf),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      context: context,
                      builder: (context) => SizedBox(
                        height: size.height * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              const Text('Index BMI Kamu',
                                  style: TextStyle(color: Colors.white)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${result.round()}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                result < 18.5
                                    ? "(Kurang)"
                                    : result > 18.5 && result < 22.9
                                        ? "(Normal)"
                                        : result > 22.9 && result <= 24.9
                                            ? "(Kelebihan)"
                                            : result > 22.9 && result < 30
                                                ? "(Obesitas 1)"
                                                : "(Obesitas 2)",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Berat badan kamu bisa dikatakan ideal jika angka BMI kamu berada antara angka 18,5 sampai 22,9. Bagaimana cara menjaga agar berat badan tetap ideal? kamu perlu mengonsumsi makanan dan minuman sesuai dengan kebutuhan kalori harian kamu, untuk mempertahankan berat badan ideal seperti sekarang. Misalnya, jika kebutuhan kalori harian kamu adalah 1950 kkal, maka kamu harus mengonsumsi makanan dengan total kalori 1950 per harinya.',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomButton(
                                    size: size,
                                    color: Colors.redAccent,
                                    text: 'Oke',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
