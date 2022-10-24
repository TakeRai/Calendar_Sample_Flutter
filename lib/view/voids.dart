import 'package:calender_sample/common/common.dart';
import 'package:calender_sample/main.dart';
import 'package:calender_sample/service/todos.dart';
import 'package:calender_sample/view/add_edit_page.dart';
// import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  WidgetRef ref,
  PageController controller,
  List<DateTime> list,
  AsyncSnapshot<List<Todo>> snapshot
  )
  async {
  showDialog(context: context, builder: (context){
    final all = ref.watch(AllProvider);
    final selected = all.all.selected;
    final beforeIndex = all.all.beforeIndex;

    return GestureDetector(
      onTap: ()async{
        
          Navigator.pop(context);
      },
      child: PageView.builder(
      onPageChanged: (index){
        all.PageChange(index);
        
      },
      
      controller: controller,
      
      itemCount: 100,
      
      itemBuilder:(context, index) {
        return FractionallySizedBox(
          widthFactor: 1/controller.viewportFraction,
          child: Column(
          mainAxisAlignment:MainAxisAlignment.end,
          children: [
            GestureDetector(onTap: (){},
            child: AlertDialog(
                
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      
                ),
                title: Container(
                  
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
                        
                        Text(Common().yMEd(list[index])),

                        TextButton(
                          onPressed: (){
                            //以下は追加の時
                            all.GoAdd();

                            GoRouter.of(context).push("/other");
                          }, 
                          child: Text("+",style: TextStyle(fontSize: 30),))
                      ],
                    ),
                ),

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
                                      Text(Common().HM(list_here[index].startTime),style: TextStyle(fontSize: 12),),
                                      Text(Common().HM(list_here[index].endTime),style: TextStyle(fontSize: 12),),

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
                                        style: TextStyle(fontSize: 18,color: Colors.black),
                                        
                                        overflow: TextOverflow.ellipsis,
                                        ),
                                    ),

                                    onPressed: (){
                                      all.GoEdit(list_here[index]);

                                      context.push("/other");
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
        return Column(
          mainAxisAlignment:MainAxisAlignment.end,
          children: [
            GestureDetector(onTap: (){},
            child: AlertDialog(
                
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      
                ),
                title: Container(
                  
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
                        
                        Text(Common().yMEd(list[index])),

                        TextButton(
                          onPressed: (){
                            //以下は追加の時
                            all.GoAdd();

                            GoRouter.of(context).push("/other");
                          }, 
                          child: Text("+",style: TextStyle(fontSize: 30),))
                      ],
                    ),
                ),

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
                                      Text(Common().HM(list_here[index].startTime),style: TextStyle(fontSize: 12),),
                                      Text(Common().HM(list_here[index].endTime),style: TextStyle(fontSize: 12),),

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
                                        style: TextStyle(fontSize: 18,color: Colors.black),
                                        
                                        overflow: TextOverflow.ellipsis,
                                        ),
                                    ),

                                    onPressed: (){
                                      all.GoEdit(list_here[index]);

                                      context.push("/other");
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
        
        );
        
      },
      
    ),
    );
    
  });
}