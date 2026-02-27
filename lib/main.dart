import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/user_session_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

/// AuthWrapper - Checks authentication status and shows appropriate screen
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Check if user is already logged in
  Future<void> _checkAuthStatus() async {
<<<<<<< HEAD
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    // Load saved theme preference
    final themeProvider = provider.Provider.of<ThemeProvider>(
      context,
      listen: false,
    );
    final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    if (isDarkMode) {
      themeProvider.setThemeMode(ThemeMode.dark);
    }

    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
=======
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      // Load saved theme preference
      if (mounted) {
        final themeProvider = provider.Provider.of<ThemeProvider>(
          context,
          listen: false,
        );
        final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
        if (isDarkMode) {
          themeProvider.setThemeMode(ThemeMode.dark);
        }
      }

      if (mounted) {
        setState(() {
          _isLoggedIn = isLoggedIn;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking auth status: $e');
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
      }
    }
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
<<<<<<< HEAD
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
=======
          backgroundColor: Colors.white, // Ensure white background
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 16),
                const Text(
                  'Loading...',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
          ),
        ),
      );
    }

    // Get router with initial location based on auth status
    final router = AppRouter.getRouter(_isLoggedIn);

    return provider.Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
