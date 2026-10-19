import 'package:dartz/dartz.dart';
import 'package:store/features/user/domain/entities/product.dart';

import '../../../../core/error/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
