import 'package:applore/conn/authentication.dart';
import 'package:applore/screens/dashboard.dart';
import 'package:applore/utilities/sizeconfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: Authentication.initializeFirebase(context: context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeHorizontal * 20,
                    horizontal: SizeConfig.blockSizeHorizontal * 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png"),
                    Spacer(),
                    _isSigningIn
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              side: BorderSide(width: 1.5, color: Colors.blue),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isSigningIn = true;
                              });

                              User? user =
                                  await Authentication.signInWithGoogle(
                                      context: context);

                              setState(() {
                                _isSigningIn = false;
                              });
                              if (user != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => Dashboard(
                                      user: user,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/google_logo.png',
                                    width: 30),
                                SizedBox(width: 20),
                                Text(
                                  "Sign In with Google",
                                  textScaleFactor: 1.2,
                                )
                              ],
                            ),
                          )
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
