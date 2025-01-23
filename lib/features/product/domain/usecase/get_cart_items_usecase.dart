import 'package:ecommerce_app/features/product/domain/entities/cart_model.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';

class GetCartItemsUsecase {

  final ProductRepository productRepository;

  GetCartItemsUsecase(this.productRepository);

  Future<List<CartModel>> call(String userId) {
    return productRepository.getCartItems(userId);
  }

}