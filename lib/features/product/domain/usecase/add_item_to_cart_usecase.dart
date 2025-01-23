

import 'package:ecommerce_app/features/product/domain/entities/cart_model.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';

class AddItemToCartUsecase {
  final ProductRepository productRepository;

  AddItemToCartUsecase(this.productRepository);

  Future<void> call(String userId, CartModel cartItem) {
    return productRepository.addItemToCart(userId, cartItem);
  }
}