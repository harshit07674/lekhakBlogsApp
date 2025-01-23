import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  String blogTitle;
  String authorName;
  String createdAt;
 
  CommentScreen({required this.blogTitle, required this.authorName, required this.createdAt});
  
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  TextEditingController replyController =  TextEditingController();
  String userProfile = '';
  String userName='';
  bool isLoading = true; 

   bool isReplyBox=false;// Loading state for user profile
  String errorMessage = ''; // Error message for user profile fetch
  String currentUserId = FirebaseAuth.instance.currentUser!.uid; // Current user ID

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
   
       FirebaseFirestore.instance.collection('blogUsers').doc(currentUserId).get().then((value){
          userProfile = value.data()!['profileUrl'];
        userName=value.data()!['userName'];
        isLoading = false; 
      });
    
        // Set loading to false after fetching
      
  
       // Set loading to false on error
      
    
  }

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body:
         Column(

           children: [
          Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: commentController,
                                decoration: InputDecoration(
                                  hintText: 'Add a comment...',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                            ),
                            IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (commentController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You can\'t submit an empty comment', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,));
                              } else {
                                submitComment();
                              }
                            },
                          ),
                          ],
                        ),
                      ),
                    ),
             Expanded(
              flex: 2,
               child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdAt}${widget.blogTitle}').collection('comments').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue,));
                  } else {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),));
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                           
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs;
                                return Column(
                                  spacing: 20,
                                  children: [
                                    Card(
                                      elevation: 4,
                                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                 CircleAvatar(
                                              backgroundImage: NetworkImage(data[index]['userProfile']),
                                            ),
                                             Text(data[index]['user']!),
                                                  ]
                                                ),
                                                Text(data[index]['comment']),
                                                SizedBox(height: 4),
                                                Row(
                                                  spacing: 5,
                                                  children: [
                                                    Text(
                                                      data[index]['currentDate'] + ' ' + data[index]['currentTime'],
                                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                    
                                                    data[index]['userId'] == currentUserId?
                                            TextButton(
                                              onPressed: () {
                                                showReplyDialog(data[index].id); // Show reply dialog
                                              },
                                              child: Text('give Reply',style: TextStyle(fontSize: 13),),
                                            ):Container(),
                                          
                                            data[index]['userId']==currentUserId?TextButton(onPressed: (){
                                                       setState(() {
                                                         isReplyBox=!isReplyBox;
                                                       });
                                            }, child: Text('Replies ${data[index]['replies'].length}',style: TextStyle(color: isReplyBox?Colors.blue:Colors.black,fontSize: 13),)):Container(),
                                                  ],
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                          // Check if the current user is the author of the blog
                                          
                                        ],
                                        
                                      ),
                                    ),
                                    isReplyBox?Card(
                                            elevation: 4,
                                            child: Container(
                                              height: dimension.height*0.5,
                                              width: dimension.width*0.9,
                                              child: ListView.builder(itemBuilder: (context,iindex){
                                                 return Card(
                                      elevation: 4,
                                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                 CircleAvatar(
                                              backgroundImage: NetworkImage(userProfile),
                                            ),
                                             Text(userName),
                                                  ]
                                                ),
                                                Text(data[index]['replies'][iindex]['reply']),
                                                SizedBox(height: 4),
                                                Row(
                                                  spacing: 5,
                                                  children: [
                                                    Text(
                                                      data[index]['replies'][iindex]['currentDate'] + ' ' + data[index]['replies'][iindex]['currentTime'],
                                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                    
                                                   
                                                  ],),
                                                
                                              ],
                                            ),
                                          ),
                                          // Check if the current user is the author of the blog
                                          
                                        ],
                                        
                                      ),
                                    );
                                              },itemCount: data[index]['replies'].length,),
                                            ),
                                          ):Container(),
                                  ],
                                );
                              },
                            ),
                          ),
                         
                        ],
                      );
                    } else {
                      return Center(child: Text('No comments available', style: TextStyle(color: Colors.grey, fontSize: 20),));
                    }
                  }
                }
                       ),
             ),
           ],
         ),
    );
  }

  void submitComment() async {
    DateTime dateTime = DateTime.now();
    int timeStamp = dateTime.millisecondsSinceEpoch;
    String currentDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    String currentTime = '${dateTime.hour % 12}:${dateTime.minute} ${dateTime.hour >= 12 ? 'pm' : 'am'}';

    try {
      await FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdAt}${widget.blogTitle}').collection('comments').doc('${timeStamp}${currentUserId}').set({
        'comment': commentController.text,
        'timeStamp': timeStamp,
        'currentDate': currentDate,
        'currentTime': currentTime,
        'user': userName,
        'userId':currentUserId,
        'isPin':false,        
        'userProfile': userProfile,
        'replies': [],
      });
       FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdAt}${widget.blogTitle}').update({
        'commentCount':FieldValue.increment(1),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your comment has been uploaded', style: TextStyle(color: Colors.white),), backgroundColor: Colors.green,));
      commentController.clear(); // Clear the text field after submission
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit comment', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,));
    }
  }

  void showReplyDialog(String commentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to Comment'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(hintText: 'Type your reply here...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                submitReply(commentId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void submitReply(String commentId) async {
    DateTime dateTime = DateTime.now();
    int timeStamp = dateTime.millisecondsSinceEpoch;
    String currentDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    String currentTime = '${dateTime.hour % 12}:${dateTime.minute} ${dateTime.hour >= 12 ? 'pm' : 'am'}';

    try {
      await FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdAt}${widget.blogTitle}').collection('comments').doc(commentId).update({
        'replies': FieldValue.arrayUnion([{
          'reply': replyController.text,
          'user': currentUserId,
          'userProfile': userProfile,
          'currentDate': currentDate,
          'currentTime': currentTime,
        }]),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your reply has been sent', style: TextStyle(color: Colors.white),), backgroundColor: Colors.green,));
      replyController.clear(); // Clear the reply text field after submission
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send reply', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,));
    }
  }
}
