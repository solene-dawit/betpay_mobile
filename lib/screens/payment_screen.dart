import 'package:flutter/material.dart';

import '../models/current_user.dart';
import '../models/tenant_assignment.dart';
import '../services/auth_service.dart';
import '../services/starpay_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final StarPayService _starPayService = StarPayService();
  final AuthService _authService = AuthService();

  final TenantAssignment _assignment =
      TenantAssignment.simulated();

  CurrentUser? _currentUser;

  bool _isLoadingUser = true;
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingUser = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not load your account information.',
          ),
        ),
      );
    }
  }

  Future<void> _payRent() async {
    if (_currentUser == null) {
      return;
    }

    setState(() {
      _isPaying = true;
    });

    try {
      final paymentUrl = await _starPayService.createPayment(
        amount: _assignment.monthlyRent,
        customerName: _currentUser!.fullName,
        customerPhone: _currentUser!.phone,
      );

      if (!mounted) return;

      setState(() {
        _isPaying = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Created'),
            content: SelectableText(
              'StarPay payment created successfully.\n\n'
              'Customer: ${_currentUser!.fullName}\n'
              'Phone: ${_currentUser!.phone}\n'
              'Amount: ${_assignment.currency} '
              '${_assignment.monthlyRent.toStringAsFixed(2)}\n\n'
              'Payment URL:\n'
              '$paymentUrl',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isPaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pay Rent'),
        ),
        body: const Center(
          child: Text(
            'Unable to load your account.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        title: const Text('Pay Rent'),
        backgroundColor: const Color(0xFF288DFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _assignment.propertyName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Room ${_assignment.roomNumber} • '
                    '${_assignment.floorNumber}nd Floor',
                  ),

                  const SizedBox(height: 20),

                  Text(
                    _currentUser!.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _currentUser!.email,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _currentUser!.phone,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Monthly Rent',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${_assignment.currency} '
                    '${_assignment.monthlyRent.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF288DFF),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isPaying ? null : _payRent,
                icon: _isPaying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.payment_rounded,
                      ),
                label: Text(
                  _isPaying
                      ? 'Creating Payment...'
                      : 'Pay ${_assignment.currency} '
                          '${_assignment.monthlyRent.toStringAsFixed(2)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF288DFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}