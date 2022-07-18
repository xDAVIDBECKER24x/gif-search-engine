import 'package:flutter/material.dart';
import 'package:gif_search_engine/user_interface/home_page.dart';

void main() {
  runApp(MaterialApp(
    home : HomePage(),
    theme: ThemeData(hintColor: Colors.white),
    debugShowCheckedModeBanner: false,
  ));
}
