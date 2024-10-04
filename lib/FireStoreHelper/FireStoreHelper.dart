import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<void> addToFirestoreUser(Job item) async {
    try {
      // الحصول على UID الخاص بالمستخدم الحالي
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // تحقق مما إذا كانت الـ Job موجودة بالفعل في Subcollection "savedJobs" الخاصة بالمستخدم الحالي
        QuerySnapshot query = await db
            .collection("users")
            .doc(userId)
            .collection("savedJobs")
            .where('id', isEqualTo: item.id)
            .get();

        if (query.docs.isEmpty) {
          // إذا لم تكن موجودة، قم بإضافتها إلى Subcollection "savedJobs"
          await db
              .collection("users")
              .doc(userId) // إنشاء/الوصول إلى Document المستخدم الحالي
              .collection("savedJobs") // الوصول إلى Subcollection "savedJobs"
              .add(item.toJson()) // إضافة الـ Job الجديدة
              .then(
                (DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'),
          );
          isTrue = true;
        } else {
          isTrue = false; // الوظيفة موجودة بالفعل
        }
      }
    } catch (e) {
      print('Error adding document: $e');
      isTrue = false;
    }
  }
  Future<List<Job>> fetchSavedJobs() async {
    List<Job> savedJobs = [];
    try {
      // الحصول على UID الخاص بالمستخدم الحالي
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // جلب الوظائف المحفوظة من Subcollection "savedJobs" الخاصة بالمستخدم الحالي
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("savedJobs")
            .get();

        // تحويل البيانات إلى كائنات Job
        for (var doc in querySnapshot.docs) {
          savedJobs.add(Job.fromJson(doc.data() as Map<String, dynamic>));
        }
      } else {
        print("No user is signed in.");
      }
    } catch (e) {
      print("Error fetching jobs: $e");
    }
    return savedJobs;
  }
  Future<void> deleteSavedJob(Job item) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        // البحث عن الـ job باستخدام jobId
        QuerySnapshot query = await db
            .collection("users")
            .doc(userId)
            .collection("savedJobs")
            .where('id', isEqualTo: item.id)
            .get();

        // حذف الـ job إذا كانت موجودة
        for (var doc in query.docs) {
          await db
              .collection("users")
              .doc(userId)
              .collection("savedJobs")
              .doc(doc.id) // استخدام الـ documentId للحذف
              .delete();

          print('Job with ID: ${item.id} deleted.');
        }
      }
    } catch (e) {
      print("Error deleting job: $e");
    }
  }
  void checkifexist(Job item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      QuerySnapshot query = await db
          .collection("users")
          .doc(userId)
          .collection("savedJobs")
          .where('id', isEqualTo: item.id)
          .get();

      if (query.docs.isEmpty) {
        isTrue = false;
      } else {
        isTrue = true;
      }
    } else {
      print("No user is signed in.");
      isTrue = false;
    }
  }

}
