import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbage_app_create/main.dart';
import 'package:garbage_app_create/mode/user_model.dart';
import 'package:garbage_app_create/screens/login_screen.dart';
import 'package:garbage_app_create/screens/safety.dart';
import 'package:garbage_app_create/screens/scanned.dart';
import 'package:garbage_app_create/screens/voucher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            color: Colors.green.shade800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Colors.white,
      //   color: Colors.green,
      //   animationDuration: Duration(milliseconds: 300),
      //   key: _NavKey,
      //   items: [
      //     Icon((myindex == 0) ? Icons.home_outlined : Icons.home),
      //     Icon((myindex == 1) ? Icons.settings_outlined : Icons.settings),
      //     Icon((myindex == 2) ? Icons.person_outline : Icons.person),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       myindex = index;
      //     });
      //   },
      // ),
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

          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final totalWastePoints = "${data.docs[index]['points']}";
                return Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/homeui.png",
                      ),
                      Text(
                        "Your Waste Points",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/pointslogo.png",
                            height: 90,
                          ),
                          Text(
                            "${data.docs[index]['points']}",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 100,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${loggedInUser.email}",
                        style: GoogleFonts.montserrat(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scan_Screen(),
                                fullscreenDialog: true),
                          );
                        },
                        child: Text(
                          'START',
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
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
