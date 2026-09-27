import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import '../bloc/registration/registration_bloc.dart';
import '../screens/landing_screen.dart';
import '../screens/registration_type_screen.dart';
import '../screens/tenant_registration_screen.dart';
import '../screens/maintenance_worker_registration_screen.dart';
import '../screens/tenant_dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../bloc/payment/payment_bloc.dart';
import '../services/auth_service.dart';
import '../services/starpay_service.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationTypeScreen(),
    ),
    
    GoRoute(
      path: '/register/tenant',
      builder: (context, state) => BlocProvider(
        create: (_) => RegistrationBloc(),
        child: const TenantRegistrationScreen(),
      ),
    ),

    GoRoute(
      path: '/register/worker',
      builder: (context, state) => BlocProvider(
        create: (_) => RegistrationBloc(),
        child: const MaintenanceWorkerRegistrationScreen(),
      ),
    ),
        GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
    path: '/tenant',
    builder: (context, state) => BlocProvider(
      create: (_) => PaymentBloc(
        starPayService: StarPayService(),
        authService: AuthService(),
      ),
      child: const TenantDashboardScreen(),
      ),
    ),
  ],
);