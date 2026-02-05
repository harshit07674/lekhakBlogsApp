

import 'package:flutter/material.dart';
import 'package:lekhk/providers/blogItemProvider.dart';
import 'package:lekhk/providers/theme_provider.dart';
import 'package:lekhk/screens/auth/login_page.dart';
import 'package:lekhk/screens/auth/mainScreens/bottom_nav_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lekhk/screens/auth/profile_screen.dart';
import 'package:lekhk/screens/auth/upload_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>BlogItemProvider()),
        ChangeNotifierProvider(create: (context)=>ThemeProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        darkTheme: ThemeData(),
        themeMode: ThemeMode.system,
        theme: ThemeData(
          
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black,fontStyle: FontStyle.italic),
          titleSmall: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color: Colors.black),
          bodyLarge: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),
          bodySmall: TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black),
          displayLarge: TextStyle(fontSize: 20,color: Colors.grey,fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 20,color: Colors.grey,fontWeight: FontWeight.normal),
          labelLarge: TextStyle(color: Colors.black,fontSize: 32,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
          headlineLarge: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold,),
          headlineSmall: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.normal,fontStyle: FontStyle.italic),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
          ),
          useMaterial3: true,
        ),
        routes: {
         '/Login':(context)=>SignUpScreen(),
         '/Home':(context)=>BottomNavBarExample(),
         '/upload':(context)=>UploadScreen(isEditable: false),
         '/upload/edit':(context)=>UploadScreen(isEditable: true),
         
        },
        debugShowCheckedModeBanner: false,
         home: 
        //  FirebaseAuth.instance.currentUser!=null
        //      ? 
            BottomNavBarExample()
            //  : SignUpScreen(),
      ),
    );
  }
}



