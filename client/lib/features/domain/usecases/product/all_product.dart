import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../entity/product_view_entity.dart';
import '../../repository/product_repository.dart';

class AllProduct implements UseCase<List<ProductViewEntity>, NoParams> {
  final ProductRepository productRepository;

  AllProduct(this.productRepository);

  @override
  Future<Either<Failure, List<ProductViewEntity>>> call(NoParams params) async {
    return await productRepository.getAllProduct();
  }
}
