import 'dart:ui';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF242072);
const kSecondryColor = Color(0xFF383786);
const kTertiaryColor = Color(0xFFb3b5cb);
const kPrimaryLightColor = Color(0xFFFFFFFF);

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
  static const TextStyle txtLabelRegularCircularSlider =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle txtMainLabel =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 28, color: Colors.white);
  static const TextStyle txtRegularWhite =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white);
  static const TextStyle txtLabelCardWhite =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white);
  static const TextStyle txtTitleOutput = TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 24);
  static const TextStyle txtTitleCard =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16);
}

class DataObject {
  List valueObject = [
    {
      "nama": "Bakso",
      "kandungan": {
        "karbohidrat": "16.4",
        "protein": "5.3",
        "lemak": "3",
        "kalori": "114  "
      }
    },
    {
      "nama": "Gado-gado",
      "kandungan": {
        "karbohidrat": "21",
        "protein": "6.1",
        "lemak": "3.2",
        "kalori": "137"
      }
    },
    {
      "nama": "Mie ayam",
      "kandungan": {
        "karbohidrat": "10.5",
        "protein": "6.2",
        "lemak": "3.9",
        "kalori": "102"
      }
    },
    {
      "nama": "Martabak Telor",
      "kandungan": {
        "karbohidrat": "45",
        "protein": "5.1",
        "lemak": "8.6",
        "kalori": "278"
      }
    },
    {
      "nama": "Ketoprak",
      "kandungan": {
        "karbohidrat": "13",
        "protein": "7.9",
        "lemak": "7.7",
        "kalori": "153"
      }
    },
    {
      "nama": "Rendang",
      "kandungan": {
        "karbohidrat": "7.8",
        "protein": "22.6",
        "lemak": "7.9",
        "kalori": "193"
      }
    },
    {
      "nama": "Soto Betawi",
      "kandungan": {
        "karbohidrat": "11.5",
        "protein": "2.5",
        "lemak": "8.8",
        "kalori": "135"
      }
    },
    {
      "nama": "Gulai Kambing",
      "kandungan": {
        "karbohidrat": "6.2",
        "protein": "4.2",
        "lemak": "9.4",
        "kalori": "126"
      }
    },
    {
      "nama": "Semur Jengkol",
      "kandungan": {
        "karbohidrat": "29.1",
        "protein": "6",
        "lemak": "10",
        "kalori": "212"
      }
    },
    {
      "nama": "Sate",
      "kandungan": {
        "karbohidrat": "14.82",
        "protein": "19.54",
        "lemak": "14.82",
        "kalori": "225"
      }
    },
  ];
}
