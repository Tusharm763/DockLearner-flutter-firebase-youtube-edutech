// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'dart:async';
// import 'dart:math';
//
// const List<String> _kProductIds = <String>[
//   'com.example.app.50',
//   'com.example.app.49',
//   // ... continue for all numbers 0-50
// ];
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   final List<ProductDetails> _products = <ProductDetails>[];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//
//   @override
//   void initState() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen(
//       (purchaseDetailsList) {
//         _listenToPurchaseUpdated(purchaseDetailsList);
//       },
//       onDone: () {
//         _subscription.cancel();
//       },
//       onError: (error) {
//         // Handle error here
//       },
//     );
//     initStoreInfo();
//     super.initState();
//   }
//
//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _loading = false;
//       });
//       return;
//     }
//
//     final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _isAvailable = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     if (productDetailResponse.productDetails.isNotEmpty) {
//       setState(() {
//         _products.addAll(productDetailResponse.productDetails);
//       });
//     }
//
//     setState(() {
//       _isAvailable = isAvailable;
//       _loading = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         setState(() {
//           _purchasePending = true;
//         });
//       } else {
//         setState(() {
//           _purchasePending = false;
//         });
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           // Handle error
//         } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
//           // Handle successful purchase
//           if (Platform.isAndroid) {
//             final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//             await androidAddition.consumePurchase(purchaseDetails);
//           }
//           if (purchaseDetails.pendingCompletePurchase) {
//             await _inAppPurchase.completePurchase(purchaseDetails);
//           }
//         }
//       }
//     });
//   }
//
//   void _makePayment(int amount) {
//     if (!_isAvailable || _products.isEmpty) {
//       return;
//     }
//
//     final String productId = 'com.example.app.$amount';
//     final ProductDetails productDetails = _products.firstWhere(
//       (element) => element.id == productId,
//       orElse: () => throw Exception('Product not found'),
//     );
//
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
//     _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // UI remains similar to the previous example, just the _makePayment() logic changes.
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Random Number Payments')),
//         body: Center(
//           child: _loading
//               ? const CircularProgressIndicator()
//               : _isAvailable
//               ? RandomNumberScreen(onPayment: _makePayment)
//               : const Text('In-App Purchases are not available.'),
//         ),
//       ),
//     );
//   }
// }
//
// class RandomNumberScreen extends StatefulWidget {
//   final Function(int) onPayment;
//
//   const RandomNumberScreen({required this.onPayment, super.key});
//
//   @override
//   _RandomNumberScreenState createState() => _RandomNumberScreenState();
// }
//
// class _RandomNumberScreenState extends State<RandomNumberScreen> {
//   final List<int> _randomNumbers = [];
//   final Random _random = Random();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               _randomNumbers.add(_random.nextInt(51)); // 0 to 50
//             });
//           },
//           child: const Text('Generate Random Number'),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _randomNumbers.length,
//             itemBuilder: (context, index) {
//               final number = _randomNumbers[index];
//               return ListTile(title: Text('Payment: Rs. $number'), onTap: () => widget.onPayment(number));
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
