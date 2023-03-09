//import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController usernameController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  GlobalKey <FormState> formKey= GlobalKey<FormState>();

  bool isLoginPage= false;

  submitForm()async{
    /*final auth= FirebaseAuth.instance;
    UserCredential authResult;
    if(isLoginPage){
      authResult=await auth.signInWithUsernameAndPassword(email: usernameController.text, password: passwordController.text);
    }else{
      //authResult=await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      //String uid=authResult.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {'email':emailController.text,
            'username':usernameController.text}

      );

    }

     */
  }

  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;


    return SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        color: Colors.white,

        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Image.asset(
                  'images/cliqueClipArtLogin.png',
                  width: width*0.3,
                  height: height*0.3
              ),
          //    SizedBox(height:height*0.05,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: usernameController,
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'This field is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(8.0) ),

                    label:const Text("Username:"),

                  ),

                ),
              ),
          //    SizedBox(height:height*0.05,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'This field is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(8.0) ),

                    label:const Text("Password:"),

                  ),

                ),
              ),

          //    SizedBox(height:height*0.05,),

              Container(
                padding: const EdgeInsets.all(5),
                child: const ElevatedButton(

                 // style: ElevatedButton.styleFrom(),

                  //TODO: onPressed

                  onPressed: null,
                  child:Text('Login'),
                 // style: ElevatedButton.styleFrom(primary: Color.fromRGBO(100, 13, 20, 0.0),
                  ),


                ),
          TextButton(
              onPressed: (){
                //setState(() {
                //  isLoginPage=!isLoginPage;
                //});
              },
              child:const Text(
                "Forgot Password? Reset your password.",
                style: TextStyle(color: Colors.black),)

          ),


          const Text("Sign Up with"),
         //SizedBox(height:height*0.05,),

          Container(
            padding: const EdgeInsets.all(5),
            child: const ElevatedButton(

              // style: ElevatedButton.styleFrom(),

              //TODO: onPressed

              onPressed: null,
              child:Text('Login'),
              // style: ElevatedButton.styleFrom(primary: Color.fromRGBO(100, 13, 20, 0.0),
              // decoration: BoxDecoration(image: DecorationImage(image: "images/facebookSymbol.png")),
            ),


          ),

          const Text("Don't have an account?"),
          //SizedBox(height:height*0.05,),

          TextButton(
            onPressed: (){
              //setState(() {
              //  isLoginPage=!isLoginPage;
              //});
            },
            child:const Text("Register as a musician.",
              style: TextStyle(color: Colors.black),),
          ),

          const TextButton(
              onPressed: null,
              child:Text("Register as a recruiter.",
                style: TextStyle(color: Colors.black),)
          ),


            ],

          ),

        ),
      ),



    );

  }
}
