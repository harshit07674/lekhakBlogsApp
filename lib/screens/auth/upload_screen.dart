import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:lekhk/models/blogItemModel.dart';
import 'package:lekhk/providers/blogItemProvider.dart';
import 'package:lekhk/screens/auth/mainScreens/bottom_nav_screen.dart';
import 'package:lekhk/screens/widgets/customImageField.dart';
import 'package:lekhk/screens/widgets/customTextField.dart';
import 'package:lekhk/utils/imagesList.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';



class UploadScreen extends StatefulWidget {
  bool isEditable;
  String? blogTitle;
  String? genre;
  String? coverImage;
  List? blogTexts;
  UploadScreen({super.key,required this.isEditable,this.blogTitle,this.genre,this.coverImage,this.blogTexts
  });

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  TextEditingController tagController = new TextEditingController();
  int count =0;
  List<TextEditingController> controllers = [];
  List<File> images = [];
  List<String> tags = [];
  List<String> blogImageUrl = [];
  List<Map<String,String>> blogTexts = [];
  List<int> imageIndexes = [];
  bool isLoading = false;
  File? img;
  TextEditingController blogTitleController = TextEditingController();
  List<String> genres = ['technology','health','education','sports','entertainment'];
  String selectedGenre = 'technology';
  File? coverFile;
  bool isDropDown=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  if(widget.isEditable){
    final blogItemProvider = Provider.of<BlogItemProvider>(context,listen: false);
    widget.blogTexts!.forEach((blogItem){
       if(blogItem['type']=='image'){
        images.add(blogItem['content']);
        blogItemProvider.blogItemsProviderList.add(blogItemModel(field: CustomImageField(image: images.last), type: 'image'));
       }
       else{
        controllers.add(new TextEditingController());
        controllers.last.text=blogItem['content'];
        blogItemProvider.blogItemsProviderList.add(blogItemModel(field: Customtextfield(controller: controllers.last, isHeading: blogItem['type']!='textHeading'?false:true, type: blogItem['type']),type: blogItem['type']));
       }
    });
  }
      
  }
  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    final blogItemProvider = Provider.of<BlogItemProvider>(context);
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Upload Blogs',),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Container(
              height: dimension.height,
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Write Your Blog section:',style: TextStyle(color: Colors.black,fontSize: 20),),
                  Expanded(
                    flex: 2,
                     child: 
                     //StreamBuilder(
                    //   stream:widget.isEditable? FirebaseFirestore.instance.collection('blogs').doc('${widget.authorName}${widget.createdAt}${widget.blogTitle}').snapshots():Stream.value(1),
                    //   builder: (context, snapshot) {
                        //if(snapshot.hasData){
                         
                        //return
                         ListView.builder(
                          itemBuilder: (context, index) {
                            return Column(
                              
                              children: [
                                blogItemProvider.blogItemsProviderList
                                    .elementAt(index)
                                    .field,
                                  IconButton(onPressed: (){
                                      blogItemProvider.deleteItem(index);
                                  }, icon: Icon(Icons.delete,color: Colors.red,size: 35,)),  
                              ],
                            );
                          },
                          itemCount: blogItemProvider.blogItemsProviderList.length,
                        ),
                  ),
                       // }
                        //else{
                  //         if(snapshot.connectionState==ConnectionState.waiting){
                  //           return Center(child: CircularProgressIndicator(color: Colors.blue,),);
                  //         }
                  //         else{
                  //           return Text("sorry,error occurred try again",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),);
                  //         }
                  //       }
                  //     }
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          controllers.add(new TextEditingController());
                          blogItemProvider.addBlogItem(blogItemModel(
                              field: Customtextfield(controller: controllers.last,isHeading: false,type: 'text',),
                              type: 'text'));
                        },
                        icon: Icon(
                            Icons.text_fields,
                            size: 35,
                            color: Colors.blue,
                          ),
                        ),
                        
                      
                      
                       IconButton(
                        onPressed: () {
                          controllers.add(new TextEditingController());
                          blogItemProvider.addBlogItem(blogItemModel(
                              field: Customtextfield(controller: controllers.last,isHeading: false,type: 'link',),
                              type: 'link'));
                        },
                        icon: Icon(
                            Icons.link,
                            size: 35,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                        onPressed: () {
                          controllers.add(new TextEditingController());
                          blogItemProvider.addBlogItem(blogItemModel(
                              field: Customtextfield(controller: controllers.last,isHeading: true,type: 'textHeading',),
                              type: 'textHeading'));
                        },
                        icon: Icon(
                            Icons.title,
                            size: 35,
                            color: Colors.blue,
                          ),
                        ),
                      IconButton(
                        onPressed: () {
                          images.add(new File(""));
                          blogItemProvider.addBlogItem(blogItemModel(
                              field: CustomImageField(image: images.last),
                              type: 'image'));
                        },
                        
                        icon:  Icon(
                            Icons.image,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                        
                    ],
                  ),
                  const Divider(thickness: 2,),
                  Expanded(
                    flex: 1,
                    child: Row(spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Blog Details Section: ',style: TextStyle(fontSize: 20),),
                        IconButton(onPressed: (){
                          setState(() {
                            isDropDown=!isDropDown;
                          });
                        }, icon: Icon(isDropDown?Icons.arrow_drop_up: Icons.arrow_drop_down,size: 30,)),
                      ],
                    ),
                  ),
                 isDropDown?  SingleChildScrollView(
                   child: Container(
                        
                   
                        child: Column(
                        spacing: 20,
                        children: [
                          Text('Genre: ',style: TextStyle(fontSize: 20),),
                                          SizedBox(
                        height: 60,
                        width: dimension.width*0.5,
                                          child: DropdownButtonFormField<String>(
                          value: selectedGenre,
                          hint: Text('Select Genre'),
                          items: genres.map((String genre) {
                            return DropdownMenuItem<String>(
                              value: genre,
                              child: Text(genre),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGenre = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),),
                         
                        const Divider(thickness: 2,),
                                         Text('Cover Image: ',style: TextStyle(fontSize: 20),),
                                         GestureDetector(
                                          onTap: () async{
                        final ImagePicker _picker = ImagePicker();
                                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery).then((value){
                             coverFile = File(value!.path);
                             setState(() {
                               
                             });
                                        });
                                        
                                          },
                                           child: Container(
                        height: dimension.height*0.15,
                        width: dimension.width*0.7,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                        ),
                        child:coverFile!=null?Image.file(coverFile!,fit: BoxFit.cover,):Center(child: Icon(Icons.camera_alt,color: Colors.black,size: 35,),),
                                           ),
                                         ),
                                         const Divider(thickness: 2,),
                                         Text('Blog Title:',style: TextStyle(fontSize: 20),),
                                          
                           Container(
                            height: dimension.height*0.08,
                            width: dimension.width*0.85,
                            child: TextField(
                              maxLength: 100,
                              controller: blogTitleController,
                              decoration: InputDecoration(
                                hintText: "Add Blog Title",
                                border: OutlineInputBorder(
                                  
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                 
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  
                                  borderSide: BorderSide(color: const Color.fromARGB(255, 2, 2, 2)),
                                ),
                              ),
                            ),
                          ),
                          const Divider(thickness: 2,),
                          // Text('Tags:',style: TextStyle(fontSize: 20),),
                          // GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemBuilder: (context,index){
                          //   return Container(
                          //      height: 50,
                          //      decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20),
                          //       border: Border.all(width: 2),
                          //      ),
                          //      child: Text('${tags[index]
                          //      }',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),

                          //   );
                          // },itemCount: tags.length,),
                          // ElevatedButton(onPressed: (){
                          //   if(tags.length>=10){
                          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You can\'t add more than 10 tags',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
                          //   }
                          //   else{
                          //     showDialog(context: context, builder: (context){
                          //        return Container(
                          //         height: 100,
                          //         width: dimension.width*0.9,
                          //         child: Column(
                          //           spacing: 10,
                          //           children: [
                          //            TextField(
                          //              controller: tagController,
                          //              decoration: InputDecoration(
                          //               enabledBorder: OutlineInputBorder(
                          //                 borderSide:BorderSide(color: Colors.black)
                          //               ),

                          //              ),
                          //            ),
                          //            Row(
                          //             spacing: 20,
                          //             children: [
                          //               ElevatedButton(onPressed: (){
                          //                       setState(() {
                          //                         tags.add(tagController.text);
                          //                           });
                          //                         tagController.clear();
                          //                         Navigator.pop(context);
                                              
                          //               }, child: Text('Ok')),
                          //               ElevatedButton(onPressed: (){
                                               
                          //               }, child: Text('Cancel')),
                          //             ],
                          //            )
                          //           ],
                          //         ),
                          //        );
                          //     });
                          //   }
                          // }, child:Text('Add Tag')),
                          Center(
                            child: ElevatedButton(
                              
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                   
                              if(blogItemProvider.blogItemsProviderList.isEmpty){
                                setState(() {
                                  isLoading=false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('you can\'t upload empty blog',style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
                                return;
                              }
                                          
                              final uploadTime = DateTime.now().millisecondsSinceEpoch;
                              for (int i = 0; i < imageFiles.length; i++) {
                                /*
                                Supabase.instance.client.storage.from('ProfileImages').upload(
                                    "blogsUploaded/${blogTitleController.text + uploadTime.toString()}/$i",
                                    imageFiles[i],
                                    fileOptions: FileOptions(upsert: false));
                                          
                                String imageUrl = await Supabase.instance.client.storage
                                    .from('ProfileImages')
                                    .getPublicUrl(
                                        "blogsUploaded/${blogTitleController.text + uploadTime.toString()}/$i");
                                blogImageUrl.add(imageUrl);
                                */
                                          
                                await FirebaseStorage.instance
                                    .ref()
                                    .child('blogImages/${blogTitleController.text}/$i')
                                    .putFile(imageFiles[i]);
                                String imageUrl = await FirebaseStorage.instance
                                    .ref()
                                    .child('blogImages/${blogTitleController.text}/$i')
                                    .getDownloadURL();
                                blogImageUrl.add(imageUrl);
                              }
                              int currTime = DateTime.now().millisecondsSinceEpoch;
                                 await FirebaseStorage.instance.ref().child('blogCovers/${blogTitleController.text}/${currTime}').putFile(coverFile!); 
                                 String coverImageUrl = await FirebaseStorage.instance.ref().child('blogCovers/${blogTitleController.text}/${currTime}').getDownloadURL();        
                              int blogCount = 0;
                              for (int i = 0;
                                  i < blogItemProvider.blogItemsProviderList.length;
                                  i++) {
                                if (blogItemProvider.blogItemsProviderList[i].type!='image') {
                                     
                                      
                                  
                                    blogTexts.add({'content':controllers[blogCount].text,'type':blogItemProvider.blogItemsProviderList[blogCount].type});
                                  blogCount++;
                                  
                                } else {
                   
                                  blogTexts.add({'content':blogImageUrl[i-blogCount],'type':'image'});
                                  imageIndexes.add(i);
                                }
                              }
                                          
                              String authorEmail = '';
                              String authorProfile = '';
                              int articlesCount = 0;
                              double point = 0.0;
                                          
                              /*
                              await Supabase.instance.client
                                  .from('blogUsers')
                                  .select()
                                  .eq('uid', user.user!.id)
                                  .then((val) {
                                setState(() {
                                  isLoading = false;
                                          
                                  authorProfile = val.first['profile_url'];
                                });
                                authorEmail = val[0]['user_name'];
                                articlesCount = val[0]['articles_written'];
                                point = val[0]['points'];
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    "user data fetched",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 50),
                                ));
                                //authorEmail = val[0]['user_name'];
                                //authorProfile = val[0]['profile_url'];
                              }).catchError((e) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    "user data error cccurred:$e",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 50),
                                ));
                              });
                                          
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "userName: ${authorEmail}" +
                                      "userProfile: ${authorProfile}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ));
                              */
                                 DateTime dateTime = DateTime.now();
                       int timeStamp = dateTime.millisecondsSinceEpoch;
                       String currentDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                                
                              await FirebaseFirestore.instance
                                  .collection('blogUsers')
                                  .doc("${FirebaseAuth.instance.currentUser!.uid}")
                                  .get()
                                  .then((data) {
                                authorEmail = data.data()!['userName'];
                                authorProfile = data.data()!['profileUrl'];
                                point = data.data()!['points'];
                                articlesCount = data.data()!['articlesWritten'];
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('userName:$authorEmail',
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.green));
                                          
                                FirebaseFirestore.instance
                                    .collection('blogs')
                                    .doc(
                                        '${authorEmail}${uploadTime}${blogTitleController.text}')
                                    .set({
                                  'author': authorEmail,
                                  'blogTexts': blogTexts,
                                  'blogImages': blogImageUrl,
                                  'blogTitle': blogTitleController.text,
                                  'imagesIndexes':imageIndexes,
                                  'authorId':FirebaseAuth.instance.currentUser!.uid,
                                  'likes': [],
                                  'coverImage':coverImageUrl,
                                  'genre':selectedGenre,
                                  'uploadDate':currentDate,
                                  'tags':blogTitleController.text.split(' '),
                                  'commentCount':0,
                                  'angryReactions': [],
                                  'sadReactions': [],
                                  'bigBrainReactions': [],
                                  'happyReactions': [],
                                  'authorProfile': authorProfile,
                                  'createdAt': uploadTime.toString(),
                                }).then((success) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Successfully uploaded blogs',
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    backgroundColor: Colors.green,
                                  ));
                                    double currPoint = point+0.1;      
                                  FirebaseFirestore.instance
                                      .collection('blogUsers')
                                      .doc('${FirebaseAuth.instance.currentUser!.uid}')
                                      .update({
                                        'points': currPoint,
                                        'articlesWritten': articlesCount + 1,
                                      })
                                      .then((v) {})
                                      .catchError((e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Error:$e',
                                                style: TextStyle(color: Colors.white)),
                                            backgroundColor: Colors.red));
                                      });
                                }).catchError((e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Error:$e',
                                          style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.red));
                                });
                                          
                                setState(() {
                                  isLoading = false;
                                });
                              }).catchError((e) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Error:$e',
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                              });
                                          
                              /*
                              Supabase.instance.client.from('blogs').insert([
                                {
                                  'blog_title': blogTitleController.text,
                                  'blog_texts': blogTexts,
                                  'blog_images': blogImageUrl,
                                  'author': authorEmail,
                                  // Supabase.instance.client.auth.currentUser!.email
                                  //   .toString()
                                  //  .split("@")[0],
                                  'author_profile': authorProfile,
                                }
                              ]).then((message) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    "your blog is successfully uploaded",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 50),
                                ));
                              }).catchError((error) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    "Sorry,Error occured : $error",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 50),
                                ));
                              });
                                           .               */
                                          
                              // Supabase.instance.client.storage
                              //     .from('ProfileImages')
                              //     .upload(
                              //        "blogUpload/${blogTitleController.text}",
                              //         img!,
                              //         fileOptions: FileOptions(upsert: false))
                              //     .then((value) {
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //     content: Text(
                              //       "updated",
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //     backgroundColor: Colors.green,
                              //   ));
                              // }).catchError((e) {
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //     content: Text(
                              //       "error:$e",
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //     backgroundColor: Colors.red,
                              //   ));
                              // });
                                          
                              /*
                              await Supabase.instance.client
                                  .from('blogUsers')
                                  .update({
                                    'articles_written': articlesCount + 1,
                                    'points': point + 0.10,
                                  })
                                  .eq('user_name', authorEmail)
                                  .then((v) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "successfuly updated article count and points",
                                          style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.green,
                                    ));
                                  })
                                  .catchError((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "error:$e",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                                  */
                                          
                              blogItemProvider.blogItemsProviderList.clear();
                              blogImageUrl.clear();
                              coverFile!.delete();
                              selectedGenre='technology';
                              blogTexts.clear();
                              controllers.clear();
                              imageFiles.clear();
                              blogTitleController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              fixedSize: Size(200,30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                          
                                                  ),
                          ),
                        ],
                                          ),
                      ),
                 ):Container(),
                  
                      
                ],
              ),
            ),
          ),
        ),
      
    );
  }

  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
    blogImageUrl.clear();
    blogTexts.clear();
    imageFiles.clear();
    controllers.clear();
    blogTitleController.dispose();
  }
}
