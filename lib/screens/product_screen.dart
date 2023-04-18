import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:productos_app/providers/product_form_provider.dart';

import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Get ProductsService provider
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      // Based on our designed flow, always that we instantiate this provider, we will have a product selected
      create: ( _ ) => ProductFormProvider( productService.selectedProduct ),
      // Provider just needs to be available in this child
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    // Get ProductFormProvider provider
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      // Wrap under SingleChildScrollView, to make scrolling. This behavior can be not desired
      body: SingleChildScrollView(
        // Once you scroll --> Hide the keyboard
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            // Allows placing widgets one in top to each other
            Stack(
              children: [
                ProductImage( url: productService.selectedProduct.picture ),

                // Wrap under Positioned to adjust the position to avoid overlapping or not be shown
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    icon: Icon( Icons.arrow_back_ios_new, size: 40, color: Colors.white ),
                  )
                ),

                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {

                      // Use image_picker dependency
                      final picker = new ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(
                        // Based on source, you can indicate how to get the image. If you would like different one's --> create several buttons
                        // source: ImageSource.gallery,
                        source: ImageSource.camera,
                        imageQuality: 100
                      );

                      if( pickedFile == null ) {
                        print('No seleccionó nada');
                        return;
                      }

                      // pickedFile.path      Know the image's path into the device
                      print("pickedFile.path ${pickedFile.path}");
                      productService.updateSelectedProductImage(pickedFile.path);
                    }, 
                    icon: Icon( Icons.camera_alt_outlined, size: 40, color: Colors.white ),
                  )
                )
              ],
            ),

            _ProductForm(),

            SizedBox( height: 100 ),

          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving 
          ? CircularProgressIndicator( color: Colors.white )
          : Icon( Icons.save_outlined ),
        onPressed: productService.isSaving 
          ? null      // Disabled the event
          : () async {
          
          if ( !productForm.isValidForm() ) return;

          // Upload the image to Cloudinary, retrieving the secureURL
          final String? imageUrl = await productService.uploadImage();

          if ( imageUrl != null ) productForm.product.picture = imageUrl;

          // Save or create the product, assigning the picture url to the product in Firebase
          await productService.saveOrCreateProduct(productForm.product);

        },
      ),
   );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Get ProductFormProvider provider
    // Display in other widgets the information passed to the ProductForm widget
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 ),
      child: Container(       // Wrap under Container, in case we want to add Padding
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,    // Validate automatically form's fields
          child: Column(      // Place widgets one below to the other
            children: [

              SizedBox( height: 10 ),

              TextFormField(
                initialValue: product.name,
                onChanged: ( value ) => product.name = value,
                validator: ( value ) {    // Validate the input
                  if ( value == null || value.length < 1 )
                    return 'El nombre es obligatorio'; 
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:'
                ),
              ),

              SizedBox( height: 30 ),

              TextFormField(
                initialValue: '${product.price}',
                // Restrict the inputs to enter
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                // Implemented logic to handle number. Even like a validation is done --> skip define validator
                onChanged: ( value ) {
                  if ( double.tryParse(value) == null ) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,   // Display different default text keyBoard
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:'
                ),
              ),
              
              SizedBox( height: 30 ),

              // List of tiles with a toggle / switch
              SwitchListTile.adaptive(
                value: product.available, 
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                //  onChanged: (value) => productForm.updateAvailability(value)
                // Since there is just 1! argument --> it can be skipped to indicate
                onChanged: productForm.updateAvailability
              ),


              SizedBox( height: 30 )

            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]
  );
}