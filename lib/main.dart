import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/admin_widget.dart';
import 'package:myapp/screens/edit_profile_screen.dart';
import 'package:myapp/screens/get_started_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/hura_point_provider.dart';
import 'screens/add_post_screen.dart';
import 'screens/creative_hura_screen.dart';
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => HuraPointProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class AppRoutes {
  static const first = '/get-started';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const admin = '/admin';
  static const creativeHura = '/creative-hura';
  static const addCreativeHura = '/add-creative-hura';
  static const editProfileScreen = '/edit-profile-screen';
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
        AppRoutes.first: (context) => const GetStartedScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const MainWidget(),
        AppRoutes.admin: (context) => const AdminWidget(),
        AppRoutes.creativeHura: (context) => const CreativeHuraScreen(),
        AppRoutes.addCreativeHura: (context) => const AddPostScreen(),
        AppRoutes.editProfileScreen: (context) => const EditProfileScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      },
    );
  }
}
