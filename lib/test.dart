import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobscout/FireStoreHelper/FireStoreHelper.dart';

import '../../kconstnt/constants.dart';
import '../../test.dart';

class ProfileScreen2 extends StatelessWidget {
  ProfileScreen2({super.key});

  final TextEditingController _controller = TextEditingController();
  final usersettings = FireStoreHelper().userProfileSettings;

  // Controllers for skills and work experience
  List<TextEditingController> skillControllers = List.generate(5, (_) => TextEditingController());
  List<TextEditingController> workExperienceControllers = List.generate(4, (_) => TextEditingController());
  List<String> skills = ['', '', '', '', ''];

  @override
  Widget build(BuildContext context) {
    // Assuming _controller.text is populated with the Bio from Firestore
    _controller.text = ''; // Replace this with the actual fetched bio

    return WillPopScope(
      onWillPop: () async {
        // Logic to save profile settings on back navigation
        FireStoreHelper().saveProfile(
          Bio: _controller.text,
          num: numberofApply,
          Skills: skills,
          WorkExperience: [
            workExperienceControllers[0].text,
            workExperienceControllers[1].text,
            workExperienceControllers[2].text,
            workExperienceControllers[3].text,
          ],
        );
        return true; // Allow pop
      },
      child: Scaffold(
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
        body: SingleChildScrollView(
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
                          const Hero(
                            tag: 'profile-pic',
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage('profile_image_url'),
                            ),
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
                    Positioned(
                      right: 0.0,
                      bottom: 16.0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                // About Me
                const SizedBox(height: 24.0),
                const Text(
                  'About Me',
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Start typing About Yourself...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),

                // My Skills
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    const Text(
                      'My Skills',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
/*
                        Navigator.push(context, MaterialPageRoute(builder: (c) => ProfileScreen2()));
*/
                      },
                      icon: const Icon(Icons.add_circle_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildSkillChip('UI/UX Design', context, 0),
                    _buildSkillChip('Mobile App Design', context, 1),
                    _buildSkillChip('Figma', context, 2),
                    _buildSkillChip('Wireframing', context, 3),
                    _buildSkillChip('Sketch', context, 4),
                  ],
                ),

                // Work Experience
                const SizedBox(height: 24.0),
                const Text(
                  'Work Experience',
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 8.0),
                _buildWorkExperienceCard(
                  'Product Designer',
                  'Netflix Inc • Miami, USA',
                  'Dec 2020 - Present',
                  'assets/netflix_logo.png',
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
        ),
      ),
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

  Widget _buildSkillChip(String label, BuildContext context, int index) {
    return GestureDetector(
      onDoubleTap: () {
        showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: Text("Update ${label}"),
              content: TextField(
                controller: skillControllers[index],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    skills[index] = skillControllers[index].text;
                    Navigator.pop(context);
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
        );
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
          onPressed: () {
            workExperienceControllers[0].text = title;
            workExperienceControllers[1].text = company;
            workExperienceControllers[2].text = period;
            // Open dialog to edit work experience
            showDialog(
              context: context,
              builder: (c) {
                return AlertDialog(
                  title: Text("Update Work Experience"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: workExperienceControllers[0]),
                      TextField(controller: workExperienceControllers[1]),
                      TextField(controller: workExperienceControllers[2]),
                    ],
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
                        // Save updated work experience
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
