import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobscout/HomeScreen/Maincubit/main_cubit.dart';
import 'package:jobscout/kconstnt/constants.dart';

import '../Firebasenotofication/NotoficationScreen.dart';
import '../main.dart';
import '../onboardingScreen/onboardingScreen.dart';
import 'JobsModel/JobsModel.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});
  String truncateHtml(String html, {int length = 200}) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = html.replaceAll(exp, '');

    // Truncate if necessary
    return (plainText.length > length) ? plainText.substring(0, length) + '...' : plainText;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainCubit>();
    return BlocListener<MainCubit,MainState>(

      listener: (BuildContext context, MainState state) {

        if (state is FailedState)
        {
          Get.snackbar(
            "Error",
            state.error,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

        }
        if (state is SuccessNotoficationState) {
          Get.snackbar(
            state.msg,              // Title of the snackbar
            state.details,           // Description/details of the snackbar
            backgroundColor: Colors.cyan,
            colorText: Colors.white,
            onTap: (snack) {
              navigatorkey.currentState!.pushNamed(
                NotoficationScreen.routeName,
                arguments: state.message,
              );
            },
            duration: Duration(seconds: 5), // How long the snackbar will be visible
            snackPosition: SnackPosition.BOTTOM, // Snackbar position
          );
        }

        if (state is SuccessState)
        {
          Get.snackbar(
            "Hello",
            "Welcome MR ${FirebaseAuth.instance.currentUser?.email}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

        }
      },
      child:  Scaffold(
        backgroundColor: Color(0xfff7faff),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(
              'Job Finder',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://th.bing.com/th/id/OIP.1cqb9FuTBVMfBMvyhRTvPwHaL1?w=124&h=199&c=7&r=0&o=5&pid=1.7"),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff2CAEE2),
                  ),
                  accountName: Text("Ahmed Ashraf"),
                  accountEmail: Text("ahmedashraf417@gmail.com")),
              ListTile(
                leading: Icon(Icons.person_3_outlined),
                title: Text("Profile"),
                onTap: () {},
              ),
              ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text("Notifications"),
                  onTap: () {}),
              ListTile(
                  leading: Icon(Icons.translate),
                  title: Text("Language"),
                  onTap: () {}),
              ListTile(
                  leading: Icon(Icons.help_center_outlined),
                  title: Text("About"),
                  onTap: () {}),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.redAccent),
                    title: Text(
                      "logout",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () {}),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(right: 30, top: 10),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ,',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Find Your Dream Job',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Featured Jobs',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CarouselSlider(
                    items: List.generate(
                        10,
                            (i) =>
                        //featured job
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // boxShadow: [BoxShadow(offset: Offset.zero,blurRadius: 5.0,spreadRadius: 3.0,color: Colors.blue.withOpacity(0.4)),],
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://th.bing.com/th/id/OIP.1cqb9FuTBVMfBMvyhRTvPwHaL1?w=124&h=199&c=7&r=0&o=5&pid=1.7"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'IBM',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time,
                                              color: Colors.white70),
                                          Text(" October 9 ,  ",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              )),
                                          Text("2022",
                                              style: TextStyle(
                                                  color: Colors.white70))
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.bookmark,
                                    color: Colors.white70,
                                  )
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Color(0xff7ebdf8),
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.work_outline,
                                            color: Colors.white),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('On Site',
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Color(0xff7ebdf8),
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        Icon(
                                            Icons
                                                .local_fire_department_outlined,
                                            color: Colors.white),
                                        Text('Part Time',
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Color(0xff7ebdf8),
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            color: Colors.white),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text('Cairo',
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                    options: CarouselOptions(
                      height: 170,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    )),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      "Recent Jobs",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Job>?>(
                  future: bloc.getJobs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    final data = snapshot.data ?? [];
                    if (data.isEmpty) {
                      return const Center(child: Text("No jobs found."));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
//
                        return GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  child: Image.network(
                                    item.companyLogo ?? '',
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: double.infinity,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.position ?? 'No Position',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    item.company ?? 'No Company',
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    item.location ?? 'No Location',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Html(
                                    data:truncateHtml(item.description),  // Use the truncated HTML content here
                                    style: {
                                      "p": Style(
                                          fontSize: FontSize(16),maxLines: 3
                                      ),

                                    },
                                  ),                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${item.salaryMin.toStringAsFixed(1)} - \$${item.salaryMax.toStringAsFixed(1)}',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Open the apply URL in a web view or external browser
                                          // Implement this using url_launcher or similar package
                                        },
                                        child: const Text(
                                          'Apply',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

