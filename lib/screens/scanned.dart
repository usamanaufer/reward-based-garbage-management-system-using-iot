import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbage_app_create/mode/user_model.dart';
import 'package:garbage_app_create/screens/bottom.dart';
import 'package:garbage_app_create/screens/home_screen.dart';
import 'package:garbage_app_create/screens/safety.dart';

class Scanned extends StatefulWidget {
  @override
  _ScannedState createState() => _ScannedState();
}

class _ScannedState extends State<Scanned> {
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

  Future<void> updateDocument() async {
    setState(() => _isSending = true);

    final callable = functions.httpsCallable('update');
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
        .collection('games')
        .where(
          'isComplete',
          isEqualTo: 'true',
        )
        .where(
          'user',
          isEqualTo: '${loggedInUser.uid}',
        )
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome ICycle"),
        centerTitle: true,
      ),
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
                        height: 40,
                      ),
                      SizedBox(
                        height: 300,
                        child: Image.asset(
                          "assets/scanning.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Clean the Eniviroment Clean",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${data.docs[index]['points']}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 150,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async => await updateDocument().then(
                          (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          ),
                        ),
                        child: Text('End'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
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
