//~~~ Made by Riko Gunawan ~~~
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:myapp/main_widget.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/hura_point_provider.dart';
// import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final huraProvider = HuraPointProvider();
  await huraProvider.loadLastLoginDate(); // Muat tanggal login sebelumnya

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (_) => HuraPointProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riko',
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
      home: const LoginScreen(),
    );
  }
}
