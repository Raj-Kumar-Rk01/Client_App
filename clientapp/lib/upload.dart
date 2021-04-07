import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'inpdeco.dart';

class UploadData extends StatefulWidget {
  String imagepath;
  UploadData({this.imagepath});
  @override
  _UploadDataState createState() => _UploadDataState(imagepath);
}
class _UploadDataState extends State<UploadData> {
  _UploadDataState(String imagepath) {
    this.imagepath = imagepath;
  }
  bool upl=false;
  bool vis=true;
  String imagepath, catergory='oralhealth', description, topicName;
  Future _UploadtoFireBase() async {
    final Reference _storeRef = FirebaseStorage.instance.ref().child(imagepath.replaceAll('/',''));
    final UploadTask _uploadTask = _storeRef.putFile(File(imagepath));
    var storageSnapShotOnComplete = await _uploadTask.whenComplete(() {});
    var downloadUrl = await storageSnapShotOnComplete.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection(catergory).add({
      'ImageUrl': downloadUrl.toString(),
      'Topic Name': topicName,
      'Category': catergory,
      'Description':description,
      'visible':vis,
    });
    upl=!upl;
  }
    @override
    Widget build(BuildContext context) {
      //bool upl=false;
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
                color:upl?Colors.white:Colors.blue,onPressed: ()async{
               setState(() {
                 upl=!upl;
               });
                  await _UploadtoFireBase();
                  Navigator.pop(context);},
                child:upl?Text(""):Text("Upload",style: TextStyle(color: Colors.white),)
              //child: CircularProgressIndicator(backgroundColor: Colors.white,),
            ),
          )],),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: 243,
                          margin: EdgeInsets.fromLTRB(20, 25, 40, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,

                          ),
                          child:ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child:Image.file(
                                File(imagepath),
                                fit: BoxFit.cover,
                                height: 186,
                                width: double.infinity,
                              ) )

                      ),
                      Container(
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DropdownButton(
                                hint: Text(catergory??"Category"),
                                items: [
                                  DropdownMenuItem(child: Text("Oral Health"),value: 'oralhealth',),
                                  DropdownMenuItem(child: Text("Category-2"),value: 'oralhealth',),
                                  DropdownMenuItem(child: Text("Category-3"),value: 'oralhealth',),
                                  DropdownMenuItem(child: Text("Category-4"),value: 'oralhealth',),
                                  DropdownMenuItem(child: Text("Category-5"),value: 'oralhealth',)
                                ], onChanged: (value){
                              setState(() {
                                catergory=value;
                              });
                            }),
                           FlatButton(

                               color: vis?Colors.green:Colors.white,
                               textColor: vis?Colors.white:Colors.black,
                               onPressed: (){setState(() {
                             vis=!vis;
                           });}, child: vis?Text("Visible"):Text("Hide"))
                          ],
                        )
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            // Text("Topic Name"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: topicName,
                                decoration:buildInputDecoration('Topic Name'),
                                onChanged: (val) {
                                  topicName = val;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.all(8),
                              child: TextFormField(
                                decoration: buildInputDecoration('Description'),
                                maxLength: 500,
                                maxLines: 6,
                                onChanged: (val) {
                                  description = val;
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
               Container(
                 height: double.infinity,
                 width: double.infinity,
                 child: Center(child: upl?Container(height:double.infinity,width:double.infinity,color:Colors.white,child: Center(child: CircularProgressIndicator(backgroundColor: Colors.green,),),):Container(),)
               )
            ],
          )
        ),
      );
    }
  }
