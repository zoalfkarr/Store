import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:store/features/user/domain/entities/product.dart';

import '../../../../core/error/failures.dart';
import '../repositories/product_repositry.dart';

@lazySingleton
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
