import 'package:cloud_firestore/cloud_firestore.dart';
import '../HomeScreen/JobsModel/JobsModel.dart';

class FireStoreHelper {
  FireStoreHelper._privateConstructor();

  static final FireStoreHelper _instance = FireStoreHelper._privateConstructor();

  factory FireStoreHelper() {
    return _instance;
  }

  final db = FirebaseFirestore.instance;
  bool isTrue = false;

  Future<void> addToFirestore(Job item) async {
    try {
      QuerySnapshot query = await db.collection("SavedJobs").where('id', isEqualTo: item.id).get();
      if (query.docs.isEmpty) {
        await db.collection("SavedJobs").add(item.toJson()).then(
              (DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'),
        );
        isTrue = true;
      } else {
        isTrue = false;
      }

    } catch (e) {
      print('Error adding document: $e');
      isTrue = false;
    }
  }
  void getdata (){

  }
  void checkifexist (Job item)async{
    QuerySnapshot query = await db.collection("SavedJobs").where('id', isEqualTo: item.id).get();
    if (query.docs.isEmpty)
      {
        isTrue = false ;
      }
    else isTrue=  true;

  }
}
