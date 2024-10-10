import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({Key? key}) : super(key: key);

  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  int selectedAmount = 0; // To keep track of the selected amount
  TextEditingController _amountController = TextEditingController();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose(); // Dispose controller when not needed
    super.dispose();
  }

  void _openCheckout() {
    var options = {
      'key': 'razorpay_key', // Replace with your Razorpay API key
      'amount': int.parse(_amountController.text) * 100, // Amount in paise
      'name': 'Wallet App',
      'description': 'Add Money',
      'prefill': {
        'contact': '9876543210', // Dummy contact info
        'email': 'testuser@example.com' // Dummy email info
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Success: ${response.paymentId}");
    // Update balance here
    Navigator.pop(context, _amountController.text); // Pass the amount to the previous screen
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Error: ${response.code} | ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet: ${response.walletName}");
  }

  Widget _buildAmountButton(BuildContext context, int amount) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAmount = amount;
          _amountController.text = amount.toString(); // Update the text field
        });
      },
      child: Text(
        '₹$amount',
        style: TextStyle(
            color: selectedAmount == amount ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedAmount == amount
            ? const Color.fromARGB(255, 212, 32, 19)
            : Colors.grey[300], // Highlight selected button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300, // Adjust height as necessary
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Money',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountButton(context, 100),
                _buildAmountButton(context, 200),
                _buildAmountButton(context, 500),
                _buildAmountButton(context, 1000),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  _openCheckout(); // Open Razorpay checkout
                } else {
                  Fluttertoast.showToast(msg: "Please enter an amount");
                }
              },
              child: Text(
                'Proceed',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 212, 32, 19), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
