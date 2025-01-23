import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lekhk/screens/auth/mainScreens/blog_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lekhk/screens/auth/upload_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  bool isMyProfile;
  String userId;
 ProfileScreen({super.key,required this.isMyProfile,required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Stream userBlogsDataStream = Stream.empty();
  String userName = '';
  int articlesWritten = 0;
  int followers = 0;
  int following = 0;
  double points = 0.0;
  String profileUrl = '';

  @override
  void initState() {
    super.initState();
    getUserCredential().then((value) {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('blogUsers').doc(widget.userId).snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage("${snapshot.data!['profileUrl']}"),
                                        fit: BoxFit.fill)),
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.verified_user,
                                          color: Colors.blue,
                                          size: 35,
                                        ),
                                        Text(
                                          "${snapshot.data!['userName']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.article,
                                        color: Colors.blue,
                                        size: 35,
                                      ),
                                      Text(
                                        ' ${snapshot.data!['articlesWritten']}',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(' Articles'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.person_2, color: Colors.blue, size: 35),
                                      Text(
                                        ' ${snapshot.data!['followers'].length}',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Icon(Icons.person_4, color: Colors.blue, size: 28),
                                      Text(' ${snapshot.data!['following'].length}',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Followers'),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text('Following'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.celebration, color: Colors.blue, size: 35),
                                      Text(
                                        ' ${snapshot.data!['points'].toString().substring(0,3)}',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(' Points'),
                                    ],
                                  ),
                                  // Follow Button
                                  widget.isMyProfile || widget.userId==FirebaseAuth.instance.currentUser!.uid?Container(): ElevatedButton(onPressed: (){
                                    if(snapshot.data!['followers'].contains(FirebaseAuth.instance.currentUser!.uid)){
                                      // Unfollow logic
                                      FirebaseFirestore.instance.collection('blogUsers').doc(widget.userId).update({
                                        'followers':FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
                                      }).then((value){
                                        FirebaseFirestore.instance.collection('blogUsers').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                          'following':FieldValue.arrayRemove([widget.userId]),
                                        }); 
                                      });
                                    } else {
                                      // Follow logic
                                      FirebaseFirestore.instance.collection('blogUsers').doc(widget.userId).update({
                                        'followers':FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                                      }).then((value){
                                        FirebaseFirestore.instance.collection('blogUsers').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                          'following':FieldValue.arrayUnion([widget.userId]),
                                        }); 
                                      });
                                    }
                                  }, child: Row(spacing: 10, children: [
                                    Text(snapshot.data!['followers'].contains(FirebaseAuth.instance.currentUser!.uid)?'Unfollow': 'Follow',style: TextStyle(color: Colors.blue,fontSize: 16),),
                                    Icon(snapshot.data!['followers'].contains(FirebaseAuth.instance.currentUser!.uid)?Icons.verified: Icons.add,color: Colors.green,size: 35,),
                                  ],),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                  ),
                                  )
                                ],
                              )
                            ],
                          );
                          }
                          else{
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(child: CircularProgressIndicator(color: Colors.blue,),);
                            }
                            else{
                              return Center(child: Text('${snapshot.error}',style: TextStyle(color: Colors.red,fontSize: 20),),);
                            }
                          }
                        }
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        "Blogs",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: 70,
                        height: 2,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
              .collection('blogs')
              .where("authorId",
                  isEqualTo:
                      widget.userId)
              .snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: (){
                                         Navigator.push(context, new MaterialPageRoute(builder: (context)=> BlogDetailScreen(authorName: snapshot.data!.docs[index]['author'],createdDate: snapshot.data!.docs[index]['createdAt'],blogTitle: snapshot.data!.docs[index]['blogTitle'],isEditable: false,)));
                                        },
                                        child:  Card(
                                            elevation: 4,
                                            child:  Container(
                                                padding: EdgeInsets.all(8),
                                                height: 100,
                                                width: 100,
                                                child:Slidable(
                                              startActionPane:widget.userId==FirebaseAuth.instance.currentUser!.uid? ActionPane(motion: ScrollMotion(), children:[
                                             SlidableAction(onPressed: (normal){
                                             FirebaseFirestore.instance.collection('blogs').doc('${snapshot.data!.docs[index]['author']}${snapshot.data!.docs[index]['createdAt']}${snapshot.data!.docs[index]['blogTitle']}').delete().then((value){
                                                      FirebaseFirestore.instance.collection('blogUsers').doc('${snapshot.data!.docs[index]['authorId']}').update({
                                                        'points':FieldValue.increment(-0.1),
                                                        'articlesWritten':FieldValue.increment(-1),
                                                      });
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted blog',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
                                                     }).catchError((e){
                                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('sorry error occurred, try again after some time',style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
                                                     });
                                            },
                                            icon:Icons.delete,
                                            spacing: 10,
                                            label: 'delete',
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.blue,
                                            borderRadius: BorderRadius.circular(10),
                                            ),
                                            SizedBox(width: 10,),
                                            SlidableAction(onPressed: (normal) async{
                                            
                                                   
                                                   List strings=[];
                                                for(int i=0;i<snapshot.data!.docs[index]['blogTexts'].length;i++){
                                                       if(snapshot.data!.docs[index]['blogTexts'][i]['type']=='image'){
                                                        File file= await  fetchImage(snapshot.data!.docs[index]['blogTexts'][i]['content'],'${snapshot.data!.docs[index]['blogTitle']}${snapshot.data!.docs[index]['createdAt']}${i}}');
                                                          strings.add({'content':file,'type':'image'});
                                                       }
                                                       else{
                                                       strings.add(snapshot.data!.docs[index]['blogTexts'][i]);
                                                       }
                                                }   

                                                Navigator.push(
                                              context, new MaterialPageRoute(builder: (context)=>UploadScreen(isEditable: true,blogTexts: strings,blogTitle: snapshot.data!.docs[index]['blogTitle'],genre: snapshot.data!.docs[index]['genre'],coverImage: snapshot.data!.docs[index]['coverImage'],)));
                                             
                                            },
                                            icon:Icons.edit,
                                            label: 'edit',
                                            spacing: 10,
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.blue,
                                            borderRadius: BorderRadius.circular(10),
                                            ),
                                          ] ):ActionPane(motion: BehindMotion(), children:[]),
                                              child: Row(
                                                  spacing: 20,
                                                  children: [
                                                  Container(
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(image: NetworkImage('${snapshot.data!.docs[index]['coverImage']}'),fit: BoxFit.fill)
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 95,
                                                    width: MediaQuery.of(context).size.width*0.5,
                                                    alignment: Alignment.center,
                                                    child: Text('${snapshot.data!.docs[index]['blogTitle']}',overflow: TextOverflow.clip,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                                                  ),
                                                  // widget.userId==FirebaseAuth.instance.currentUser!.uid? IconButton(onPressed: (){ 
                                                     
                                                  // }, icon: Icon(Icons.delete,color: Colors.red,size: 35,)):Container(),
                                                  ],
                                                )
                                              ),
                                            ),
                                          ),
                                        
                                      );
                                    });
                              } else {
                                return Center(
                                  child: Text('error : ${snapshot.error}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                );
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Future<File> fetchImage(String url,String fileName) async{
    final directory = await getApplicationDocumentsDirectory();
  File file = new File('${directory.path}/${fileName}');
  var response = await http.get(Uri.parse(url));

  if(response.statusCode==200){
     await file.writeAsBytes(response.bodyBytes);
     
  }
  return file;
 }

  Future<void> getUserCredential() async {
    FirebaseFirestore.instance
        .collection('blogUsers')
        .doc(widget.userId)
        .get()
        .then((data) {
      userName = data.data()!['userName'];
      articlesWritten = data.data()!['articlesWritten'];
      points = data.data()!['points'];
      profileUrl = data.data()!['profileUrl'].toString();
      List follow = data.data()!['followers'];
      followers = follow.length;
      List followingList = data.data()!['following'];
      following = followingList.length;

      setState(() {});
    });
  }
}
