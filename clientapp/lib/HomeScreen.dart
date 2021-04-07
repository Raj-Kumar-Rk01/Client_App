
import 'package:animations/animations.dart';
import 'package:clientapp/edit_data.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool v=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,elevation: 1,title: Text("Client App",style: TextStyle(color: Colors.black),),centerTitle: true,),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [FlatButton(
                  color: v?Colors.green:Colors.white,
                    textColor: v?Colors.white:Colors.black,
                    onPressed: (){setState(() {
                  v=true;
                });},
                    child: Text("visible")),
                  FlatButton(
                      color: !v?Colors.green:Colors.white,
                      textColor: !v?Colors.white:Colors.black,
                      onPressed: (){setState(() {
                  v=false;
                });}, child: Text("Hide")),

                ],
              ),
             SingleChildScrollView(
               child: Container(
                 height: 700,
                   child: v?Visible():Hide(),
               ),
             )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: (){
          Navigator.pushNamed(context, 'Gallery');
        },
      ),
    );
  }
}

class Visible extends StatefulWidget {
  @override
  _VisibleState createState() => _VisibleState();
}

class _VisibleState extends State<Visible> {
  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      itemsPerPage: 4,
      //item builder type is compulsory.
      itemBuilderType:
      PaginateBuilderType.listView, //Change types accordingly
      itemBuilder: (index, context, documentSnapshot) => documentSnapshot.data()['visible']?Container(
        alignment: Alignment.center,

        child: Column(
            children:[
              SizedBox(height:10),
              OpenContainer(
                //transitionType: _containerTransitionType,
                transitionDuration: Duration(seconds: 1),
                openShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                    side: BorderSide(color: Colors.white, width: 1)),
                openBuilder: (context, _) {
                  return Scaffold(
                    body: SafeArea(
                      child: Column(
                          children:[
                            Container(
                              alignment: Alignment.center,
                              height:250,
                              color: Colors.white,
                              child: Image(image: NetworkImage(documentSnapshot.data()['ImageUrl']??'NULL'),fit: BoxFit.cover,width: double.infinity,),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                      child: Row(children: [Icon(Icons.delete),Text("Delete")],), onPressed: () async {
                                   await FirebaseFirestore.instance.collection('oralhealth').doc(documentSnapshot.id).delete();
                                   Navigator.of(context).pop();
                                   setState(() {
                                   });
                                  }),
                                  FlatButton(
                                      child: Row(children: [Icon(Icons.edit),Text("Edit")],), onPressed: ()  {
                                        String imagepath,documentId,description,category,topicname;
                                        imagepath=documentSnapshot.data()['ImageUrl']??'NULL';
                                        documentId=documentSnapshot.id;
                                        description=documentSnapshot.data()['Description']??'NULL';
                                    category=documentSnapshot.data()['Category']??'NULL';
                                    topicname=documentSnapshot.data()['Topic Name']??'NULL';

                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditData(
                                      imagepath: imagepath,
                                      description: description,
                                      category: category,
                                      topicName: topicname,
                                      docid: documentId,

                                    )));
                                  }),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height*0.75,
                                  child:Text(documentSnapshot.data()['Description']??'NULL',style: TextStyle(fontSize: 18),)
                              ),
                            ),
                          ]),
                    ),
                  );
                },
                closedElevation: 0,
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.white, width: 1)),
                closedColor: Colors.white,
                closedBuilder: (context, _) =>
                    Container(
                      alignment: Alignment.center,
                      height: 250,
                      margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(18, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(documentSnapshot.data()['Category']??'NULL',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500))),
                          Container(
                              margin: EdgeInsets.fromLTRB(18, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(documentSnapshot.data()['Topic Name']??'NULL',style: TextStyle(fontSize: 18),)),
                          ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            child: Image(image: NetworkImage(documentSnapshot.data()['ImageUrl']??'NULL'),fit: BoxFit.cover,height: 186,width: double.infinity,),)
                        ],
                      ),
                    ),
              ),
            ]),
      ):Container(),
      // orderBy is compulsory to enable pagination
      query: FirebaseFirestore.instance.collection('oralhealth').orderBy('Topic Name'),
      // to fetch real-time data
      isLive: true,
    );
  }
}

class Hide extends StatefulWidget {
  @override
  _HideState createState() => _HideState();
}

class _HideState extends State<Hide> {
  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      itemsPerPage: 4,
      //item builder type is compulsory.
      itemBuilderType:
      PaginateBuilderType.listView, //Change types accordingly
      itemBuilder: (index, context, documentSnapshot) => !documentSnapshot.data()['visible']?Container(
        alignment: Alignment.center,
        child: Column(
            children:[
              SizedBox(height:10),
              OpenContainer(
                //transitionType: _containerTransitionType,
                transitionDuration: Duration(seconds: 1),
                openShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                    side: BorderSide(color: Colors.white, width: 1)),
                openBuilder: (context, _) {
                  return Scaffold(
                    body: SafeArea(
                      child: Column(
                          children:[
                            Container(
                              alignment: Alignment.center,
                              height:250,
                              color: Colors.white,
                              child: Image(image: NetworkImage(documentSnapshot.data()['ImageUrl']??'NULL'),fit: BoxFit.cover,width: double.infinity,),
                            ),
                            Container(
                                child: Row(
                                  children: [
                                    //Text(documentSnapshot.id),
                                    FlatButton(child:  Row(children: [Icon(Icons.delete),Text("Delete")],), onPressed: () async {
                                      await FirebaseFirestore.instance.collection('oralhealth').doc(documentSnapshot.id).delete();
                                      Navigator.of(context).pop();
                                      setState(() {

                                      });
                                    }),
                                    FlatButton(child:  Row(children: [Icon(Icons.delete),Text("Delete")],), onPressed: ()  {
                                      String imagepath,documentId,description,category,topicname;
                                      imagepath=documentSnapshot.data()['ImageUrl']??'NULL';
                                      documentId=documentSnapshot.id;
                                      description=documentSnapshot.data()['Description']??'NULL';
                                      category=documentSnapshot.data()['Category']??'NULL';
                                      topicname=documentSnapshot.data()['Topic Name']??'NULL';

                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditData(
                                        imagepath: imagepath,
                                        description: description,
                                        category: category,
                                        topicName: topicname,
                                        docid: documentId,
                                      )));
                                    })
                                  ],
                                )
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height*0.75,
                                  child:Text(documentSnapshot.data()['Description']??'NULL',style: TextStyle(fontSize: 18),)
                              ),
                            ),
                          ]),
                    ),
                  );
                },
                closedElevation: 0,
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.white, width: 1)),
                closedColor: Colors.white,
                closedBuilder: (context, _) =>
                    Container(
                      alignment: Alignment.center,
                      height: 250,
                      margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(18, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(documentSnapshot.data()['Category']??'NULL',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500))),
                          Container(
                              margin: EdgeInsets.fromLTRB(18, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(documentSnapshot.data()['Topic Name']??'NULL',style: TextStyle(fontSize: 18),)),
                          ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            child: Image(image: NetworkImage(documentSnapshot.data()['ImageUrl']??'NULL'),fit: BoxFit.cover,height: 186,width: double.infinity,),)
                        ],
                      ),
                    ),
              ),
            ]),
      ):Container(),
      // orderBy is compulsory to enable pagination
      query: FirebaseFirestore.instance.collection('oralhealth').orderBy('Topic Name'),
      // to fetch real-time data
      isLive: true,
    );
  }
}

