import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';
import 'package:fpdart/fpdart.dart';

class GetFavouriteProductsIdUsercase {
  final ProductRepository productRepository;

  GetFavouriteProductsIdUsercase(this.productRepository);

  Future<Either<Failure, List<int>>> call(String userId) async {
    return await productRepository.getFavouriteProductsId(userId);
  }
}
