// import 'package:fanchat/presentation/layouts/home_layout.dart';
// import 'package:fanchat/presentation/screens/home_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
//
// class PaypalPayment extends StatelessWidget {
//   final double amount;
//   final String currency;
//   const PaypalPayment({Key? key, required this.amount, required this.currency})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeLayout()));
//           },
//           child: const Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: WebView(
//         initialUrl:
//         'http://localhost:3000/createpaypalpayment?amount=$amount&currency=$currency',
//         javascriptMode: JavascriptMode.unrestricted,
//         gestureRecognizers: Set()
//           ..add(Factory<DragGestureRecognizer>(
//                   () => VerticalDragGestureRecognizer())),
//         onPageFinished: (value) {
//           print(value);
//         },
//         navigationDelegate: (NavigationRequest request) async {
//           if (request.url.contains('http://return_url/?status=success')) {
//             print('return url on success');
//             Navigator.pop(context);
//           }
//           if (request.url.contains('http://cancel_url')) {
//             Navigator.pop(context);
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanchat/constants/app_strings.dart';
import 'package:fanchat/presentation/layouts/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class BusinessPackage extends StatefulWidget {
  const BusinessPackage({Key? key}) : super(key: key);

  @override
  State<BusinessPackage> createState() => _BusinessPackageState();
}

class _BusinessPackageState extends State<BusinessPackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('paypal'),
        ),
        body: Center(
          child: TextButton(
              onPressed: () =>
              {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UsePaypal(
                            sandboxMode: false,
                            clientId:
                            "AR1MjIVVA1CS0X8hdaVPphbme4_oqEdLS2F4jyf173pasfShsoGdkXjvvMEHhkEcoVxA4bqoQ8Vump7R",
                            secretKey:
                            "ELiFdHo3vCj8zDLAXfKdizlfdkctPKlQXCWkz7OTFI183m_8SMW8NcOOVKHGmM7Lk5N25fz-t0maRfCZ",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '200',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '200',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                "fanchat business account",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '200',
                                      "currency": "USD"
                                    }
                                  ],

                                  // shipping address is not required though
                                  "shipping_address": {
                                    "recipient_name": "fanchat App",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              setState((){
                                FirebaseFirestore.instance.collection('users').doc(AppStrings.uId)
                                    .update({
                                  'accountActive':true,
                                }).then((value){
                                  print('success to update aaccountStates');
                                }).catchError((error){
                                  print('success to update aaccountStates${error.toString()}');
                                });
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLayout()));
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                  ),
                )
              },
              child: const Text("Make Payment")),
        ));
  }

  }

