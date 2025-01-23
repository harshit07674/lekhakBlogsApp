import 'package:flutter/material.dart';

class Customtextfield extends StatefulWidget {
  TextEditingController controller;
  bool isHeading;
  String type;
   Customtextfield({super.key,required this.controller,required this.isHeading,required this.type});

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    return Container(
      height: 200,
      margin: EdgeInsets.only(left: 8,right: 8),
      width: dimension.width*0.9,
      child: TextField(
        
        decoration: InputDecoration(
          hintText:widget.type=='link'? 'Add link here':'',
          border: OutlineInputBorder(
           borderSide: BorderSide(color:widget.type=='link'?Colors.blue: Colors.black,),
          ),
          
        ),
        style: TextStyle(fontWeight:widget.isHeading? FontWeight.bold:FontWeight.normal,fontSize: 20,),
        controller: widget.controller,
        
        maxLines: 3,
        maxLength: 250,
      ),
    );
  }
}
