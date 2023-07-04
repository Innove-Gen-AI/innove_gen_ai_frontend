import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/models/products_info.dart';
import 'package:innove_gen_ai_frontend/models/user_info.dart';
import 'package:innove_gen_ai_frontend/util/decoration_util.dart';
import 'package:innove_gen_ai_frontend/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserInfo(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductsInfo(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget with DecorationUtil {
  const MyApp({super.key});

  Future<void> _getProducts() {
    print('Getting products');
    return Future.delayed(const Duration(seconds: 1));
  }

  // default home
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
            headlineMedium: prettifyText(theme.textTheme.headlineLarge!),
            headlineLarge: prettifyText(theme.textTheme.headlineLarge!),
          ),
        ),
        home: withScreenDecoration(const SplashScreen()));
  }
}
