// ignore_for_file: unnecessary_const

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:innove_gen_ai_frontend/connectors/backend_connector.dart';
import 'package:innove_gen_ai_frontend/models/ProductResponse.dart';
import 'package:innove_gen_ai_frontend/models/products_info.dart';
import 'package:innove_gen_ai_frontend/util/decoration_util.dart';
import 'package:innove_gen_ai_frontend/views/product_review_summary_view.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with DecorationUtil {
  final TextEditingController _controller = TextEditingController();

  // replace with call to backend or directly to db to fetch product from list
  Product fetchProduct(List<Product> products) {
    return products
        .singleWhere((element) => element.productName == _controller.text);
  }

  void handleOnSubmit(Product p) {
    Provider.of<ProductsInfo>(context, listen: false).foundProduct(p);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => withScreenDecoration(const ProductSummary()),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double webMultiplier(double value, { double multi = 2 }) {
    if (kIsWeb) {
      return value * multi;
    } else {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {

    double margin() {
      double defaultMargin = 24;
      double defaultWidth = 550;
      double width = MediaQuery.of(context).size.width;
      if (kIsWeb) {
        if(width <= defaultWidth){
          return defaultMargin;
        } else {
          return (width - defaultWidth) / 5;
        }
      } else {
        return defaultMargin;
      }
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),

          // auto complete text search field
          Container(
            padding: const EdgeInsets.only(left: 40),
            margin: EdgeInsets.symmetric(horizontal: margin()),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.black26,
                      blurRadius: 2)
                ]),
            child: Consumer<ProductsInfo>(
              builder: (context, products, child) {
                var listOfProducts = products.getProducts;

                return EasyAutocomplete(
                  controller: _controller,
                  suggestions:
                      listOfProducts.map((e) => e.productName).toList(),
                  suggestionBackgroundColor: Colors.white,
                  onSubmitted: (value) =>
                      handleOnSubmit(fetchProduct(listOfProducts)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Search anything...',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
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
              width: MediaQuery.of(context).size.width * 0.7,
              height: 216,
              child: Text(
                textAlign: TextAlign.center,
                'Experience the revolution of tailored reviews',
                style: prettifyText(Theme.of(context).textTheme.headlineMedium!)
                    .copyWith(color: Colors.grey.shade400, fontSize: 37),
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
