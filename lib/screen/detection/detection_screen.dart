import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalori/view_models/detection_view_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../main.dart';
import 'component/output_bottom_sheet.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({Key? key}) : super(key: key);

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  File _imageFile = File('');

  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _isRearCameraSelected = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;

  final resolutionPresets = ResolutionPreset.values;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Perizinan kamera: Diberikan');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      onNewCameraSelected(cameras[0]);
    } else {
      log('Perizinan kamera: Ditolak');
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('Gagal mengambil gambar: $e');
      return null;
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      debugPrint('Gagal menginisialisasi kamera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void initState() {
    getPermissionStatus();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<DetectionViewModel>(context, listen: false).loadModel();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    controller!.stopImageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var viewModel = Provider.of<DetectionViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraPermissionGranted
          ? _isCameraInitialized
              ? _imageFile.path.isNotEmpty || _imageFile.path != ''
                  ? showImage(context)
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        imageCache!.clear();
                                        _imageFile = File('');
                                        Navigator.pushNamed(
                                            context, '/root_page');
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: kPrimaryBlue.withOpacity(.5),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/info');
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: kPrimaryBlue.withOpacity(.5),
                                        ),
                                        child: const Icon(
                                          Icons.info,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _currentFlashMode = FlashMode.off;
                                          });
                                          await controller!.setFlashMode(
                                            FlashMode.off,
                                          );
                                        },
                                        child: Icon(
                                          Icons.flash_off,
                                          color:
                                              _currentFlashMode == FlashMode.off
                                                  ? Colors.amber
                                                  : Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _currentFlashMode = FlashMode.auto;
                                          });
                                          await controller!.setFlashMode(
                                            FlashMode.auto,
                                          );
                                        },
                                        child: Icon(
                                          Icons.flash_auto,
                                          color: _currentFlashMode ==
                                                  FlashMode.auto
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _currentFlashMode =
                                                FlashMode.always;
                                          });
                                          await controller!.setFlashMode(
                                            FlashMode.always,
                                          );
                                        },
                                        child: Icon(
                                          Icons.flash_on,
                                          color: _currentFlashMode ==
                                                  FlashMode.always
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _currentFlashMode = FlashMode.torch;
                                          });
                                          await controller!.setFlashMode(
                                            FlashMode.torch,
                                          );
                                        },
                                        child: Icon(
                                          Icons.highlight,
                                          color: _currentFlashMode ==
                                                  FlashMode.torch
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            AspectRatio(
                              aspectRatio: 1 / controller!.value.aspectRatio,
                              child: Stack(
                                children: [
                                  CameraPreview(
                                    controller!,
                                    child: LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTapDown: (details) => onViewFinderTap(
                                            details, constraints),
                                      );
                                    }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: DropdownButton<
                                                  ResolutionPreset>(
                                                dropdownColor: Colors.black87,
                                                underline: Container(),
                                                value: currentResolutionPreset,
                                                items: [
                                                  for (ResolutionPreset preset
                                                      in resolutionPresets)
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        preset
                                                            .toString()
                                                            .split('.')[1]
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      value: preset,
                                                    )
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    currentResolutionPreset =
                                                        value!;
                                                    _isCameraInitialized =
                                                        false;
                                                  });
                                                  onNewCameraSelected(
                                                      controller!.description);
                                                },
                                                hint: const Text("Select item"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, top: 16.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                _currentExposureOffset
                                                        .toStringAsFixed(1) +
                                                    'x',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: SizedBox(
                                              height: 30,
                                              child: Slider(
                                                value: _currentExposureOffset,
                                                min:
                                                    _minAvailableExposureOffset,
                                                max:
                                                    _maxAvailableExposureOffset,
                                                activeColor: Colors.white,
                                                inactiveColor: Colors.white30,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    _currentExposureOffset =
                                                        value;
                                                  });
                                                  await controller!
                                                      .setExposureOffset(value);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Slider(
                                                value: _currentZoomLevel,
                                                min: _minAvailableZoom,
                                                max: _maxAvailableZoom,
                                                activeColor: Colors.white,
                                                inactiveColor: Colors.white30,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    _currentZoomLevel = value;
                                                  });
                                                  await controller!
                                                      .setZoomLevel(value);
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _currentZoomLevel
                                                            .toStringAsFixed(
                                                                1) +
                                                        'x',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isCameraInitialized = false;
                                                });
                                                onNewCameraSelected(cameras[
                                                    _isRearCameraSelected
                                                        ? 1
                                                        : 0]);
                                                setState(() {
                                                  _isRearCameraSelected =
                                                      !_isRearCameraSelected;
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.circle,
                                                    color: Colors.black38,
                                                    size: 60,
                                                  ),
                                                  Icon(
                                                    _isRearCameraSelected
                                                        ? Icons.camera_front
                                                        : Icons.camera_rear,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                XFile? rawImage =
                                                    await takePicture();
                                                _imageFile =
                                                    File(rawImage!.path);
                                                await viewModel.clasifyImage(
                                                    image: _imageFile);
                                                showModalBottomSheet(
                                                  backgroundColor:
                                                      kPrimaryLightColor,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(16),
                                                              topRight: Radius
                                                                  .circular(
                                                                      16))),
                                                  context: context,
                                                  builder: (_) {
                                                    return OutputBottomSheet(
                                                        size: size,
                                                        file: _imageFile,
                                                        viewModel: viewModel);
                                                  },
                                                );
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.white38,
                                                    size: 80,
                                                  ),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.white,
                                                    size: 65,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final filePicked =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery);
                                                if (filePicked!
                                                    .path.isNotEmpty) {
                                                  await viewModel.clasifyImage(
                                                      image: File(
                                                          filePicked.path));
                                                  setState(() {
                                                    _imageFile =
                                                        File(filePicked.path);

                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            kPrimaryLightColor,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        16),
                                                                topRight: Radius
                                                                    .circular(
                                                                        16))),
                                                        context: context,
                                                        builder: (_) {
                                                          return OutputBottomSheet(
                                                              size: size,
                                                              file: _imageFile,
                                                              viewModel:
                                                                  viewModel);
                                                        });
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Gagal mendapatkan path gambar',
                                                      backgroundColor:
                                                          Colors.white,
                                                      textColor:
                                                          Colors.black87);
                                                }
                                              },
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/galery.svg',
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
              : loadingCamera()
          : permissionCameraDenied(),
    );
  }

  Widget permissionCameraDenied() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(),
        const Text(
          'Perizinan Kamera di tolak',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            getPermissionStatus();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Berikan perizinan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget loadingCamera() {
    return const Center(
      child: Text(
        'LOADING',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget showImage(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.file(
                  _imageFile,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    imageCache!.clear();
                    _imageFile = File('');
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 80,
                    ),
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 65,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      imageCache!.clear();
                      _imageFile = File('');
                      Navigator.pushNamed(context, '/root_page');
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: kPrimaryBlue.withOpacity(.5),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/info');
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: kPrimaryBlue.withOpacity(.5),
                      ),
                      child: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
          )
        ]),
      ),
    );
  }
}
