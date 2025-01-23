import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  String searchText='';
  @override
  Widget build(BuildContext context) {
    final dimension=MediaQuery.of(context).size;
    return SafeArea(child:Scaffold(
     body: Column(
      spacing: 20,
      children: [
      Container(
        height: 70,
        width: dimension.width*0.95,
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.all(8),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blue)
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.black),
            ),
            hintText: 'Search any blog here...',
            hintStyle: TextStyle(color: Colors.grey.shade700,fontSize: 20),
          
            
            prefix: IconButton(onPressed: (){
                searchText=searchController.text;
                setState(() {
                  searchController.clear();
                });
            }, icon: Icon(Icons.search,color: Colors.black,size: 35,)),
          ),
           textAlignVertical: TextAlignVertical.center,
        ),
      ),
      searchText==''?Container(
        height: 80,
        width: dimension.width*0.95,
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue,width: 3),
        ),
        child: Text('You have not searched anything yet',style: TextStyle(color: Colors.green,fontSize: 22,fontWeight: FontWeight.bold),),
      ):Expanded(flex: 2,child: StreamBuilder(stream: FirebaseFirestore.instance.collection('blogs').where('tags',arrayContainsAny: searchText.split(' ') ).snapshots(), builder: (context,snapshot){
        if(snapshot.hasData){
          return ListView.builder(itemBuilder: (context,index){
               return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:Border.all(color: Colors.black,width: 3)
                ),
                 child: ListTile(
                  leading: Image.network('${snapshot.data!.docs[index]['coverImage']}'),
                  title: Container(
                    height: 95,
                    width: dimension.width*0.7,
                    alignment: Alignment.center,
                   child: Text('${snapshot.data!.docs[index]['blogTitle']}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),overflow: TextOverflow.clip,),
                  ),
                 ),
               );
          },itemCount: snapshot.data!.docs.length,);
        }
        else{
          if(snapshot.connectionState==ConnectionState.waiting){
               return Center(child: CircularProgressIndicator(color: Colors.blue,),);
          }
          else{
             return Center(child: Text('Sorry,Can\'t find data',style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),);
          }
        }
      }),)
      ],
     ),
    ));
  }
}