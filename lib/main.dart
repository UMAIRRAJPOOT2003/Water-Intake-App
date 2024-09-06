import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterintakeapp/provider/water_provider.dart';

import 'pages/homepage.dart';

void main()=>runApp(ChangeNotifierProvider(
  create:(context)=>WaterData(),
  child:new MaterialApp(
    debugShowCheckedModeBanner: false,
    home:homepage(),
  )

)) ;


