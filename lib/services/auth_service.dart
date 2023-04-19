import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

// Extend from ChangeNotifier to make easier life to handle via Provider
class AuthService extends ChangeNotifier {
  // Base Firebase's authentication url
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  //  _firebaseToken    Firebase's APIToken     != Token used by our users to authenticate
  // It should be changed by yours
  final String _firebaseToken = 'AIzaSyBcytoCbDUARrX8eHpcR-Bdrdq0yUmSjf8';

  // Store firebaseToken in a secure way
  final storage = new FlutterSecureStorage();


  // Si retornamos algo, es un error, si no, todo bien!
  // email and password as arguments, since we have enabled email-password sign in Firebase's authentication
  Future<String?> createUser( String email, String password ) async {
    // The way to send the body in a request is via JSON serialized map
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    // 'idToken'    attribute with the token
    if ( decodedResp.containsKey('idToken') ) {
        // Token hay que guardarlo en un lugar seguro
        await storage.write(key: 'token', value: decodedResp['idToken']);
        // decodedResp['idToken'];
        return null;
    } else {
      // error.message    attribute to display the error of the request
      return decodedResp['error']['message'];
    }

  }

  // Validate the user already created
  Future<String?> login( String email, String password ) async {
    // The way to send the body in a request is via JSON serialized map
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    // 'idToken'    attribute with the token
    if ( decodedResp.containsKey('idToken') ) {
        // Token hay que guardarlo en un lugar seguro
        // decodedResp['idToken'];
        await storage.write(key: 'token', value: decodedResp['idToken']);
        return null;
    } else {
      // error.message    attribute to display the error of the request
      return decodedResp['error']['message'];
    }

  }

  // Logout === Delete the token got, to force loading again
  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  // Read the token
  // Since we have got the idea to use in a FutureBuilder, if this method would return null === it hasn't got data
  Future<String> readToken() async {
    // .read    It can return a null --> In case, it doesn't exist, we return ''
    return await storage.read(key: 'token') ?? '';

  }

}