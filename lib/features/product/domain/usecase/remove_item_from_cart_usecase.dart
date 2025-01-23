import 'package:ecommerce_app/features/product/domain/entities/cart_model.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';

class RemoveItemFromCartUsecase {
  final ProductRepository productRepository;

  RemoveItemFromCartUsecase(this.productRepository);

  Future<void> call(String userId, CartModel cartItem) {
    return productRepository.removeItemFromCart(userId, cartItem);
  }
}