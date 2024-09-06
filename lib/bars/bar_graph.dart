import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waterintakeapp/bars/bar_data.dart';

class BarGraph extends StatefulWidget {
  final double maxY;
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thurWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  const BarGraph({
    super.key,
    required this.maxY,
    required this.sunWaterAmt,
    required this.monWaterAmt,
    required this.tueWaterAmt,
    required this.wedWaterAmt,
    required this.thurWaterAmt,
    required this.friWaterAmt,
    required this.satWaterAmt,
  });

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {


  @override
  Widget build(BuildContext context) {
    // Initialize bar data using widget properties
    BarData barData = BarData(
      sunWaterAmt: widget.sunWaterAmt, // Access through widget
      monWaterAmt: widget.monWaterAmt, // Access through widget
      tueWaterAmt: widget.tueWaterAmt, // Access through widget
      wedWaterAmt: widget.wedWaterAmt, // Access through widget
      thurWaterAmt: widget.thurWaterAmt, // Access through widget
      friWaterAmt: widget.friWaterAmt, // Access through widget
      satWaterAmt: widget.satWaterAmt, // Access through widget
    );
    barData.inintBarData();

    return Padding(
      padding:EdgeInsets.all(8.0),
      child: BarChart(BarChartData(
        maxY: widget.maxY,
        minY: 0,
        gridData: FlGridData(show:false),
        borderData: FlBorderData(show:false),//to remove borders of bar graph
        titlesData: FlTitlesData(
          show:true,
          topTitles: AxisTitles(sideTitles:SideTitles(showTitles:false)),//to remove numeric values on top of bargraph
          leftTitles:AxisTitles(sideTitles: SideTitles(showTitles: false)),//to remove numeric values onn left side of bar graph
          rightTitles:AxisTitles(sideTitles:SideTitles(showTitles:false)),//to remove numeric values on right side if bar graph
          bottomTitles:AxisTitles(sideTitles:SideTitles(showTitles:true,
          getTitlesWidget: getBottomTitlesWidget)),

        ),
        //This code is used to map a list of data points (stored in barData.barData) to a list of BarChartGroupData objects, which are then passed to a bar chart widget to define how the bars are grouped and displayed.
        barGroups: barData.barData//it is used to map bar data on bar chart.barData.barData refers to a property within the BarData class that contains a list of data points to be displayed in the bar chart. Each item in this list is expected to represent one data point or bar.
        .map((data)=>BarChartGroupData(x: data.x,
        barRods: [
          BarChartRodData(toY: data.y,width:23,borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight:Radius.circular(10)),
          backDrawRodData: BackgroundBarChartRodData(//To make a remaining empty road decorated and visible
            show:true,
            toY: widget.maxY,
            color:Colors.grey[350],
          ))
        ]),).toList(),//=> BarChartGroupData(x: data.x) is an anonymous function (also known as a lambda or arrow function) that converts each data object into a BarChartGroupData object. The property x of BarChartGroupData is set to data.x.


      )),
    );
  }

  Widget getBottomTitlesWidget(double value, TitleMeta meta) {//value: A double value, likely corresponding to the position on the x-axis of the chart.
    TextStyle mystyle=TextStyle(
      color:Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;//This declares a Widget variable named text that will hold the specific text label corresponding to the value.
    switch(value.toInt()){
      case 0:
        text=Text(
          'S',
          style:mystyle,
        );
        break;
      case 1:
        text=Text(
          'M',
          style:mystyle,
        );
        break;

      case 2:
        text=Text(
          'T',
          style:mystyle,
        );
        break;
      case 3:
        text=Text(
          'W',
          style:mystyle,
        );
        break;
      case 4:
        text=Text(
          'T',
          style:mystyle,
        );
        break;
      case 5:
        text=Text(
          'F',
          style:mystyle,
        );
        break;
      case 6:
        text=Text(
          'S',
          style:mystyle,
        );
        break;
      default:
        text=Text('');
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide,space:3);
  }
}
