import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/models/user_info.dart';
import 'package:innove_gen_ai_frontend/util/decoration_util.dart';
import 'package:innove_gen_ai_frontend/widgets/filter_card.dart';
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

class _ProductSummaryState extends State<ProductSummary> with DecorationUtil {
  BackendConnector backendConnector = BackendConnector();

  late Product product;
  late String authToken;

  Future<Prediction> retrieveProduct(List<String> filters) async {
    product =
        Provider
            .of<ProductsInfo>(context, listen: false)
            .getSingleProduct;
    authToken = Provider
        .of<UserInfo>(context, listen: false)
        .getAuthValue;
    return backendConnector.callFreeForm(product.productId, authToken, filters);

    // one for the morning - do we want to make a call to the backend after the user has applied to selected filter or
    // have all the filtered text options available from the initial call then we only have to replace the text shown when they 'apply' the filter

  }

  @override
  void initState() {
    super.initState();
  }


  Widget getMainBody(Widget child, BuildContext context, Product product) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            widthFactor: 7,
            alignment: Alignment.bottomLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.grey),
            ),
          ),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(
                        product.productName,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Overall sentiment',
                  style:
                  prettifyText(Theme
                      .of(context)
                      .textTheme
                      .headlineSmall!),
                ),
                const SizedBox(height: 18),
                //replace with scrollable widget containing longer text
                Expanded(child: child),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FloatingActionButton(
            elevation: 2,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => MyFilterCard(),
              );
            },
            backgroundColor: Colors.lightBlueAccent.shade200,
            child: const Icon(
              Icons.tune,
              weight: 20,
              size: 36,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
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
                                height: 200,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                snapshot.data!.content,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
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
}