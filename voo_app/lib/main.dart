import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/welcome/welcome_screen.dart';
import 'state/app_state.dart';

void main() {
  runApp(const VooApp());
}

class VooApp extends StatelessWidget {
  const VooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VOO',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFF05051C),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}