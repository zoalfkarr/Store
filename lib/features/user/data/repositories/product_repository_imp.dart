import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:store/features/user/domain/entities/product.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/product_repositry.dart';
import '../datasources/product_remote_data_source.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImp implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImp(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getProducts();
      return Right(remoteProducts);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.message ?? 'Error connecting to server'));
    } catch (e) {
      if (e is SocketException) {
        return const Left(NetworkFailure());
      }
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.error is SocketException ||
        e.message?.contains('SocketException') == true ||
        e.message?.contains('Network is unreachable') == true;
  }
}
