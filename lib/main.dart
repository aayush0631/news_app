import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week4/routing/router.dart';
import 'package:week4/routing/routes.dart';
import 'providers/news_provider.dart';


void main() {
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
