import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'license_purchase_provider.dart';
import 'LisencePurchase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LicensePurchaseProvider()),
      ],
      child: MaterialApp(
        title: 'License Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LicensePurchasePage(),
      ),
    );
  }
}
