import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:applore/utilities/sizeconfig.dart';
import 'package:applore/widgets/drawer.dart';

class Dashboard extends StatefulWidget {
  final User? user;

  Dashboard({this.user});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      drawer: appDrawer(context),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 6,
            horizontal: SizeConfig.blockSizeHorizontal * 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text("Popular Food Near You !",
                style: TextStyle(
                  fontSize: 18,
                )),
            SizedBox(height: 20),
            Card(
                elevation: 8.0,
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer()),
                    ),
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Search your Favourite",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    )),
                    IconButton(icon: Icon(Icons.search), onPressed: () {}),
                  ],
                )),
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("ref")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot data =
                                  snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      elevation: 8.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0)),
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeHorizontal * 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                            data["image"]) ==
                                                        null
                                                    ? NetworkImage(data[
                                                        "https://foodtango.com.au/img/ui/noimage.png"])
                                                    : NetworkImage(
                                                        data["image"]),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      data["title"],
                                      textScaleFactor: 1.4,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    })),
          ],
        ),
      ),
    );
  }
}
