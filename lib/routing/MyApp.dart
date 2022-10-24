import 'package:calender_sample/view/add_edit_page.dart';
import 'package:calender_sample/view/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';


class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  final GoRouter _router = GoRouter(
    initialLocation: "/",
    routes: [
    GoRoute(
      path: "/",
      name: "home",
      builder: (context, state) {
        return MyHomePage();
      },
      ),
    GoRoute(
      path: "/other",
      name: "other",
      builder: (context, state) {
        return Add_Edit_Page();
      },
    )
  ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      
      routerDelegate: _router.routerDelegate,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.grey
      ),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      
      ],
      supportedLocales: [
        const Locale('ja'),
      ],
    );
    


  }

  

}