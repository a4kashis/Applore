import 'package:applore/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:applore/screens/dashboard.dart';
import 'package:applore/screens/manageProducts.dart';

Map<String, WidgetBuilder> routes = {
  '/login': (BuildContext context) => Login(),
  '/dashboard': (BuildContext context) => Dashboard(),
  '/manage': (BuildContext context) => ManageProducts(),
};
