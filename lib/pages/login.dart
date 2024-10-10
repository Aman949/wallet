import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallet/helper/helper.dart';
import 'package:wallet/pages/home.dart';
import 'package:wallet/pages/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  void Login()async{
    try{
      showDialog(context: context, builder: (context)=>
        Center(child: CircularProgressIndicator(),)
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    } on FirebaseAuthException catch(e){
      displayMessage("An unexpected error occurred", context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 100.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80.0,bottom: 120.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.wallet,
                        color: Colors.red,
                        size: 60,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Wallet",
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ),
          
              //textfild for info
          
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: emailcontroller,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12.0),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 20.0)),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: passwordcontroller,
                  style: TextStyle(fontSize: 20.0),
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12.0),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.password),
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 20.0)
                    ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 200,),
              GestureDetector(
                onTap: Login,
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "LogIn",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  )),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 23.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 23.0),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
