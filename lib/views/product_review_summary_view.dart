import 'package:flutter/material.dart';
import 'package:innove_gen_ai_frontend/models/filter_info.dart';
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

class _ProductSummaryState extends State<ProductSummary> with DecorationUtil, TickerProviderStateMixin{
  BackendConnector backendConnector = BackendConnector();

  late Product product;
  late String authToken;
  late final TabController _tabBarController;

  List<String> convertToList(String input) => input.replaceAll("'","\"").replaceAll("[", "").replaceAll("]","").split(",");

  Future<Prediction> retrieveReview(List<FilterOptions> filters) async {
    product =
        Provider
            .of<ProductsInfo>(context, listen: false)
            .getSingleProduct;
    authToken = Provider
        .of<UserInfo>(context, listen: false)
        .getAuthValue;
    return backendConnector.callFreeForm(product.productId, authToken, filters.map((e) => e.name).toList());
  }

  Future<Prediction> retrieveSentimentAnalysis(List<FilterOptions> filters) async {
    product =
        Provider
            .of<ProductsInfo>(context, listen: false)
            .getSingleProduct;
    authToken = Provider
        .of<UserInfo>(context, listen: false)
        .getAuthValue;
    return backendConnector.callSentimentAnalysis(product.productId, authToken, filters.map((e) => e.name).toList());
  }

  String sentimentCalculation(List<String> input) {
    int positive = (input.where((element) => element.contains("positive")).toList()).length;
    int negative = (input.where((element) => element.contains("negative")).toList()).length;
    int totalCount = positive + negative;
    double calculation = ((positive - negative) / totalCount) * 100;
    double checkCalculation = calculation < 0 ? 0.00 : calculation;
    return checkCalculation.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  Widget getMainBody(Widget child, BuildContext context, Product product, String title, List<String> sentimentAnalysis) {
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TabBar.secondary(
                        isScrollable: true, // Allows the tabs to scroll horizontally
                        indicatorPadding: EdgeInsets.zero, // Removes padding around the selected tab indicator
                        labelPadding: EdgeInsets.symmetric(horizontal: 8.0), // Reduces horizontal padding around the tab labels
                        labelColor: Colors.lightBlueAccent.shade200,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: prettifyText(Theme.of(context).textTheme.labelLarge!),
                        controller: _tabBarController,
                        tabs: const <Widget>[
                          Tab(text: 'Review'),
                          Tab(text: 'Data'),
                        ],
                      ),
                    ),
                     Expanded(flex: 1,child: Container())
                  ],
                ),
                Expanded(child: TabBarView(
                  controller: _tabBarController,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          title,
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
                    Column(children: [
                      const SizedBox(height: 20.0),
                      Text('Sentiment Score', style: prettifyText(Theme.of(context).textTheme.titleLarge!)),
                      const SizedBox(height: 20.0),
                      Text(sentimentCalculation(sentimentAnalysis), style: prettifyText(Theme.of(context).textTheme.titleMedium!).copyWith(color: Colors.black))
                    ],)
                  ],
                ))
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
          future: Future.wait([retrieveReview(Provider.of<FilterInfo>(context).getFilterOptions), retrieveSentimentAnalysis(Provider.of<FilterInfo>(context).getFilterOptions) ]),
          builder: (BuildContext context, AsyncSnapshot<List<Prediction>> snapshot) {
            if (!snapshot.hasData) {
              return getMainBody(
                  const Center(child: CircularProgressIndicator()),
                  context,
                  product,
                  "Generating AI review sentiment..",List.empty());
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
                                snapshot.data![0].content,
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
                product,
            snapshot.data![0].title,
            convertToList(snapshot.data![1].content));
          },
        ),
      ),
    );
  }
}