import 'package:ecommerce_app/features/product/domain/entities/cart_model.dart';

class CartState {}
class CartInitial extends CartState {}
class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> cartItems;

  CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}