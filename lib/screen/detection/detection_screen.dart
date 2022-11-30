import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import '../../main.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({Key? key}) : super(key: key);

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  CameraController? cameraController;
  CameraImage? cameraImage;
  List? recognitionsList;
  XFile image = XFile('');

  initCamera() async {
    if (cameras.isEmpty != null) {
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  runModel() async {
    try {
      recognitionsList = await Tflite.detectObjectOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResultsPerClass: 1,
        threshold: 0.4,
      );

      setState(() {
        cameraImage;
      });
    } catch (e) {}
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
  }

  @override
  void dispose() {
    super.dispose();

    cameraController!.stopImageStream();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();

    initCamera();
    // loadModel();
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitionsList == null) return [];

    double factorX = screen.width;
    double factorY = screen.height;

    Color colorPick = Colors.pink;

    return recognitionsList!.map((result) {
      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> list = [];

    list.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height - 100,
        child: Container(
          height: size.height - 100,
          child: (!cameraController!.value.isInitialized)
              ? new Container()
              : AspectRatio(
                  aspectRatio: cameraController!.value.aspectRatio,
                  child: CameraPreview(cameraController!),
                ),
        ),
      ),
    );

    if (cameraImage != null) {
      list.addAll(displayBoxesAroundRecognizedObjects(size));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Deteksi Makanan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: size.height * 0.7,
                width: size.width,
                // margin: EdgeInsets.only(top: 50),
                color: Colors.transparent,
                child: image.path.isEmpty
                    ? (!cameraController!.value.isInitialized)
                        ? new Container()
                        : AspectRatio(
                            aspectRatio: cameraController!.value.aspectRatio,
                            child: CameraPreview(cameraController!),
                          )
                    : Image.file(File(image.path)),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: image.path.isEmpty
                    ? () async {
                        try {
                          if (cameraController != null) {
                            //check if contrller is not null
                            if (cameraController!.value.isInitialized) {
                              //check if cameraController is initialized
                              image = await cameraController!
                                  .takePicture(); //capture image
                              setState(() {
                                //update UI
                              });
                            }
                          }
                        } catch (e) {
                          print(e); //show error
                        }
                        // print(image!.path.toString());
                      }
                    : () {
                        setState(() {
                          imageCache!.clear();

                          image = XFile('');
                          print(image.path.toString());
                        });
                      },
                child: CircleAvatar(
                  radius: size.height * 0.04,
                  child: image.path.isEmpty
                      ? CircleAvatar(
                          radius: size.height * 0.036,
                          backgroundColor: Colors.grey)
                      : CircleAvatar(
                          radius: size.height * 0.036,
                          // backgroundColor: Colors.grey,
                          child: const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 50,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
