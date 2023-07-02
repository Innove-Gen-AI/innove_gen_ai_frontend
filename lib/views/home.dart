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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const SizedBox(
            height: 60,
          ),

          //Search field
          Container(
            margin: const EdgeInsets.only(bottom: 138),
            padding: const EdgeInsets.only(left: 56),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.black26,
                      blurRadius: 2)
                ]),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search anything...',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          //Rich text content
          Expanded(
            flex: 2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: RichText(
                text: TextSpan(
                  text: 'Discover the power of ',
                  style: Theme.of(context).textTheme.headlineLarge,
                  children: [
                    TextSpan(
                      text: 'relevant reviews',
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Empty container for spacing
          Expanded(child: Container())
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
