import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import 'core/database/app_database.dart'; 
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/checklist/providers/checklist_provider.dart';

import 'features/advisor/presentation/advisor_screen.dart';
import 'features/checklist/presentation/checklist_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/calculator/presentation/calculator_screen.dart';
import 'features/commercial/presentation/commercial_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appDatabase = AppDatabase();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(appDatabase),
        ),
        ChangeNotifierProvider(                          
          create: (_) => ChecklistProvider(appDatabase), 
        ),
      ],
      child: const EVTechApp(),
    ),
  );
}

class EVTechApp extends StatelessWidget {
  const EVTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WireFlow VE Dashboard',
      debugShowCheckedModeBanner: false, 

      themeMode: ThemeMode.system, 
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //fontFamily: 'Inter', 
      
      // Definimos la ruta 
      initialRoute: '/',
      // Mapa de rutas
      routes: {
        '/': (context) => const DashboardScreen(),
        '/calculator': (context) => const CalculatorScreen(),
        '/commercial': (context) => const CommercialScreen(),
        '/checklist': (context) => const ChecklistScreen(),
        '/advisor': (context) => const AdvisorScreen(),
      },
    );
  }
}