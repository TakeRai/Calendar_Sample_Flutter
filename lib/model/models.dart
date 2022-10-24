import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calender_sample/service/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AllModel{
  AllModel(
    this.selected,
    this.month,
    this.startTime,
    this.endTime,
    this.startTimeText,
    this.endTimeText,
    this.title,
    this.comment,
    this.switchBool,
    this.enableSave,
    this.isEdit,
    this.Id,
    this.beforeIndex,
    this.defaultTodo,
  );

  DateTime selected;
  DateTime month;
  DateTime startTime;
  DateTime endTime;
  String startTimeText;
  String endTimeText;
  TextEditingController title;
  TextEditingController comment;
  bool switchBool;
  bool enableSave;
  bool isEdit;
  int Id;
  num beforeIndex;
  Todo defaultTodo;
}


