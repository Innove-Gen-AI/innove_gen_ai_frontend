import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            // TODO reformat the textfield t olook nicer
            child: TextField(),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                  text: 'Discover the power of ',
                  style: Theme.of(context).textTheme.headlineLarge,
                  children: [
                    TextSpan(
                      text: 'relevant reviews',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w800),
                    )
                  ]),
            ),
          ),
          Expanded(child: Container())
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
