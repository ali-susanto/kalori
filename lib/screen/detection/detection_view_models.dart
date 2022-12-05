import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kalori/constants.dart';
import 'package:kalori/model/data_object_model.dart';
import 'package:tflite/tflite.dart';

class DetectionViewModel with ChangeNotifier {
  List output = [];
  List<DataObjectModel> dataValueObject = [];
  String? kalori;
  String? karbohidrat;
  String? protein;

  Future clasifyImage({required File image}) async {
    output.clear();
    kalori = '0';
    karbohidrat = '0';
    protein = '0';
    try {
      var outputFromModel = await Tflite.detectObjectOnImage(
          path: image.path,
          numResultsPerClass: 1,
          imageMean: 127.5,
          imageStd: 127.5,
          threshold: 0.4);

      print(outputFromModel);
      var data = outputFromModel!.map((e) {
        return e["detectedClass"];
      }).toList();
      print('data' + data.toString());
      output = data;

      for (var element in dataObject().valueObject) {
        if (element["nama"]
            .toString()
            .toLowerCase()
            .contains(output[0].toLowerCase())) {
          kalori = element["kandungan"]["kalori"];
          karbohidrat = element["kandungan"]["karbohidrat"];
          protein = element["kandungan"]["protein"];

          notifyListeners();
        }
      }

      print("${output}");
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
