import 'dart:developer';

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
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter/foundation.dart';

// ignore: avoid_web_libraries_in_flutter
import 'package:universal_html/html.dart' show ImageElement;

import 'package:innove_gen_ai_frontend/views/web/platform_view_registry.dart';


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

  double viewWidth() {
    double defaultWidth = 325;
    if(kIsWeb){
      double width = MediaQuery.of(context).size.width / 3;
      if(width <= defaultWidth){
        return defaultWidth;
      } else {
        return width;
      }
    } else {
      return defaultWidth;
    }
  }

  List<String> convertToList(String input) {
    if(input.isEmpty){
      return List.empty();
    } else {
      return input.replaceAll("[", "").replaceAll("]","").replaceAll("\\", "").split(",").map(
              (e) => e.trim()
      ).map(
              (e) => e.replaceAll("'", "")
      ).toList();
    }
  }

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

  Future<Prediction> retrieveKeywords(List<FilterOptions> filters) async {
    product =
        Provider
            .of<ProductsInfo>(context, listen: false)
            .getSingleProduct;
    authToken = Provider
        .of<UserInfo>(context, listen: false)
        .getAuthValue;
    return backendConnector.callKeywords(
        product.productId, authToken, filters.map((e) => e.name).toList());
  }

  String sentimentCalculation(List<String> input) {
    int neutral = (input.where((element) => element.contains("neutral")).toList()).length;
    int positive = (input.where((element) => element.contains("positive")).toList()).length;
    int negative = (input.where((element) => element.contains("negative")).toList()).length;
    int totalCount = positive + negative + neutral;
    double calculation = ((positive + (neutral / 2)) / totalCount) * 100;
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

  double keywordsPadding(bool isWeb, {bool vertical = false}){
    if(isWeb){
      if(vertical){
        return 5;
      } else {
        return 8;
      }
    } else {
      if(vertical){
        return 0;
      } else {
        return 2;
      }
    }
  }

  double webMultiplier(double value, { double multi = 2 }) {
    if (kIsWeb) {
      return value * multi;
    } else {
      return value;
    }
  }

  double backArrowPadding() {
    double defaultPadding = 30;
    double width = MediaQuery.of(context).size.width;

    double padding = (width - viewWidth()) / 2 - 40;
    if(padding <= defaultPadding){
      return defaultPadding;
    } else {
      return padding;
    }
  }

  Widget getMainBody(Widget child, BuildContext context, Product product, String title, List<String> sentimentAnalysis, List<String> keywords) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: backArrowPadding()),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 12), //const EdgeInsets.all(24),
            height: 650,
            width: viewWidth(),
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
                        SizedBox(height: 12.0),
                        Text(
                          title,
                          style:
                          prettifyText(Theme
                              .of(context)
                              .textTheme
                              .titleLarge!),
                        ),
                        SizedBox(height: 10),
                        //replace with scrollable widget containing longer text
                        Expanded(child: child),
                      ],
                    ),
                    sentimentAnalysis.isEmpty ? Center(child: CircularProgressIndicator()) :
                    ListView(
                      children: [
                        const SizedBox(height: 16.0),
                        Center(child: Text('Keywords', style: prettifyText(Theme.of(context).textTheme.titleLarge!))),
                        SizedBox(height: webMultiplier(3.0, multi: 4.0)),
                        Center(
                          child: Wrap(
                            children: keywords.map((e) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: keywordsPadding(kIsWeb), vertical: keywordsPadding(kIsWeb, vertical: true)),
                              child: Chip(label: Text(e,
                                  style: const TextStyle(color: Colors.black, fontSize: 14)
                              )),
                            )).toList(),
                          ),
                        ),
                        SizedBox(height: webMultiplier(9.0, multi: 2.5)),
                        Center(child: Text('Sentiment Score', style: prettifyText(Theme.of(context).textTheme.titleLarge!))),
                      SfRadialGauge(
                        enableLoadingAnimation: true, title: GaugeTitle(text: 'Based on 80 product reviews', textStyle: prettifyText(Theme.of(context).textTheme.titleSmall!).copyWith(color: Colors.grey)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 100.000001, startAngle: 180, endAngle: 0, ticksPosition: ElementsPosition.outside, labelsPosition: ElementsPosition.outside,
                                ranges: <GaugeRange>[
                                  GaugeRange(startValue: 0, endValue: 33, color:Colors.red, label: "Negative", startWidth: 0.3, endWidth: 0.3, sizeUnit: GaugeSizeUnit.factor),
                                  GaugeRange(startValue: 33,endValue: 66,color: Colors.orange, label: "Neutral", startWidth: 0.3, endWidth: 0.3, sizeUnit: GaugeSizeUnit.factor),
                                  GaugeRange(startValue: 66,endValue: 100,color: Colors.green, label: "Positive", startWidth: 0.3, endWidth: 0.3, sizeUnit: GaugeSizeUnit.factor)],
                                pointers: <GaugePointer>[
                                  NeedlePointer(value: double.parse(sentimentCalculation(sentimentAnalysis)), enableAnimation: true,)],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(widget: Container(child:
                                  Text(sentimentCalculation(sentimentAnalysis) ,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                      angle: 90, positionFactor: 0.3
                                  )]
                            )]),

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


  Widget productImageCreation(String image){
    if(kIsWeb){
      return Center(
          child: Container(
              width: 180,
              height: 180,
              child: HtmlElementView(viewType: image)
          )
      );
    } else {
      return Image.network(
        image,
        height: 180,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    String start = DateTime.now().toIso8601String();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Future.wait([retrieveReview(Provider.of<FilterInfo>(context).getFilterOptions),
            retrieveSentimentAnalysis(Provider.of<FilterInfo>(context).getFilterOptions),
            retrieveKeywords(Provider.of<FilterInfo>(context).getFilterOptions)]),
          builder: (BuildContext context, AsyncSnapshot<List<Prediction>> snapshot) {
            if (!snapshot.hasData) {

              if(kIsWeb) {
                // ignore: undefined_prefixed_name
                platformViewRegistry.registerViewFactory(product.image, (int viewId) =>
                ImageElement()
                  ..style.height = 'auto'
                  ..style.maxWidth = '180px'
                  ..src = product.image
                );
              }

              return getMainBody(
                  const Center(child: CircularProgressIndicator()),
                  context,
                  product,
                  "Generating AI review sentiment..",List.empty(), List.empty());
            }

            print(start);
            print(DateTime.now().toIso8601String());

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
                              Text(
                                "Summarised from 80 product reviews",
                                style:
                                prettifyText(Theme.of(context).textTheme.titleSmall!).copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              productImageCreation(product.image),
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
            convertToList(snapshot.data![1].content),
            convertToList(snapshot.data![2].content)
            );
          },
        ),
      ),
    );
  }
}