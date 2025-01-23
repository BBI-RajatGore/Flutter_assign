

import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';

class CartModel {
  final int productId;
  final int quantity;
  ProductModel? product;

  CartModel({
    required this.productId,
    required this.quantity,
    this.product
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }


   CartModel copyWith({
    int? productId,
    int? quantity,
    ProductModel? product,
  }) {
    return CartModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}