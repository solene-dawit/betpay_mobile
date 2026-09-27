import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/payment/payment_bloc.dart';
import '../bloc/payment/payment_event.dart';
import '../bloc/payment/payment_state.dart';

class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        // ==========================================
        // PAYMENT SUCCESS
        // ==========================================

        if (state is PaymentSuccess) {
          debugPrint('========================================');
          debugPrint('PAYMENT BLOC: PAYMENT SUCCESS');
          debugPrint('ORDER ID: ${state.orderId}');
          debugPrint('PAYMENT URL: ${state.paymentUrl}');
          debugPrint('========================================');

          _openPaymentPage(state.paymentUrl);
        }

        // ==========================================
        // PAYMENT FAILURE
        // ==========================================

        if (state is PaymentFailure) {
          debugPrint('========================================');
          debugPrint('PAYMENT BLOC: PAYMENT FAILED');
          debugPrint('ERROR: ${state.message}');
          debugPrint('========================================');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },

      builder: (context, state) {
        final bool isLoading = state is PaymentLoading;

        return Scaffold(
          backgroundColor: Colors.white,

          // ==========================================
          // APP BAR
          // ==========================================

          appBar: AppBar(
            backgroundColor: const Color(0xFF288DFF),
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'BetPay',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                ),
              ),
            ],
          ),

          // ==========================================
          // BODY
          // ==========================================

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========================================
                  // WELCOME
                  // ========================================

                  const Text(
                    'Welcome back 👋',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Tenant Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ========================================
                  // PROPERTY CARD
                  // ========================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF288DFF),
                          Color(0xFF759BFA),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(
                            alpha: 0.15,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.20,
                            ),
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Sunshine Apartment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Room 204 • 2nd Floor',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Divider(
                          color: Colors.white30,
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monthly Rent',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'ETB 8,500',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'OVERDUE',
                                style: TextStyle(
                                  color: Color(0xFF288DFF),
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ========================================
                  // RENT INFORMATION
                  // ========================================

                  const Text(
                    'Rent Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFF),
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFE2E8F8),
                      ),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.payments_outlined,
                          title: 'Amount Due',
                          value: 'ETB 8,500',
                        ),

                        const Divider(height: 25),

                        _infoRow(
                          icon:
                              Icons.calendar_today_outlined,
                          title: 'Due Date',
                          value: 'September 5, 2026',
                        ),

                        const Divider(height: 25),

                        _infoRow(
                          icon:
                              Icons.notifications_outlined,
                          title: 'Reminder',
                          value: '3 days before',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ========================================
                  // PAY RENT BUTTON
                  // ========================================

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              debugPrint(
                                '========================================',
                              );
                              debugPrint(
                                'PAY RENT BUTTON PRESSED',
                              );
                              debugPrint(
                                'Sending PayRentPressed to PaymentBloc',
                              );
                              debugPrint(
                                '========================================',
                              );

                              context
                                  .read<PaymentBloc>()
                                  .add(
                                    PayRentPressed(),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF288DFF),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF9CC8FF),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Processing...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.payment_outlined,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Pay Rent',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ========================================
                  // QUICK ACTIONS
                  // ========================================

                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _quickAction(
                          icon:
                              Icons.receipt_long_outlined,
                          title: 'Payments',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _quickAction(
                          icon: Icons.build_outlined,
                          title: 'Maintenance',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _quickAction(
                          icon:
                              Icons.description_outlined,
                          title: 'Lease',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _quickAction(
                          icon: Icons.people_outline,
                          title: 'Community',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // OPEN STARPAY PAYMENT PAGE
  // ==========================================

  static Future<void> _openPaymentPage(
    String paymentUrl,
  ) async {
    debugPrint('========================================');
    debugPrint('OPENING STARPAY PAYMENT PAGE');
    debugPrint('URL: $paymentUrl');
    debugPrint('========================================');

    final uri = Uri.parse(paymentUrl);

    try {
      final canOpen = await canLaunchUrl(uri);

      debugPrint(
        'CAN OPEN STARPAY URL: $canOpen',
      );

      if (!canOpen) {
        debugPrint(
          'No application can open this URL.',
        );
        return;
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      debugPrint(
        'URL LAUNCH RESULT: $launched',
      );

      if (launched) {
        debugPrint(
          'STARPAY PAYMENT PAGE OPENED SUCCESSFULLY',
        );
      } else {
        debugPrint(
          'FAILED TO OPEN STARPAY PAYMENT PAGE',
        );
      }
    } catch (e) {
      debugPrint(
        'URL LAUNCH ERROR: $e',
      );
    }
  }

  // ==========================================
  // INFO ROW
  // ==========================================

  static Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF288DFF),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // QUICK ACTION
  // ==========================================

  static Widget _quickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE2E8F8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.03,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF288DFF),
                size: 24,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}