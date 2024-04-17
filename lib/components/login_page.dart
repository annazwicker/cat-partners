// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/user_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final ScrollController _vertical = ScrollController();
  // Future<User?> actualUser;

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Login using Google',
      home: Scaffold(
        body:SingleChildScrollView(
          controller: _vertical,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  const SizedBox(
                    width: 150,
                    height: 150,
                    child: Image(image: AssetImage('images/googleLogo.png'))
                  ),
                  Positioned(
                    bottom: 50,
                    child: SignInButton(
                      Buttons.Google,
                      text: "Sign up with Google",
                      onPressed: () async{
                        try {
                          final user = await UserGoogle().loginWithGoogle();
                          if (user != null && mounted){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
                          }
                        } on FirebaseAuthException catch (error){
                          // print(error.message);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? "Something went wrong")));
                        } on Exception catch (error){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                        }
                      },
                    )
                  )
                ],
              )
            )
          ),
        )
      )
    );
  }
}