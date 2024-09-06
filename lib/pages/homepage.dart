import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:waterintakeapp/components/water_intake_summary.dart';
import 'package:waterintakeapp/model/water_model.dart';
import 'package:waterintakeapp/pages/about_screen.dart';
import 'package:waterintakeapp/pages/settings_screen.dart';

import '../provider/water_provider.dart';
class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
 
  bool _isLoading=true;
  final amountController = TextEditingController();
  
  //function to first load data in waterdatalist by calling getwater function beacuse waterdatalist will recieve data inside getwater function otherwise waterdatalist will be empty  when first stateful widget tree is created
  void initState(){
_loadData();
  super.initState();
  }
  void _loadData()async{
   await Provider.of<WaterData>(context,listen:false).getWater().then((waters)=>{
     if(waters.isNotEmpty){
       setState((){
         _isLoading=false;
       })
     }
     else{
       setState((){
         _isLoading=true;
       })
     }
    });
}


  // void saveWater(String amount) async{
  //   final url=Uri.https('water-intaker-5b0d6-default-rtdb.firebaseio.com','water.json');//this means water.json file will be inserted at this link of database
  //   var response=await http.post(url,headers: {//it is used to tell the server that these are the types that are expeceted to recieved
  //     'Content-Type':'application/json'//it means that server should expect json file to recieve
  //   },body: json.encode({
  //     'amount':double.parse(amount),
  //     'unit':'ml',
  //     'dateTime':DateTime.now().toString()
  //   })//the actual data that we want to save
  //   );
  //   if(response.statusCode==200)
  //     {
  //       print('Data saved');
  //     }
  //   else
  //     {
  //       print('Data not saved');
  //     }
  // }

  void addWater(WaterData value){
    showDialog(context: context, builder: (context)=>
    AlertDialog(
      backgroundColor: Colors.lightBlue[50],
    title: Text("Add Water"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children:<Widget>[
          Text("ADD WATER TO YOUR DAILY INTAKE"),
          SizedBox(height:10),
          TextField(
              controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal:true),
            decoration:InputDecoration(

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width:2.0,color:Colors.blue)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width:2.0,color: Colors.green)
              ),


              prefixIcon: Icon(Icons.water_drop,color: Colors.blue,),
              labelText: 'Amount'
            )
          )

        ]
      ),
      actions:<Widget>[
        TextButton(onPressed: (){
      value.addWater(WaterModel (amount:double.parse(amountController.text.toString()), dateTime: DateTime.now(), unit:'ml'));
      clear();
      
        },
          child:Text("Save"),
        ),
        TextButton(onPressed: (){
Navigator.pop(context);
        },
          child:Text("Cancel"),
        ),

      ]
    )
    );
  }
  void clear(){
    amountController.clear();
  }
  @override
  Widget build(BuildContext context) {
    final value=Provider.of<WaterData>(context) ;
    return Consumer<WaterData>(
      builder:(context,value,child)=>
       Scaffold(
         appBar: AppBar(
           title:Text("${value.calculateWeeklyWaterIntake(value)} ml",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
           centerTitle: true,
         ),

           body:Padding(
                     padding:EdgeInsets.only(top:20.0),
                     child: ListView(

                     children:[
                     WaterSummary(startofweek: value.getstartofweek()),
                     !_isLoading?ListView.builder(
                     shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     itemCount: value.waterDataList.length,
                     itemBuilder: (context,index){
               final waterModel=value.waterDataList[index];

                return Card(
                  elevation:4,
                  child: ListTile(

                    title:Row(children:<Widget>[
                      Icon(Icons.water_drop,color: Colors.blue,),
                    Text("${waterModel.amount.toStringAsFixed(2)}ml"),
                    ] ,
                    ),

                    //subtitle: Text(waterModel.id!),
                    subtitle: Text("${waterModel.dateTime.day}/${waterModel.dateTime.month}/${waterModel.dateTime.year}"),
                    trailing: IconButton(
                      onPressed: (){
                        Provider.of<WaterData>(context,listen: false).delete(waterModel);

                        // value.delete(WaterModel(amount: waterModel.amount, dateTime: DateTime.now(), unit: 'ml'));
                      },
                      icon:Icon(Icons.delete),
                    ),

                  ),
                );

            }):Center(child:CircularProgressIndicator()),
           ],
          ),
        ),

        floatingActionButton:Align(
          alignment: FractionalOffset(0.6,1.0),
          child: FloatingActionButton(
            backgroundColor: Colors.lightBlue[300],
            onPressed:(){
              addWater(value);
            },
            child:Icon(Icons.add)
          ),
        ),

      drawer:Drawer(
           child:Container(
             color:Colors.teal[900],
             child: ListView(

               children: <Widget>[
                 DrawerHeader(
                   decoration:BoxDecoration(
                 color: Colors.teal[900],
                   ),
                     child: Text("Water Intake Go",style: TextStyle(color:Colors.blue[100],fontWeight: FontWeight.bold,fontSize: 25),)
                 ),
                 ListTile(
                   title:Text("Settings",style:TextStyle(color:Colors.blue[100],fontWeight: FontWeight.bold,fontSize: 20)),
                   trailing: Icon(Icons.settings),
                   onTap:(){
                     Navigator.push(context,MaterialPageRoute(builder:(context)=>SettingsScreen()));

                   }
                 ),
                 ListTile(
                   title:Text("About",style:TextStyle(color:Colors.blue[100],fontWeight: FontWeight.bold,fontSize: 20)),
                     onTap:(){
                       Navigator.push(context,MaterialPageRoute(builder:(context)=>AboutScreen()));

                     }
                 )

               ],
             ),
           )
       )
    ),
    );
  }
}
