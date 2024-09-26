import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Firebasenotofication/NotoficationScreen.dart';
import '../main.dart';
import '../onboardingScreen/onboardingScreen.dart';
import 'JobsModel/JobsModel.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  String truncateHtml(String html, {int length = 200}) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = html.replaceAll(exp, '');

    // Truncate if necessary
    return (plainText.length > length)
        ? plainText.substring(0, length) + '...'
        : plainText;
  }

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url); // Convert the string URL to a Uri
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  List<Job> JobBanners = [];

/*
    bool isloading =false ;

  Future <void> getNotes(MainCubit bloc) async {
    try {
      int count = 1;
      await bloc.getJobs();
      for (var s in bloc.JobModels ) {
        if (count == 10) {
          break;
        }

        JobBanners.add(s);
        count++;
      }
      isloading =true ;
    } catch (e) {}

  }*/

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainCubit>();

    return BlocListener<MainCubit, MainState>(
      listener: (BuildContext context, MainState state) {
        if (state is FailedState) {
          Get.snackbar(
            "Error",
            state.error,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        if (state is SuccessNotoficationState) {
          Get.snackbar(
            state.msg, // Title of the snackbar
            state.details, // Description/details of the snackbar
            backgroundColor: Colors.cyan,
            colorText: Colors.white,
            onTap: (snack) {
              navigatorkey.currentState!.pushNamed(
                NotoficationScreen.routeName,
                arguments: state.message,
              );
            },
            duration: Duration(seconds: 5),
            // How long the snackbar will be visible
            snackPosition: SnackPosition.BOTTOM, // Snackbar position
          );
        }

        if (state is SuccessState) {
          Get.snackbar(
            "Hello",
            "Welcome MR ${FirebaseAuth.instance.currentUser?.email}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfff7faff),
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
                          "Hi ${FirebaseAuth.instance.currentUser?.displayName??"Guest"}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Color(0xff3c6EAE),
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                        const Text(
                          'Find Your Dream Job',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0xff3c6EAE),
                              fontSize: 25, fontWeight: FontWeight.w900),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      'Featured Jobs',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Job>?>(
                  future: bloc.getJobsAndSetBanners(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show SkeletonLoader while loading
                      return CarouselSlider(
                        items: List.generate(
                          10, // Show 10 skeleton placeholders
                          (i) => Skeletonizer(
                            enabled: true, // Skeleton loading enabled
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                backgroundBlendMode: BlendMode.dst,
                                image:DecorationImage(
                                    image: AssetImage('assets/images/black.avif'), // Your image URL
                                    fit: BoxFit.cover, // Adjusts how the image fits inside the container
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.2), // Adjust the transparency here
                                      BlendMode.dstATop,)),
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(height: 15),
                                      const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        // Skeleton avatar
                                        radius: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Container(
                                            width: 100,
                                            height: 15,
                                            color: Colors
                                                .grey[400], // Skeleton text
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            width: 80,
                                            height: 10,
                                            color: Colors
                                                .grey[400], // Skeleton text
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        color:
                                            Colors.grey[400], // Skeleton icon
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            // Skeleton button
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            // Skeleton button
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            // Skeleton button
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        options: CarouselOptions(
                          height: 170,
                          viewportFraction: 1,
                          enableInfiniteScroll: true,
                          autoPlay: false,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final jobData = snapshot.data ?? [];
                    if (jobData.isEmpty) {
                      return const Center(child: Text("No jobs found."));
                    }

                    final jobBanners = jobData.toList();

                    return CarouselSlider(
                      items: List.generate(
                        jobBanners.length,
                        (i) => Skeletonizer(
                          enabled: false,
                          // Skeleton loading disabled when data is ready
                          //------------> Banner Container <------------------
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 170,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image:DecorationImage(
                                  image: AssetImage('assets/images/black.avif'), // Your image URL
                              fit: BoxFit.cover, // Adjusts how the image fits inside the container
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.2), // Adjust the transparency here
                                BlendMode.dstATop,)),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xff62cff4),
                                  Color(0xff2c67f2),
                                ],
                              ),
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const SizedBox(height: 15),
                                    Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      jobBanners[i].companyLogo,
                                      // color: Colors.blue,
                                      width: 55,
                                      height: 55,
                                      alignment: Alignment.center,
                                      maxHeightDiskCache: 75,
                                      fit: BoxFit.contain,
                                      // للصور اللى لسه بتحمل
                                      placeholder: (c, u) =>
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/reddit.png"),
                                          ),
                                      // للصور البايظة
                                      errorWidget: (c, u, e) =>
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/linkedin.png"),
                                          ),
                                    ),
                                  ),
                                  ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // const SizedBox(height: 5),
                                        Text(
                                          jobBanners[i].company,
                                          style: TextStyle(
                                              color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Row(
                                          children: [
                                            Icon(Icons.access_time,
                                                color: Colors.white70),
                                            Text(
                                              " October 9 ,  ",
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                            Text(
                                              "2022",
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.bookmark,
                                        color: Colors.white70),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(0xff7ebdf8),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.work_outline,
                                                color: Colors.white),
                                            // SizedBox(width: 8),
                                            Text('On Site',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(0xff7ebdf8),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons
                                                  .local_fire_department_outlined,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Part Time',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(0xff7ebdf8),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.location_on_outlined,
                                                color: Colors.white),
                                            Text('Remote',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      options: CarouselOptions(
                        height: 170,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    Text(
                      "Recent Jobs",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Job>?>(
                  future: bloc.getJobs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // SkeletonLoader for when the data is loading
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5, // Number of skeleton placeholders
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            enabled: true, // Show skeleton
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
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
                                  // Skeleton for image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      color: Colors.grey[
                                          300], // Grey placeholder for image
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: 100,
                                            height: 20,
                                            color: Colors.grey[
                                                300], // Skeleton for position text
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          color: Colors.grey[
                                              300], // Skeleton for bookmark icon
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      width: 150,
                                      height: 16,
                                      color: Colors.grey[
                                          300], // Skeleton for company name
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      width: 100,
                                      height: 16,
                                      color: Colors.grey[
                                          300], // Skeleton for location text
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      color: Colors.grey[
                                          300], // Skeleton for description
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors
                                              .grey[300], // Skeleton for salary
                                        ),
                                        Container(
                                          width: 50,
                                          height: 16,
                                          color: Colors.grey[
                                              300], // Skeleton for apply button
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final bloc2 = context.read<MainCubit>();
                        final item = data[index];

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
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
                                // Display image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: Image.network(
                                    item.companyLogo ?? '',
                                    fit: BoxFit.scaleDown,
                                    height: 200,
                                    width: double.infinity,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.expectedTotalBytes !=
                                                  null
                                              ? progress.cumulativeBytesLoaded /
                                                  (progress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.error, size: 50),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.position ?? 'No Position',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      BlocBuilder<MainCubit, MainState>(
                                        builder: (context, state) {
                                          return IconButton(
                                            onPressed: () {
                                              final newColor =
                                                  item.savedColor == Colors.grey
                                                      ? Colors.blue
                                                      : Colors.grey;
                                              context
                                                  .read<MainCubit>()
                                                  .changeColor(index, newColor);
                                            },
                                            icon: Icon(
                                              Icons.bookmark,
                                              color: item.savedColor,
                                              // Saved color
                                              size: 30,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    item.company ?? 'No Company',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    item.location ?? 'No Location',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Html(
                                    data: truncateHtml(item.description),
                                    style: {
                                      "p": Style(
                                          fontSize: FontSize(16), maxLines: 3),
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${item.salaryMin.toStringAsFixed(1)} - \$${item.salaryMax.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _launchUrl(item.applyUrl);
                                        },
                                        child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 70,
                        decoration: BoxDecoration(
                        color: Color(0xff09555c),
                        borderRadius:
                        BorderRadius.circular(18),
                        ),
                                          child: const Text('Apply',
                                              style:
                                                  TextStyle(color: Colors.white)),
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
