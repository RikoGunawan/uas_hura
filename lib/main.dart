import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/admin/admin_profile.dart';
import 'package:myapp/main_widget.dart';
import 'package:myapp/providers/quest_provider.dart';
import 'package:myapp/screens/home/login_screen.dart';
import 'package:myapp/widgets/admin_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/event_provider.dart';
import 'providers/hura_point_provider.dart';
import 'services/event_service.dart';
import 'utils/app_colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final huraProvider = HuraPointProvider();
  await huraProvider.loadLastLoginDate();

  await Supabase.initialize(
    url: 'https://cqmadsjfyxpbewyouuvk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxbWFkc2pmeXhwYmV3eW91dXZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI1MTAwMDYsImV4cCI6MjA0ODA4NjAwNn0.qOhio_3HHn_JiFMKX-gh12Ycww8hzZsav5bZ8j9gZ74',
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
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => HuraPointProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
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
      debugShowCheckedModeBanner: false,
      title: 'Hura',
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
      home: LoginScreen(),
    );
  }
}
