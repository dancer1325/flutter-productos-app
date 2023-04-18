import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    Key? key,             // Let as optional, in case we need it
    required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // First Widget created to see the result, location, ...
    // return Container(
    //   width: double.infinity,
    //   height: 400,
    //   color: Colors.red,
    // )
    return Padding(   // Wrap under Padding to specify the padding
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only( top: 30, bottom: 50 ),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        // Allows placing widgets one in top to each other
        child: Stack(
          alignment: Alignment.bottomLeft,      // Alignment, based on a point respected to the rectangle
          children: [

            _BackgroundImage( product.picture ),

            _ProductDetails(
              title: product.name,
              subTitle: product.id!,    // !    Because it could not exist
            ),

            // Widget to indicate the position of a widget into a Stack
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag( product.price )
            ),


            if( !product.available )
              Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable()
              ),

          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10
      )
    ]
  );
}

class _NotAvailable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle( color: Colors.white, fontSize: 20 ),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.only( topLeft: Radius.circular(25), bottomRight: Radius.circular(25) )
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  // Instead to pass all the product, just the necessary properties
  final double price;

  // Constructor based on position, since it has got 1! element
  const _PriceTag( this.price );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(   // Wrap under FittedBox, to adapt the text to the space
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10 ),
          // $$price    Interpolate the double
          // \$$price   / to escape $ under String
          child: Text('\$$price', style: TextStyle( color: Colors.white, fontSize: 20 ))
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only( topRight: Radius.circular(25), bottomLeft: Radius.circular(25) )
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {

  // Instead to pass all the product, just the necessary properties
  final String title;
  final String subTitle;

  const _ProductDetails({ 
    required this.title, 
    required this.subTitle
  });


  @override
  Widget build(BuildContext context) {

    return Padding(   // Wrap under Padding, to add a padding
      padding: EdgeInsets.only( right: 50 ),
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, 
              style: TextStyle( fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,    // Avoid text is larger than figure containing it
            ),
            Text(
              subTitle, 
              style: TextStyle( fontSize: 15, color: Colors.white ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only( bottomLeft: Radius.circular(25), topRight: Radius.circular(25) )
  );
}

class _BackgroundImage extends StatelessWidget {
 
  final String? url;

  // Constructor based on position, since it has got 1! element
  const _BackgroundImage( this.url );

  @override
  Widget build(BuildContext context) {
    // Wrap under ClipRRect, in order to apply the blur just to the specific container
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null      // Handling that url doesn't come
          ? Image(
              image: AssetImage('assets/no-image.png'),
              fit: BoxFit.cover
            )
          // An image which shows a placeholder image, while it's loading
          : FadeInImage(
            placeholder: AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(url!),      // Fetch the image from the given URL, being cached
            fit: BoxFit.cover,
          ),
      ),
    );
  }
}