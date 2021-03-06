import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/GameScreen.dart';
import 'Screens/HelpScreen.dart';
import 'Screens/RecordsScreen.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Nokia XPress Remake',
    initialRoute: '/',
    routes:
    {
      '/': (BuildContext context) => HomeScreen(),
      '/game': (BuildContext context) => GameScreen(),
      '/records': (BuildContext context) => RecordsScreen(),
      '/help': (BuildContext context) => HelpScreen(),
    },
    theme: ThemeData(
      primarySwatch: Colors.pink,
      accentColor: Colors.white,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: GoogleFonts.play().fontFamily,
    ),
  ));
}