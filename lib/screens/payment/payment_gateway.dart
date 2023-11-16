import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/screens/books/pdf.dart';

final _razorpay = Razorpay();

class PaymentWidget extends StatefulWidget {
  final String productName;
  final String path;
  final int price;
  final String id;
  final int page;
  const PaymentWidget(
      {super.key,
      required this.productName,
      required this.path,
      required this.price,
      required this.id,
      required this.page});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onPaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);

    super.initState();
  }

  void onPaymentSuccess(PaymentSuccessResponse response) async {
    var collection = FirebaseFirestore.instance.collection('/data');
    collection.doc(FirebaseAuth.instance.currentUser?.uid).update({
      "Purchased": FieldValue.arrayUnion([widget.id])
    });
    var book =
        FirebaseFirestore.instance.collection("magazines").doc(widget.id);
    book.update({
      "purchased": FieldValue.increment(1),
    });

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewPDF(
              pageNum: widget.page,
              name: widget.productName,
              path: widget.path,
              id: widget.id),
        ));
  }

  void onPaymentFailure(PaymentFailureResponse response) {}
  void onExternalWallet(ExternalWalletResponse response) {}
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  final TextEditingController _emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
  final TextEditingController _numController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: Text(widget.productName),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Checkout Page",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.productName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Price : ${widget.price} INR",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 50,
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextField(
                    maxLength: 10,
                    controller: _numController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(hintText: "Contact Number"),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextField(
                    controller: _emailController,
                    enabled: false,
                    decoration:
                        const InputDecoration(hintText: "Email address"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: secondary, foregroundColor: primary),
                    onPressed: () {
                      if (_numController.text.isEmpty) {
                        Widget okButton = TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: const Text("Invalid Request"),
                          content:
                              const Text("Please provide your contact number."),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } else {
                        var options = {
                          'key': 'rzp_test_TjYOj9jpuXJ3Tk',
                          'amount': widget.price * 100,
                          'name': widget.productName,
                          'description': 'VaReVa Magazine Volume 2',
                          'prefill': {
                            'email': FirebaseAuth.instance.currentUser?.email,
                            'contact': _numController.text.toString()
                            // 'contact':
                          }
                        };
                        _razorpay.open(options);
                      }
                    },
                    child: const Text("Proceed to checkout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
