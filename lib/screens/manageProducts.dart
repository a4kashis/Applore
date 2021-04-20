import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/material.dart';
import 'package:applore/conn/dbConn.dart';
import 'package:applore/utilities/colors.dart';
import 'package:applore/utilities/sizeconfig.dart';
import 'package:applore/widgets/drawer.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  bool addNew = false;
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController desc = new TextEditingController();
  TextEditingController editPlace = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() => addNew = !addNew);
                print(addNew);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: appDrawer(context),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 4,
            horizontal: SizeConfig.blockSizeHorizontal * 6),
        child: SingleChildScrollView(
          child: Column(
            children: [
              !addNew
                  ? Container()
                  : isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: SizeConfig.blockSizeVertical * 60,
                          child: Column(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          SizeConfig.blockSizeVertical * 8,
                                      horizontal:
                                          SizeConfig.blockSizeVertical * 12),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.blue),
                                ),
                                onPressed: () => getImage(),
                                child: _displayChild1(),
                              ),
                              Expanded(
                                  child: TextFormField(
                                controller: title,
                                decoration:
                                    InputDecoration(hintText: "Enter Title"),
                              )),
                              SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 4),
                              Expanded(
                                  child: TextFormField(
                                controller: desc,
                                decoration: InputDecoration(
                                  hintText: "Enter Description",
                                ),
                              )),
                              ElevatedButton(
                                  onPressed: () => validateUpload(),
                                  child: Text("Add Product"))
                            ],
                          ),
                        ),
              SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("ref").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot places =
                                snapshot.data!.docs[index];
                            return CustomTile(
                                places["title"], places["desc"], places.id);
                          });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomTile(String title, String desc, String docId) {
    String updatedDes = "";
    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textScaleFactor: 1.2,
                ),
                SizedBox(height: 5),
                Text(
                  desc,
                  textScaleFactor: 1.2,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text("Edit Place"),
                        content: TextFormField(
                          // controller: editPlace,
                          onChanged: (value) => updatedDes = value,
                          initialValue: desc,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel")),
                          TextButton(
                              onPressed: () => DbConn()
                                  .editData(docId, updatedDes)
                                  .then((value) => Navigator.pop(context)),
                              child: Text("Update"))
                        ],
                      )),
              icon: Icon(Icons.edit, color: Colors.grey)),
          IconButton(
              onPressed: () => DbConn().deleteData(docId),
              icon: Icon(Icons.delete_outline, color: Colors.grey))
        ],
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _displayChild1() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateUpload() async {
    if (_image != null) {
      setState(() => isLoading = true);

      String imageUrl1;

      fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
      final String picture =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      fs.UploadTask task1 = storage.ref().child(picture).putFile(_image!);

      TaskSnapshot snapshot = await task1.then((snapshot) => snapshot);

      task1.then((snapshot) async {
        imageUrl1 = await snapshot.ref.getDownloadURL();
        DbConn().uploadData(
          title: title.text,
          desc: desc.text,
          img: imageUrl1,
        );

        setState(() => isLoading = false);

        Fluttertoast.showToast(msg: 'Product Added');
        addNew = false;
        title.clear();
        desc.clear();
        _image = null;
      });
    } else {
      setState(() => isLoading = false);

      // Fluttertoast.showToast(msg: 'Select An Image');
    }
  }
}
