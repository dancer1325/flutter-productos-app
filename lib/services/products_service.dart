import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

// Extend from ChangeNotifier to make easier life to handle via Provider
class ProductsService extends ChangeNotifier {

  // Our firebase's realtime database url
  // It should be changed by yours
  final String _baseUrl = 'flutter-varios-14e0e-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    this.loadProducts();
  }

  // Unnecessary to return something, since it could be void for our purposes
  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();      // Notify any Widget, that we are loading the products

    // Create the uri and make the HTTP requests
    final url = Uri.https( _baseUrl, 'products.json');
    final resp = await http.get( url );

    // resp.body    String
    final Map<String, dynamic> productsMap = json.decode( resp.body );

    productsMap.forEach((key, value) {
      print('key $key and value $value');
      final tempProduct = Product.fromMap( value );
      tempProduct.id = key;
      this.products.add( tempProduct );
    });

    // Once the products have been already loaded. We notify again, to redraw again the Widgets listening it
    this.isLoading = false;
    notifyListeners();

    return this.products;

  }

  Future saveOrCreateProduct( Product product ) async {
    isSaving = true;
    notifyListeners();    // Notify any Widget, that we are saving the products

    if ( product.id == null ) {
      // Es necesario crear
      await this.createProduct( product );
    } else {
      // Actualizar
      await this.updateProduct( product );
    }

    // Once the products have been already saved. We notify again, to redraw again the Widgets listening it
    isSaving = false;
    notifyListeners();

  }

  // notifyListeners()    isn't invoked here, because it's used where this function is invoked
  Future<String> updateProduct( Product product ) async {
    // Create the uri (firebase concatenates the id in the next way to get it) and make the HTTP requests
    final url = Uri.https( _baseUrl, 'products/${ product.id }.json');
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;
    print("decodedData $decodedData");

    // Identify the element that we are updating, to update the list of products
    final index = this.products.indexWhere((element) => element.id == product.id );
    this.products[index] = product;

    return product.id!;
  }

  // notifyListeners()    isn't invoked here, because it's used where this function is invoked
  Future<String> createProduct( Product product ) async {
    // Create the uri and make the HTTP request
    final url = Uri.https( _baseUrl, 'products.json');
    final resp = await http.post( url, body: product.toJson() );
    final decodedData = json.decode( resp.body );   // body is JSON, but we want to convert to a Map

    // Response contains 'name' property which we can use as Id
    product.id = decodedData['name'];

    // Update to the list of products
    this.products.add(product);

    return product.id!;

  }

  void updateSelectedProductImage( String path ) {
    // This path doesn't contain 'http', since it's a path in our file system
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri( Uri(path: path) );

    notifyListeners();  // Notify any Widget, which it's listening the ProductsService
  }

  // String?      Optional, because nothing could be returned, in case something fails during the uploading
  Future<String?> uploadImage() async {
    // In case there is no new picture selected to assign to the product
    if (  this.newPictureFile == null ) return null;

    this.isSaving = true;     // Notify any Widget, that we are saving the products
    notifyListeners();

    // Make the post request to upload the image to cloudinary
    // 1. Uri.https
    // Uri.https( _baseCloudinaryUrl, 'image/upload?upload_preset=autwc6pa');

    // 2. http.MultipartRequest();
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dx0pryfzn/image/upload?upload_preset=autwc6pa');   // Uri.parse(UploadMediaURLWithoutFile)
    final imageUploadRequest = http.MultipartRequest('POST', url );
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();       // Make the request finally
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];       // Get the field with the secure_url to get access to the media via internet

  }

}