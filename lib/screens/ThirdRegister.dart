import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'maplayout2.dart';
import 'package:image_picker/image_picker.dart';

class ThirdRegister extends StatelessWidget {
  const ThirdRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: _isSmallScreen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Logo(),
                      FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: const [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: FormContent()),
                        ),
                      ],
                    ),
                  )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/rent-a-car.png',
            width: _isSmallScreen ? 300 : 600,
            height: _isSmallScreen ? 100 : 150),
      ],
    );
  }
}

class FormContent extends StatefulWidget {
  const FormContent({Key? key}) : super(key: key);

  @override
  State<FormContent> createState() => _FormContentState();
}

class _FormContentState extends State<FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;
  String? _retrieveDataError;

  String dniAnverso = '';
  late Image initialImage;

  // images paths
  late Image dniA_path = Image.network('https://via.placeholder.com/60');
  late String dniA_value = '';

  late Image dniP_path = Image.network('https://via.placeholder.com/60');
  late String dniP_value = '';

  late Image cConducirA_path = Image.network('https://via.placeholder.com/60');
  late String cConducirA_value = '';

  late Image cConducirP_path = Image.network('https://via.placeholder.com/60');
  late String cConducirP_value = '';

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _onImageButtonPressed(ImageSource source, String chosenImage,
      {BuildContext? context, bool isMultiImage = false}) async {
    print("entered _onImageButtonPressed");
    if (isMultiImage) {
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
          print(pickedFile!);
          Uint8List bytes;
          switch (chosenImage) {
            case 'dniA_path':
              dniA_path = Image.file(File(pickedFile.path));
              File(pickedFile.path).readAsBytes().then((value) async {
                bytes = Uint8List.fromList(value);
                String base64String = base64Encode(bytes);
                dniA_value = base64String;
              });
              break;
            case 'dniP_path':
              dniP_path = Image.file(File(pickedFile.path));
              File(pickedFile.path).readAsBytes().then((value) async {
                bytes = Uint8List.fromList(value);
                String base64String = base64Encode(bytes);
                dniP_value = base64String;
              });
              break;
            case 'cConducirA_path':
              cConducirA_path = Image.file(File(pickedFile.path));
              File(pickedFile.path).readAsBytes().then((value) async {
                bytes = Uint8List.fromList(value);
                String base64String = base64Encode(bytes);
                cConducirA_value = base64String;
              });
              break;
            case 'cConducirP_path':
              cConducirP_path = Image.file(File(pickedFile.path));
              File(pickedFile.path).readAsBytes().then((value) async {
                bytes = Uint8List.fromList(value);
                String base64String = base64Encode(bytes);
                cConducirP_value = base64String;
              });
              break;
            default:
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

    //dniA_path = Image.file(File(_imageFileList![0].path));
    // _previewImages();
  }

  Widget _previewImages() {
    print("entered previewImages");
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      final File file = File(_imageFileList![0].path);
      print(file);
      //dniA_path = _imageFileList![0].path;
      dniA_path = Image.file(File(_imageFileList![0].path));
      Uint8List bytes;
      file.readAsBytes().then((value) {
        bytes = Uint8List.fromList(value);
        print(bytes);
      });
      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: Image.file(File(_imageFileList![index].path)),
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
    return _previewImages();
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    initialImage = Image.file(File('$dniAnverso'));
    return Container(
        height: MediaQuery.of(context).size.height / 1.4,
        margin: const EdgeInsets.only(top: 25.0),
        constraints: const BoxConstraints(maxWidth: 300),
        child: SingleChildScrollView(
          child: (Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("DNI Anterior")),
                    Expanded(
                      flex: 2,
                      // child: Card(
                      //   elevation: 10,
                      child: FloatingActionButton(
                        backgroundColor: Colors.blueAccent,
                        onPressed: () {
                          _onImageButtonPressed(
                            ImageSource.gallery,
                            "dniA_path",
                            context: context,
                            isMultiImage: false,
                          );
                        },
                        child: const Icon(Icons.photo_library),
                      ),
                    ),
                    // ),
                    Expanded(flex: 3, child: dniA_path),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("DNI Posterior")),
                    Expanded(
                      flex: 2,
                      // child: Card(
                      //   elevation: 10,
                      child: FloatingActionButton(
                        onPressed: () {
                          _onImageButtonPressed(
                            ImageSource.gallery,
                            "dniP_path",
                            context: context,
                            isMultiImage: false,
                          );
                        },
                        child: const Icon(Icons.photo_library),
                      ),
                      // ),
                    ),
                    Expanded(flex: 3, child: dniP_path),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("Carnet Anterior")),
                    Expanded(
                      flex: 2,
                      // child: Card(
                      //   elevation: 10,
                      child: FloatingActionButton(
                        onPressed: () {
                          _onImageButtonPressed(
                            ImageSource.gallery,
                            'cConducirA_path',
                            context: context,
                            isMultiImage: false,
                          );
                        },
                        child: const Icon(Icons.photo_library),
                      ),
                    ),
                    // ),
                    Expanded(flex: 3, child: cConducirA_path),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 3, child: Text("Carnet Posterior")),
                    Expanded(
                      flex: 2,
                      // child: Card(
                      //   elevation: 10,
                      child: FloatingActionButton(
                        onPressed: () {
                          _onImageButtonPressed(
                            ImageSource.gallery,
                            'cConducirP_path',
                            context: context,
                            isMultiImage: false,
                          );
                        },
                        child: const Icon(Icons.photo_library),
                      ),
                    ),
                    // ),
                    Expanded(flex: 3, child: cConducirP_path),
                  ],
                ),
                // boton de continuar
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 20, 110, 224)),
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size(200, 40)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Completar registro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        print("nepe");
                        // if (_formKey.currentState?.validate() ?? false) {
                        final Future<SharedPreferences> _prefs =
                            SharedPreferences.getInstance();
                        final SharedPreferences prefs = await _prefs;

                        // https://m.carby.info/api/users/upload-nif
                        // print(prefs.getString('userToken'));

                        final responseDNI = await http.post(
                            Uri.parse(globals.URL_API + 'users/upload-nif'),
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  prefs.getString('userToken')!,
                              HttpHeaders.contentTypeHeader: 'application/json',
                            },
                            body: json.encode({
                              "nif_front": dniP_value,
                              "nif_back": dniA_value
                            }));

                        // https://m.carby.info/api/users/upload-card
                        final responseCARD = await http.post(
                            Uri.parse(globals.URL_API + 'users/upload-card'),
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  prefs.getString('userToken')!,
                              HttpHeaders.contentTypeHeader: 'application/json',
                            },
                            body: json.encode({
                              "nif_front": cConducirP_value,
                              "nif_back": cConducirA_value
                            }));

                        /// Si todo esta bien, te llevara a la siguiente pagina
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapsSample()));
                        // }
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  Widget _gap() => const SizedBox(height: 16);
}
