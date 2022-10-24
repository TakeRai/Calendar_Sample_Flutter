import 'package:calender_sample/common/common.dart';
import 'package:calender_sample/main.dart';
import 'package:calender_sample/view/voids.dart' as v;
import 'package:calender_sample/view/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';


class Add_Edit_Page extends ConsumerWidget{

  @override
  Widget build(BuildContext context,WidgetRef ref){
    // final id = ref.watch(IdProvider);
    // final def = ref.watch(defaultProvider);
    final db = ref.watch(calendarDBProvider);

    final all = ref.watch(AllProvider);
    final startTime = all.all.startTime;
    final endTime = all.all.endTime;
    final startTimeText = all.all.startTimeText;
    final endTimeText = all.all.endTimeText;
    final title = all.all.title;
    final comment = all.all.comment;
    final switchBool = all.all.switchBool;
    final enableSave = all.all.enableSave;
    final isEdit = all.all.isEdit;
    final Id = all.all.Id;
    final def = all.all.defaultTodo;

    // if(enableSave){
    //   print("no");
    // }
    
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
              FocusScope.of(context).unfocus();
              await Future.delayed(Duration(milliseconds: 100));
              if(isEdit){
                await db.updateTodo(Id, title.text, comment.text, switchBool, startTime, endTime);
              }else{
                await db.addTodo(title.text, comment.text, switchBool, startTime, endTime);
              }
              
              all.AddEditReset();             
              GoRouter.of(context).push("/");
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
                      all.AddEditReset();
                     GoRouter.of(context).push("/");
                      
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
              initialValue: title.text,
              onChanged: (text){
                all.TitleChange(text);
                
              },
              
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
                         all.SwitchChange(value);
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
                                initialDateTime: startTime,

                                onDateTimeChanged: (newDate){
                                  all.StartDramDateTimeChange(newDate);

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
                                initialDateTime: endTime,

                                onDateTimeChanged: (newDate){
                                  all.EndDramDateTimeChange(newDate);
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
                initialValue: comment.text,
                // controller: comment,
                onChanged:(value) {
                  all.CommentChange(value);
                },
                
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
                                  all.AddEditReset();
                                  db.deleteTodo(Id);
                                  GoRouter.of(context).push("/");
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