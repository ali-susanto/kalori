import 'package:flutter/material.dart';

import '../constants.dart';

class DetailTipsScreen extends StatelessWidget {
  const DetailTipsScreen(
      {Key? key,
      required this.image,
      required this.title,
      required this.headline,
      required this.content,
      required this.id})
      : super(key: key);
  final String image;
  final String title;
  final String headline;
  final String content;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Image.network(image),
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    color: Colors.black87.withOpacity(0.4),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.5, horizontal: 8),
                      child: Icon(Icons.arrow_back_ios_outlined,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    headline,
                    style: Styles.txtRegular,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    content,
                    style: Styles.txtRegular,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
