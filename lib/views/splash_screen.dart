import 'dart:async';

import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/util/decoration_util.dart';
import 'package:innove_gen_ai_frontend/views/home.dart';
import 'package:provider/provider.dart';
import '../models/products_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with DecorationUtil {

  var myFuture;

  int delay = 4;

  @override
  void initState() {
    super.initState();
    myFuture = Provider.of<ProductsInfo>(context, listen: false).populateList().then((value) =>
        Future.delayed(Duration(seconds: delay)).then((value) =>
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => withScreenDecoration(const Home()),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'AI.Rev→',
                  style:
                  prettifyText(Theme.of(context).textTheme.headlineLarge!).copyWith(fontSize: 70),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Text(
                    'The power of AI curated reviews',
                    textAlign: TextAlign.center,
                    style:
                        prettifyText(Theme.of(context).textTheme.headlineMedium!).copyWith(color: Colors.grey.shade400, fontSize: 40),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
