import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6/routing/router.dart';
import 'package:week6/routing/routes.dart';
import 'features/news/viewmodel/news_viewmodel.dart';
import 'core/services/dio_handler.dart';
import 'package:week6/features/bookmarks/viewmodel/booking_viewmodel.dart';

void main() {
  DioHandler.setup();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkController()),
      ],
      child: const MyApp(),
    ),
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
