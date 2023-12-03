import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/components/successful.dart';
import 'package:vartarevarta_magazine/components/text_input_widget.dart';

final _razorpay = Razorpay();

class SubscribeWidget extends StatefulWidget {
  const SubscribeWidget({super.key});

  @override
  State<SubscribeWidget> createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget> {
  TextEditingController name = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName);

  // address
  TextEditingController apartment = TextEditingController();
  TextEditingController locality = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController dist = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController state = TextEditingController();

  //contact
  TextEditingController email =
      TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
  TextEditingController phone = TextEditingController();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onPaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);

    super.initState();
  }
  // RazorPay handlers

  void onPaymentSuccess(PaymentSuccessResponse response) async {
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessFulWidget(),
        ));
  }

  void onPaymentFailure(PaymentFailureResponse response) {}
  void onExternalWallet(ExternalWalletResponse response) {}

  // Disposing handlers
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 40),
        child: ListView(
          children: [
            const Gap(40),
            Input(placeholder: "Name", controller: name),
            Input(placeholder: "Apartment / House No.", controller: apartment),
            Input(placeholder: "Locality", controller: locality),
            Input(placeholder: "City", controller: city),
            Input(placeholder: "District", controller: dist),
            Input(placeholder: "ZIP", controller: zip),
            Input(
              placeholder: "Email",
              controller: email,
              enabled: false,
            ),
            Input(
              placeholder: "Country",
              controller: TextEditingController(text: "India"),
              enabled: false,
            ),
            IntlPhoneField(
              countries: const [
                Country(
                  name: "India",
                  nameTranslations: {
                    "sk": "India",
                    "se": "India",
                    "pl": "Indie",
                    "no": "India",
                    "ja": "インド",
                    "it": "India",
                    "zh": "印度",
                    "nl": "India",
                    "de": "Indien",
                    "fr": "Inde",
                    "es": "India",
                    "en": "India",
                    "pt_BR": "Índia",
                    "sr-Cyrl": "Индија",
                    "sr-Latn": "Indija",
                    "zh_TW": "印度",
                    "tr": "Hindistan",
                    "ro": "India",
                    "ar": "الهند",
                    "fa": "هند",
                    "yue": "印度"
                  },
                  flag: "🇮🇳",
                  code: "IN",
                  dialCode: "91",
                  minLength: 10,
                  maxLength: 10,
                )
              ],
              onChanged: (n) {
                phone.text = n.completeNumber;
              },
              initialCountryCode: 'IN',
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
            ),
            const Gap(20),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "વાર્ષિક લવાજમ : ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Gap(5),
                  FaIcon(FontAwesomeIcons.indianRupeeSign, size: 20),
                  Gap(5),
                  Text(
                    "440.00",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const Gap(20),
            const Text(
              "વાર્ષિક લવાજમ ભર્યા પછી એક મહિનાની અંદર કુરિયર અથવા પોસ્ટ દ્વારા આપના સરનામે ન મળે તો ",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            InkWell(
              onTap: () {
                launchUrl(Uri(
                  scheme: 'mailto',
                  path: 'vrvsamayik@gmail.com',
                ));
              },
              child: const Text(
                "vrvsamayik@gmail.com",
                style: TextStyle(fontSize: 17, color: Colors.blue),
              ),
            ),
            const Text(
              " ઉપર ઇ-મેઈલથી જાણ કરવી",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const Gap(20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (name.text.isEmpty ||
                        email.text.isEmpty ||
                        phone.text.isEmpty ||
                        zip.text.isEmpty ||
                        dist.text.isEmpty ||
                        city.text.isEmpty ||
                        locality.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill in all the inputs")));
                      return;
                    }
                    var options = {
                      'key': 'rzp_live_mpe84NF38NR7hD',
                      'amount': 440 * 100,
                      'name': "1 year subscription for VarReVa Magazine",
                      'notes': {
                        "Name": name.text,
                        "Apartment/House": apartment.text,
                        "Locality": locality.text,
                        "City": city.text,
                        "District": dist.text,
                        "ZIP": zip.text,
                        "Phone": phone.text,
                        "Email": email.text,
                      },
                      'prefill': {
                        'email': email.text,
                        'contact': phone.text.toString(),
                        // 'contact':
                      }
                    };
                    _razorpay.open(options);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primary, foregroundColor: secondary),
                  child: const Text("Proceed to checkout"),
                ),
              ],
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}
