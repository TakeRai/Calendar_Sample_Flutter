import 'package:calender_sample/model/providers.dart';
import 'package:calender_sample/routing/routing.dart';
import 'package:calender_sample/service/todos.dart';
import 'package:calender_sample/view/add_edit_page.dart';
// import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';


Future ShowDram(BuildContext context,Widget child)async{
  showCupertinoModalPopup(context: context, builder: (BuildContext context2)=>
    Container(
      height: 216,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: child,
      ),
    )
  
  );
}

Future ShowSchedule(
  BuildContext context,
  int beforeIndex,
  WidgetRef ref,
  PageController controller,
  List<DateTime> list,
  AsyncSnapshot<List<Todo>> snapshot
  )
  async {
  showDialog(context: context, builder: (context){
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: PageView.builder(
      onPageChanged: (index){

        if(index > beforeIndex){
            ref.watch(selectedProvider.state).state = ref.watch(selectedProvider).add(Duration(days: 1));
            ref.watch(focusedProvider.state).state = ref.watch(selectedProvider).add(Duration(days: 1));
        }else{
            ref.watch(selectedProvider.state).state = ref.watch(selectedProvider).add(Duration(days: -1));
            ref.watch(focusedProvider.state).state = ref.watch(selectedProvider).add(Duration(days: -1));
        }
        
        beforeIndex = index;
      },
      controller: controller,
      
      itemCount: 101,
      
      itemBuilder:(context, index) {
        return Center(
          child: Column(
          mainAxisAlignment:MainAxisAlignment.end,
          children: [
            GestureDetector(onTap: (){

            },
            child: AlertDialog(
                
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      
                ),

                title : Container(
                  
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 222, 222, 222),
                            width: 1
                          )
                        )
                      ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                      children: [
                        
                        // Text(DateFormat.yMEd("ja").format(ref.watch(selectedProvider.state).state)),
                        Text(DateFormat.yMEd("ja").format(list[index])),

                        TextButton(
                          onPressed: (){
                            //以下は追加の時のみ
                            var amari = DateTime.now().minute % 15;
                            var minute = DateTime.now().minute - amari;
                            
                            
                            DateTime dateTime = DateTime(ref.watch(selectedProvider.state).state.year,ref.watch(selectedProvider.state).state.month,ref.watch(selectedProvider.state).state.day,DateTime.now().hour,minute);
                            ref.watch(startTimeProvider.state).state = dateTime;
                            ref.watch(startTimeTextProvider.state).state = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                            ref.watch(endTimeProvider.state).state = dateTime;
                            ref.watch(endTimeTextProvider.state).state = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                            
                            
                            ref.watch(isEditProvider.state).state = false;
                            ref.watch(switchBoolProvider.state).state = false;

                            GoAddEdit(context);
                          }, 
                          child: Text("+",style: TextStyle(fontSize: 30),))
                      ],
                    )),

                    content: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width ,
                  child: ((){
                    List list_here =  [];
                    var selectdate = list[index];

                    int selectNum = selectdate.year * 10000 + selectdate.month * 100 + selectdate.day;

                    for(var i=0; i< snapshot.data!.length; i++){
                      var startDate = snapshot.data![i].startTime;
                      var endDate = snapshot.data![i].endTime;

                      int startNum = startDate.year * 10000 + startDate.month * 100 + startDate.day;
                      int endNum = endDate.year * 10000 + endDate.month * 100 + endDate.day;

                      if(startNum <= selectNum && selectNum <= endNum){
                        list_here.add(snapshot.data![i]);
                      }
                    }
                    
                    if(list_here.length == 0){
                      return Center(child: Text("予定がありません。"),);
                    }
                    

                    return ListView.builder(
                      itemCount: list_here.length,
                      itemBuilder: (context,index){
                          
                          return Container(
                            padding: EdgeInsets.all(5),
                            height: 60,
                            decoration: BoxDecoration(
                                    border: const Border(
                                      bottom: const BorderSide(
                                        color: Color.fromARGB(255, 232, 232, 232),
                                        width: 1
                                      )
                                    )
                                  ),

                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 10,left: 10),
                                  width: 60,
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    border: const Border(
                                      right: const BorderSide(
                                        color: Colors.blue,
                                        width: 4
                                      )
                                    )
                                  ),
                                  child: ((){
                                    if(list_here[index].isAllday == true){
                                      return Center(child:Text("終日",style: TextStyle(fontSize: 12),));
                                    }

                                    return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(DateFormat("HH:mm").format(list_here[index].startTime),style: TextStyle(fontSize: 12),),
                                      Text(DateFormat("HH:mm").format(list_here[index].endTime),style: TextStyle(fontSize: 12),),

                                    ],
                                  );
                                  })(),
                                ),
                                Container(
                                  // width: 196,
                                  padding: EdgeInsets.only(left: 10),
                                  // child: Text(list_here[index].title),
                                  child: TextButton(
                                    
                                    child: Container(
                                      width: 160,
                                      child: Text(
                                        list_here[index].title,
                                        // "ああああああああああああ",
                                        style: TextStyle(fontSize: 18,color: Colors.black),
                                        
                                        // textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        ),
                                    ),

                                    onPressed: (){
                                      ref.watch(isEditProvider.state).state = true;
                                      ref.watch(IdProvider.state).state = list_here[index].id;
                                      ref.watch(titleProvider.state).state.text = list_here[index].title;
                                      ref.watch(commentProvider.state).state.text = list_here[index].comment;
                                      ref.watch(startTimeProvider.state).state = list_here[index].startTime;
                                      ref.watch(endTimeProvider.state).state = list_here[index].endTime;
                                      ref.watch(switchBoolProvider.state).state = list_here[index].isAllday;

                                      ref.watch(defaultProvider.state).state = list_here[index];

                                      ref.watch(enableSaveProvider.state).state = false;

                                      GoAddEdit(context);
                                    },
                                  )
                                ),

                                
                                  
                              ],
                            ),
                          );
                      },
                    );


                  })(),
                  
                  
                ),


              ),
            )
            
            
            
          ],
        ),
        );
      },
      
    ),
    );
    
  });
}