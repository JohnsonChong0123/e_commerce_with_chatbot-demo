import 'package:fpdart/fpdart.dart';
import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/entity/product_view_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../sources/remote/product_remote_data.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteData productRemoteData;
  const ProductRepositoryImpl(this.productRemoteData);

  @override
  Future<Either<Failure, List<ProductViewEntity>>> getAllProduct() async {
    try {
      final product = await productRemoteData.getAllProduct();
      return right(product);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
