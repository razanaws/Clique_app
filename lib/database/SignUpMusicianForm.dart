import 'package:flutter/material.dart';

class SignUpMusicianForm extends StatefulWidget {
  const SignUpMusicianForm({Key? key}) : super(key: key);

  @override
  State<SignUpMusicianForm> createState() => _SignUpMusicianFormState();
}

class _SignUpMusicianFormState extends State<SignUpMusicianForm> {

  GlobalKey <FormState> formKey= GlobalKey<FormState>();

  var TalentsList = ['Singer', 'Drummer', 'Guitarist']; //TODO: Add all talents
  String? _selectedItem;

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
                      "Create a new account",
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
                      hintText: 'Alexandra',
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
                      hintText: 'alexandra_smiths',
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
                      hintText: 'Alexandra@example.com',
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
                  padding: const EdgeInsets.all(7.0),
                  child: SizedBox(
                    width:width*0.955,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:Colors.grey,
                        borderRadius:BorderRadius.circular(50.0),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: DropdownButton(
                          value: _selectedItem,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: TalentsList.map((String items) {
                            return DropdownMenuItem<String>(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          dropdownColor: Colors.grey,
                          hint: Text("Choose an item"),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItem = newValue ?? "";
                            });
                          },
                        ),
                      ),
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
