import 'package:calender_sample/service/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';


final  focusedProvider = StateProvider.autoDispose((ref){
  return DateTime.now();
});

final  selectedProvider = StateProvider.autoDispose((ref){
  return DateTime.now() ;
});

final monthProvider = StateProvider.autoDispose((ref){
  return DateTime.now() ;
});

final startTimeProvider = StateProvider.autoDispose((ref){
  return DateTime.now() ;
});

final endTimeProvider = StateProvider.autoDispose((ref){
  return DateTime.now() ;
});

final startTimeTextProvider = StateProvider.autoDispose((ref){
  return "";
});

final endTimeTextProvider = StateProvider.autoDispose((ref){
  return "";
});

final titleProvider = StateProvider.autoDispose((ref){
  return TextEditingController(text: "");
});

final commentProvider = StateProvider.autoDispose((ref){
  return TextEditingController(text: "");
});

final switchBoolProvider = StateProvider.autoDispose((ref){
  return false;
});

final enableSaveProvider = StateProvider.autoDispose((ref){
  return false;
});

final isEditProvider = StateProvider.autoDispose((ref){
  return true;
});

final IdProvider = StateProvider.autoDispose((ref){
  return -1;
});



final calendarDBProvider = StateProvider.autoDispose((ref){
  return CalenderDatabase();
});

final  defaultProvider = StateProvider.autoDispose((ref){
  return Todo(id:0, title: "", comment: "", isAllday: false, startTime: DateTime.now(), endTime: DateTime.now());
});

// List sumDayList = [];

