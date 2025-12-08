import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/assignments_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentsProvider()),
      ],
      child: const JohnRenanListApp(),
    ),
  );
}

class JohnRenanListApp extends StatelessWidget {
  const JohnRenanListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'JohnRenanList',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: themeProvider.currentTheme == AppTheme.light 
                ? Brightness.light 
                : Brightness.dark,
            scaffoldBackgroundColor: themeProvider.backgroundColor,
            primaryColor: themeProvider.panicColor,
            cardColor: themeProvider.cardBackgroundColor,
            colorScheme: ColorScheme(
              brightness: themeProvider.currentTheme == AppTheme.light 
                  ? Brightness.light 
                  : Brightness.dark,
              primary: themeProvider.panicColor,
              secondary: themeProvider.accentColor,
              surface: themeProvider.cardBackgroundColor,
              error: Colors.red,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onSurface: themeProvider.textColor,
              onError: Colors.white,
            ),
            textTheme: GoogleFonts.firaCodeTextTheme().apply(
              bodyColor: themeProvider.textColor,
              displayColor: themeProvider.textColor,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: themeProvider.navbarColor,
              foregroundColor: themeProvider.textColor,
              elevation: 0,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: themeProvider.accentColor,
              foregroundColor: Colors.black,
            ),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
