import 'package:flutter/material.dart';

import '../components/betpay_button.dart';

class ButtonPreviewScreen extends StatelessWidget {
  const ButtonPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetPay Buttons'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Primary Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            BetPayButton(
              text: 'Get Started',
              onPressed: () {},
            ),

            const SizedBox(height: 32),

            const Text(
              'Success Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            BetPayButton(
              text: 'Pay Rent',
              backgroundColor: const Color.fromARGB(255, 16, 20, 16),
              icon: Icons.payment,
              onPressed: () {},
            ),

            const SizedBox(height: 32),

            const Text(
              'Danger Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            BetPayButton(
              text: 'Delete',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: () {},
            ),

            const SizedBox(height: 32),

            const Text(
              'Outlined Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            BetPayButton(
              text: 'Login',
              outlined: true,
              icon: Icons.login,
              onPressed: () {},
            ),

            const SizedBox(height: 32),

            const Text(
              'Small Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            BetPayButton(
              text: 'Edit',
              width: 150,
              height: 44,
              fontSize: 14,
              icon: Icons.edit,
              onPressed: () {},
            ),

            const SizedBox(height: 32),

            const Text(
              'Large Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            BetPayButton(
              text: 'Continue',
              height: 64,
              fontSize: 18,
              icon: Icons.arrow_forward,
              iconRight: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}