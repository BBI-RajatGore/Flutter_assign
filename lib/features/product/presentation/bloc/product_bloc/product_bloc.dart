import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_favourite_products_id_usercase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/toggle_favourite_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  
  final GetProductsUsecase getProductsUsecase;
  final GetFavouriteProductsIdUsercase getFavouriteProductsIdUsercase;
  final ToggleFavouriteUsecase toggleFavouriteUsecase;

  List<ProductModel> _productList = [];

  ProductBloc(
      {required this.getProductsUsecase,
      required this.toggleFavouriteUsecase,
      required this.getFavouriteProductsIdUsercase})
      : super(ProductInitial()) {
    on<GetProductEvent>(_getProductEvent);
    on<ToggleFavoriteEvent>(_toggleFavoriteEvent);
    on<LoadFavoriteProductsIdEvent>(_loadFavouriteProductIdEvent);
    on<ClearProductListEvent>(_clearProductList);
  }

  Future<void> _getProductEvent(
      GetProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    if (_productList.isNotEmpty) {
      emit(ProductLoaded(_productList));
      return;
    }

    final productsResponse = await getProductsUsecase.call();

    productsResponse.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (products) async {
        _productList = products;
        add(LoadFavoriteProductsIdEvent());
      },
    );
  }

  Future<void> _loadFavouriteProductIdEvent(
      LoadFavoriteProductsIdEvent event, Emitter<ProductState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final favouriteIdsResponse =
        await getFavouriteProductsIdUsercase.call(userId);

    favouriteIdsResponse.fold((failure) {
      emit(ProductLoaded(_productList));
    }, (favoriteIds) {
      for (var product in _productList) {
        product.isFavorite = favoriteIds.contains(product.id);
      }

      emit(ProductLoaded(_productList));
    });
  }

  Future<void> _toggleFavoriteEvent(
      ToggleFavoriteEvent event, Emitter<ProductState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final product = _productList.firstWhere((p) => p.id == event.productId);

    final newIsFavorite = !product.isFavorite;

    final result = await toggleFavouriteUsecase.call(
        userId, event.productId, newIsFavorite);

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (_) {
        product.isFavorite = newIsFavorite;
        emit(ProductLoaded(_productList));
      },
    );
  }

  Future<void> _clearProductList(
      ClearProductListEvent event, Emitter<ProductState> emit) async {
    _productList = [];
    emit(ProductInitial());
  }

}
