import 'package:carttogo/Data/Mock_data.dart';
import 'package:carttogo/widgets/Admin_Products_Widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Products_List_Admin extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text("Admin Interfece"),
          actions: [
              PopupMenuButton(itemBuilder: (context)=> [
                 PopupMenuItem<int>(
                   value: 0,
                   child: Text('asd'),
                   
                   ),
                  
          ])]
        ),
        body:

          SingleChildScrollView(child: 
          Column(
            children: products.map((e) {
            return Admin_Products_Widgets(e);
          }).toList(),
          ) 
         ,));
  }

}