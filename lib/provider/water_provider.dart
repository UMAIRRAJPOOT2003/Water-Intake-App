import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../model/water_model.dart';
import 'package:http/http.dart' as http;
class WaterData extends ChangeNotifier{
  List<WaterModel>waterDataList=[];

  Future<List<WaterModel>> getWater()async{
    final url=Uri.https('water-intaker-5b0d6-default-rtdb.firebaseio.com','water.json');
     final response=await http.get(url);
     if(response.statusCode==200 && response.body!='null'){
       final extractedData=json.decode(response.body) as Map<String,dynamic>;
       for(var element in extractedData.entries){//.entries will make extracted data iterable like list
         waterDataList.add(WaterModel(id:element.key,amount: element.value['amount'], dateTime: DateTime.parse(element.value['dateTime']), unit: element.value['unit']));

       }
     }
     notifyListeners();
     return waterDataList;
  }

  void addWater(WaterModel water) async{
    final url=Uri.https('water-intaker-5b0d6-default-rtdb.firebaseio.com','water.json');//this means water.json file will be inserted at this link of database
    var response=await http.post(url,headers: {//it is used to tell the server that these are the types that are expeceted to recieved
      'Content-Type':'application/json'//it means that server should expect json file to recieve
    },body: json.encode({
      'amount':double.parse(water.amount.toString()),
      'unit':'ml',
      'dateTime':DateTime.now().toString()
    })//the actual data that we want to save
    );
    if(response.statusCode==200){
      final extractedData=json.decode(response.body);
      waterDataList.add(WaterModel(
        id:extractedData['name'],//extractedData['name']is the name(ajeeb sa name of each entry jis ko expand krty hn firebase mien) of entry in firebase databse
          amount: water.amount,
          dateTime: DateTime.now(),
          unit: 'ml'));
    }
    else
      {
        print("ERROR IN LOADING WATER OBJECT: ${response.statusCode}");
      }
    notifyListeners();
  }
  void delete(WaterModel water){
    final url=Uri.https('water-intaker-5b0d6-default-rtdb.firebaseio.com','water/${water.id}.json');
    http.delete(url);//deleting element from firebase database

    //removing element form water data list
    waterDataList.removeWhere((element) => element.id==water.id);
    notifyListeners();


  }

String getWeekday(DateTime day){
    switch(day.weekday){
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return '';


    }
}
  DateTime getstartofweek(){
    DateTime?startofweek;
    //get the current date
    DateTime dateTime=DateTime.now();
    for(int i=0;i<7;i++){
      if(getWeekday(dateTime.subtract(Duration(days:i)))=='sunday'){// If the condition is true (i.e., the day is Sunday), this line assigns that date to startofweek.

        startofweek=dateTime.subtract(Duration(days:i));//assigns date to start of week variable
      }

    }
    return startofweek!;
  }

  String calculateWeeklyWaterIntake(WaterData value){
    double weeklyWaterIntake=0;
    //loop through water data list
    for(var water in value.waterDataList ){
      weeklyWaterIntake=weeklyWaterIntake+double.parse(water.amount.toString());

    }
    return weeklyWaterIntake.toStringAsFixed(2);
  }
  String convertDateTimeToString(DateTime dateTime){
    String year=dateTime.year.toString();
    String month=dateTime.month.toString();
    String day=dateTime.day.toString();
    if(month.length==1){
      month='0$month';//if month is less than 10 then append 0 with it in start

    }
    if(day.length==1){
      day='0$day';
    }
    return year+month+day;
  }

  //function to calculate daly water intake by adding all water mount that are entered on same date
Map<String,double> calculateDailyWaterSummary(){
    Map<String,double>dailyWaterSummary={};
    //loop through water data list
  for(var water in waterDataList){
    String date=convertDateTimeToString(water.dateTime);
    double amount = double.parse(water.amount.toString());
    if(dailyWaterSummary.containsKey(date)){//This checks if the dailyWaterSummary map already contains an entry for the current date. If it does, it means that some water data has already been recorded for that day.
      double currentamount=dailyWaterSummary[date]!;//If the amount is already entered for that date  in the map, retrieve the current total amount of water consumed on that date. The ! operator is used to assert that the value is non-null (since the key exists in the map).
      currentamount=currentamount+double.parse(amount.toString());
      dailyWaterSummary[date]=currentamount;
    }
    else{
      dailyWaterSummary.addAll({date:amount});

    }

  }
    return dailyWaterSummary;
  
}

}