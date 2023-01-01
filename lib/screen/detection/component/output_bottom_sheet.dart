import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kalori/service/auth_service.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_button.dart';
import '../../../components/loading_toast.dart';
import '../../../components/nutrition_data.dart';
import '../../../constants.dart';
import '../../../view_models/detection_view_models.dart';

class OutputBottomSheet extends StatelessWidget {
  const OutputBottomSheet(
      {Key? key,
      required this.size,
      required this.viewModel,
      required this.file})
      : super(key: key);

  final Size size;
  final DetectionViewModel viewModel;
  final File file;

  @override
  Widget build(BuildContext context) {
    var authViewmModel = Provider.of<AuthService>(context, listen: false);
    return SizedBox(
      height: size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 31,
                        child: CircleAvatar(
                            radius: 28,
                            child: ClipOval(
                              child: Image.file(
                                file,
                              ),
                            )),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              viewModel.output.isEmpty
                                  ? 'Objek Tidak Terdata'
                                  : '${viewModel.output[0]}',
                              style: Styles.txtTitleOutput),
                          Text("Kalori : ${viewModel.kalori} Kcal/100g",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionData(
                        nutritionName: "Karbohidrat",
                        nutritionValue: viewModel.karbohidrat ?? '0',
                        valueColor: Colors.blueAccent.withOpacity(0.7),
                        dataColor: Colors.blue),
                    NutritionData(
                        nutritionName: 'Protein',
                        nutritionValue: viewModel.protein ?? '0',
                        valueColor: Colors.pinkAccent.withOpacity(0.7),
                        dataColor: Colors.pink),
                    NutritionData(
                        nutritionName: 'Lemak',
                        nutritionValue: viewModel.lemak ?? '0',
                        valueColor: Colors.orangeAccent.withOpacity(0.7),
                        dataColor: Colors.orange)
                  ],
                )
              ],
            ),
            Column(
              children: [
                CustomButton(
                    size: size,
                    color: Colors.blueAccent,
                    text: 'Tambahkan Ke Makanan Hari Ini',
                    onPressed: () async {
                      if (viewModel.output.isNotEmpty) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) =>
                              const LoadingToast(message: 'Tunggu sebentar'),
                        );
                        await authViewmModel
                            .addDataMakanan(
                                nama: viewModel.output[0],
                                tanggal: DateTime.now().toString(),
                                karbohidrat: viewModel.karbohidrat!,
                                protein: viewModel.protein!,
                                lemak: viewModel.lemak!,
                                kalori: viewModel.kalori!)
                            .then((value) => Fluttertoast.showToast(
                                msg: 'Berhasil di tambahkan'))
                            .then((value) => Navigator.pop(context));
                      }
                    }),
                const SizedBox(
                  height: 5,
                ),
                CustomButton(
                    size: size,
                    color: Colors.redAccent,
                    text: 'Kembali',
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
