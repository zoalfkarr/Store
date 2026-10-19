import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/user/domain/entities/product.dart';
import 'package:store/features/user/presentation/cubit/product_cubit.dart';
import 'package:store/features/user/presentation/cubit/product_state.dart';

import '../Widget/check_internet.dart';
import '../Widget/loading_screen.dart';
import '../Widget/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Store',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => context.read<ProductCubit>().fetchProducts(),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return BuildLoadingState();
          } else if (state is ProductsLoaded) {
            return _buildProductGrid(context, state.products);
          } else if (state is ProductError) {
            return CheckInternetConnection(
              context: context,
              message: state.message,
              isNetworkError: state.isNetworkError,
            );
          }
          return _buildInitialState(context);
        },
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No Product Yet...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.deepPurple,
      onRefresh: () async {
        await context.read<ProductCubit>().fetchProducts();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.63,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(products: product);
          },
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => context.read<ProductCubit>().fetchProducts(),
        icon: const Icon(Icons.download_rounded),
        label: const Text('Get Products'),
      ),
    );
  }
}
