import 'dart:ui';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const kPrimaryBlue = Color(0xFF4163b1);
const kSecondaryBlue = Color(0xFF83a9e4);
const kWhiteColor = Color(0xFFf5f3fb);
const kBlackColor = Color(0xFF020507);
const kGreyColor = Color(0xFFa9b3b9);
const kPrimaryGreen = Color(0xFF24444b);
const kSecondaryGreen = Color(0xFF769152);

const double defaultPadding = 16.0;

class Styles {
  static const TextStyle txtGeneralBoldWhite =
      TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);
  static const TextStyle txtLabelCircularSlider =
      TextStyle(color: Colors.white);
  static const TextStyle txtLabelSmallCircularSlider =
      TextStyle(color: Colors.white, fontSize: 10);
  static const TextStyle txtRegular = TextStyle(fontSize: 14);
}

class dataObject {
  List valueObject = [
    {
      "nama": "apple",
      "kandungan": {"karbohidrat": "14.9", "protein": "0.3", "kalori": "52.1"}
    },
    {
      "nama": "pisang",
      "kandungan": {"karbohidrat": "26.3", "protein": "0.8", "kalori": "88.7"}
    },
    {
      "nama": "pizza",
      "kandungan": {"karbohidrat": "29", "protein": "14", "kalori": "360"}
    },
    {
      "nama": "donut",
      "kandungan": {"karbohidrat": "34.44", "protein": "2.7", "kalori": "250"}
    },
    {
      "nama": "hot dog",
      "kandungan": {"karbohidrat": "18.03", "protein": "10.39", "kalori": "242"}
    },
  ];
}
