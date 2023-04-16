import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        // (_)    BuildContext, but since we don't need it here --> It's indicated as _
        'login': ( _ ) => LoginScreen(),
        'home' : ( _ ) => HomeScreen(),
      },
      // copyWith()     Create a copy of a theme, and personalize it specifically each desired property
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300]
      ),
    );
  }
}