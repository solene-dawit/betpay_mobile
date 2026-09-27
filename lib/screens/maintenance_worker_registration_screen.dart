import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/registration/registration_bloc.dart';
import '../bloc/registration/registration_event.dart';
import '../bloc/registration/registration_state.dart';

class MaintenanceWorkerRegistrationScreen extends StatefulWidget {
  const MaintenanceWorkerRegistrationScreen({
    super.key,
  });

  @override
  State<MaintenanceWorkerRegistrationScreen> createState() =>
      _MaintenanceWorkerRegistrationScreenState();
}

class _MaintenanceWorkerRegistrationScreenState
    extends State<MaintenanceWorkerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _serviceController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ------------------------------------------------------------
  // SUPPORTED COUNTRIES
  // ------------------------------------------------------------

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

    // Default country is Ethiopia.
    _selectedCountry = _countries.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    _serviceController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // PHONE CLEANING
  // ------------------------------------------------------------

  String _cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  // ------------------------------------------------------------
  // PHONE FORMATTING
  // ------------------------------------------------------------

  String formatPhoneNumber(String phone) {
    String cleaned = _cleanPhone(phone).trim();

    final countryCode = _selectedCountry['code']!;
    final countryDigits = countryCode.replaceAll('+', '');

    // Already starts with +
    if (cleaned.startsWith('+')) {
      return '+${cleaned.substring(1)}';
    }

    // User entered country code without +
    if (cleaned.startsWith(countryDigits)) {
      return '+$cleaned';
    }

    // User entered local number beginning with 0
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    return '$countryCode$cleaned';
  }

  // ------------------------------------------------------------
  // PHONE VALIDATION
  // ------------------------------------------------------------

  bool _isValidPhone(String phone) {
    final formattedPhone = formatPhoneNumber(phone);

    final countryCode = _selectedCountry['code']!;
    final countryDigits = countryCode.replaceAll('+', '');

    final digitsOnly =
        formattedPhone.replaceAll(RegExp(r'[^0-9]'), '');

    if (!digitsOnly.startsWith(countryDigits)) {
      return false;
    }

    final localNumber =
        digitsOnly.substring(countryDigits.length);

    final expectedDigits =
        int.tryParse(_selectedCountry['digits']!) ?? 0;

    return localNumber.length == expectedDigits;
  }

  // ------------------------------------------------------------
  // COUNTRY SELECTOR
  // ------------------------------------------------------------

  Widget _countrySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, String>>(
          value: _selectedCountry,
          isExpanded: true,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF288DFF),
          ),
          items: _countries.map((country) {
            return DropdownMenuItem<Map<String, String>>(
              value: country,
              child: Row(
                children: [
                  Text(
                    country['flag']!,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      country['name']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    country['code']!,
                    style: const TextStyle(
                      color: Color(0xFF288DFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (country) {
            if (country == null) {
              return;
            }

            setState(() {
              _selectedCountry = country;
            });

            // Revalidate the phone after changing country.
            _formKey.currentState?.validate();
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // REGISTRATION
  // ------------------------------------------------------------

  void _registerWorker() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final formattedPhone = formatPhoneNumber(
      _phoneController.text,
    );

    final countryIso = _selectedCountry['iso']!;

    context.read<RegistrationBloc>().add(
          RegisterUser(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: formattedPhone,
            countryIso: countryIso,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            role: 'maintenance_worker',
          ),
        );
  }

  // ------------------------------------------------------------
  // INPUT DECORATION
  // ------------------------------------------------------------

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
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF288DFF),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        // --------------------------------------------------------
        // SUCCESS
        // --------------------------------------------------------

        if (state is RegistrationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Worker account created successfully!',
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.blue,
            ),
          );

          context.go('/maintenance-worker');
        }

        // --------------------------------------------------------
        // FAILURE
        // --------------------------------------------------------

        if (state is RegistrationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
            child: Column(
              children: [
                // ------------------------------------------------
                // TOP BAR
                // ------------------------------------------------

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Worker Registration',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // ------------------------------------------------
                // FORM
                // ------------------------------------------------

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      20,
                      24,
                      30,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Become a Maintenance Worker',
                            style: TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Create your account and start offering your maintenance services through BetPay.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ------------------------------------------------
                          // WHITE FORM CARD
                          // ------------------------------------------------

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.94,
                              ),
                              borderRadius:
                                  BorderRadius.circular(28),
                            ),
                            child: Column(
                              children: [
                                // ------------------------------------------
                                // FULL NAME
                                // ------------------------------------------

                                TextFormField(
                                  controller: _nameController,
                                  textInputAction:
                                      TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: 'Full Name',
                                    hint: 'Enter your full name',
                                    icon: Icons
                                        .person_outline_rounded,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your full name';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // COUNTRY
                                // ------------------------------------------

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      bottom: 8,
                                      left: 4,
                                    ),
                                    child: Text(
                                      'Country',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                _countrySelector(),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // PHONE
                                // ------------------------------------------

                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType:
                                      TextInputType.phone,
                                  textInputAction:
                                      TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: 'Phone Number',
                                    hint:
                                        'Enter your ${_selectedCountry['name']} number',
                                    icon:
                                        Icons.phone_outlined,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your phone number';
                                    }

                                    if (!_isValidPhone(value)) {
                                      return 'Enter a valid ${_selectedCountry['name']} phone number';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 8),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Example: ${_selectedCountry['code']} ${'X' * int.parse(_selectedCountry['digits']!)}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // EMAIL
                                // ------------------------------------------

                                TextFormField(
                                  controller: _emailController,
                                  keyboardType:
                                      TextInputType.emailAddress,
                                  textInputAction:
                                      TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: 'Email',
                                    hint: 'example@email.com',
                                    icon:
                                        Icons.email_outlined,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }

                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // SERVICE
                                // ------------------------------------------

                                TextFormField(
                                  controller:
                                      _serviceController,
                                  textInputAction:
                                      TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: 'Service',
                                    hint:
                                        'e.g. Plumbing, Electrical',
                                    icon:
                                        Icons.build_outlined,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your service';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // EXPERIENCE
                                // ------------------------------------------

                                TextFormField(
                                  controller:
                                      _experienceController,
                                  keyboardType:
                                      TextInputType.number,
                                  textInputAction:
                                      TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: 'Experience',
                                    hint: 'e.g. 3 years',
                                    icon: Icons
                                        .work_outline_rounded,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your experience';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // LOCATION
                                // ------------------------------------------

                                TextFormField(
                                  controller:
                                      _locationController,
                                  textInputAction:
                                      TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: 'Location',
                                    hint: 'e.g. Addis Ababa',
                                    icon: Icons
                                        .location_on_outlined,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your location';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // PASSWORD
                                // ------------------------------------------

                                TextFormField(
                                  controller:
                                      _passwordController,
                                  obscureText:
                                      _obscurePassword,
                                  textInputAction:
                                      TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: 'Password',
                                    hint:
                                        'Enter your password',
                                    icon: Icons
                                        .lock_outline_rounded,
                                    suffixIcon:
                                        IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword =
                                              !_obscurePassword;
                                        });
                                      },
                                      icon: Icon(
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
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please enter a password';
                                    }

                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // ------------------------------------------
                                // CONFIRM PASSWORD
                                // ------------------------------------------

                                TextFormField(
                                  controller:
                                      _confirmPasswordController,
                                  obscureText:
                                      _obscureConfirmPassword,
                                  textInputAction:
                                      TextInputAction.done,
                                  decoration: _inputDecoration(
                                    label: 'Confirm Password',
                                    hint:
                                        'Enter your password again',
                                    icon: Icons
                                        .lock_outline_rounded,
                                    suffixIcon:
                                        IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                      icon: Icon(
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
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
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

                                const SizedBox(height: 28),

                                // ------------------------------------------
                                // REGISTER BUTTON
                                // ------------------------------------------

                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: BlocBuilder<
                                      RegistrationBloc,
                                      RegistrationState>(
                                    builder:
                                        (context, state) {
                                      final isLoading = state
                                          is RegistrationSubmitting;

                                      return ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : _registerWorker,
                                        style: ElevatedButton
                                            .styleFrom(
                                          backgroundColor:
                                              const Color(
                                            0xFF288DFF,
                                          ),
                                          foregroundColor:
                                              Colors.white,
                                          disabledBackgroundColor:
                                              Colors.blue.shade200,
                                          elevation: 0,
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth:
                                                      2,
                                                  color:
                                                      Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Create Worker Account',
                                                style:
                                                    TextStyle(
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // ------------------------------------------
                                // LOGIN
                                // ------------------------------------------

                                TextButton(
                                  onPressed: () =>
                                      context.go('/login'),
                                  child: const Text(
                                    'Already have an account? Login',
                                    style: TextStyle(
                                      color:
                                          Color(0xFF288DFF),
                                      fontWeight:
                                          FontWeight.w600,
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