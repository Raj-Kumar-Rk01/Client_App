import 'dart:io';
import 'package:clientapp/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'inpdeco.dart';

class EditData extends StatefulWidget {
  String imagepath,description,category,topicName,docid;
  EditData({this.imagepath,this.category,this.topicName,this.description,this.docid});
  @override
  _EditDataState createState() => _EditDataState(imagepath,category,topicName,description,docid);
}
class _EditDataState extends State<EditData> {
  _EditDataState(String imagepath,String catergory,String topicName,String description,String docid) {
    this.imagepath = imagepath;
    this.catergory= catergory;
    this.topicName= topicName;
    this.description= description;
    this.docid=docid;
  }
  bool upl=false;
  bool vis=true;
  String imagepath, catergory, description, topicName,docid;

  Future _UploadtoFireBase() async {
    await FirebaseFirestore.instance.collection(catergory).doc(docid).update({
      //'ImageUrl': downloadUrl.toString(),
      'Topic Name': topicName,
      'Category': catergory,
      'Description':description,
      'visible':vis,
    });
    upl=!upl;
  }
  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen()));},
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
                      Text("Image cannot be edited"),
                      Container(
                          height: 243,
                          margin: EdgeInsets.fromLTRB(20, 25, 40, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,

                          ),
                          child:ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child:Image.network(
                                imagepath,
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
                                initialValue: description,
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
