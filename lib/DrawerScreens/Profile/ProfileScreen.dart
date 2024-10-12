


import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobscout/FireStoreHelper/FireStoreHelper.dart';
import '../../kconstnt/constants.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final TextEditingController _controller = TextEditingController();
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _image = img;
  }


  Future<void> EditField(String field, BuildContext context, {int index = 0,List Skills = const []}) async {
    String newValue = '';

    // Work Experience update scenario (Field is empty or set to workExperience)
    if (  field == 'workExperience') {
      List<TextEditingController> controllers = [
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ];

      // Show dialog for updating work experience
      await showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: const Text("Update Work Experience"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(controllers.length, (i) {
                return TextField(
                  style: TextStyle(color: Colors.white),
                  controller: controllers[i],
                  decoration: InputDecoration(
                    hintText: "Enter value for position ${i + 1}",

                  ),
                  onChanged: (value) {
                    controllers[i].text = value; // Update corresponding controller text
                  },
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // Gather all updated values from text fields
                  List<String> updatedValues = controllers.map((controller) => controller.text).toList();
                  Navigator.pop(context, updatedValues);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ).then((updatedValues) async {
        if (updatedValues != null && updatedValues is List<String>) {
          // Update Firestore with the new work experience values
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({
            'workExperience': updatedValues, // Assuming 'workExperience' is a list in Firestore
          });
        }
      });

    } else {
      // Single field update scenario (like skills or any other field)
      await showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text("Update $field"),
            content: TextField(
              style: TextStyle(color: Colors.white),

              controller: TextEditingController(text: newValue),
              decoration: InputDecoration(
                hintText: "Enter new value for $field",
              ),
              onChanged: (value) {
                newValue = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, newValue);
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      ).then((updatedValue) async {
        if (updatedValue != null && updatedValue.trim().isNotEmpty) {
          // Determine if field is a list (like skills) or a direct update
          if (field == 'skills') {
            // If updating an indexed skill
            Skills [index]=updatedValue;
            await FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .update({
              'skills': Skills, // Update specific index in 'skills' array
            });
          } else {
            // For single value field updates
            await FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .update({
              field: updatedValue,
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue[400]),
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${FirebaseAuth.instance.currentUser?.displayName ?? "Guest"}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Color(0xff3c6EAE),
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).snapshots(), builder: (context,snapshot){
        if (snapshot.hasData){
          final userdata = snapshot.data?.data()as Map<String,dynamic>;
          List <dynamic>Skills =userdata['skills'];

          return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF263238), Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        _image !=null?CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.white,
                          backgroundImage:MemoryImage(_image!),
                        ):  const CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/OIP (4).jpeg'),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FirebaseAuth.instance.currentUser?.displayName ?? "Guest",
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                FirebaseAuth.instance.currentUser?.email ?? "Guest@gmail.com",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatColumn(FireStoreHelper().numberofApply.toString(), 'Job Applied'),
                                  _buildStatColumn('1 week', 'Member Since'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Positioned(height: 230,left: 80,child: IconButton(onPressed: (){selectImage();

                }, icon: Icon(Icons.add_a_photo_rounded,color: Colors.black,)))
                ],
              ),
              // About Me
              const SizedBox(height: 24.0),
              Row(
                children:  [const Text(
                  'About Me',
                  style: TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black87),

                ),Spacer(),IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () {EditField ("Bio",context );
                  },
                )]
              ),
              const SizedBox(height: 8.0),
                  Text(userdata["Bio"]),    //About

              // My Skills
              const SizedBox(height: 24.0),
              const Row(
                children: [
                  Text(
                    'My Skills',
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
              ]),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildSkillChip(userdata["skills"][0], context, 0,Skills),
                  _buildSkillChip(userdata["skills"][1], context, 1,Skills),
                  _buildSkillChip(userdata["skills"][2], context, 2,Skills),
                  _buildSkillChip(userdata["skills"][3], context, 3,Skills),
                  _buildSkillChip(userdata["skills"][4], context, 4,Skills),
                ],
              ),//Skills

              // Work Experience
              const SizedBox(height: 24.0),
              const Text(
                'Work Experience',
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 8.0),
              _buildWorkExperienceCard(
                userdata["workExperience"][0],
                userdata["workExperience"][1],
                userdata["workExperience"][2],
                userdata["workExperience"][3],
                context,
              ),
              const SizedBox(height: 12.0),
              _buildWorkExperienceCard(
                'Sr. UX Researcher',
                'Microsoft • Bengaluru, India',
                'July 2019 - December 2020',
                'assets/microsoft_logo.png',
                context,
              ),
            ],
          ),
        ),
      );
        }
        else if (snapshot.hasError){
          return Text("error ${snapshot.error}");
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
        
      }),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12.0),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label, BuildContext context, int index,List Skills) {
    return GestureDetector(
      onDoubleTap: () {
        EditField ("skills",context,index :index,Skills:Skills );
      },
      child: Chip(
        label: Text(label),
        backgroundColor: const Color(0xff3c6EAE),
        elevation: 4.0,
        shadowColor: Colors.black38,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      ),
    );
  }

  Widget _buildWorkExperienceCard(String title, String company, String period, String logoPath, BuildContext context) {
    return Card(
      elevation: 6.0,
      color: Colors.white,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.asset("assets/images/photo_2024-09-16_15-28-23-removebg-preview.png", height: 40),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.black87),
        ),
        subtitle: Text(
          '$company\n$period',
          style: const TextStyle(color: Colors.black54, fontSize: 14.0),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () {EditField ("workExperience",context );
          },
        ),
      ),
    );
  }
}
