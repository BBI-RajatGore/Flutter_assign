import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';
import 'package:fpdart/fpdart.dart';

class GetProductsUsecase {
  final ProductRepository productRepository;

  GetProductsUsecase(this.productRepository);

  Future<Either<Failure, List<ProductModel>>> call() async {
    return await productRepository.getProducts();
  }
}
