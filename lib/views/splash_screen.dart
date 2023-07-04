import 'dart:async';

import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/util/decoration_util.dart';
import 'package:innove_gen_ai_frontend/views/home.dart';
import 'package:innove_gen_ai_frontend/views/login_view.dart';
import 'package:provider/provider.dart';

import '../connectors/backend_connector.dart';
import '../models/ProductResponse.dart';
import '../models/products_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with DecorationUtil {
  BackendConnector backendConnector = BackendConnector();

  Future<List<Product>> getProducts() {
    return backendConnector.callProducts();
  }

  var myFuture;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then(
      (value) => myFuture =
          Provider.of<ProductsInfo>(context, listen: false).populateList().then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => withScreenDecoration(const Login()),
                  ),
                ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(46)),
              ),
              Center(
                child: Text(
                  'Reviews you can trust',
                  style:
                      prettifyText(Theme.of(context).textTheme.headlineMedium!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
