import 'dart:convert';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:http/http.dart' as http;


abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProductsFromApi();
}

class ProductRemoteDataSourceImpl  implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> fetchProductsFromApi() async {
    const String apiUrl = "https://dummyjson.com/products";

    final response = await client.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> response_map = json.decode(response.body);
      final List<dynamic> data = response_map["products"];
      print("object");
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products. Status Code: ${response.statusCode}');
    }
  }
}