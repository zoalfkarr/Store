import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/user/domain/usecases/get_products_usecase.dart';
import 'package:store/features/user/presentation/cubit/product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductCubit(this.getProductsUseCase) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    final result = await getProductsUseCase();
    result.fold(
      (failure) => emit(
        ProductError(
          failure.message,
          isNetworkError: failure is NetworkFailure,
        ),
      ),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}
