import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innove_gen_ai_frontend/models/SentimentAnalysisResponse.dart';
import 'package:innove_gen_ai_frontend/models/ProductResponse.dart';

class BackendConnector {

  // final String _baseUrl = "http://localhost:1000";
  final String _baseUrl = "https://innove-gen.duckdns.org";

  final String _keywordsRoute = 'keywords';
  final String _sentimentAnalysisRoute = 'sentiment-analysis';
  final String _freeFormRoute = 'freeform';
  final String _productsRoute = 'products';

  Future<Prediction> callKeywords(String productId, List<String> filters) async {
    var uri = Uri.parse("$_baseUrl/$_keywordsRoute");
    final Map<String, String> headers = {
      'Authorization': 'Bearer token',
      'Content-Type': 'application/json',
    };

    var filtersString = filterValue(filters).map((e) => "\"${e.toLowerCase()}\"").join(",");

    final response = await
    http.post(uri, body: """{
    "product_id": "$productId",
    "datasetSize": 30,
    "filters": [$filtersString]
    }""" , headers: headers);

    if (response.statusCode == 200) {
      print("Keywords success code = ${response.statusCode}");
      return Prediction.fromJson(jsonDecode(response.body));
    } else {
      print("Keywords error code = ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  }

  List<String> filterValue(List<String> filters) {
    if(filters.contains("Negative") && filters.contains("Positive")){
      return filters.where((element) => element == "Recent" || element == "Sponsored").toList();
    } else {
      return filters;
    }
  }

  Future<Prediction> callSentimentAnalysis(String productId, List<String> filters) async {
    var uri = Uri.parse("$_baseUrl/$_sentimentAnalysisRoute");
    final Map<String, String> headers = {
      'Authorization': 'Bearer token',
      'Content-Type': 'application/json',
    };

    var filtersString = filterValue(filters).map((e) => "\"${e.toLowerCase()}\"").join(",");

    final response = await
    http.post(uri, body: """{
    "product_id": "$productId",
    "datasetSize": 68,
    "filters": [$filtersString]
    }""" , headers: headers);

    if (response.statusCode == 200) {
      print("Sentiment success code = ${response.statusCode}");
      return Prediction.fromJson(jsonDecode(response.body));
    } else {
      print("Sentiment error code = ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  }

  Future<Prediction> callFreeForm(String productId, List<String> filters) async {
    var uri = Uri.parse("$_baseUrl/$_freeFormRoute");
    final Map<String, String> headers = {
      'Authorization': 'Bearer token',
      'Content-Type': 'application/json',
    };

    var filtersString = filterValue(filters).map((e) => "\"${e.toLowerCase()}\"").join(",");

    String prompt() {
      if(filterValue(filters).contains("Positive")){
        return "Be detailed and describe the highlights of the product.";
      } else if(filterValue(filters).contains("Negative")){
        return "Be detailed and describe the drawbacks of the product.";
      } else {
        return "Be detailed and describe the highlights and the drawbacks of the product.";
      }
    }

    final response = await
    http.post(uri, body: """{
    "product_id": "$productId",
    "prompt": "Create a review based off of the inputs. ${prompt()} Keep the review to one paragraph.",
    "datasetSize": 80,
    "parameters": {
         "temperature": 0.2,
         "maxOutputTokens": 400,
         "topP": 0.8,
         "topK": 40
    },
    "filters": [$filtersString]
    }""" , headers: headers);


    if (response.statusCode == 200) {
      print("Review success code = ${response.statusCode}");
      return Prediction.fromJson(jsonDecode(response.body));
    } else {
      print("Review error code = ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  }

  Future<List<Product>> callProducts() async {
    var uri = Uri.parse("$_baseUrl/$_productsRoute");

    final response = await http.get(uri);

    if(response.statusCode == 200) {
      print("Products success code = ${response.statusCode}");
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      print("Products error code = ${response.statusCode}");
      throw Exception('Failed to load data');
    }

  }
}