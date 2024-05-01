// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/user_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../const.dart';

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
      theme: ThemeData(fontFamily: 'Playfair Display'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: SUYellow,
          centerTitle: true,
          title: const Text('Sign in to SU Cat Partners Feeder with Google'),
        ),
        body:SingleChildScrollView(
          controller: _vertical,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // google logo, sign in button, then Cat Partners Logo
                children: [
                  const SizedBox(
                    width: 150,
                    height: 150,
                    child: Image(image: AssetImage('images/googleLogo.png'))
                  ),
                  const SizedBox(
                    height: 30,
                    width: 20,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 60,
                        width: 250,
                        color: const Color.fromARGB(255, 202, 202, 202),
                      ),
                      SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        // Will redirect to HomePage when login is successful and is authorized to Firebase
                        onPressed: () async{
                          try {
                            final user = await UserGoogle.loginWithGoogle();
                            if (user != null && mounted){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
                            }
                          // error handling
                          } on FirebaseAuthException catch (error){
                            // print(error.message);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? "Something went wrong")));
                          } on Exception catch (error){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                          }
                        },
                      )
                    ]
                  ),
                  const SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                      height: 150,
                      width: 150,
                      child: Image(image: AssetImage('images/SUCP_Head_Logo.PNG'))),
                ],
              )
            )
          ),
        )
      )
    );
  }
}