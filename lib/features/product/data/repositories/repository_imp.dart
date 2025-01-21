import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/product/data/datasource/remote_data_source.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);


  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final products = await remoteDataSource.fetchProductsFromApi();
      return Right(products);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}