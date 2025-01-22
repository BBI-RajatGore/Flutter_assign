import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:http/http.dart' as http;


abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProductsFromApi();
  Future<List<int>> getFavouriteProductsId(String userId);
  Future<void> toggleFavorite(String userId, int productId, bool isFavorite);
}

class ProductRemoteDataSourceImpl  implements ProductRemoteDataSource {

  final http.Client client;
  final FirebaseFirestore _firebaseFirestore;

  ProductRemoteDataSourceImpl(this.client,this._firebaseFirestore);

  @override
  Future<List<ProductModel>> fetchProductsFromApi() async {
    const String apiUrl = "https://dummyjson.com/products";

    final response = await client.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = json.decode(response.body);
      final List<dynamic> data = responseMap["products"];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products. Status Code: ${response.statusCode}');
    }
  }


  @override
  Future<List<int>> getFavouriteProductsId(String userId) async {
    try {
      final userRef = _firebaseFirestore.collection('wishlist').doc(userId);
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('favourite')) {
          return List<int>.from(data['favourite']);
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
  }
  
@override
Future<void> toggleFavorite(String userId, int productId, bool isFavorite) async {
  try {
    final userRef = _firebaseFirestore.collection('wishlist').doc(userId);
    
    final docSnapshot = await userRef.get();

    if (!docSnapshot.exists) {

      await userRef.set({
        'favourite': [],
      });
    }

    if (isFavorite) {
      await userRef.update({
        'favourite': FieldValue.arrayUnion([productId]),
      });
    } else {
      await userRef.update({
        'favourite': FieldValue.arrayRemove([productId]),
      });
    }
  } catch (e) {
    throw Exception('Failed to toggle favorite: $e');
  }
}


}