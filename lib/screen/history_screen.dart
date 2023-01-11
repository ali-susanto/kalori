import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalori/enums.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../service/auth_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Riwayat Makan',
            style: TextStyle(color: kBlackColor),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: RefreshIndicator(onRefresh: () async {
            Provider.of<AuthService>(context, listen: false).getDataMakanan();
          }, child: Consumer<AuthService>(builder: (context, state, child) {
            if (state.stateType == DataState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                ...List.generate(
                    viewModel.makanan.length,
                    (index) => Card(
                          color: const Color(0xFFF3F3F3),
                          child: ListTile(
                            title: Text(
                              viewModel.makanan[index].nama,
                              style: Styles.txtTitleCard,
                            ),
                            subtitle: Text(
                              DateFormat("dd MMMM yyyy     hh:mm a").format(
                                  DateTime.parse(
                                      viewModel.makanan[index].tanggal)),
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: Text(
                              "${viewModel.makanan[index].kandungan.kalori} Kcal",
                              textAlign: TextAlign.start,
                              style: Styles.txtTitleCard,
                            ),
                          ),
                        ))
              ],
            );
          })),
        ),
      ),
    );
  }
}
