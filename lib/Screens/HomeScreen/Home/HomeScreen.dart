import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helpers/FireStoreHelper/FireStoreHelper.dart';
import '../../../Helpers/kconstnt/constants.dart';
import '../../../main.dart';
import '../../DrawerScreens/Profile/ProfileScreen.dart';
import '../../Firebasenotofication/NotoficationScreen.dart';
import '../Maincubit/main_cubit.dart';
import '../SearchScreen/job_details_screen.dart';
import '../JobsModel/JobsModel.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  String truncateHtml(String html, {int length = 100}) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = html.replaceAll(exp, '');

    // Truncate if necessary
    return (plainText.length > length)
        ? '${plainText.substring(0, length)}...'
        : plainText;
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri url0 = Uri.parse(url); // Convert the string URL to a Uri
      if (!await launchUrl(url0)) {
        throw Exception('Could not launch $url0');
      }
    }catch (e){
      throw Exception('Could not launch $e');
    }

  }
  final color = Colors.white;

   final List<Job> JobBanners = [];

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainCubit>();
    final iSDarkMode = Theme.of(context).brightness ==Brightness.dark;

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
            duration: const Duration(seconds: 5),
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

        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>ProfileScreen()));
                  },

                  child: Card(color: iSDarkMode?Colors.black:Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/OIP (4).jpeg'),
                            radius: 30,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "Welcome Back ${FirebaseAuth.instance.currentUser?.displayName ?? ""}",
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style:   TextStyle(
                                      color: iSDarkMode?Colors.white:Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                               ),
                              const SizedBox(height: 4),
                              Text(
                                'You have applied to $numberofApply jobs this week.',
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.9)// لون النص في الثيم الداكن
                                      : Colors.black.withOpacity(0.7), // لون النص في الثيم الفاتح
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Title
                const Text(
                  'Job Analytics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Earnings/Job Stats Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  color: Colors.transparent, // Set the card's background to transparent
                  child: Stack(
                    children: [
                      // Background image container
                      Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF263238), Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),

                            borderRadius: BorderRadius.circular(12),
                          image:  DecorationImage(
                            image: AssetImage(iSDarkMode?"assets/images/MoonKnightImage.jpg":'assets/images/Clouds.jpg'), // Path
                            opacity:iSDarkMode? 0.23:0.3,
                            // to your image
                            fit: BoxFit.cover, // Ensures the image covers the entire card
                          ),
                          color: Theme.of(context).primaryColor
                        ),
                        height: 220, // Set height based on your content
                      ),

                      // Card content on top of the background
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Active Jobs',
                              style: TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.73) , fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                             Text(
                              '${ bloc.JobModels.isEmpty ?"42": bloc.JobModels.length} Jobs',
                              style:  TextStyle(
                                  color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.93) ,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                             Text(
                              'You applied for $numberofApply jobs this month',
                              style:  TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.83), fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Text(
                                    'Monthly Target: 30 Jobs',
                                    style: TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.73)),
                                  ),
                                  Text(
                                    'Reached: $numberofApply  ',
                                    style:  TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.73)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Bar Chart placeholder
                const Text(
                  'Applications Over Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(height: 200, child: _buildBarChart()),
                const SizedBox(height: 20),
                // Dashboard Stats
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDashboardItem(Icons.work, "Active Jobs", " ${ bloc.JobModels.isEmpty ?"42": bloc.JobModels.length} ", Colors.pink,iSDarkMode),
                    _buildDashboardItem(Icons.people, "Candidates", "298", Colors.yellow,iSDarkMode),
                    _buildDashboardItem(Icons.event, "Events", "54", Colors.blue,iSDarkMode),
                    _buildDashboardItem(Icons.check_circle, "To-dos", "48", Colors.green,iSDarkMode),
                  ],
                ),
                const SizedBox(height: 20),
                // Job Analytics Bar Chart
                // Placeho
                /////////////////////// lder for chart
                const SizedBox(
                  height: 20,
                ),
                //-----------------------------------------------------------------------------------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: BlocBuilder<MainCubit, MainState>(
                    builder: (context,state) {
                      final bloc = context.read<MainCubit>();

                    return Row(
                      children: [
                        InkWell(
                            onTap: () {
                              bloc.changecolor("All");
                            },
                            child: _tag(
                              "All",
                              const Icon(
                                Icons.all_inclusive_outlined,
                                color: Colors.grey,
                              ),
                              color: bloc.tagColors["All"],
                            )),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Software");
                          },
                          child: _tag("Software",
                              const Icon(Icons.computer, color: Colors.grey),
                            color:  bloc.tagColors["All"],ISDarkMode: iSDarkMode,

                          ),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Design");
                          },
                          child: _tag("Design",
                              const Icon(Icons.design_services, color: Colors.grey),
                            color:  bloc.tagColors["All"],ISDarkMode:iSDarkMode ,
                          ),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Management");
                          },
                          child: _tag("Management",
                              const Icon(Icons.manage_accounts, color: Colors.grey),
                              color: bloc.tagColors["Management"],ISDarkMode: iSDarkMode),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Developer");
                          },
                          child: _tag("Developer",
                              const Icon(Icons.developer_mode, color: Colors.grey),
                              color: bloc.tagColors["Developer"],ISDarkMode: iSDarkMode),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Security");
                          },
                          child: _tag("Security",
                              const Icon(Icons.security, color: Colors.grey),
                              color: bloc.tagColors["Security"],ISDarkMode: iSDarkMode),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Senior");
                          },
                          child: _tag(
                              "Senior", const Icon(Icons.scale, color: Colors.grey),
                              color: bloc.tagColors["Senior"],ISDarkMode: iSDarkMode),
                        ),
                        const SizedBox(width: 14),
                      ],
                    );
                  }

                  ),
                ),
                const SizedBox(height: 10,),

                //-------------------------------------------------------------------------------------
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
                              padding: const EdgeInsets.all(10),
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                backgroundBlendMode: BlendMode.dst,
                                image: DecorationImage(
                                    image:
                                        const AssetImage('assets/images/black.jpg'),
                                    // Your image URL
                                    fit: BoxFit.cover,
                                    // Adjusts how the image fits inside the container
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.2),
                                      // Adjust the transparency here
                                      BlendMode.dstATop,
                                    )),
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailsScreen(
                                    item: jobBanners[i],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 170,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        const AssetImage('assets/images/black.avif'),
                                    // Your image URL
                                    fit: BoxFit.cover,
                                    // Adjusts how the image fits inside the container
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.2),
                                      // Adjust the transparency here
                                      BlendMode.dstATop,
                                    )),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF263238), Colors.blueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                color: Colors.blue[400],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            imageUrl: jobBanners[i].companyLogo,
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
                                                  "assets/images/photo_2024-09-16_15-28-23-removebg-preview.png"),
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
                                          SizedBox(
                                            width: 220,
                                            child: Text(
                                              jobBanners[i].company,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time,
                                                  color: Colors.white70),
                                              Text(
                                                jobBanners[i].date.length > 10
                                                    ? '${jobBanners[i].date.substring(0, 10)}...'
                                                    : jobBanners[i].date,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      BlocBuilder<MainCubit, MainState>(
                                        builder: (context, state) {
                                          return IconButton(
                                            onPressed: () {
                                              final newColor =
                                                  jobBanners[i].savedColor ==
                                                          Colors.grey
                                                      ? Colors.redAccent
                                                      : Colors.grey;
                                              context
                                                  .read<MainCubit>()
                                                  .changeColor(i, newColor);
                                            },
                                            icon: Icon(
                                              Icons.bookmark,
                                              color: jobBanners[i].savedColor,
                                              // Saved color
                                              size: 30,
                                            ),
                                          );
                                        },
                                      ),
                                      // const Icon(Icons.bookmark,
                                      //     color: Colors.white70),
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
                                            color: const Color(0xff3c6EAE),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
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
                                            color: const Color(0xff3c6EAE),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
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
                                            color: const Color(0xff3c6EAE),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child:  Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(Icons.location_on_outlined,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                    jobBanners[i].location,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
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
                ), //Banners
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
                                    offset: const Offset(0, 3),
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
                        final item = data[index];


                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailsScreen(
                                  item: item,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:iSDarkMode?Colors.black :Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
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
                                  child:Hero(
                                    transitionOnUserGestures: true,
                                    tag: item.id,
                                    child: CachedNetworkImage(
                                      imageUrl: item.companyLogo,
                                      fit: BoxFit.scaleDown,
                                      height: 200,
                                      placeholder: (context, url) => Image.asset("assets/images/black.jpg", fit: BoxFit.cover),
                                      errorWidget: (context, url, error) => Center(
                                        child: Image.asset("assets/images/linkedin.png"),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.position  ,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      BlocBuilder<MainCubit, MainState>(
                                        builder: (context, state) {
                                          return IconButton(
                                            onPressed: () {
                                              final newColor = item.savedColor == Colors.grey ? Colors.blue : Colors.grey;
                                            final checked =   context.read<MainCubit>().changeColor(index, newColor);
                                              checked ?FireStoreHelper().addToFirestoreUser(item) :
                                              showDialog(context: context, builder: (c){
                                                return AlertDialog(
                                                  title:  const Text("DO YOU WANT TO DELETE THIS ITEM From Saved  ?"),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      Navigator.pop(context);

                                                    }, child: const Text("NO")),
                                                    TextButton(onPressed: (){
                                                      FireStoreHelper().deleteSavedJob(item);
                                                      Navigator.pop(context);

                                                    }, child: const Text("Yes")),
                                                  ],

                                                );
                                              });

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

                                    item.company  ,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    item.location  ,
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
                                          fontSize: FontSize(16), maxLines: 2),
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
                                          FireStoreHelper().addnumofapplytimes(numberofApply++);
                                        _launchUrl(item.applyUrl);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff09555c),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          child: const Text('Apply',
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                ), //Home
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _tag(String tagName, Icon icon,
      {double width = 91, double height = 80, Color ?color = Colors.white,bool ISDarkMode=false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: ISDarkMode?Colors.black:color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 6),
          Text(
            tagName,
            style:  TextStyle(color: ISDarkMode?Colors.white:Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String label, String value, Color color,bool ISDarkMode) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:ISDarkMode ?Colors.black:Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }

  // Placeholder bar chart implementation (You can customize this)
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                );
                switch (value.toInt()) {
                  case 0:
                    return const Text('Jan', style: style);
                  case 1:
                    return const Text('Feb', style: style);
                  case 2:
                    return const Text('Mar', style: style);
                  case 3:
                    return const Text('Apr', style: style);
                  case 4:
                    return const Text('May', style: style);
                  case 5:
                    return const Text('Jun', style: style);
                  case 6:
                    return const Text('Jul', style: style);
                  case 7:
                    return const Text('Aug', style: style);
                  default:
                    return Container();
                }
              },
            ),
          ),
        ),
        barGroups: [
          _makeBarGroup(0, 10, 5), // For January
          _makeBarGroup(1, 50, 30), // For February
          _makeBarGroup(2, 80, 50), // For March
          _makeBarGroup(3, 120, 60), // For April
          _makeBarGroup(4, 40, 20), // For May
          _makeBarGroup(5, 50, 30), // For June
          _makeBarGroup(6, 30, 15), // For July
          _makeBarGroup(7, 40, 20), // For August
        ],
      ),
    );
  }

  // Helper method for bar chart groups
  BarChartGroupData _makeBarGroup(int x, double applied, double qualified) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: applied,
          color: Colors.blue,
          width: 12,
        ),
        BarChartRodData(
          toY: qualified,
          color: Colors.green,
          width: 12,
        ),
      ],
    );
  }

}
