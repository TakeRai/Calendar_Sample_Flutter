import 'package:calender_sample/main.dart';
import 'package:calender_sample/model/providers.dart';
import 'package:calender_sample/view/voids.dart' as v;
import 'package:calender_sample/routing/routing.dart';
import 'package:calender_sample/view/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';


class Add_Edit_Page extends ConsumerWidget{

  @override
  Widget build(BuildContext context,WidgetRef ref){
    final switchBool = ref.watch(switchBoolProvider);
    final selected = ref.watch(selectedProvider);
    final startTimeText = ref.watch(startTimeTextProvider);
    final startTime = ref.watch(startTimeProvider);
    final endTimeText = ref.watch(endTimeTextProvider);
    final endTime = ref.watch(endTimeProvider);
    final title = ref.watch(titleProvider);
    final comment = ref.watch(commentProvider);
    final enableSave = ref.watch(enableSaveProvider);
    final isEdit = ref.watch(isEditProvider);
    final id = ref.watch(IdProvider);
    final def = ref.watch(defaultProvider);
    final db = ref.watch(calendarDBProvider);




    if(!switchBool){
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.watch(startTimeTextProvider.state).state = DateFormat('yyyy-MM-dd HH:mm').format(startTime));
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.watch(endTimeTextProvider.state).state = DateFormat('yyyy-MM-dd HH:mm').format(endTime));
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.watch(startTimeTextProvider.state).state = DateFormat('yyyy-MM-dd').format(startTime));
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.watch(endTimeTextProvider.state).state = DateFormat('yyyy-MM-dd').format(endTime));

    }

    // if(!isEdit){
    if(comment.text != "" && title.text != ""){
      if(isEdit){
        if(comment.text != def.comment || title.text != def.title || switchBool != def.isAllday || startTime != def.startTime || endTime != def.endTime){
          

          WidgetsBinding.instance.addPostFrameCallback((_) => ref.watch(enableSaveProvider.state).state = true);
          
        }
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) => ref.watch(enableSaveProvider.state).state = true);
      }
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.watch(enableSaveProvider.state).state = false);    
    }
    String title_bar = isEdit ? "予定の編集" : "予定の追加";
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 243, 239, 239),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          
          Container(
            padding: EdgeInsets.all(8),
            
            child: TextButton(
            onPressed: !enableSave ? null : ()async{
              // await db.addTodo(title.text, comment.text, switchBool, startTime, endTime);
              FocusScope.of(context).unfocus();
              await Future.delayed(Duration(milliseconds: 100));
              if(isEdit){
                await db.updateTodo(id, title.text, comment.text, switchBool, startTime, endTime);
              }else{
                await db.addTodo(title.text, comment.text, switchBool, startTime, endTime);
              }

              
              
              ref.watch(commentProvider.state).state.text = "";
              ref.watch(titleProvider.state).state.text = "";
              GoMyApp(context);
            }, 
            
            child: Text(
              "保存",
              style: TextStyle(color: enableSave ? Colors.black : Colors.black.withOpacity(0.3)),
              ),
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 239, 239, 239),
              padding: EdgeInsets.all(0),
            ),
            
            ),
          )
          
        ],
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            showCupertinoModalPopup(context: context, builder: (BuildContext context){
              return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    onPressed: (){
                      ref.watch(titleProvider.state).state = TextEditingController(text: "");
                      ref.watch(commentProvider.state).state = TextEditingController(text: "");

                     GoMyApp(context);
                      
                    }, 
                    child: Text("編集を破棄")
                    )
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: (){
                    Navigator.pop(context,"キャンセル");
                  },
                  isDefaultAction: true, 
                  child: Text("キャンセル")
                  ),
              );
            });
          },
          ),
        title: Text(title_bar),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          reverse: true,
          child:Padding(
            padding: EdgeInsets.only(bottom: bottomSpace),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){primaryFocus?.unfocus();},
              child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,width: 2)
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "タイトルを入力してください",
                border: InputBorder.none,
                
                ),
              autofocus: true,
              controller: title,
              
            ),
            
            
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 20,right: 20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("終日"),
                        Switch(value: switchBool, onChanged: (value){
                         ref.watch(switchBoolProvider.state).state = value;
                        })
                      ],
                    ),
                  ),
                  SizedBox(height: 3,),

                  Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 20,right: 20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("開始"),
                        TextButton(
                          onPressed: (){
                            
                            v.ShowDram(
                              context, 
                              CupertinoDatePicker(
                                mode: switchBool ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                minuteInterval: 15,
                                use24hFormat: true,
                                // initialDateTime: DateTime(selected.year, selected.month, selected.day, DateTime.now().hour, (DateTime.now().minute % 15 * 15).toInt()),
                                initialDateTime: startTime,

                                onDateTimeChanged: (newDate){
                                  // print(DateTime.now().hour);
                                  

                                  if(!switchBool){
                                    ref.watch(startTimeProvider.state).state = newDate;
                                    ref.watch(startTimeTextProvider.state).state = DateFormat('yyyy-MM-dd HH:mm').format(newDate);

                                  }else{
                                    DateTime addDate = DateTime(newDate.year,newDate.month,newDate.day,startTime.hour,startTime.minute);
                                    ref.watch(startTimeProvider.state).state = addDate;
                                    ref.watch(startTimeTextProvider.state).state = DateFormat('yyyy-MM-dd').format(addDate);

                                  }

                                  if(newDate.isAfter(endTime)){
                                    DateTime updateDate = DateTime(newDate.year,newDate.month,newDate.day,newDate.hour + 1 ,newDate.minute);
                                    if(!switchBool){
                                    ref.watch(endTimeProvider.state).state = updateDate;
                                    ref.watch(endTimeTextProvider.state).state = DateFormat('yyyy-MM-dd HH:mm').format(updateDate);

                                    }else{
                                      DateTime addDate = DateTime(newDate.year,newDate.month,newDate.day,endTime.hour,endTime.minute);
                                      ref.watch(endTimeProvider.state).state = addDate;
                                      ref.watch(endTimeTextProvider.state).state = DateFormat('yyyy-MM-dd').format(addDate);

                                    }
                                  }

                                },


                              )
                              );
                            
                          }, 
                          child: Text(startTimeText,style: TextStyle(color: Colors.black),)
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 3,),

                  Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 20,right: 20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("終了"),
                        TextButton(
                          onPressed: (){
                             v.ShowDram(
                              context, 
                              CupertinoDatePicker(
                                mode: switchBool ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                minuteInterval: 15,
                                use24hFormat: true,
                              //  initialDateTime: DateTime(selected.year, selected.month, selected.day, DateTime.now().hour, (DateTime.now().minute % 15 * 15).toInt()),
                                initialDateTime: endTime,

                                onDateTimeChanged: (newDate){
                                  

                                   if(!switchBool){
                                    ref.watch(endTimeProvider.state).state = newDate;
                                    ref.watch(endTimeTextProvider.state).state = DateFormat('yyyy-MM-dd HH:mm').format(newDate);

                                  }else{
                                    DateTime addDate = DateTime(newDate.year,newDate.month,newDate.day,endTime.hour,endTime.minute);
                                    ref.watch(endTimeProvider.state).state = addDate;
                                    ref.watch(endTimeTextProvider.state).state = DateFormat('yyyy-MM-dd').format(addDate);

                                  }

                                  

                                },


                              )
                              );
                            
                          }, 
                          child: Text(endTimeText,style: TextStyle(color: Colors.black),)
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 3,),


                ],
              ),
            ),
            
            SizedBox(height: 10,),
            
            TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue,width: 2)
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "コメントを入力してください",
                  border: InputBorder.none,
                  
                  
                  ),
                autofocus: true,
                maxLines: 7,
                controller: comment,
                
              ),
            

            SizedBox(height: 30,),

            ((){
              if(isEdit){
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: TextButton(
                      onPressed: (){
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: const Text('予定の削除'),
                            content: const Text('本当にこの日の予定を削除しますか'),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('キャンセル',style: TextStyle(color: Colors.blue ,fontWeight:FontWeight.normal),),
                              ),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                onPressed: () {
                                  ref.watch(titleProvider.state).state = TextEditingController(text: "");
                                  ref.watch(commentProvider.state).state = TextEditingController(text: "");
                                  db.deleteTodo(id);

                                  GoMyApp(context);
                                },
                                child: const Text('削除',style: TextStyle(color: Colors.blue),),
                              )
                            ],
                          ),
                        );
                      }, 
                      child: Text("この予定を削除",style: TextStyle(color: Colors.red),)),
                  ),
                );
              }

              return SizedBox();
            })()
          ],
        ),
            )
          
          )

        )
      ),
    );
  }
}