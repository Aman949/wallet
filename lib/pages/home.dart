import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallet/pages/addmoney.dart';
import 'package:wallet/pages/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double balance = 0.0;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  void _navigateToAddMoneyPage() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: AddMoneyPage(),
        ),
      ),
    );

    // Update the balance after returning from AddMoneyPage
    if (result != null) {
      setState(() {
        balance += double.parse(result);  // Update the balance
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            // Header
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              decoration: BoxDecoration(color: const Color.fromARGB(255, 212, 32, 19)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: logout,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      "Wallet",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Wallet Balance
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 32, 19),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallet, color: Colors.white, size: 60),
                      SizedBox(width: 15),
                      Text(
                        "\$$balance",  // Display updated balance
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Your Wallet Balance",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: _navigateToAddMoneyPage,  // Open the Add Money page
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(80)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 40),
                          SizedBox(width: 15),
                          Text(
                            "Topup Balance",
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromARGB(255, 212, 32, 19)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            // Recent Transactions (can be expanded further)
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, left: 25.0),
                      child: Text(
                        "Recent Transactions",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
