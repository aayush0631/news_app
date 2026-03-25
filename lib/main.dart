import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6/routing/router.dart';
import 'package:week6/routing/routes.dart';
import 'providers/news_provider.dart';
import 'services/dio_handler.dart';

void main() {
  DioHandler.setup();
  runApp(
    ChangeNotifierProvider(create: (_) => NewsProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Routes.home,
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
    );
  }
}
