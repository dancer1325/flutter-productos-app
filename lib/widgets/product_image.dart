import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {

  final String? url;

  const ProductImage({
    Key? key, 
    this.url
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( left: 10, right: 10, top: 10 ),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 450,
        // Wrap under Opacity, to display camera icon although the image's background is of the same color
        child: Opacity(
          opacity: 0.9,
          // Wrap under ClipRRect, in order to apply a specific border to the container
          child: ClipRRect(
            borderRadius: BorderRadius.only( topLeft: Radius.circular( 45 ), topRight: Radius.circular(45) ),
            child: getImage(url)
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.only( topLeft: Radius.circular( 45 ), topRight: Radius.circular(45) ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0,5)
      )
    ]
  );


  Widget getImage( String? picture ) {
    // In case the Product doesn't contain picture related to
    if ( picture == null ) 
      return Image(
          image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover,
        );

    // In case the Product contains picture, which in fact it's already uploaded
    if ( picture.startsWith('http') ) 
        return FadeInImage(
          image: NetworkImage( this.url! ),     // !    I handle it
          placeholder: AssetImage('assets/jar-loading.gif'),
          fit: BoxFit.cover,
        );


    // In case the Product contains picture, but it's not yet uploaded or saved
    return Image.file(
      File( picture ),
      fit: BoxFit.cover,
    );
  }

}