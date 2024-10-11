import 'dart:core';

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
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> addToFirestoreUser(Job item) async {
    try {
      // الحصول على UID الخاص بالمستخدم الحالي

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
   int?  numberofApply ;
  Future<List<Job>> fetchSavedJobs() async {
    List<Job> savedJobs = [];
    try {
      // الحصول على UID الخاص بالمستخدم الحالي

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

  Future<void> addnumofapplytimes(int num) async {
    try {
       if (userId != null) {
        // Reference the user's document
        DocumentReference userDoc = db.collection("users").doc(userId);

        // Get the document snapshot
        DocumentSnapshot snapshot = await userDoc.get();

        if (!snapshot.exists) {
          // If the document doesn't exist, create it with applyCount
          await userDoc.set({
            "applyCount": num,
          });
        } else {
          // Update the applyCount if the document exists
          await userDoc.update({
            "applyCount": num,
          });
        }

        print(num);
      }

      print("eeeeeeeeeeeeeeeee${numberofApply}");
    } catch (e) {
      print('Error adding/updating apply times: $e');
    }
  }
  Future<void> getumofapplytimes() async {
    try {
      if (userId != null) {
        DocumentReference userDoc = db.collection("users").doc(userId);

        // Get the document snapshot
        DocumentSnapshot snapshot = await userDoc.get();

        if (snapshot.exists) {
          // Access the data and retrieve the applyCount field
          var data = snapshot.data() as Map<String, dynamic>;
          int applyCount = data['applyCount'] ?? 0; // Default to 0 if the field does not exist
          numberofApply =applyCount;

          print('Apply Count: $applyCount');
        } else {
          print('No document found for user: $userId');
        }
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('Error retrieving apply times: $e');
    }
  }

  /// numberofApply = num;
  ///
  Future<void> saveProfile({
    int num = 0,
    String Bio = "",
    String Username = "",
    List<String> Skills = const [],
    List<String> WorkExperience = const [],
  }) async {
    try {
      if (userId != null) {
        DocumentSnapshot document = await db.collection("users").doc(userId).get();

        if (!document.exists) {
          // Create new user profile if it doesn't exist
          await db.collection("users").doc(userId).set({
            "applyCount": num,
            "Bio": Bio,
            "username": Username,
            "skills": Skills,
            "workExperience": WorkExperience,
          });
        } else {
          // Update existing user profile with the provided values
          await db.collection("users").doc(userId).update({
            "applyCount": num,
            "Bio": Bio,
            "username": Username,
            "skills": Skills,
            "workExperience": WorkExperience,
          });
        }
      }
    } catch (e) {
      print("Error saving profile: $e");
    }
  }
   late final ProfileSettings userProfileSettings ;
  Future<ProfileSettings?> getProfileSettings() async {
    try {
      if (userId != null) {
        DocumentSnapshot query = await FirebaseFirestore.instance.collection("users").doc(userId).get();

         if (query.exists) {
           userProfileSettings=ProfileSettings.fromJson(query.data() as Map<String, dynamic>);
          return userProfileSettings;
        } else {
          return ProfileSettings(); // You can modify this to fit your logic
        }
      }
    } catch (e) {
      print("Error getting profile settings: $e");
    }
    return null; // Return null if userId is null or an error occurs
  }



}
class ProfileSettings {
  int num;
  String bio;
  String username;
  List<String> skills;
  List<String> workExperience;

  ProfileSettings({
    this.num = 0,
    this.bio = "",
    this.username = "",
    List<String>? skills,
    List<String>? workExperience,
  })  : skills = skills ?? [],
        workExperience = workExperience ?? [];

  factory ProfileSettings.fromJson(Map<String, dynamic> json) {
    return ProfileSettings(
      num: json['applyCount'] ?? 0,
      bio: json['Bio'] ?? "",
      username: json['username'] ?? "",
      skills: List<String>.from(json['skills'] ?? []),
      workExperience: List<String>.from(json['workExperience'] ?? []),
    );
  }

  // Method to convert a ProfileSettings instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'applyCount': num,
      'Bio': bio,
      'username': username,
      'skills': skills,
      'workExperience': workExperience,
    };
  }
}



