import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/models/user_info.dart';
import 'package:provider/provider.dart';

import '../connectors/backend_connector.dart';
import '../models/ProductResponse.dart';
import '../models/SentimentAnalysisResponse.dart';
import '../models/products_info.dart';

class ProductSummary extends StatefulWidget {
  const ProductSummary({Key? key}) : super(key: key);

  @override
  State<ProductSummary> createState() => _ProductSummaryState();
}

class _ProductSummaryState extends State<ProductSummary> {
  BackendConnector backendConnector = BackendConnector();

  // gets data from provider
  // makes function call to backend to summarise

  late Product product;
  late String authToken;
  late List<String> filters;

  Future<Prediction> retrieveProduct(List<String> filters) async {
    product =
        Provider.of<ProductsInfo>(context, listen: false).getSingleProduct;
    authToken = Provider.of<UserInfo>(context, listen: false).getAuthValue;
    return backendConnector.callFreeForm(product.productId, authToken, filters);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: retrieveProduct([]),
          builder: (BuildContext context, AsyncSnapshot<Prediction> snapshot) {
            if (!snapshot.hasData) {
              return getMainBody(
                  const Center(child: CircularProgressIndicator()),
                  context,
                  product);
            }
            return getMainBody(
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                product.image,
                                height: 250,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                snapshot.data!.content,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                context,
                product);
          },
        ),
      ),
    );
  }
  
  Widget getMainBody(Widget child, BuildContext context, Product product) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            height: 650,
            width: 325,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Overall sentiment',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 18),
                //replace with scrollable widget containing longer text
                Expanded(child: child),
              ],
            ),
          ),
          FloatingActionButton(
            elevation: 2,
            onPressed: () {
              retrieveProduct([
                //TODO refresh page when new filter applied / show filter options and refresh when options applied
                // "positive",
                "negative",
                // "recent"
              ]);
            },
            backgroundColor: Colors.lightBlueAccent.shade200,
            child: const Icon(
              Icons.tune,
              weight: 100,
              size: 36,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
