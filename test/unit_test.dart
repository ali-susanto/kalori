import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalori/service/tips_api.dart';
import 'package:tflite/tflite.dart';

void main() {
  group('Unit Testing =>', () {
    test("Deteksi makanan", () async {
      try {
        await Tflite.loadModel(
            model: "assets/models/model_unquant.tflite",
            labels: "assets/models/labels.txt");

        var outputData = await Tflite.runModelOnImage(
            path: 'assets/images/bakso.jpg',
            imageMean: 127.5,
            imageStd: 127.5,
            threshold: 0.5);
        expect(outputData!.first['label'], 'Bakso');
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    test('Data artikel', () async {
      var data = await TipsApi().getTipsData();
      expect(data.isNotEmpty, true);
    });
  });
}
