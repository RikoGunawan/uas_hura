import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/admin_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/hura_point_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'main_widget.dart';
import 'services/event_service.dart';
import 'utils/app_colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final huraProvider = HuraPointProvider();
  await huraProvider.loadLastLoginDate();

  await Supabase.initialize(
    url: 'https://naybuanerhxbupsgafhv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5heWJ1YW5lcmh4YnVwc2dhZmh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyNzkzNDksImV4cCI6MjA0Nzg1NTM0OX0.1qGWdSbOh7JFSGJ6N_GJdn2zFFgx6rWE7Wb5ZKkYLHQ',
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<SupabaseClient>(
          create: (_) => Supabase.instance.client,
        ),
        ProxyProvider<SupabaseClient, EventService>(
          create: (context) => EventService(Supabase.instance.client),
          update: (_, client, previousService) =>
              previousService ?? EventService(client),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => HuraPointProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const admin = '/admin';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hura',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primaryColorLight: AppColors.primaryLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background,
          onPrimary: AppColors.textPrimary,
          onSecondary: AppColors.textSecondary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const MainWidget(),
        AppRoutes.admin: (context) => const AdminWidget(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      },
    );
  }
}
