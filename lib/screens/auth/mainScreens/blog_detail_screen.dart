import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lekhk/models/blogItemModel.dart';
import 'package:lekhk/providers/blogItemProvider.dart';
import 'package:lekhk/screens/auth/mainScreens/comment_screen.dart';
import 'package:lekhk/screens/auth/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class BlogDetailScreen extends StatefulWidget {
  String blogTitle;
  String authorName;
  bool isEditable;
  String createdDate;
  BlogDetailScreen({
    super.key,
    required this.isEditable,
    required this.createdDate,
    required this.blogTitle,
    required this.authorName,
  });

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  int count = 0;
  List<int> texts = [];
  String userId = '';
  Stream blogDataStream = Stream.empty();
  late Future<dynamic> blogDatas;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBlogDetails();
    userId = FirebaseAuth.instance.currentUser!.uid.toString();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'blog post',
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
          stream: blogDataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              '${widget.blogTitle}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ))),
                    Expanded(
                      flex: 1,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                 Navigator.push(context, new MaterialPageRoute(builder: (context)=>ProfileScreen(isMyProfile: false, userId: snapshot.data['authorId'])));
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          '${snapshot.data!['authorProfile']}'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Container(
                              height: 45,
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.bottomLeft,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text(
                                '${widget.authorName}',
                                overflow: TextOverflow.clip,
                              ),
                            ),

                            /*
                       Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width*0.9,
                        alignment: Alignment.topCenter,
                       child:Flexible( fit: FlexFit.loose,child:Text('${widget.blogTitle}', style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.clip,),),

                      ),
                      */

                            Spacer(),
                            Container(
                              height: 45,
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  'Created At: ${snapshot.data!['uploadDate']}'),
                            ),
                          ]),
                    ),
                    Expanded(
                        flex: 9,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            var doc = snapshot.data;
                            if (doc['blogTexts'][index]['type']=='image') {
                              return Container(
                                margin: EdgeInsets.all(10),
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: NetworkImage(
                                      "${doc['blogTexts'][index]['content']}"),
                                  fit: BoxFit.cover,
                                )),
                              );
                            } else {
                              if(doc['blogTexts'][index]['type']=='textHeading'){
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    '${doc["blogTexts"][index]['content']}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                                  ));
                              }
                              else{
                                if(doc['blogTexts'][index]['type']=='link'){
                                  return GestureDetector(
                                    onTap: () async{
                                         await launchUrl(Uri.parse(doc['blogTexts'][index]['content']),mode: LaunchMode.externalApplication);
                                    },
                                    child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      '${doc["blogTexts"][index]['content']}',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 20,),
                                    )),
                                  );
                                }
                                else{
                              return Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    '${doc["blogTexts"][index]['content']}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ));
                                }
                              }
                            }
                          },
                          itemCount: snapshot.data['blogTexts'].length,
                        )),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon: Icon(
                                      snapshot.data!['likes'].contains(userId)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      size: snapshot.data!['likes']
                                              .contains(userId)
                                          ? 40
                                          : 30,
                                      color: Colors.red),
                                  onPressed: () {
                                    /*
                                    if (snapshot.data!['happyReactions']
                                            .contains(userId) ||
                                        snapshot.data!['angryReactions']
                                            .contains(userId) ||
                                        snapshot.data!['sadReactions']
                                            .contains(userId) ||
                                        snapshot.data!['bigBrainReactioms']
                                            .contains(userId)) {
                                            }
                                            */

                                    if(snapshot.data!['likes'].contains(userId)){
                                      FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'likes':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                    else{
                                      FirebaseFirestore.instance.collection("blogs").doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'likes':FieldValue.arrayUnion([userId]),
                                        'sadReactions':FieldValue.arrayRemove([userId]),
                                        'angryReactions':FieldValue.arrayRemove([userId]),
                                        'bigBrainReactions':FieldValue.arrayRemove([userId]),
                                        'happyReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                  }),
                              TextButton(
                                onPressed: () {
                                  if (snapshot.data!['happyReactions']
                                      .contains(userId)) {
                                    FirebaseFirestore.instance
                                        .collection('blogs')
                                        .doc(
                                            '${widget.authorName}${widget.createdDate}${widget.blogTitle}')
                                        .update({
                                      'happyReactions':
                                          FieldValue.arrayRemove([userId]),
                                          
                                
                                          
                                    });
                                  } else {
                                
                                      FirebaseFirestore.instance
                                          .collection('blogs')
                                          .doc(
                                              '${widget.authorName}${widget.createdDate}${widget.blogTitle}')
                                          .update({
                                        'happyReactions':
                                            FieldValue.arrayUnion([userId]),
                                            'likes':FieldValue.arrayRemove([userId]),
                                            'sadReactions':FieldValue.arrayRemove([userId]),
                                            'angryReactions':FieldValue.arrayRemove([userId]),
                                            'bigBrainReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                  
                                },
                                child:Text('😂', style: TextStyle(fontSize: snapshot.data!['happyReactions'].contains(userId)?40: 30)),
                            ),
                              TextButton(child: Text('😞',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: snapshot.data!['sadReactions'].contains(userId)?40: 30)),onPressed: (){
                                        if(snapshot.data!['sadReactions'].contains(userId)){
                                      FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'sadReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                    else{
                                      FirebaseFirestore.instance.collection("blogs").doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'likes':FieldValue.arrayRemove([userId]),
                                        'sadReactions':FieldValue.arrayUnion([userId]),
                                        'angryReactions':FieldValue.arrayRemove([userId]),
                                        'bigBrainReactions':FieldValue.arrayRemove([userId]),
                                        'happyReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                      },),
                              TextButton(child:Text('😡',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize:snapshot.data!['angryReactions'].contains(userId)?40: 30)),onPressed: (){
                                        if(snapshot.data!['angryReactions'].contains(userId)){
                                      FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'angryReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                    else{
                                      FirebaseFirestore.instance.collection("blogs").doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'likes':FieldValue.arrayRemove([userId]),
                                        'sadReactions':FieldValue.arrayRemove([userId]),
                                        'angryReactions':FieldValue.arrayUnion([userId]),
                                        'bigBrainReactions':FieldValue.arrayRemove([userId]),
                                        'happyReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                      },),
                              TextButton(child: Text('💯',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize:snapshot.data!['bigBrainReactions'].contains(userId)?40: 30 )),onPressed: (){
                                        if(snapshot.data!['bigBrainReactions'].contains(userId)){
                                      FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'bigBrainReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                    else{
                                      FirebaseFirestore.instance.collection("blogs").doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}').update({
                                        'likes':FieldValue.arrayRemove([userId]),
                                        'sadReactions':FieldValue.arrayRemove([userId]),
                                        'angryReactions':FieldValue.arrayRemove([userId]),
                                        'bigBrainReactions':FieldValue.arrayUnion([userId]),
                                        'happyReactions':FieldValue.arrayRemove([userId]),
                                      });
                                    }
                                      },),
                              IconButton(icon:Icon(Icons.comment, color: Colors.red, size: 35),onPressed: (){
                                Navigator.push(context,new MaterialPageRoute(builder: (context)=>CommentScreen(blogTitle: widget.blogTitle,createdAt: widget.createdDate,authorName: widget.authorName,)));
                              },),
                              
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            spacing: 50,
                            children: [
                              Text(
                                '${snapshot.data!['likes'].length}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text('${snapshot.data!['happyReactions'].length}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Text('${snapshot.data!['sadReactions'].length}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Text('${snapshot.data!['angryReactions'].length}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Text('${snapshot.data!['bigBrainReactions'].length}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                             
                              Text('${snapshot.data!['commentCount']}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    'error:${snapshot.error}',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              }
            }
          }),
    );
  }

  Future<void> getBlogDetails() async {
    blogDataStream = FirebaseFirestore.instance
        .collection('blogs')
        .doc('${widget.authorName}${widget.createdDate}${widget.blogTitle}')
        .snapshots();
  }
}
