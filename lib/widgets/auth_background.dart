import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  // Widget to pass as argument
  final Widget child;

  // https://dart.dev/language/constructors#initializer-list
  const AuthBackground({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        width: double.infinity,   // All device's size
        height: double.infinity,
        //  Strategy is to overlap several children in a simple way --> Stack
        child: Stack(
          children: [

            _PurpleBox(),

            _HeaderIcon(),

            this.child,

          ],
        ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(      // Wrap under SafeArea, to ignore the bottom and top area
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only( top: 30 ),
        child: Icon( Icons.person_pin, color: Colors.white, size: 100 ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Get device's size
    final size = MediaQuery.of(context).size;

    return Container(    // Wrap under Container to add the 'decoration' and the child
      width: double.infinity,
      height: size.height * 0.4,      // Place in a certain part of the device's screen
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          // Widget to indicate the position of a widget into a Stack
          Positioned(child: _Bubble(), top: 90, left: 30 ),
          Positioned(child: _Bubble(), top: -40, left: -30 ),
          Positioned(child: _Bubble(), top: -50, right: -20 ),
          Positioned(child: _Bubble(), bottom: -50, left: 10 ),
          Positioned(child: _Bubble(), bottom: 120, right: 20 ),
        ],
      ),
    );
  }

  // Description to paint a box
  BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]
    )
  );
}

class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      // Description to paint a box
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}