import 'package:flutter/material.dart';

import 'views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          headlineLarge: theme.textTheme.headlineLarge!.copyWith(
              color: Colors.blue.shade400, fontWeight: FontWeight.w700),
        ),
      ),
      home: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue.shade300,
              Colors.white,
              Colors.deepPurple.shade300
            ],
          )),
          child: const SafeArea(child: Home())),
    );
  }
}
