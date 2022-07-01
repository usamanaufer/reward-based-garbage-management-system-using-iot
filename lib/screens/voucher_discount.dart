import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbage_app_create/mode/user_model.dart';
import 'package:garbage_app_create/screens/bottom.dart';
import 'package:garbage_app_create/screens/home_screen.dart';
import 'package:garbage_app_create/screens/login_screen.dart';
import 'package:garbage_app_create/screens/safety.dart';
import 'package:garbage_app_create/screens/scanned.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class VoucherClaimTwo extends StatefulWidget {
  @override
  _VoucherClaimTwoState createState() => _VoucherClaimTwoState();
}

class _VoucherClaimTwoState extends State<VoucherClaimTwo> {
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

  GlobalKey<CurvedNavigationBarState> _NavKey = GlobalKey();

  var myindex = 0;

  bool _isSending = false;

  Future<void> sendEmail() async {
    setState(() => _isSending = true);

    final callable = functions.httpsCallable('create');
    final results = await callable();

    setState(() => _isSending = false);

    debugPrint(results.data);
  }

  Future<void> redeemVoucherClaim() async {
    setState(() => _isSending = true);

    final callable = functions.httpsCallable('voucher');
    final results = await callable();

    setState(() => _isSending = false);

    debugPrint(results.data);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => bottom(),
      ),
    );
  }

  Future<void> redeemVoucherTwo() async {
    setState(() => _isSending = true);

    final callable = functions.httpsCallable('vouchersecond');
    final results = await callable();

    setState(() => _isSending = false);

    debugPrint(results.data);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => bottom(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> users = FirebaseFirestore.instance
        .collection('users')
        .where(
          'uid',
          isEqualTo: '${loggedInUser.uid}',
        )
        .snapshots();
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'iWaste',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: users,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        "assets/cocotree.png",
                        height: 200,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "CocoTree",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Purchase for Over Rs.3000 \n and get a Free Ice \nCream from Cocotree",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Cocotree, Pudhu Kada",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Image.asset(
                        "assets/barcode.webp",
                        height: 200,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async =>
                            await redeemVoucherTwo().whenComplete(
                          () => Dialogs.materialDialog(
                            color: Colors.white,
                            msg: "Don't Worry, Keep the eniviroment!",
                            title: 'Ops, Not Enought Points !',
                            lottieBuilder: Lottie.asset(
                              'assets/trash.json',
                              fit: BoxFit.contain,
                            ),
                            context: context,
                            actions: [
                              IconsButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: 'Ok',
                                color: Colors.green.shade800,
                                textStyle: TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        child: Text(
                          'Redeem Now',
                          style: GoogleFonts.montserrat(),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          padding: MaterialStateProperty.resolveWith<
                              EdgeInsetsGeometry>(
                            (Set<MaterialState> states) {
                              return EdgeInsets.fromLTRB(30, 20, 30, 20);
                            },
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green.shade800),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
