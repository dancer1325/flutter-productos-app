import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';

 
void main() => runApp(AppState());

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => ProductsService() )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'home',
      routes: {
        // _    BuildContext    It's not specified, that's why it's indicated as '_'
        'login'   : ( _ ) => LoginScreen(),
        'home'    : ( _ ) => HomeScreen(),
        'product' : ( _ ) => ProductScreen(),
      },
      // copyWith()     Create a copy of a theme, and personalize it specifically each desired property
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(       // Customize floatingActionButton's theme
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}