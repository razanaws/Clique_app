import 'package:flutter/material.dart';

class SignUpRecruiterForm extends StatefulWidget {
  const SignUpRecruiterForm({Key? key}) : super(key: key);

  @override
  State<SignUpRecruiterForm> createState() => _SignUpRecruiterFormState();
}

class _SignUpRecruiterFormState extends State<SignUpRecruiterForm> {
  GlobalKey <FormState> formKey= GlobalKey<FormState>();

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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 7.0),

                child: const Text(
                  "Create a new recruiter account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextFormField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:BorderRadius.circular(50.0),
                    ),

                    label:const Text("Name", style: TextStyle(color: Colors.black,fontSize: 13)),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Emma Micheals',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextFormField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:BorderRadius.circular(50.0),
                    ),

                    label:const Text("Username", style: TextStyle(color: Colors.black,fontSize: 13),),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'emma_micheals',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:BorderRadius.circular(50.0),
                    ),

                    label:const Text("Email", style: TextStyle(color: Colors.black,fontSize: 13),),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Emma@example.com',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:BorderRadius.circular(50.0),
                    ),

                    label:const Text("Number", style: TextStyle(color: Colors.black,fontSize: 13),),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: '123-456-789',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(50.0)
                    ),
                    label:const Text(
                      "Password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: '*********',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:BorderRadius.circular(50.0),
                    ),

                    label:const Text("Company", style: TextStyle(color: Colors.black,fontSize: 13),),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Company name',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),

                ),
              ),

              Container(
                width: double.maxFinite,
                height: 60,
                padding: const EdgeInsets.all(5),
                child:  ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(100, 13, 20, 1)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0),)),),
                  //TODO: onPressed

                  onPressed: null,
                  child:const Text('SIGN UP',style: TextStyle(color: Colors.white),),
                ),
              ),

              TextButton(
                  onPressed: (){
                    //setState(() {
                    //  isLoginPage=!isLoginPage;
                    //});
                  },
                  child:const Text(
                    "I already have an account",
                    style: TextStyle(color: Colors.white),)

              ),
            ],
          ),
        ),
      ),
    );
  }
}
