import 'package:flutter/material.dart';

// Utility class
class NotificationsService {

  // State of the MaterialApp
  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar( String message ) {

    // SnackBar        StatefulWidget, which is lightweight message
    final snackBar = new SnackBar(
      content: Text( message, style: TextStyle( color: Colors.white, fontSize: 20) ),
    );

    // showSnackBar     Show the previous snackBar, through all the Scaffold via it's state
    messengerKey.currentState!.showSnackBar(snackBar);

  }


}