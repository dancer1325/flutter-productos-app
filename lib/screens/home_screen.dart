import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);
    
    if( productsService.isLoading ) return LoadingScreen();


    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      // ListView
      // Allows scrolling
      body: ListView.builder(     //.builder      Create the widgets on demand
        itemCount: productsService.products.length,       // Number of elements to display
        // GestureDetector        Widget which detects gestures
        itemBuilder: ( BuildContext context, int index ) => GestureDetector(
          onTap: () {
            productsService.selectedProduct = productsService.products[index].copy();
            // pushNamed instead of pushreplacement to allow coming back
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(
            product: productsService.products[index],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        onPressed: () {
          productsService.selectedProduct = new Product(
            available: false, 
            name: '', 
            price: 0
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
   );
  }
}