import 'package:app_firebase_example/models/models.dart';
import 'package:app_firebase_example/screens/screens.dart';
import 'package:app_firebase_example/services/auth_service.dart';
import 'package:app_firebase_example/services/product_data_source.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductDataSource>(context);

    return productsService.isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Products'),
              leading: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  final authservice = Provider.of<AuthService>(context, listen: false);
                  authservice.logout();
                  Navigator.pushReplacementNamed(context, 'login');
                  //Future.microtask(() =>
                },
              ),
            ),
            body: ListView.builder(
              itemBuilder: (_, index) => GestureDetector(
                child: ProductCard(product: productsService.products[index]),
                onTap: () {
                  productsService.selectedProduct = productsService.products[index].copy();
                  Navigator.pushNamed(context, 'product');
                },
              ),
              itemCount: productsService.products.length,
            ),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  productsService.selectedProduct = Products(available: false, name: "", price: 0);

                  Navigator.of(context).pushNamed('product');
                }),
          );
  }
}
