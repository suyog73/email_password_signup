import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_signup/helpers/validators.dart';
import 'package:email_password_signup/screens/home_screen.dart';
import 'package:email_password_signup/screens/login_screen.dart';
import 'package:email_password_signup/widgets/input_fields.dart';
import 'package:email_password_signup/widgets/logo_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Firebase auth
  final _auth = FirebaseAuth.instance;

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Editing Controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // username field
    final usernameField = InputField(
      label: 'Username',
      icon: Icons.account_circle,
      onChange: (username) {
        usernameController.value =
            usernameController.value.copyWith(text: username);
      },
      controller: usernameController,
      textInputType: TextInputType.name,
      validator: usernameValidator,
    );

    // email field
    final emailField = InputField(
      label: 'Email',
      icon: Icons.mail,
      onChange: (email) {
        emailController.value = emailController.value.copyWith(text: email);
      },
      controller: emailController,
      textInputType: TextInputType.emailAddress,
      validator: emailValidator,
    );

    // password field
    final passwordField = InputField(
      label: 'Password',
      obscureText: true,
      icon: Icons.vpn_key,
      onChange: (password) {
        passwordController.value =
            passwordController.value.copyWith(text: password);
      },
      controller: passwordController,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.visiblePassword,
      validator: passwordValidator,
    );

    // cPassword field
    final cPasswordField = InputField(
      label: 'Confirm Password',
      obscureText: true,
      icon: Icons.vpn_key,
      onChange: (cPassword) {
        cPasswordController.value =
            cPasswordController.value.copyWith(text: cPassword);
      },
      controller: cPasswordController,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      validator: (value) {
        if (value != passwordController.text) {
          return 'Password and Confirm password doesn\'t match';
        }
      },
    );

    // SignUp button
    final signupButton = InkWell(
      onTap: () {
        signUp(emailController.text, passwordController.text);
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
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
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
          child: Text(
            'SignUp',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LogoImage(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      usernameField,
                      const SizedBox(height: 10),
                      emailField,
                      const SizedBox(height: 10),
                      passwordField,
                      const SizedBox(height: 10),
                      cPasswordField,
                      const SizedBox(height: 30),
                      signupButton,
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              ' Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => {sendDetailsToFireStore()},
          )
          .catchError(
            (e) => {Fluttertoast.showToast(msg: e!.message)},
          );
    }
  }

  sendDetailsToFireStore() async {
    // calling firestore
    // calling user model
    // sending data

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    await firebaseFirestore.collection('users').doc(user!.uid).set({
      "email": user.email,
      "password": passwordController.text,
      "username": usernameController.text,
      "uid": user.uid,
    });

    Fluttertoast.showToast(msg: 'Account created successfully');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
