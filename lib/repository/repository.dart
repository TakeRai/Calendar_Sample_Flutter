import 'package:calender_sample/common/common.dart';
import 'package:calender_sample/model/models.dart';
import 'package:calender_sample/service/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:calender_sample/view/voids.dart';

class AllRepository extends ChangeNotifier{
  AllModel all = AllModel(
    DateTime.now(), 
    DateTime.now(), 
    DateTime.now(), 
    DateTime.now(), 
    "", 
    "", 
    TextEditingController(text: ""), 
    TextEditingController(text: ""),
    false, 
    false, 
    true, 
    -1,
    49.5,
    Todo(id: -1, title: "", comment: "", isAllday: false, startTime: DateTime.now(), endTime: DateTime.now()),
    );

  void SelectFocusChange(DateTime dateTime){
    all.selected = dateTime;
    notifyListeners();
  }

  void MonthChange(DateTime dateTime){
    all.month = dateTime;
    notifyListeners();
  }

  void StartTimeChange(DateTime dateTime){
    all.startTime = dateTime;
    notifyListeners();
  }

  void EndTimeChange(DateTime dateTime){
    all.endTime = dateTime;
    notifyListeners();
  }
  
  void CommentChange(String text){
    all.comment.text = text;

    if(all.isEdit){
      if(all.title.text !="" && text != "" ){
        if(text != all.defaultTodo.comment){
          all.enableSave = true;
        }
      }else{
        all.enableSave = false;
      }

    }else{
      if(all.title.text !="" && text != "" ){
        all.enableSave = true;
      }else{
        all.enableSave = false;
      }
    }
    notifyListeners();
  }

  void TitleChange(String text){
    all.title.text = text;

    if(all.isEdit){
      if(all.comment.text !="" && text != "" ){
        if(text != all.defaultTodo.title){
          all.enableSave = true;
        }
      }else{
        all.enableSave = false;
      }

    }else{
      if(all.comment.text !="" && text != "" ){
        all.enableSave = true;
      }else{
        all.enableSave = false;
      }
    }

    notifyListeners();
  }

  void AddEditReset(){
    all.title.text = "";
    all.comment.text = "";
    notifyListeners();
  }

  void SwitchChange(bool value){
    all.switchBool = value;

    if(value){
      all.startTimeText = Common().y_m_d(all.startTime);
      all.endTimeText = Common().y_m_d(all.endTime);
    }else{
      all.startTimeText = Common().y_m_d_hm(all.startTime);
      all.endTimeText = Common().y_m_d_hm(all.endTime);

    }

    if(all.isEdit){
      all.enableSave = true;
    }

    notifyListeners();
  }

  void EnableSaveChange(bool value){
    all.enableSave = value;
    // notifyListeners();
  }

  void IsEditChange(bool value){
    all.isEdit = value;
    notifyListeners();
  }

  void GoAdd(){
    var amari = DateTime.now().minute % 15;
    var minute = DateTime.now().minute - amari;
    DateTime dateTime = DateTime(all.selected.year,all.selected.month,all.selected.day,DateTime.now().hour,minute);
    all.startTime = dateTime;
    all.startTimeText = Common().y_m_d_hm(dateTime);
    all.endTime = dateTime;
    all.endTimeText = Common().y_m_d_hm(dateTime);
    
    all.isEdit = false;
    print("after?");
    all.enableSave = false;
    all.switchBool = false;
    notifyListeners();
    
  }

  void GoEdit(Todo todo){
    all.isEdit = true;
    all.Id = todo.id;
    all.title.text = todo.title;
    all.comment.text = todo.comment;
    all.startTime = todo.startTime;
    all.endTime = todo.endTime;
    all.switchBool = todo.isAllday;

    all.defaultTodo = todo;
    all.enableSave = false;

    if(!all.switchBool){
      all.startTimeText = Common().y_m_d_hm(todo.startTime);
      all.startTimeText = Common().y_m_d_hm(todo.endTime);
    }else{
      all.startTimeText = Common().y_m_d(todo.startTime);
      all.startTimeText = Common().y_m_d(todo.endTime);

    }

    notifyListeners();
  }

