import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
/*
  submitForm()async{
    final auth= FirebaseAuth.instance;
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
  }
  */
  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
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

              Container(
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(


                  //style: ElevatedButton.styleFrom(),
                  onPressed: (){submitForm();},

                  child:isLoginPage const Text('Login'),

                ),
              ),
              Text("Don't have an account?"),
              TextButton(
                  onPressed: (){
                    setState(() {
                      isLoginPage=!isLoginPage;
                    });
                  },
                  child:isLoginPage? const Text("Register as a recruiter."):const Text("Register as a musician.")

              )],


            ],



          ),

        ),
      ),




    );
  }
}
