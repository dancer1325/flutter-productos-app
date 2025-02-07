import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        // SingleChildScrollView      Restrict the size and in case it overcomes the screen's size --> You will see, doing scroll
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox( height: 250 ),

              CardContainer(
                child: Column(
                  children: [

                    SizedBox( height: 10 ),
                    Text('Login', style: Theme.of(context).textTheme.headline4 ),
                    SizedBox( height: 30 ),

                    // Alone, without wrapping under MultiProvider, because we just need 1
                    // ChangeNotifierProvider(create: (_) => new LoginFormProvider() ),    Unnecessary new
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm()       // Only Widget in which the ChangeNotifierProvider lives
                    )
                    

                  ],
                )
              ),

              SizedBox( height: 50 ),
              Text('Crear una nueva cuenta', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),),
              SizedBox( height: 50 ),
            ],
          ),
        )
      )
   );
  }
}


class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Get access to the provider via context
    final loginForm = Provider.of<LoginFormProvider>(context);

    // Wrap under Container, in case we want to add Padding
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,         // Validate automatically form's fields


        child: Column(    // Place widgets one below to the other
          children: [
            
            TextFormField(
              autocorrect: false,   // avoid autocorrecting each time you text
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: ( value ) => loginForm.email = value,      // Pass to the provider
              validator: ( value ) {      // Validate the input
                  // email regex pattern    https://gist.github.com/Klerith/d2d819ae378ef5a1980fde3557b64d1d
                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = new RegExp(pattern);
                  
                  return regExp.hasMatch(value ?? '')       // ??     https://www.geeksforgeeks.org/dart-null-aware-operators/
                    ? null
                    : 'El valor ingresado no luce como un correo';

              },
            ),

            SizedBox( height: 30 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => loginForm.password = value,     // Pass to the provider
              validator: ( value ) {      // Validate the input
                  // Our custom password's rules
                  return ( value != null && value.length >= 6 ) 
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';                                    
                  
              },
            ),

            SizedBox( height: 30 ),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,     // Place as first element on the top of the stack
              color: Colors.deepPurple,
              child: Container(     // Wrap under Container to add padding
                padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading         // Display different text, depending on isLoading property
                    ? 'Espere'
                    : 'Ingresar',
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed: loginForm.isLoading ? null : () async {      // Once the event is null --> the button is disabled

                // Lose keyboard's focus once you click in this button
                FocusScope.of(context).unfocus();
                
                if( !loginForm.isValidForm() ) return;

                loginForm.isLoading = true;

                // Simulate a delay of the button's  validation
                await Future.delayed(Duration(seconds: 2 ));

                // TODO: validar si el login es correcto
                loginForm.isLoading = false;

                // Navigate to home screen, once it's validated
                Navigator.pushReplacementNamed(context, 'home');
              }
            )

          ],
        ),
      ),
    );
  }
}