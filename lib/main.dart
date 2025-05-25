import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/services/theme/theme_service.dart';
import 'package:sharevoices/views/home_view.dart';

final providerContainer = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await providerContainer.read(themeProvider).loadSavedTheme();

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Share Voices',
        theme: ref.watch(themeProvider).themeData,
        home: child,
      ),
      child: const HomeView(),
    );
  }
}

/// to run codemagic push on develop branch