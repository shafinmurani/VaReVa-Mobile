import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/components/successful.dart';
import 'package:vartarevarta_magazine/components/text_input_widget.dart';

final _razorpay = Razorpay();

class DonationWidget extends StatefulWidget {
  const DonationWidget({super.key});

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController amt = TextEditingController();

  TextEditingController email =
      TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onPaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);

    super.initState();
  }

  void onPaymentSuccess(PaymentSuccessResponse response) async {
    var collection = FirebaseFirestore.instance.collection('/donation');
    await collection.doc().set({
      "name": name.text,
      "email": email.text,
      "phone": phone.text,
      "address": address.text,
      "uid": FirebaseAuth.instance.currentUser?.uid,
      "paymentId": response.paymentId,
      "orderId": response.orderId,
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessFulWidget(),
        ));
  }

  void onPaymentFailure(PaymentFailureResponse response) {}
  void onExternalWallet(ExternalWalletResponse response) {}
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Donation"),
        backgroundColor: primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: ListView(
              children: [
                const Gap(10),
                Input(
                  placeholder: "Full Name",
                  controller: name,
                ),
                Input(
                  placeholder: "Address",
                  controller: address,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                ),
                IntlPhoneField(
                  onChanged: (nume) {
                    phone.text = nume.completeNumber;
                  },
                  initialCountryCode: 'IN',
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                Input(
                  enabled: true,
                  placeholder: "Donation in INR",
                  controller: amt,
                ),
                Input(
                  enabled: false,
                  placeholder: "Email Address",
                  controller: email,
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondary,
                        foregroundColor: primary,
                      ),
                      onPressed: () {
                        if (name.text.isEmpty ||
                            address.text.isEmpty ||
                            phone.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all the inputs"),
                            ),
                          );
                          return;
                        }
                        var options = {
                          'key': 'rzp_live_mpe84NF3990468NR7hD',
                          'amount': int.parse(amt.text) * 100,
                          'name': "Donation by ${name.text} : ${email.text}",
                          'prefill': {
                            'email': email.text,
                            'contact': phone.text.toString()
                            // 'contact':
                          }
                        };
                        _razorpay.open(options);
                      },
                      child: const Text("Donate"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