  void StartDramDateTimeChange(DateTime newDate){
    if(!all.switchBool){
      all.startTime = newDate;
      all.startTimeText = Common().y_m_d_hm(newDate);

    }else{
      DateTime addDate = DateTime(newDate.year,newDate.month,newDate.day,all.startTime.hour,all.startTime.minute);
      all.startTime = addDate;
      // all.startTimeText = DateFormat('yyyy-MM-dd').format(addDate);
      all.startTimeText = Common().y_m_d(addDate);
    }

    if(newDate.isAfter(all.endTime)){
      DateTime updateDate = DateTime(newDate.year,newDate.month,newDate.day,newDate.hour + 1 ,newDate.minute);
      if(!all.switchBool){
      all.endTime = updateDate;
      // all.endTimeText = DateFormat('yyyy-MM-dd HH:mm').format(updateDate);
      all.startTimeText = Common().y_m_d_hm(updateDate);

      }else{
        DateTime addDate = DateTime(newDate.year,newDate.month,newDate.day,all.endTime.hour,all.endTime.minute);
        all.endTime = addDate;
        // all.endTimeText = DateFormat('yyyy-MM-dd').format(addDate);
        all.startTimeText = Common().y_m_d(addDate);


      }
    }

    if(all.isEdit && all.defaultTodo.startTime != newDate){
      all.enableSave = true;
    }
    
    notifyListeners();
  }

  void EndDramDateTimeChange(DateTime newDate){
      if(!all.switchBool){
        all.endTime = newDate;
        // all.endTimeText = DateFormat('yyyy-MM-dd HH:mm').format(newDate);
        all.endTimeText = Common().y_m_d_hm(newDate);

      }else{
        DateTime addDate = DateTime(newDate.year,newDate.month,newDate.day,all.endTime.hour,all.endTime.minute);
        all.endTime = addDate;
        // all.endTimeText = DateFormat('yyyy-MM-dd').format(addDate);
        all.endTimeText = Common().y_m_d(addDate);
      }

      if(all.isEdit && all.defaultTodo.endTime != newDate){
        all.enableSave = true;
      }

      notifyListeners();
  }

  void IdChange(int Id){
    all.Id = Id;
    notifyListeners();
  }

  void DefaultTodoChange(Todo todo){
    all.defaultTodo = todo;
    notifyListeners();
  }

  void DaySelecte(DateTime selectedDay,BuildContext context,WidgetRef ref,AsyncSnapshot<List<Todo>> snapshot){
    List<DateTime> list = [];
    int diffCount1 = selectedDay.difference(Common().pickerStartTime).inDays;
    int diffCount2 = selectedDay.difference(Common().pickerEndTime).inDays;
    int here;
    if(diffCount1 < 100){
      here = diffCount1;
      for(var i=-here; i<100-here; i++){
      list.add(selectedDay.add(Duration(days: i)));
      }

    }else if(-100 < diffCount2){

      here = diffCount2 + 99;
      for(var i=-here; i<100-here; i++){
      list.add(selectedDay.add(Duration(days: i)));
      }
    }else{
      here = 50;
      for(var i=-50; i<50; i++){
      list.add(selectedDay.add(Duration(days: i)));
      }
    }

    final PageController controller = PageController(initialPage: here,viewportFraction: 0.85);
    
    all.beforeIndex = here;
    

    ShowSchedule(context,ref, controller, list, snapshot);

    notifyListeners();

  }

  void beforeIndexChange(int index){
    all.beforeIndex = index;
    notifyListeners();
  }

  void PageChange(int index){
    if(index > all.beforeIndex){
      all.selected = all.selected.add(Duration(days: 1));
    }else{
        all.selected = all.selected.add(Duration(days: -1));
    }


        
    all.beforeIndex = index;

    notifyListeners();
  }

  // void popBoolChange(bool bool){
  //   all.popBool = bool;
  //   notifyListeners();
  // }
}

