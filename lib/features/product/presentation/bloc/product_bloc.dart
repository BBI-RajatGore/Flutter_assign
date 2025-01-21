import 'package:ecommerce_app/features/product/domain/entities/product_model.dart';
import 'package:ecommerce_app/features/product/domain/usecase/get_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;

  List<ProductModel> _productModel = [];

  ProductBloc({
    required this.getProductsUsecase,
  }) : super(ProductInitial()) {
    on<GetProductEvent>(_getProductEvent);
  }

  Future<void> _getProductEvent(
      GetProductEvent event, Emitter<ProductState> emit) async {

    emit(ProductLoading());
    

    if(_productModel.isNotEmpty){
      emit(ProductLoaded(_productModel));
      return ;
    }

    final  response = await getProductsUsecase.call();

    
    response.fold((left) {
      emit(ProductError(left.message));
    }, (right) {
      _productModel = right;
      emit(ProductLoaded(right));
    });
  }


}
