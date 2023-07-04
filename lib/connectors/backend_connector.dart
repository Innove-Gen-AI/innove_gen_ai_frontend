import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innove_gen_ai_frontend/models/SentimentAnalysisResponse.dart';
import 'package:innove_gen_ai_frontend/models/ProductResponse.dart';

class BackendConnector {

  String baseUrl = "http://localhost:10041";
  String summariseRoute = 'summarise';
  String productsRoute = 'products';

  Future<Prediction> callSummarise(String productId, String bearerToken) async {
    var uri = Uri.parse("$baseUrl/$summariseRoute");
    final Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    };

    final response = await
    http.post(uri, body: """{
    "product_id": "$productId"
    }""" , headers: headers);


    if (response.statusCode == 200) {
      return Prediction.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Product>> callProducts(String bearerToken) async {
    var uri = Uri.parse("$baseUrl/$productsRoute");
    final Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken'
    };

    final response = await http.get(uri, headers: headers);

    if(response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }

  }
}