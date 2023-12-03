import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/firebase/firebase_options.dart';
import 'package:vartarevarta_magazine/services/analytics_service.dart';
import 'package:vartarevarta_magazine/services/notifications.dart';
import 'package:vartarevarta_magazine/services/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FireBaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [AnalyticsService().getAnalyticsObserver()],
      debugShowCheckedModeBanner: false,
      title: 'VaReVa Magazine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown.shade600, primary: Colors.brown.shade400),
        useMaterial3: true,
      ),
      home: const WrapperWidget(),
    );
  }
}
