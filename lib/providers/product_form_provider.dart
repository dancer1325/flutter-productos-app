import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

// Handle my form's global state via a state manager
// ChangeNotifier      Declare as part of Material App's widgets, to share the information
class ProductFormProvider extends ChangeNotifier {

  // FormState      Since we want to handle keys related to forms' state
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  // Based on our designed flow, always that we instantiate this provider, we will have a product available
  Product product;

  // Constructor based on position, since it has got 1! element
  ProductFormProvider( this.product );

  updateAvailability( bool value ) {
    print(value);
    this.product.available = value;
    notifyListeners();    // Notify to all widget that it has been changed --> Force to redraw all the widgets
  }

  bool isValidForm() {
    print( product.name );
    print( product.price );
    print( product.available );

    // ?    Because it's possible isn't associated to some Widget yet
    return formKey.currentState?.validate() ?? false;
  }

}