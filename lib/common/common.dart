import 'package:calender_sample/repository/repository.dart';
import 'package:calender_sample/service/todos.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final AllProvider = ChangeNotifierProvider.autoDispose(
  (ref){
    return AllRepository();
  }
);

final calendarDBProvider = StateProvider.autoDispose((ref){
  return CalenderDatabase();
});

class Common{

  DateTime pickerStartTime = DateTime.utc(2000,1,1);
  DateTime pickerEndTime = DateTime.utc(2050,12,31);

  String ymmm(DateTime dateTime){
    return DateFormat.yMMM("ja").format(dateTime);
  }

  String E(DateTime dateTime){
    return DateFormat.E("ja").format(dateTime);
  }

  String HM(DateTime dateTime){
    return DateFormat("HH:mm").format(dateTime);
  }

  String yMEd(DateTime dateTime){
    return DateFormat.yMEd("ja").format(dateTime);
  }

  String y_m_d(DateTime dateTime){
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String y_m_d_hm(DateTime dateTime){
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
