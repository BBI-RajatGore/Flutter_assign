import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';
import 'package:fpdart/fpdart.dart';

class ToggleFavouriteUsecase {

  final ProductRepository productRepository;

  ToggleFavouriteUsecase(this.productRepository);

  Future<Either<Failure, void>> call(String userId,int productId,bool isFavorite) async {
    return await productRepository.toggleFavorite(userId, productId, isFavorite);
  }
}
