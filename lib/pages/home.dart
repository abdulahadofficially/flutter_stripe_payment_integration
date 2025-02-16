import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/services/stripe_services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CupertinoButton.filled(
                child: const Text('Purchased'),
                onPressed: () =>
                    StripeServices.instance.makePayment(context: context)),
          )
        ],
      ),
    );
  }
}
