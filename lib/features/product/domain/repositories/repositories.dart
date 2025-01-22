import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure,void>> toggleFavorite(String userId,int productId,bool isFavorite);
  Future<Either<Failure,List<int>>> getFavouriteProductsId(String userId);
}