import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';

// Intermediate screen to check if the user is already authenticated
class CheckAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // listen: false    We don't need to redraw this Screen ever
    final authService = Provider.of<AuthService>( context, listen: false );

    return Scaffold(
      body: Center(
        // Since the validation could take time --> FutureBuilder is used
        child: FutureBuilder(
          future: authService.readToken(),      // Async process, which returns a Future
          // builder        Needs to return a Widget
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            // Arguments are related to the response of the future --> String

            if ( !snapshot.hasData )            
              return Text('');

            // Widget to be returned, needs to be created before making the navigation!!    --> Future.microtask(), which will wait for
            // .data    It's the latest data received from the async computation
            // if       This scenario is when the user hasn't got a token
            if ( snapshot.data == '' ) {
              Future.microtask(() {
                // Automatic navigation
                // Navigator.of(context).pushReplacementNamed('login');

                // Manual navigation
                Navigator.pushReplacement(context, PageRouteBuilder(
                  // PageRouteBuilder     Define one-off page routes — in terms of — callbacks
                  pageBuilder: ( _, __ , ___ ) => LoginScreen(),      //  LoginScreen()       Screen to which, we redirect to
                  transitionDuration: Duration( seconds: 0)     // Eliminate the ugly page transition
                  )
                );

              });

            } else {
              Future.microtask(() {

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _, __ , ___ ) => HomeScreen(),       //  HomeScreen()       Screen to which, we redirect to
                  transitionDuration: Duration( seconds: 0)     // Eliminate the ugly page transition
                  )
                );

              });
            }

            // Since builder needs to return always a Widget
            return Container();

          },
        ),
     ),
   );
  }
}