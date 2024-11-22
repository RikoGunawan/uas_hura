import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/hura_point_provider.dart';
import 'screens/login_screen.dart';
import 'services/event_service.dart';
import 'utils/app_colors.dart';
import 'utils/auth_guard.dart'; // Tambahkan import ini

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
        ChangeNotifierProxyProvider<EventService, EventProvider>(
          create: (context) => EventProvider(context.read<EventService>()),
          update: (_, service, previousProvider) =>
              previousProvider ?? EventProvider(service),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HuraPointProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riko',
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
      home: const AuthGuard(child: LoginScreen()), // Gunakan AuthGuard
    );
  }
}
