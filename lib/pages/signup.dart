import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallet/helper/helper.dart';
import 'package:wallet/pages/home.dart';
import 'package:wallet/pages/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  void Signup() async {
    // Check if passwords match
    if (passwordcontroller.text != confirmpasswordcontroller.text) {
      displayMessage("Passwords don't match!", context);
      return;
    }

    try {
      // Show the loading dialog
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Try to create a new user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      await saveUser(userCredential);
      // Dismiss the loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );

      // Navigate to the Home page after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading dialog in case of an error
      Navigator.pop(context);

      // Display appropriate error messages based on the error code
      if (e.code == 'weak-password') {
        displayMessage('The password provided is too weak.', context);
      } else if (e.code == 'email-already-in-use') {
        displayMessage('An account already exists for that email.', context);
      } else if (e.code == 'invalid-email') {
        displayMessage('The email address is not valid.', context);
      } else {
        displayMessage(e.message ?? "An error occurred", context);
      }
    } catch (e) {
      // Dismiss the loading dialog if any other error occurs
      Navigator.pop(context);
      displayMessage("An unexpected error occurred", context);
    }
  }

  Future<void> saveUser(UserCredential userCredential) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.email)
        .set({
      "username": usercontroller.text,
      "email": userCredential.user!.email,
      "password": passwordcontroller.text,
    });
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
                margin: EdgeInsets.only(top: 80.0, bottom: 40.0),
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
                  controller: usercontroller,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12.0),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                      hintText: "Username",
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
                  controller: confirmpasswordcontroller,
                  style: TextStyle(fontSize: 20.0),
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12.0),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.password),
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(fontSize: 20.0)),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: Signup,
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Sign Up",
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
                    "Already have an account? ",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 23.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Log In",
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
