import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/product/data/datasource/remote_data_source.dart';
import 'package:ecommerce_app/features/product/domain/entities/cart_model.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/domain/repositories/repositories.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  List<ProductModel>? _cachcedProducts;


  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {

    if(_cachcedProducts != null){
      return Right(_cachcedProducts!);
    }

    try {
      final products = await remoteDataSource.fetchProductsFromApi();
      _cachcedProducts = products;
      return Right(products);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<int>>> getFavouriteProductsId(String userId) async {
    try {
      final productIds = await remoteDataSource.getFavouriteProductsId(userId);
      return Right(productIds);
    } catch (e) {
      return Left(Failure('Failed to fetch favorite products'));
    }
  }
  
  @override
  Future<Either<Failure, void>> toggleFavorite(String userId, int productId, bool isFavorite) async {
      try {
      await remoteDataSource.toggleFavorite(userId, productId, isFavorite);
      return const Right(null);
    } catch (e) {
      return Left(Failure('Failed to toggle favorite'));
    }
  }


  @override
  Future<void> addItemToCart(String userId, CartModel cartItem) {
    return remoteDataSource.addItemToCart(userId, cartItem);
  }

  @override
  Future<void> removeItemFromCart(String userId, CartModel cartItem) {
    return remoteDataSource.removeItemFromCart(userId, cartItem);
  }

  @override
  Future<List<CartModel>> getCartItems(String userId) {
    return remoteDataSource.getCartItems(userId);
  }

}