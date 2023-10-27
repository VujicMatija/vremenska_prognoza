import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vremenska_prognoza_v2/screens/locationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 0, 102)),
          textTheme: GoogleFonts.passionOneTextTheme()),
      home: LocationPage(),
    );
  }
}
