import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_signup/helpers/constants.dart';
import 'package:email_password_signup/screens/login_screen.dart';
import 'package:email_password_signup/widgets/logo_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  String? email;

  // get data from firebase using uid
  Future getData() async {
    var fireStore = FirebaseFirestore.instance;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await fireStore
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        username = value.data()!['username'];
        email = value.data()!['email'];
      }).catchError((error) {
        throw (error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // logout button
    final logoutButton = InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 15),
                  Text('App Name'),
                ],
              ),
              content: const Text('Do you want to logout from app'),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8),
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        logout(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6),
                            child: Text(
                              'Yes',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(55),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome', style: TextStyle(fontSize: 28)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoImage(),
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: const [
                      Text('Loading...', style: kTextStyle),
                      Text('Leading...', style: kTextStyle),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Text('$username', style: kTextStyle),
                      Text('$email', style: kTextStyle),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 55),
            logoutButton,
          ],
        ),
      ),
    );
  }

  // SignOut method
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Fluttertoast.showToast(msg: 'Successfully logged out');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
