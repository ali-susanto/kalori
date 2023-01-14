import 'package:flutter/material.dart';
import 'package:kalori/constants.dart';

class DetectionInfoScreen extends StatelessWidget {
  const DetectionInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Info',
          // style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.grey.withOpacity(0.01),
        elevation: 0,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Informasi Tentang Deteksi Makanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Data makanan yang bisa terdeteksi : ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            ...List.generate(DataObject().valueObject.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '${index + 1}.   ' + DataObject().valueObject[index]['nama'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Catatan :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('*'),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    'Jumlah kandungan gizi yang ditampilkan pada hasil deteksi merupakan data per 100 gram.',
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('*'),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    'Sumber untuk data gizi yaitu pada website www.panganku.org milik Kementerian Kesehatan Republik Indonesia.',
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
