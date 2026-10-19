import '../../domain/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  ProductsLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  final bool isNetworkError;

  ProductError(this.message, {this.isNetworkError = false});
}
