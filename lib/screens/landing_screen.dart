import 'package:flutter/material.dart';
import '../components/betpay_button.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // =========================
        // GRADIENT BACKGROUND
        // =========================
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF288DFF),
              Color(0xFF759BFA),
              Color(0xFFE2E8F8),
              Colors.white,
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // =========================
                // HEADER
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // =========================
                      // LEFT SIDE
                      // =========================
                      Row(
                        children: [

                          // MENU BUTTON
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Menu will be added later
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
  ),                           
                              child: Image.asset(
                              'assets/images/betpay_logo.png',
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          )
                          // BETPAY LOGO
                          
                        ],
                      ),

                      // =========================
                      // LOGIN BUTTON
                      // =========================
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 104, 18, 18),
                            foregroundColor: const Color.fromARGB(255, 250, 250, 251),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================
                // HERO SECTION
                // =========================
                Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Column(
                          children: [

                            const SizedBox(height: 40),

                            // =========================
                            // HERO IMAGE AREA
                            // =========================
                            Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.asset(
                                  'assets/images/.jpg',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          

                      const SizedBox(height: 40),

                      // =========================
                      // TITLE
                      // =========================
                      const Text(
                        'Manage Your Property\nWith Ease',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =========================
                      // DESCRIPTION
                      // =========================
                      const Text(
                        'Pay rent, manage your property, '
                        'and stay connected with BetPay.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // =========================
                      // GET STARTED
                      // =========================
                         BetPayButton(
                        text: 'Get Started',
                        icon: Icons.arrow_forward_rounded,
                        iconRight: true,
                        onPressed: () {
                          context.push('/register');
                        },
                      ),

                      const SizedBox(height: 16),

                      // =========================
                      // LEARN MORE
                      // =========================
                      BetPayButton(
                        text: 'Learn More',
                        outlined: true,
                        onPressed: () {},
                      ),

                      const SizedBox(height: 40),

                      // =========================
                      // FOOTER
                      // =========================
                      const Text(
                        '© 2026 BetPay',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 2, 1, 1),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}