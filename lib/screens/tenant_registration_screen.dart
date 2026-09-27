import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/registration/registration_bloc.dart';
import '../bloc/registration/registration_event.dart';
import '../bloc/registration/registration_state.dart';

class TenantRegistrationScreen extends StatefulWidget {
  const TenantRegistrationScreen({super.key});

  @override
  State<TenantRegistrationScreen> createState() =>
      _TenantRegistrationScreenState();
}

class _TenantRegistrationScreenState
    extends State<TenantRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ==========================================
  // COUNTRY DATA
  // ==========================================

  final List<Map<String, String>> _countries = [
    {
      'name': 'Ethiopia',
      'code': '+251',
      'iso': 'ET',
      'flag': '🇪🇹',
      'digits': '9',
    },
    {
      'name': 'United States',
      'code': '+1',
      'iso': 'US',
      'flag': '🇺🇸',
      'digits': '10',
    },
    {
      'name': 'Canada',
      'code': '+1',
      'iso': 'CA',
      'flag': '🇨🇦',
      'digits': '10',
    },
    {
      'name': 'United Kingdom',
      'code': '+44',
      'iso': 'GB',
      'flag': '🇬🇧',
      'digits': '10',
    },
    {
      'name': 'Kenya',
      'code': '+254',
      'iso': 'KE',
      'flag': '🇰🇪',
      'digits': '9',
    },
    {
      'name': 'Uganda',
      'code': '+256',
      'iso': 'UG',
      'flag': '🇺🇬',
      'digits': '9',
    },
    {
      'name': 'Tanzania',
      'code': '+255',
      'iso': 'TZ',
      'flag': '🇹🇿',
      'digits': '9',
    },
    {
      'name': 'Rwanda',
      'code': '+250',
      'iso': 'RW',
      'flag': '🇷🇼',
      'digits': '9',
    },
    {
      'name': 'South Africa',
      'code': '+27',
      'iso': 'ZA',
      'flag': '🇿🇦',
      'digits': '9',
    },
    {
      'name': 'United Arab Emirates',
      'code': '+971',
      'iso': 'AE',
      'flag': '🇦🇪',
      'digits': '9',
    },
    {
      'name': 'Saudi Arabia',
      'code': '+966',
      'iso': 'SA',
      'flag': '🇸🇦',
      'digits': '9',
    },
    {
      'name': 'Germany',
      'code': '+49',
      'iso': 'DE',
      'flag': '🇩🇪',
      'digits': '10',
    },
    {
      'name': 'France',
      'code': '+33',
      'iso': 'FR',
      'flag': '🇫🇷',
      'digits': '9',
    },
    {
      'name': 'India',
      'code': '+91',
      'iso': 'IN',
      'flag': '🇮🇳',
      'digits': '10',
    },
    {
      'name': 'Australia',
      'code': '+61',
      'iso': 'AU',
      'flag': '🇦🇺',
      'digits': '9',
    },
  ];

  late Map<String, String> _selectedCountry;

  @override
  void initState() {
    super.initState();

    // Default country
    _selectedCountry = _countries.first;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================
  // CLEAN PHONE NUMBER
  // ==========================================

  String _cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  // ==========================================
  // FORMAT INTERNATIONAL PHONE NUMBER
  // ==========================================

  String formatPhoneNumber(String phone) {
    String cleaned = _cleanPhone(phone).trim();

    final countryCode = _selectedCountry['code']!;
    final countryDigits = countryCode.replaceAll('+', '');

    // Remove + temporarily
    if (cleaned.startsWith('+')) {
      cleaned = cleaned.substring(1);
    }

    // Already international
    //
    // Example:
    // +251912345678
    // 251912345678
    if (cleaned.startsWith(countryDigits)) {
      return '+$cleaned';
    }

    // Local number
    //
    // Example:
    // 0912345678
    //
    // becomes:
    // 912345678
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    return '$countryCode$cleaned';
  }

  // ==========================================
  // VALIDATE PHONE NUMBER
  // ==========================================

  bool _isValidPhone(String phone) {
    final formattedPhone = formatPhoneNumber(phone);

    final countryCode = _selectedCountry['code']!;
    final countryDigits = countryCode.replaceAll('+', '');

    // Keep numbers only
    final digitsOnly =
        formattedPhone.replaceAll(RegExp(r'[^0-9]'), '');

    // Make sure the selected country code exists
    if (!digitsOnly.startsWith(countryDigits)) {
      return false;
    }

    // Remove country code
    final localNumber =
        digitsOnly.substring(countryDigits.length);

    // Get expected local phone length
    final expectedDigits =
        int.tryParse(_selectedCountry['digits']!) ?? 0;

    return localNumber.length == expectedDigits;
  }

  // ==========================================
  // REGISTER
  // ==========================================

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Convert phone to international format
    final formattedPhone = formatPhoneNumber(
      _phoneController.text,
    );

    // Get selected country ISO
    final countryIso = _selectedCountry['iso']!;

    debugPrint(
      'REGISTER PHONE: $formattedPhone',
    );

    debugPrint(
      'REGISTER COUNTRY: $countryIso',
    );

    context.read<RegistrationBloc>().add(
          RegisterUser(
            fullName:
                _fullNameController.text.trim(),

            email:
                _emailController.text.trim(),

            // Example:
            // 0912345678 -> +251912345678
            phone: formattedPhone,

            // Example:
            // Ethiopia -> ET
            countryIso: countryIso,

            password:
                _passwordController.text,

            confirmPassword:
                _confirmPasswordController.text,

            role: 'tenant',
          ),
        );
  }

  // ==========================================
  // INPUT DECORATION
  // ==========================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon: Icon(
        icon,
        color: const Color(0xFF288DFF),
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF288DFF),
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  // ==========================================
  // COUNTRY SELECTOR
  // ==========================================

  Widget _countrySelector() {
    return InkWell(
      onTap: () {
        _showCountryPicker();
      },

      borderRadius:
          BorderRadius.circular(16),

      child: Container(
        height: 58,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),

        child: Row(
          children: [
            Text(
              _selectedCountry['flag']!,
              style:
                  const TextStyle(fontSize: 24),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    _selectedCountry['name']!,

                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  Text(
                    _selectedCountry['code']!,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF288DFF),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // COUNTRY PICKER
  // ==========================================

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,

      backgroundColor:
          Colors.transparent,

      isScrollControlled: true,

      builder: (context) {
        return Container(
          height:
              MediaQuery.of(context)
                      .size
                      .height *
                  0.75,

          decoration:
              const BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),

          child: Column(
            children: [
              const SizedBox(height: 15),

              Container(
                width: 45,
                height: 5,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey.shade300,

                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Select Country',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount:
                      _countries.length,

                  itemBuilder:
                      (context, index) {
                    final country =
                        _countries[index];

                    final selected =
                        country['iso'] ==
                            _selectedCountry[
                                'iso'];

                    return ListTile(
                      leading: Text(
                        country['flag']!,

                        style:
                            const TextStyle(
                          fontSize: 28,
                        ),
                      ),

                      title: Text(
                        country['name']!,

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      subtitle: Text(
                        '${country['code']} • ${country['iso']}',
                      ),

                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color:
                                  Color(
                                0xFF288DFF,
                              ),
                            )
                          : null,

                      onTap: () {
                        setState(() {
                          _selectedCountry =
                              country;

                          // Clear old phone number
                          // when country changes.
                          _phoneController
                              .clear();
                        });

                        Navigator.pop(
                          context,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        RegistrationBloc,
        RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Account created successfully. Welcome to BetPay!',
              ),
              behavior:
                  SnackBarBehavior.floating,
              backgroundColor:
                  Colors.blue,
            ),
          );

          context.go('/tenant');
        }

        if (state is RegistrationFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content:
                  Text(state.message),
              backgroundColor:
                  Colors.red,
            ),
          );
        }
      },

      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,

          decoration:
              const BoxDecoration(
            gradient:
                LinearGradient(
              begin:
                  Alignment.topCenter,
              end:
                  Alignment.bottomCenter,

              colors: [
                Color(0xFF288DFF),
                Color(0xFF759BFA),
                Color(0xFFE2E8F8),
                Colors.white,
              ],
            ),
          ),

          child: SafeArea(
            child: Column(
              children: [
                // ==========================================
                // HEADER
                // ==========================================

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            context.pop(),

                        icon: const Icon(
                          Icons
                              .arrow_back_rounded,
                          color:
                              Colors.white,
                          size: 28,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          'Tenant Registration',

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(
                            color:
                                Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 48,
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // FORM
                // ==========================================

                Expanded(
                  child:
                      SingleChildScrollView(
                    padding:
                        const EdgeInsets
                            .fromLTRB(
                      24,
                      20,
                      24,
                      30,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            'Create Your Account',

                            style: TextStyle(
                              fontSize: 30,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color:
                                  Colors.white,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          const Text(
                            'Enter your information to get started with BetPay.',

                            style: TextStyle(
                              fontSize: 15,
                              color:
                                  Colors.white,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(
                            height: 28,
                          ),

                          Container(
                            width:
                                double.infinity,

                            padding:
                                const EdgeInsets
                                    .all(22),

                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .white
                                  .withValues(
                                alpha: 0.94,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                28,
                              ),
                            ),

                            child: Column(
                              children: [
                                // ==========================================
                                // FULL NAME
                                // ==========================================

                                TextFormField(
                                  controller:
                                      _fullNameController,

                                  textInputAction:
                                      TextInputAction
                                          .next,

                                  decoration:
                                      _inputDecoration(
                                    label:
                                        'Full Name',
                                    hint:
                                        'Enter your full name',
                                    icon: Icons
                                        .person_outline_rounded,
                                  ),

                                  validator:
                                      (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return 'Please enter your full name';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 18,
                                ),

                                // ==========================================
                                // EMAIL
                                // ==========================================

                                TextFormField(
                                  controller:
                                      _emailController,

                                  keyboardType:
                                      TextInputType
                                          .emailAddress,

                                  textInputAction:
                                      TextInputAction
                                          .next,

                                  decoration:
                                      _inputDecoration(
                                    label:
                                        'Email',
                                    hint:
                                        'example@email.com',
                                    icon: Icons
                                        .email_outlined,
                                  ),

                                  validator:
                                      (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return 'Please enter your email';
                                    }

                                    if (!value
                                        .contains(
                                            '@')) {
                                      return 'Please enter a valid email';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 18,
                                ),

                                // ==========================================
                                // COUNTRY
                                // ==========================================

                                const Align(
                                  alignment:
                                      Alignment
                                          .centerLeft,

                                  child: Text(
                                    'Country',

                                    style:
                                        TextStyle(
                                      fontSize:
                                          15,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                _countrySelector(),

                                const SizedBox(
                                  height: 18,
                                ),

                                // ==========================================
                                // PHONE
                                // ==========================================

                                TextFormField(
                                  controller:
                                      _phoneController,

                                  keyboardType:
                                      TextInputType
                                          .phone,

                                  textInputAction:
                                      TextInputAction
                                          .next,

                                  decoration:
                                      _inputDecoration(
                                    label:
                                        'Phone Number',
                                    hint:
                                        'Enter phone number',
                                    icon: Icons
                                        .phone_outlined,
                                  ),

                                  validator:
                                      (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return 'Please enter your phone number';
                                    }

                                    if (!_isValidPhone(
                                        value)) {
                                      return 'Enter a valid phone number for ${_selectedCountry['name']}';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Align(
                                  alignment:
                                      Alignment
                                          .centerLeft,

                                  child: Text(
                                    'International format: ${_selectedCountry['code']}${'X' * int.parse(_selectedCountry['digits']!)}',

                                    style:
                                        TextStyle(
                                      fontSize:
                                          12,
                                      color: Colors
                                          .grey
                                          .shade600,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 18,
                                ),

                                // ==========================================
                                // PASSWORD
                                // ==========================================

                                TextFormField(
                                  controller:
                                      _passwordController,

                                  obscureText:
                                      _obscurePassword,

                                  textInputAction:
                                      TextInputAction
                                          .next,

                                  decoration:
                                      _inputDecoration(
                                    label:
                                        'Password',
                                    hint:
                                        'Enter your password',
                                    icon: Icons
                                        .lock_outline_rounded,

                                    suffixIcon:
                                        IconButton(
                                      onPressed:
                                          () {
                                        setState(
                                          () {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          },
                                        );
                                      },

                                      icon:
                                          Icon(
                                        _obscurePassword
                                            ? Icons
                                                .visibility_outlined
                                            : Icons
                                                .visibility_off_outlined,

                                        color:
                                            const Color(
                                          0xFF288DFF,
                                        ),
                                      ),
                                    ),
                                  ),

                                  validator:
                                      (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .isEmpty) {
                                      return 'Please enter a password';
                                    }

                                    if (value
                                            .length <
                                        8) {
                                      return 'Password must be at least 8 characters';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 18,
                                ),

                                // ==========================================
                                // CONFIRM PASSWORD
                                // ==========================================

                                TextFormField(
                                  controller:
                                      _confirmPasswordController,

                                  obscureText:
                                      _obscureConfirmPassword,

                                  textInputAction:
                                      TextInputAction
                                          .done,

                                  decoration:
                                      _inputDecoration(
                                    label:
                                        'Confirm Password',
                                    hint:
                                        'Enter your password again',
                                    icon: Icons
                                        .lock_outline_rounded,

                                    suffixIcon:
                                        IconButton(
                                      onPressed:
                                          () {
                                        setState(
                                          () {
                                            _obscureConfirmPassword =
                                                !_obscureConfirmPassword;
                                          },
                                        );
                                      },

                                      icon:
                                          Icon(
                                        _obscureConfirmPassword
                                            ? Icons
                                                .visibility_outlined
                                            : Icons
                                                .visibility_off_outlined,

                                        color:
                                            const Color(
                                          0xFF288DFF,
                                        ),
                                      ),
                                    ),
                                  ),

                                  validator:
                                      (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .isEmpty) {
                                      return 'Please confirm your password';
                                    }

                                    if (value !=
                                        _passwordController
                                            .text) {
                                      return 'Passwords do not match';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 28,
                                ),

                                // ==========================================
                                // REGISTER BUTTON
                                // ==========================================

                                SizedBox(
                                  width:
                                      double.infinity,
                                  height: 56,

                                  child:
                                      BlocBuilder<
                                          RegistrationBloc,
                                          RegistrationState>(
                                    builder:
                                        (
                                      context,
                                      state,
                                    ) {
                                      final isLoading =
                                          state
                                              is RegistrationSubmitting;

                                      return ElevatedButton(
                                        onPressed:
                                            isLoading
                                                ? null
                                                : _register,

                                        style:
                                            ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(
                                            0xFF288DFF,
                                          ),

                                          foregroundColor:
                                              Colors.white,

                                          elevation:
                                              0,

                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              16,
                                            ),
                                          ),
                                        ),

                                        child:
                                            isLoading
                                                ? const SizedBox(
                                                    width:
                                                        24,
                                                    height:
                                                        24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth:
                                                          2,
                                                      color:
                                                          Colors.white,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Register',

                                                    style:
                                                        TextStyle(
                                                      fontSize:
                                                          17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  height: 14,
                                ),

                                TextButton(
                                  onPressed: () =>
                                      context.pop(),

                                  child:
                                      const Text(
                                    'Already have an account? Login',

                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xFF288DFF,
                                      ),
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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