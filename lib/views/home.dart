// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:innove_gen_ai_frontend/connectors/backend_connector.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  BackendConnector backendConnector = BackendConnector();
  // replace with call to backend or directly to db to fetch product from list
  void _fetchSuggestions() {
    print('Text field search: ${_controller.text}');
  }

  final List<String> _suggestions = [
    "iPhone 12",
    "Samsung Galaxy S21",
    "MacBook Pro",
    "Google Pixel 5",
    "Sony PlayStation 5",
    "AirPods Pro",
    "Nintendo Switch",
    "Fitbit Versa 3",
    "DJI Mavic Air 2",
    "Amazon Echo Dot"
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_fetchSuggestions);
    backendConnector.callProducts("");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),

          // auto complete text search field
          Container(
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
            child: EasyAutocomplete(
              suggestions: _suggestions,
              suggestionBackgroundColor: Colors.white,
              onChanged: (value) => _fetchSuggestions(),
              onSubmitted: (value) => _fetchSuggestions(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Search anything...',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // standard text search field
          // Container(
          //   padding: const EdgeInsets.only(left: 56),
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(24),
          //       boxShadow: const [
          //         BoxShadow(
          //             offset: Offset(0, 4),
          //             color: Colors.black26,
          //             blurRadius: 2)
          //       ]),
          //   child: TextField(
          //     controller: _controller,
          //     decoration: const InputDecoration(
          //       border: InputBorder.none,
          //       labelText: 'Search anything...',
          //       suffixIcon: Icon(
          //         Icons.search,
          //         color: Colors.grey,
          //       ),
          //     ),
          //   ),
          // ),

          const SizedBox(
            height: 120,
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
