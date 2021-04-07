
import 'package:clientapp/HomeScreen.dart';
import 'package:clientapp/edit_data.dart';
import 'package:clientapp/image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'upload.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/',
    routes:{
      '/':(context)=>HomeScreen(),
      'Gallery':(context)=>GalleryView(),
      'UploadScreen':(context)=>UploadData(),
      'editScreen':(context)=>EditData()
    } ,
  ));
}