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

class OutputBottomSheet extends StatefulWidget {
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
  State<OutputBottomSheet> createState() => _OutputBottomSheetState();
}

class _OutputBottomSheetState extends State<OutputBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var authViewmModel = Provider.of<AuthService>(context, listen: false);
    String porsiMakan = "1 Porsi (240 gr)";
    double nilaiPorsi = 0;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: widget.size.height * 0.5,
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
                                widget.file,
                              ),
                            )),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.viewModel.output.isEmpty
                                  ? 'Objek Tidak Terdata'
                                  : '${widget.viewModel.output[0]}',
                              style: Styles.txtTitleOutput),
                          Text("Kalori : ${widget.viewModel.kalori} Kcal/100g",
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
                        nutritionValue: widget.viewModel.karbohidrat ?? '0',
                        valueColor: Colors.blueAccent.withOpacity(0.7),
                        dataColor: Colors.blue),
                    NutritionData(
                        nutritionName: 'Protein',
                        nutritionValue: widget.viewModel.protein ?? '0',
                        valueColor: Colors.pinkAccent.withOpacity(0.7),
                        dataColor: Colors.pink),
                    NutritionData(
                        nutritionName: 'Lemak',
                        nutritionValue: widget.viewModel.lemak ?? '0',
                        valueColor: Colors.orangeAccent.withOpacity(0.7),
                        dataColor: Colors.orange)
                  ],
                )
              ],
            ),
            Column(
              children: [
                Visibility(
                  visible: widget.viewModel.output.isEmpty ? false : true,
                  child: CustomButton(
                      size: widget.size,
                      color: Colors.blueAccent,
                      text: 'Tambahkan Ke Makanan Hari Ini',
                      onPressed: () async {
                        if (widget.viewModel.output.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setStates) {
                                  return AlertDialog(
                                    title: const Center(
                                        child: Text('Porsi Makan')),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RadioListTile(
                                            title:
                                                const Text("1 Porsi (240 gr)"),
                                            value: "1 Porsi (240 gr)",
                                            groupValue: porsiMakan,
                                            onChanged: (value) {
                                              setStates(() {
                                                porsiMakan = value.toString();
                                                nilaiPorsi = 2.4;
                                              });
                                            }),
                                        RadioListTile(
                                            title:
                                                const Text("2 Porsi (480 gr)"),
                                            value: "2 Porsi (480 gr)",
                                            groupValue: porsiMakan,
                                            onChanged: (value) {
                                              setStates(() {
                                                porsiMakan = value.toString();
                                                nilaiPorsi = 4.8;
                                              });
                                            }),
                                        RadioListTile(
                                            title:
                                                const Text("3 Porsi (720 gr)"),
                                            value: "3 Porsi (720 gr)",
                                            groupValue: porsiMakan,
                                            onChanged: (value) {
                                              setStates(() {
                                                porsiMakan = value.toString();
                                                nilaiPorsi = 7.2;
                                              });
                                            }),
                                      ],
                                    ),
                                    actions: [
                                      CustomButton(
                                          size: size,
                                          color: Colors.blueAccent,
                                          text: "simpan",
                                          onPressed: () async {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) =>
                                                  const LoadingToast(
                                                      message:
                                                          'Tunggu sebentar'),
                                            );
                                            await authViewmModel
                                                .addDataMakanan(
                                                    nama: widget
                                                        .viewModel.output[0],
                                                    tanggal: DateTime.now()
                                                        .toString(),
                                                    porsi: porsiMakan,
                                                    karbohidrat:
                                                        (double.parse(widget.viewModel.karbohidrat!) * nilaiPorsi).toStringAsFixed(1),
                                                    protein:
                                                        (double.parse(widget.viewModel.protein!) * nilaiPorsi).toStringAsFixed(1),
                                                    lemak:
                                                        (double.parse(widget.viewModel.lemak!) * nilaiPorsi).toStringAsFixed(1),
                                                    kalori: (double.parse(widget
                                                                .viewModel
                                                                .kalori!) *
                                                            nilaiPorsi)
                                                        .toStringAsFixed(1))
                                                .then((value) =>
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Berhasil di tambahkan'))
                                                .then((value) =>
                                                    Navigator.pop(context))
                                                .then((value) =>
                                                    Navigator.pop(context));
                                          }),
                                      CustomButton(
                                          size: size,
                                          color: Colors.redAccent,
                                          text: "Batal",
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ],
                                  );
                                });
                              });
                        }
                      }),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomButton(
                    size: widget.size,
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
