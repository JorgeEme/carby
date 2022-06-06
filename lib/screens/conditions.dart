import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';

import '/helpers.dart';

class WebViewXPage1 extends StatefulWidget {
  const WebViewXPage1({Key? key}) : super(key: key);
  @override
  _WebViewXPageState1 createState() => _WebViewXPageState1();
}

class _WebViewXPageState1 extends State<WebViewXPage1> {
  void _viewFile() async {
    const _url1 = 'https://m.carby.info/storage/terms.pdf';
    if (await canLaunch(_url1)) {
      await launch(_url1);
    } else {
      print('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Terms and use conditions'),
            backgroundColor: Colors.orangeAccent),
        body: Container(
            constraints: BoxConstraints(
                minHeight: 100,
                minWidth: double.infinity,
                maxHeight: (MediaQuery.of(context).size.height / 1.2)),
            color: Colors.white70,
            margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Terms and Conditions \n',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              text:
                                  "By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You're not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You're not allowed to attempt to extract the source code of the app, and you also shouldn't try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to .\n is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you're paying for. \n The Carby app stores and processes personal data that you have provided to us, to provide our Service. It's your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone's security features and it could mean that the Carby app won’t work properly or at all",
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          text: '\nChanges to This Terms and Conditions \n',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                text:
                                    "\nWe may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page. \n These terms and conditions are effective as of 2022-05-04"),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          text: '\n Contact Us \n',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                text:
                                    "\n If you have any questions or suggestions about our Terms and Conditions, do not hesitate to contact us at support@carby.info."),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent,
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        child: Text('Download terms'),
                        onPressed: _viewFile,
                      ),
                    ]))));
  }
}
