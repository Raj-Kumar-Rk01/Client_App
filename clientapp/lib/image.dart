import 'dart:convert';
import 'dart:io';
import 'package:clientapp/upload.dart';
import 'package:flutter/material.dart';
import 'package:storage_path/storage_path.dart';
import 'package:clientapp/file.dart';

 class GalleryView extends StatefulWidget {
   @override
   _GalleryViewState createState() => _GalleryViewState();
 }

 class _GalleryViewState extends State<GalleryView> {
   List<FileModel> files;
   FileModel selectedModel;
   String image;
   @override
   void initState() {
     super.initState();
     getImagesPath();
   }
   getImagesPath() async {
     var imagePath = await StoragePath.imagesPath;
     var images = jsonDecode(imagePath) as List;
     files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
     if (files != null && files.length > 0)
       setState((){
         selectedModel = files[0];
         image = files[0].files[0];
       });
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: SafeArea(
         child: Column(
           children: <Widget>[
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Row(
                   children: <Widget>[
                     IconButton(icon: Icon(Icons.clear), onPressed: (){Navigator.of(context).pop();}),
                     SizedBox(width: 10),
                     DropdownButtonHideUnderline(
                         child: DropdownButton<FileModel>(
                           items: getItems(),
                           onChanged: (FileModel d) {
                             assert(d.files.length > 0);
                             image = d.files[0];
                             setState(() {
                               selectedModel = d;
                             });
                           },
                           value: selectedModel,
                         ))
                   ],
                 ),
                 IconButton(icon: Icon(Icons.arrow_forward_rounded,color: Colors.blue,), onPressed: (){

                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadData(imagepath: '$image',)));
                 })
               ],
             ),
             Divider(),
             Container(

                // height: MediaQuery.of(context).size.height * 0.3,
                 child: image != null
                     ? Container(
                     height: 243,
                     margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: Colors.white,

                     ),
                     child:ClipRRect(
                         borderRadius: BorderRadius.circular(20),
                         child:Image.file(
                           File(image),
                           fit: BoxFit.cover,
                           height: 186,
                           width: double.infinity,
                         ) )

                 ) : Container()),
             Divider(),
             selectedModel == null && selectedModel.files.length < 1
                 ? Container()
                 : Expanded(
                   child: Container(
              // height: 500,
                     child: GridView.builder(
                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 3,
                               crossAxisSpacing: 4,
                               mainAxisSpacing: 4),
                           itemBuilder: (_, i) {
                             var file = selectedModel.files[i];
                             return GestureDetector(
                               child: Card(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10)
                                 ),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(10),
                                   child: Image.file(
                                     File(file),
                                     fit: BoxFit.cover,
                                   ),
                                 ),
                               ),
                               onTap: () {
                                 setState(() {
                                   image = file;
                                 });
                               },
                             );
                           },
                           itemCount: selectedModel.files.length),
                   ),
                 )
           ],
         ),
       ),
     );
   }

   List<DropdownMenuItem> getItems() {
     return files
         ?.map((e) => DropdownMenuItem(
       child: Text(
         e.folder,
         style: TextStyle(color: Colors.black),
       ),
       value: e,
     ))
         ?.toList() ??
         [];
   }
 }
