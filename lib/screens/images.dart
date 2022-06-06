import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:carby/screens/signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import '../translations/locale_keys.g.dart';
import 'package:signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'imagepicker.dart';

class Images extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  Images();

  @override
  _Images createState() => _Images();
}

class _Images extends State<Images> {
  // contract related
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  late int contractId;

  late String type;
  @override
  void initState() {
    super.initState();
    // _controller.addListener(() => print('Value changed'));
  }

  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // interaction (clicking on a "play" button, for example).
      const double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage(
          maxWidth: 600,
          maxHeight: 400,
          imageQuality: 70,
        );
        setState(() {
          if (_imageFileList != null) {
            _imageFileList!.addAll(pickedFileList!);
          } else {
            _imageFileList = pickedFileList;
          }
          // _imageFileList = pickedFileList;
          // _imageFileList!.addAll(pickedFileList!);
          //  _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        print("entered pickImage");
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 600,
          maxHeight: 400,
          imageQuality: 70,
        );
        setState(() {
          if (_imageFileList != null) {
            _imageFileList!.add(pickedFile!);
          } else {
            _imageFile = pickedFile;
          }
          //
        });
      } catch (e) {
        print("entered error");
        setState(() {
          _pickImageError = e;
        });
      }
      // });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }

    if (_imageFileList != null) {
      // final File file = File(_imageFileList![0].path);
      // print(file);
      // Uint8List bytes;
      // file.readAsBytes().then((value) {
      //   bytes = Uint8List.fromList(value);
      //   print(bytes);
      // });

      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(_imageFileList![index].path)
                    : Image.file(File(_imageFileList![index].path)),
              );
            },
            itemCount: _imageFileList!.length,
          ),
          label: 'image_picker_example_picked_images');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError ',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImages();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration myBoxDecoration() {
      return BoxDecoration(border: Border.all(), color: Colors.white);
    }

    BoxDecoration myMainBoxDecoration() {
      return BoxDecoration(
        border: Border.all(),
        color: const Color.fromARGB(255, 227, 227, 227),
      );
    }

    return Scaffold(
        appBar: AppBar(
          actions: const <Widget>[
            // your widget
          ],
          title: Text("Selector de imágenes"),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(
                    ImageSource.gallery,
                    context: context,
                    isMultiImage: true,
                  );
                },
                heroTag: 'image1',
                tooltip: 'Pick Multiple Image from gallery',
                child: const Icon(Icons.photo_library),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
            // NEXT BUTTON
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.greenAccent,
                onPressed: () {
                  // TODO go to Signature page + SAVE IMAGES
                  isVideo = false;
                  if (_imageFileList != null) {
                    final fileList = [];

                    if (_imageFileList!.isNotEmpty) {
                      print(_imageFileList!.length);
                      for (var i = 0; i < _imageFileList!.length; i++) {
                        final File file = File(_imageFileList![i].path);
                        final currentdate = DateTime.now();
                        Uint8List bytes;
                        file.readAsBytes().then((value) async {
                          bytes = Uint8List.fromList(value);
                          final doCheckinSign = await http.post(
                              Uri.parse('https://m.carby.info/api/test'),
                              headers: headers,
                              body: json.encode({
                                "any": currentdate.year,
                                "tipus": "document",
                                "state": 'upload',
                                "modificacio": currentdate.toIso8601String(),
                                "contingut": bytes,
                                // "contracte": contractId,
                              }));
                          // fileList.add({
                          //   "any": "2022",
                          //   "tipus": "document",
                          //   "modificacio": currentdate,
                          //   "contingut": bytes,
                          //   "contracte": contractId,
                          // });
                        });
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Sign(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(LocaleKeys.faltaImagen.tr()),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                  child: const Text("Ok"),
                                  style: TextButton.styleFrom(
                                    primary: Colors.orangeAccent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(LocaleKeys.faltaImagen.tr()),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                                child: const Text("Ok"),
                                style: TextButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        );
                      },
                    );
                  }
                },
                heroTag: 'image3',
                tooltip: 'Next',
                child: const Icon(Icons.arrow_forward),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  _imageFileList = null;
                  Navigator.of(context).pop();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Images()));
                },
                heroTag: 'video1',
                tooltip: 'Take a Video',
                child: const Icon(Icons.delete_forever),
              ),
            ),
          ],
        ),
        body: Center(
          child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return _handlePreview();
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
              : _handlePreview(),
        ));
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth if desired'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight if desired'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality if desired'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}
