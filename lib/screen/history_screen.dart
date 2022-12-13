import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Riwayat Makan',
            style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w600),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Card(
              color: const Color(0xFFF3F3F3),
              child: ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Color(0xFFF3F3F3),
                    child: Text(
                      '1',
                      style: const TextStyle(color: Colors.black),
                    )),
                title: Text('Bakso'),
                subtitle: Text(
                    "Tanggal : ${DateFormat('dd/MM/yyyy - hh:mm aaa').format(DateTime.now())}"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
