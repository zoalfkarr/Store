import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:store/core/di/register_module.dart';
import 'package:store/features/user/data/datasources/product_remote_data_source.dart';
import 'package:store/features/user/data/repositories/product_repository_imp.dart';
import 'package:store/features/user/domain/repositories/product_repositry.dart';
import 'package:store/features/user/domain/usecases/get_products_usecase.dart';
import 'package:store/features/user/presentation/cubit/product_cubit.dart';

extension GetItInjectableX on GetIt {
  GetIt init({String? environment, EnvironmentFilter? environmentFilter}) {
    final gh = GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<Dio>(() => registerModule.dio);
    gh.lazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(gh<Dio>()),
    );
    gh.lazySingleton<ProductRepository>(
      () => ProductRepositoryImp(gh<ProductRemoteDataSource>()),
    );
    gh.lazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(gh<ProductRepository>()),
    );
    gh.factory<ProductCubit>(() => ProductCubit(gh<GetProductsUseCase>()));
    return this;
  }
}

class _$RegisterModule extends RegisterModule {}
