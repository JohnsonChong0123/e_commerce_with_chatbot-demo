part of 'product_cubit.dart';

sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductViewEntity> products;
  ProductSuccess(this.products);
}

class ProductFailure extends ProductState {
  final String message;
  ProductFailure(this.message);
}
