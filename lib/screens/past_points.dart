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

class PastPoints extends StatefulWidget {
  @override
  _PastPointsState createState() => _PastPointsState();
}

class _PastPointsState extends State<PastPoints> {
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
        .collection('games')
        .where(
          'user',
          isEqualTo: '${loggedInUser.uid}',
        )
        .where(
          'isComplete',
          isEqualTo: 'false',
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

          Text(
            "Past Sessions",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          );

          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final totalWastePoints = "${data.docs[index]['points']}";
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            "${data.docs[index]['location']}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${data.docs[index]['garbage']}",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            "assets/pointslogo.png",
                            height: 20,
                          ),
                          Text(
                            "${data.docs[index]['points']}",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      )
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
