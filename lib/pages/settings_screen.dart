import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text("Settings",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),centerTitle: true,backgroundColor:Colors.teal[900],),

    );
  }
}
