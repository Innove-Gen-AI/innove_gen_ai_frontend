import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/views/product_review_summary_view.dart';

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
          headlineMedium: theme.textTheme.headlineLarge!.copyWith(
            color: Colors.lightBlueAccent.shade200,
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: theme.textTheme.headlineLarge!.copyWith(
            color: Colors.lightBlueAccent.shade200,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.lightBlueAccent.shade100,
              Colors.white,
              Colors.deepPurple.shade100
            ],
          ),
        ),
        child: const SafeArea(child: Home()),
      ),
    );
  }
}
