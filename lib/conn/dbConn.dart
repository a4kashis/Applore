import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';

class DbConn {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String ref = 'ref';

  Future<void> uploadData(
      {required String title,
      required String desc,
      required String img}) async {
    print(img);
    var id = Uuid();
    String productId = id.v1();
    _firestore
        .collection(ref)
        .doc(productId)
        .set({'title': title, 'desc': desc, 'image': img})
        .then((value) => print("upload completed"))
        .catchError((e) {
          print(e);
        });
  }

  Future<void> deleteData(docID) async {
    print(docID);
    await _firestore
        .collection("ref")
        .doc(docID)
        .delete()
        .then((value) => print("deletion completed"))
        .catchError((e) {
      print(e);
    });
  }

  Future<void> editData(String id, String myPlace) async {
    print(id + myPlace);
    await _firestore
        .collection("ref")
        .doc(id)
        .update({"desc": myPlace})
        .then((value) => print("updation completed"))
        .catchError((e) {
          print(e);
        });
  }
}
