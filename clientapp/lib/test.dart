import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Dental App Animations",style: GoogleFonts.josefinSans(fontSize: 25,color: Colors.grey[350]),),
              Expanded(
                child: ListView.builder(itemCount: 6,shrinkWrap: true,scrollDirection: Axis.vertical,itemBuilder: (BuildContext context,  index) {
                  return Container(
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
                              return Column(
                                  children:[
                                    Container(
                                      alignment: Alignment.center,
                                      height: 230,
                                      width: 500,

                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "  Topic $index",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),

                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 620,
                                      width: 530,
                                      decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "More Details about the Topic",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),

                                    ),
                                  ]);
                            },
                            closedElevation: 0,
                            closedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.white, width: 1)),
                            closedColor: Colors.blue,
                            closedBuilder: (context, _) =>
                                Container(
                                  alignment: Alignment.center,
                                  height: 200,
                                  width: 350,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "  Topic $index",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),

                                ),
                          ),
                        ]),
                  );
                }),
              ),
            ]),

      ),
    );
  }

}
