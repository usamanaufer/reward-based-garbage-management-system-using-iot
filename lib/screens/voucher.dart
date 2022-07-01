import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:garbage_app_create/mode/user_model.dart';
import 'package:garbage_app_create/screens/home_screen.dart';
import 'package:garbage_app_create/screens/login_screen.dart';
import 'package:garbage_app_create/screens/safety.dart';
import 'package:garbage_app_create/screens/scanned.dart';
import 'package:garbage_app_create/screens/voucher_discount.dart';
import 'package:garbage_app_create/screens/voucher_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class Voucher extends StatefulWidget {
  @override
  _VoucherState createState() => _VoucherState();
}

class _VoucherState extends State<Voucher> {
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

  var PagesAll = [HomeScreen(), Voucher(), HomeScreen()];

  var myindex = 0;

  bool _isSending = false;

  Future<void> sendEmail() async {
    setState(() => _isSending = true);

    final callable = functions.httpsCallable('create');
    final results = await callable();

    setState(() => _isSending = false);

    debugPrint(results.data);
  }

  Future<void> redeemVoucher() async {
    setState(() => _isSending = true);

    final callable = functions.httpsCallable('voucher');
    final results = await callable();

    setState(() => _isSending = false);

    debugPrint(results.data);
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
              final points = "${data.docs[index]['points']}";
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
                      Text(
                        "YOUR BALANCE",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${data.docs[index]['points']}",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 100,
                              color: Colors.green.shade800,
                            ),
                          ),
                          Text(
                            "POINTS",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "WASTE POINTS COUPONS",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 10,
                        color: Colors.green.shade800,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/cocotree.png",
                            height: 60,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                "Purhcase 5 Dairy milk\n and get two dairy milk for free",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/pointslogo.png",
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "200 Points",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  var voucherPoints = int.parse(
                                      "${data.docs[index]['points']}");
                                  if (voucherPoints >= 200) {
                                    Dialogs.materialDialog(
                                      color: Colors.white,
                                      msg: "Please click Continue to claim",
                                      title: 'You can claim the discount !',
                                      lottieBuilder: Lottie.asset(
                                        'assets/claim.json',
                                        fit: BoxFit.contain,
                                      ),
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VoucherClaim()),
                                            );
                                          },
                                          text: 'Contitue',
                                          color: Colors.green.shade800,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                  } else {
                                    Dialogs.materialDialog(
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
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                  }
                                },
                                child: Text(
                                  'Redeem',
                                  style: GoogleFonts.montserrat(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 10,
                        color: Colors.green.shade800,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/cocotree.png",
                            height: 60,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                "Purchase for Over Rs.3000 \n and get a Free Ice \nCream from Food city",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/pointslogo.png",
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "50 Points",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  var voucherPoints = int.parse(
                                      "${data.docs[index]['points']}");
                                  if (voucherPoints >= 50) {
                                    Dialogs.materialDialog(
                                      color: Colors.white,
                                      msg: "Please click Continue to claim",
                                      title: 'You can claim the discount !',
                                      lottieBuilder: Lottie.asset(
                                        'assets/claim.json',
                                        fit: BoxFit.contain,
                                      ),
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VoucherClaimTwo(),
                                              ),
                                            );
                                          },
                                          text: 'Contitue',
                                          color: Colors.green.shade800,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                  } else {
                                    Dialogs.materialDialog(
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
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                  }
                                },
                                child: Text(
                                  'Redeem',
                                  style: GoogleFonts.montserrat(),
                                ),
                              ),
                            ],
                          ),
                        ],
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
