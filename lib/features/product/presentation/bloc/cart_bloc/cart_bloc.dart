import 'package:ecommerce_app/features/product/domain/entities/cart_model.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/domain/usecase/add_item_to_cart_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_cart_items_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/remove_item_from_cart_usecase.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/cart_bloc/cart_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetProductsUsecase getProductsUsecase;
  final AddItemToCartUsecase addItemToCart;
  final GetCartItemsUsecase getCartItems;
  final RemoveItemFromCartUsecase removeItemFromCart;

  Map<int, ProductModel> _productMap = {};
  
  List<CartModel> _cartItems = [];

  CartBloc({
    required this.getProductsUsecase,
    required this.addItemToCart,
    required this.getCartItems,
    required this.removeItemFromCart,
  }) : super(CartInitial()) {
    on<GetProductEventForCart>(_onGetProducts);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<GetCartEvent>(_onGetCartItems);
     on<LoadCartFunction>(_loadCartFunction);
  }


  Future<void> _onGetProducts(GetProductEventForCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final response = await getProductsUsecase.call();
    response.fold(
      (failure) {
        emit(CartError(failure.message));
      },
      (products) {
        _productMap = {for (var product in products) product.id: product};
      },
    );
  }


  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {

    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      if (_productMap.containsKey(event.productId)) {
        final product = _productMap[event.productId]!;
        final cartItem = CartModel(productId: product.id, quantity: event.quantity);

        await addItemToCart(userId, cartItem);

        add(GetCartEvent());
      } else {
        emit(CartError('Product not found.'));
      }
    } catch (e) {
      emit(CartError('Failed to add item to cart: $e'));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final cartItem = CartModel(productId: event.productId, quantity: event.quantity);
      await removeItemFromCart(userId, cartItem);

      add(GetCartEvent()); 
    } catch (e) {
      emit(CartError('Failed to remove item from cart: $e'));
    }
  }


  Future<void> _onGetCartItems(GetCartEvent event, Emitter<CartState> emit) async {

    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {

      final cartItems = await getCartItems.call(userId);


      final populatedCartItems = cartItems.map((cartItem) {
        final productId = cartItem.productId;
        return cartItem.copyWith(product: _productMap[productId]);
      }).toList();

      _cartItems = populatedCartItems;

      emit(CartLoaded(populatedCartItems));

    } catch (e) {

      emit(CartError('Failed to fetch cart items: $e'));

    }
  }


  Future<void> _loadCartFunction(LoadCartFunction event, Emitter<CartState> emit) async {
    emit(CartLoading());
    add(GetCartEvent());
  }





}