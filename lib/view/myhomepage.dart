import 'package:calender_sample/common/common.dart';
import 'package:calender_sample/main.dart';
import 'package:calender_sample/service/todos.dart';
import 'package:calender_sample/view/voids.dart';
import 'package:calender_sample/view/add_edit_page.dart';
import 'package:flutter/material.dart';
import "package:table_calendar/table_calendar.dart";
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';



class MyHomePage extends ConsumerWidget {


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final all = ref.watch(AllProvider);
    final selected = all.all.selected;
    final db = ref.watch(calendarDBProvider);
    print(selected);

    return Scaffold(
      appBar: AppBar(
        title: Text("カレンダー"),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: db.watchEntries(),
        builder: (context, AsyncSnapshot<List<Todo>> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          return TableCalendar<dynamic>(
          
          firstDay: Common().pickerStartTime,
          lastDay: Common().pickerEndTime,
          focusedDay: selected,
          startingDayOfWeek : StartingDayOfWeek.monday,
          daysOfWeekHeight: 40,
          rowHeight: 75,
          locale: 'ja_JP',
          
          eventLoader: (day) {
            List here = [];
            int dayNum = day.year * 10000 + day.month * 100 + day.day;

            for(var i =0; i<  snapshot.data!.length; i++){
              var startDate = snapshot.data![i].startTime;
              var endDate =  snapshot.data![i].endTime;
              int startNum = startDate.year * 10000 + startDate.month * 100 + startDate.day;
              int endNum = endDate.year * 10000 + endDate.month * 100 + endDate.day;
              
              if(startNum <= dayNum && dayNum <= endNum){
                here.add(snapshot.data![i].title);
              }
            }

            return here;
            

          },
          
          selectedDayPredicate: (day) {
              return isSameDay(selected, day);
            },
          onDaySelected: (selectedDay, focusedDay) async {
            all.SelectFocusChange(selectedDay);
            all.DaySelecte(selectedDay, context, ref, snapshot);
            
          },

          calendarStyle: CalendarStyle(
            selectedDecoration:BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              
            )
          ),

          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible : false,
            leftChevronVisible : false,
            rightChevronVisible: false,
            
          ),

          calendarBuilders: CalendarBuilders(
            
            defaultBuilder: (
                BuildContext context, DateTime day, DateTime focusedDay) {
                  
                  return Center(
                    
                    child: Text( day.day.toString(),
                      style: TextStyle(
                        color: ((){
                          if(day.weekday == DateTime.sunday){
                            return Colors.red;
                          }

                          if(day.weekday == DateTime.saturday){
                            return Colors.blue;
                          }

                          return Colors.black;
                        })(),
                        
                      ),)
                  );
            },
            dowBuilder:(context, day) {
              return Container(
                height: 100,
                padding: EdgeInsets.only(bottom: 0),
                color: Color.fromARGB(255, 217, 217, 217),
                child: ((){

                if (day.weekday == DateTime.sunday) {
                  return Center(
                    child: Text(
                    Common().E(day),
                    style: const TextStyle(color: Colors.red,fontSize: 12),
                  ),
                  );
                }

              if (day.weekday == DateTime.saturday) {
                  return Center(
                    child: Text(
                    Common().E(day),
                    style: const TextStyle(color: Colors.blue,fontSize: 12),
                  ),
                  );
                }


              return Center(
                    child: Text(
                    Common().E(day),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  );

                  
                })(),
              );

            },
            headerTitleBuilder: (context, day) {
              // final texta = Common().ymmm(day);

              return Container(
                height:50,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(-1.0,0),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            child: Text("今日",style: TextStyle(color: Colors.black),),
                            onPressed: (){
                              all.SelectFocusChange(DateTime.now());
                            },
                            
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                              side: BorderSide(
                                color: Color.fromARGB(255, 229, 229, 229),
                                width: 1
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              )
                              
                            ),
                          ),
                        ),
                        
                      ),
                    

                    Align(
                      alignment: Alignment(0,0),
                      child: Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Common().ymmm(day),style: TextStyle(fontSize: 20),),
                            GestureDetector(
                              onTap: (){
                                showMonthPicker(
                                  context: context, 
                                  firstDate: Common().pickerStartTime,
                                  lastDate: Common().pickerEndTime,
                                  initialDate:selected,customHeight: 250).
                                then((date) {
                                  if(date != null){
                                    int theday = selected.day;
                                    all.SelectFocusChange(DateTime(date.year,date.month,theday));
                                    
                                  }

                                });
                              },
                              child: Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      )
                    ),

                  ],
                )
              );
            },

            markerBuilder: (BuildContext context, date, events) {
              if (events.isEmpty) return SizedBox();

              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 60),
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        width: 7,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black),
                      ),
                    );
                  });
            },

            
          ),


          


        );
        },
      ),
    );
    

    
  }
}