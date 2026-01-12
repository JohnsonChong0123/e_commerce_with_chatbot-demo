import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/entity/product_view_entity.dart';
import '../../../domain/usecases/product/all_product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final AllProduct _productUsecase;

  ProductCubit({
    required AllProduct allProductUseCase,
  })  : _productUsecase = allProductUseCase,
        super(ProductInitial());

  Future<void> loadProduct() async {
    debugPrint('loadProduct called');
    emit(ProductLoading());
    final res = await _productUsecase(NoParams());
    res.fold(
      (l) => emit(ProductFailure(l.message)),
      (r) => emit(ProductSuccess(r)),
    );
  }
}