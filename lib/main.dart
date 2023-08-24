import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_robo_cash/bloc/robo_cash_bloc.dart';
import 'package:simple_robo_cash/core/settings.dart';

import 'presentation/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Robo Cash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: surface,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
      ),
      home: BlocProvider<RoboCashBloc>(
        create: (BuildContext context) => RoboCashBloc()..add(RoboCashLoadEvent()),
        child: const MainScreen(),
      ),
    );
  }
}
