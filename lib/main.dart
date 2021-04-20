import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:applore/utilities/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MaterialApp(
            title: "Applore",
            debugShowCheckedModeBanner: false,
            initialRoute: '/login',
            // home: Dashboard(),
            routes: routes,
            theme: ThemeData(
              fontFamily: 'DroidSans',
              // primaryColor: red,
              // appBarTheme: AppBarTheme(color: red)),
            ),
          )));
}
