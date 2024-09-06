import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterintakeapp/bars/bar_graph.dart';
import 'package:waterintakeapp/provider/water_provider.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startofweek;
  const WaterSummary({super.key,required this.startofweek});
  //function to calculate daily water summary in relation to other day water intake amounts.Also
  //this function will make the bar up if user add water intake amount in same day smaller than  total water intake on anyother day.if user add water intake and it reaches to  level greater than any other day   then  same day  bar will not go up and other days bar will go down due to  this formula: Bar height=(Daily Consumption/maxAmount)*Chart Height
  double calculateMaxAmount(WaterData waterData,String sunday,String monday,String tuesday,String wednesday,String thursday,String friday,String saturday){
    double maxAmount=100;
    List<double>values=[
      waterData.calculateDailyWaterSummary()[sunday]??0,
      waterData.calculateDailyWaterSummary()[monday]??0,
      waterData.calculateDailyWaterSummary()[tuesday]??0,
      waterData.calculateDailyWaterSummary()[wednesday]??0,
      waterData.calculateDailyWaterSummary()[thursday]??0,
      waterData.calculateDailyWaterSummary()[friday]??0,
      waterData.calculateDailyWaterSummary()[saturday]??0,

    ];
    //sort from smallest value to largest(ascending order)
    values.sort();
    //get largest value
    //increase the max amount by x% of the largest value
    maxAmount=values.last*1.3;//By increasing the largest daily consumption by 30% (maxAmount = values.last * 1.3), the function ensures there is some extra space above the highest recorded value. This is particularly useful in graphs or charts where you want to avoid the largest data point touching the top of the chart.
    return maxAmount==0?100:maxAmount;

  }

  @override
  Widget build(BuildContext context) {
    final value=Provider.of<WaterData>(context);
    String sunday=value.convertDateTimeToString(startofweek.add(Duration(days:0)));//this will add  0 days(date) in start of week which is still 0(sunday)
    String monday=value.convertDateTimeToString(startofweek.add(Duration(days:1)));//this will add 1day(date) in start of week which is monday
    String tuesday=value.convertDateTimeToString(startofweek.add(Duration(days:2)));//this will add 2 days(date) in start of week which is tuesday
    String wednesday=value.convertDateTimeToString(startofweek.add(Duration(days:3)));//this will add 3days(date) in start of week which is wednesday
    String thursday=value.convertDateTimeToString(startofweek.add(Duration(days:4)));//this will add 4days(date) n start of week which is thursday
    String friday=value.convertDateTimeToString(startofweek.add(Duration(days:5)));//this will add 5days(date) in start of week which is friday
    String saturday=value.convertDateTimeToString(startofweek.add(Duration(days:6)));//this will add 6days(date) in start of week which is saturday
    return Consumer<WaterData>(
      builder:(context,myvalue,child){//myvalue will consider as object of water model
        return SizedBox(height:300,
        child:BarGraph(
            maxY: calculateMaxAmount(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday),
            sunWaterAmt: value.calculateDailyWaterSummary()[sunday]??0,//[sunday] represent date of sunday that is a key in map that calculateDailyWaterSummary returns.value.calculateDailyWaterSummary() is a method that returns a map of water consumption data, with dates as keys and amounts as values.sunday is a variable that holds the string representation of the Sunday date that will fetch amount of sunday date (calculated earlier in the week).
            monWaterAmt: value.calculateDailyWaterSummary()[monday]??0,//jo monday wali date(key) h map mien uski jo bhi value(amount)hogi woh fetch krdyga map sy
            tueWaterAmt: value.calculateDailyWaterSummary()[tuesday]??0,
            wedWaterAmt: value.calculateDailyWaterSummary()[wednesday]??0,
            thurWaterAmt: value.calculateDailyWaterSummary()[thursday]??0,
            friWaterAmt: value.calculateDailyWaterSummary()[friday]??0,
            satWaterAmt: value.calculateDailyWaterSummary()[saturday]??0,
        ) ,
        );

      }
    );
  }
}
