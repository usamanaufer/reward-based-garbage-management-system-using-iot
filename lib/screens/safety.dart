// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbage_app_create/mode/user_model.dart';
import 'package:garbage_app_create/screens/qrscanneroverlay.dart';
import 'package:garbage_app_create/screens/scanned.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_functions/cloud_functions.dart';

final functions = FirebaseFunctions.instance;

class Scan_Screen extends StatefulWidget {
  final functions = FirebaseFunctions.instance;
  @override
  _Scan_ScreenState createState() => _Scan_ScreenState();
}

class _Scan_ScreenState extends State<Scan_Screen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  bool _isSending = false;

  Future<void> sendEmail() async {
    setState(() => _isSending = true);

    final callable = functions.httpsCallable('create');
    final results = await callable();

    setState(() => _isSending = false);

    debugPrint(results.data);
  }

  MobileScannerController cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ICycle"),
        actions: [
          IconButton(
            onPressed: () {
              cameraController.switchCamera();
            },
            icon: Icon(Icons.camera_rear),
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) async => await sendEmail()
                .then(
                  (value) => CircularProgressIndicator(),
                )
                .whenComplete(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Scanned()),
                  ),
                ),
          ),
          QRScannerOverlay(
            overlayColour: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
