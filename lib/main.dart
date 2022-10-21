import 'package:calender_sample/model/providers.dart';
import 'package:calender_sample/view/voids.dart' as v;
import 'package:calender_sample/service/todos.dart';
import 'package:calender_sample/view/myhomepage.dart';
import 'package:flutter/material.dart';
import "package:table_calendar/table_calendar.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:flutter/cupertino.dart';




void main() {
  
  runApp(
    ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.grey
      ),
      home: MyHomePage(),
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









