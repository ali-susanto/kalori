import 'package:flutter/material.dart';

class DetectionInfoScreen extends StatelessWidget {
  const DetectionInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: Column(
        children: const [Text('Data')],
      ),
    );
  }
}
