import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text("About",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),centerTitle: true,backgroundColor:Colors.teal[900],),

    );
  }
}
