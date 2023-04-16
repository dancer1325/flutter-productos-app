import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  // Widget to pass as argument
  final Widget child;

  const CardContainer({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(   // Wrap under Padding, to add padding to the child container
      padding: EdgeInsets.symmetric( horizontal: 30 ),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all( 20 ),
          decoration: _createCardShape(),
          child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 5),     // Position to move the shadow
      )
    ]
  );
}