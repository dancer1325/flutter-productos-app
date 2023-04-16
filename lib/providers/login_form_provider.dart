import 'package:flutter/material.dart';

// Handle my form's global state via a state manager
// ChangeNotifier      To declare as part of Material App's widgets, to share the information
class LoginFormProvider extends ChangeNotifier {

  // FormState      Since we want to handle keys related to forms's state
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email    = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();      // Notify to all widget that it has been changed --> Force to redraw all the widgets
  }

  
  bool isValidForm() {

    print(formKey.currentState?.validate());

    print('$email - $password');

    // ?    Because it's possible isn't associated to some Widget yet
    return formKey.currentState?.validate() ?? false;
  }

}