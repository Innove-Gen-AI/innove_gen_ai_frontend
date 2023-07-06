import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innove_gen_ai_frontend/models/SentimentAnalysisResponse.dart';
import 'package:innove_gen_ai_frontend/models/ProductResponse.dart';

class BackendConnector {

  final String _baseUrl = "http://localhost:10041";
  final String _summariseRoute = 'summarise';
  final String _freeFormRoute = 'freeform';
  final String _productsRoute = 'products';

  Future<Prediction> callSummarise(String productId, String bearerToken) async {
    var uri = Uri.parse("$_baseUrl/$_summariseRoute");
    final Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    };

    final response = await
    http.post(uri, body: """{
    "product_id": "$productId"
    }""" , headers: headers);


    if (response.statusCode == 200) {
      print(response.body);
      return Prediction.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Prediction> callFreeForm(String productId, String bearerToken, List<String> filters) async {
    var uri = Uri.parse("$_baseUrl/$_freeFormRoute");
    final Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    };

    var filtersString = filters.map((e) => "\"${e.toLowerCase()}\"").join(",");

    final response = await
    http.post(uri, body: """{
    "product_id": "$productId",
    "prompt": "Create a review based off of the inputs. Be detailed and describe the highlights and the drawbacks of the product.",
    "datasetSize": 20,
    "parameters": {
         "temperature": 0.2,
         "maxOutputTokens": 400,
         "topP": 0.8,
         "topK": 40
    },
    "filters": [$filtersString]
    }""" , headers: headers);


    if (response.statusCode == 200) {
      print(response.body);
      return Prediction.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Product>> callProducts() async {
    var uri = Uri.parse("$_baseUrl/$_productsRoute");

    final response = await http.get(uri);

    if(response.statusCode == 200) {
      print(response.body);
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }

  }
}