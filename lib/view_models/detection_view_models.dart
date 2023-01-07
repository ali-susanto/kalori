import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kalori/constants.dart';
import 'package:tflite/tflite.dart';

class DetectionViewModel with ChangeNotifier {
  List output = [];
  String? kalori;
  String? karbohidrat;
  String? protein;
  String? lemak;

  Future loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
          model: "assets/models/model_unquant.tflite",
          labels: "assets/models/labels.txt");
      debugPrint('sukses');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future clasifyImage({required File image}) async {
    output.clear();
    kalori = '0';
    karbohidrat = '0';
    protein = '0';
    try {
      var outputFromModel = await Tflite.runModelOnImage(
          path: image.path, imageMean: 127.5, imageStd: 127.5, threshold: 0.5);

      var data = outputFromModel!.map((e) {
        return e["label"].replaceAll(RegExp(r'[0-9]'), '').substring(1);
      }).toList();
      output = data;

      for (var element in DataObject().valueObject) {
        if (element["nama"]
            .toString()
            .toLowerCase()
            .contains(output[0].toLowerCase())) {
          kalori = element["kandungan"]["kalori"];
          karbohidrat = element["kandungan"]["karbohidrat"];
          protein = element["kandungan"]["protein"];
          lemak = element["kandungan"]["lemak"];

          notifyListeners();
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
