import 'package:carby/screens/signin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home.dart';
import 'images.dart';
import 'maplayout.dart';
import 'maplayout2.dart';
import 'signature.dart';

class Paypage extends StatelessWidget {
  const Paypage({Key? key}) : super(key: key);

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
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: const [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
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

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25.0),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                // add telefono validation
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacio';
                }
                if (value.length < 16) {
                  return 'Demasiado corto';
                }
                if (value.length > 16) {
                  return 'Demasiado largo';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Numero de la tarjeta',
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                // add nombre validation
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacio';
                }
                if (value.length < 4) {
                  return 'Demasiado corto';
                }
                if (value.length > 25) {
                  return 'Demasiado largo';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Introduce tu nombre',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                // add apellido validation
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacio';
                }
                if (value.length < 4) {
                  return 'Demasiado corto';
                }
                if (value.length > 25) {
                  return 'Demasiado largo';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                hintText: 'Introduce tus apellidos',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                // add fecha_caducidad validation
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacio';
                }
                if (value.length < 5) {
                  return 'Demasiado corto';
                }
                if (value.length > 5) {
                  return 'Demasiado largo';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Fecha de caducidad',
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                // add CVC validation
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacio';
                }
                if (value.length < 3) {
                  return 'Demasiado corto';
                }
                if (value.length > 3) {
                  return 'Demasiado largo';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'CVC',
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                // add direccion validation
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacio';
                }
                if (value.length < 4) {
                  return 'Demasiado corto';
                }
                if (value.length > 50) {
                  return 'Demasiado largo';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Direccion',
                hintText: 'Introduce tu direccion',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Tarjeta de trabajo'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),

            // boton de continuar
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 3, 135, 161)),
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(200, 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      /// Si todo esta bien, te llevara a la siguiente pagina
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapsSample()));
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: 'ATRAS\n\n',
                        recognizer: TapGestureRecognizer()
                          //TODO poner posicion centro, como el
                          ..onTap = () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage2()));
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
