import 'package:flutter/material.dart';

import '../../constants.dart';

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
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: kBlackColor,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Detail',
            style: TextStyle(color: kBlackColor),
          )),
    );
  }
}
