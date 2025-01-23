import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lekhk/screens/search/search_screen.dart';

import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:lekhk/screens/auth/mainScreens/blog_detail_screen.dart';
import 'package:lekhk/screens/auth/profile_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> texts = [];
  List<String> images = [];
  late Stream blogsDataStteam;
  final blogsData = FirebaseFirestore.instance.collection('blogs').snapshots();
  int current=0;
  String genre='';
  @override
  void initState() {
    super.initState();
    // blogsDataStteam =
    //     Supabase.instance.client.from('blogs').select().asStream();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Blogs'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: dimension.height,
            width: dimension.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context)=>SearchScreen()));
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.all(8),
                  width: dimension.width*0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black,width: 2),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(spacing: 10,children: [
                    Icon(Icons.search,color: Colors.black,size: 35,),
                    Text('Search for blog here',style: TextStyle(color: Colors.grey.shade700,fontSize: 15),),
                  ],),
                ),
              ),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Blogs By Users You Follow',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Expanded(child: StreamBuilder(stream: FirebaseFirestore.instance.collection('blogUsers').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(), builder: (context,snapshot){
                if(snapshot.hasData){
                  // List<String> following = snapshot.snapshot1.data!['following'].toList();
                  // print(following);
                      // print(snapshotdata!.docs.last['authorId']);
                      print(snapshot.data!['following']);
                     return StreamBuilder(stream: FirebaseFirestore.instance.collection('blogs').where('authorId',whereIn: snapshot.data!['following'].toList().isEmpty?['abjhhhhl']:snapshot.data!['following'].toList()).snapshots(), builder: (context,snapshots){
            
                     if(snapshots.hasData){
                   return ListView.builder(
                    
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                       
                    // if(snapshot.data!['following'].contains(snapshots.data!.docs[index]['authorId'].toString())){
                      // print(snapshot.snapshot2.data!.docs[index]['author']);
                     
                      var data = snapshots.data!;
                      return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  BlogDetailScreen(
                                                   isEditable: false,
                                                    createdDate: data.docs[index]['createdAt'],
                                                    blogTitle: data.docs[index]['blogTitle'],
                                                    authorName: data.docs[index]['author'],
                                                  ))); 
                                    },
                                    child: Card(
                                      margin: EdgeInsets.all(10),
                                      elevation: 4,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width *
                                            0.9, // 90% of screen width
                                        height: MediaQuery.of(context).size.height *
                                            0.3, // Adjust height as needed
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                           
                                                
                                                
                                            SizedBox(height: 10),
                                            Container(
                                                  width: dimension.width*0.9,
                                                  height: dimension.height*0.1,
                                                  
                                                  decoration: 
                                                          data
                                                          .docs[index]['coverImage']
                                                          .isEmpty
                                                      ? BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                          border: Border.all(
                                                              color: Colors.green,
                                                              width: 2),
                                                        )
                                                      : BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                                '${data.docs[index]['coverImage']}'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                  padding: EdgeInsets.all(5),
                                                  child: data!
                                                          .docs[index]['coverImage']
                                                          .isEmpty
                                                      ? Center(
                                                          child: Text(
                                                            "No Image",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                                const SizedBox(height: 10,),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7, // 40% of screen width
                                                  height:
                                                      45, // Adjust height as needed
                                                  child: Text(
                                                    '${data.docs[index]['blogTitle']}',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,fontSize: 18),
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                 Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            '${data.docs[index]['authorProfile']}'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              
                                                SizedBox(width: 10),
                                                Text(
                                                    '${data.docs[index]['author']}'),
                                                
                                                
                                              ],
                                            ),
            
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              spacing: 10,
                                              children
                                              : [
                                                Icon(Icons.date_range,color: Colors.black,size: 20,),
                                                Text(
                                                        'Uploaded on:'),
                                                        Text('${data.docs[index]['uploadDate'].toString()}',)
                                              ],
                                            ),
                                          ]
                                      ),
                                      ),
                                    ),
                                  );
                    // }
                   },itemCount: snapshots.data!.docs.length,);
                     }
                     else{
                      return Center(child: Container(),);
                     }
                     },);
                }
                else{
                  if(snapshot.connectionState==ConnectionState.waiting ){
                         return Center(child: CircularProgressIndicator(color: Colors.blue,),);
                  }
                  else{
                   return Center(child: Text('sorry,error occurred',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),);
                  }
                }
              }),flex: 2,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Genres",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
              ),
              // Row for genre buttons
              Container(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 20,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            genre='technology';
                          });
                          
                          // Handle genre selection
                        },
                        child: Text('Technology'),
                        style: ElevatedButton.styleFrom(
                          fixedSize:genre=='technology'? Size(150,50):Size(150,30),
                          backgroundColor:genre=='technology'? Colors.white:Colors.amber,
                          side: genre=='technology'?BorderSide(color: Colors.blue):BorderSide(color: Colors.amber)
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            genre='health';
                          });
                          
                          // Handle genre selection
                        },
                        child: Text('Health'),
                        style: ElevatedButton.styleFrom(
                          fixedSize:genre=='health'? Size(150,50):Size(150,30),
                          backgroundColor:genre=='health'? Colors.white:Colors.amber,
                          side: genre=='health'?BorderSide(color: Colors.blue):BorderSide(color: Colors.amber)
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            genre='education';
                          });
                          
                          // Handle genre selection
                        },
                        child: Text('Education'),
                        style: ElevatedButton.styleFrom(
                          fixedSize:genre=='education'? Size(150,50):Size(150,30),
                          backgroundColor:genre=='education'? Colors.white:Colors.amber,
                          side: genre=='education'?BorderSide(color: Colors.blue):BorderSide(color: Colors.amber)
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            genre='sports';
                          });
                          
                          // Handle genre selection
                        },
                        child: Text('Sports'),
                        style: ElevatedButton.styleFrom(
                          fixedSize:genre=='sports'? Size(150,50):Size(150,30),
                          backgroundColor:genre=='sports'? Colors.white:Colors.amber,
                          side: genre=='sports'?BorderSide(color: Colors.blue):BorderSide(color: Colors.amber)
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            genre='entertainment';
                          });
                          
                          // Handle genre selection
                        },
                        child: Text('Entertainment'),
                        style: ElevatedButton.styleFrom(
                          fixedSize:genre=='entertainment'? Size(150,50):Size(150,30),
                          backgroundColor:genre=='entertainment'? Colors.white:Colors.amber,
                          side: genre=='entertainment'?BorderSide(color: Colors.blue):BorderSide(color: Colors.amber)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Other Blogs',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Expanded(
                  flex: 2,
                  child: StreamBuilder<QuerySnapshot>(
                      stream:genre==''? FirebaseFirestore.instance.collection('blogs').snapshots():FirebaseFirestore.instance.collection('blogs').where('genre',isEqualTo: genre).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        } else {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  "No blog is uploaded yet",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                
                                itemCount: snapshot.data!.docs.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  BlogDetailScreen(
                                                    isEditable: false,
                                                    createdDate: snapshot.data!
                                                        .docs[index]['createdAt'],
                                                    blogTitle: snapshot.data!
                                                        .docs[index]['blogTitle'],
                                                    authorName: snapshot.data!
                                                        .docs[index]['author'],
                                                  ))); 
                                    },
                                    child: Card(
                                      margin: EdgeInsets.all(10),
                                      elevation: 4,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width *
                                            0.9, // 90% of screen width
                                        height: MediaQuery.of(context).size.height *
                                            0.3, // Adjust height as needed
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                           
                                                
                                                
                                            SizedBox(height: 10),
                                            Container(
                                                  width: dimension.width*0.9,
                                                  height: dimension.height*0.1,
                                                  
                                                  decoration: snapshot
                                                          .data!
                                                          .docs[index]['coverImage']
                                                          .isEmpty
                                                      ? BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                          border: Border.all(
                                                              color: Colors.green,
                                                              width: 2),
                                                        )
                                                      : BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                                '${snapshot.data!.docs[index]['coverImage']}'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                  padding: EdgeInsets.all(5),
                                                  child: snapshot
                                                          .data!
                                                          .docs[index]['coverImage']
                                                          .isEmpty
                                                      ? Center(
                                                          child: Text(
                                                            "No Image",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                                const SizedBox(height: 10,),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7, // 40% of screen width
                                                  height:
                                                      45, // Adjust height as needed
                                                  child: Text(
                                                    '${snapshot.data!.docs[index]['blogTitle']}',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,fontSize: 18),
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                 Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            '${snapshot.data!.docs[index]['authorProfile']}'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              
                                                SizedBox(width: 10),
                                                Text(
                                                    '${snapshot.data!.docs[index]['author']}'),
                                                
                                                
                                              ],
                                            ),
            
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              spacing: 10,
                                              children
                                              : [
                                                Icon(Icons.date_range,color: Colors.black,size: 20,),
                                                Text(
                                                        'Uploaded on:'),
                                                        Text('${snapshot.data!.docs[index]['uploadDate'].toString()}',)
                                              ],
                                            ),
                                          ]
                                      ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          } else {
                            if (snapshot.hasError) {
                              return Center(
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    'Error occurred please try again make sure your internet is on',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      })),
            ]),
          ),
        ));
  }
}
