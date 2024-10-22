import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../Helpers/kconstnt/constants.dart';
import '../../../Helpers/responsive/responsive.dart';
import '../../../main.dart';
import '../../DrawerScreens/Profile/ProfileScreen.dart';
import '../../Firebasenotofication/NotoficationScreen.dart';
import '../Maincubit/main_cubit.dart';
import '../JobsModel/JobsModel.dart';
import 'Skeletonizer/SkeletonizerHelper.dart';

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
                SizedBox(height: 10,),
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
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                           CircleAvatar(
                            backgroundImage: AssetImage('assets/images/OIP (4).jpeg'),
                            radius: Responsive.TextSize(context,isExtraSmallSize:27,isMobileSize: 30,isMobileLarge:36,isIpadSize: 57,isTabletSize: 73,isLargeTabletSize: 90,defaultSize: 20  ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Responsive.TextSize(context,isExtraSmallSize:200,isMobileSize: 220,isMobileLarge:300,isIpadSize: 560,isTabletSize: 550,isLargeTabletSize: 760,defaultSize: 230  ),
                                child: Text(
                                  "Welcome Back ${FirebaseAuth.instance.currentUser?.displayName ?? ""}",
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style:TextStyle(
                                      color: iSDarkMode?Colors.white:Colors.black,
                                      fontSize: Responsive.TextSize(context,isExtraSmallSize:12,isMobileSize: 15,isMobileLarge:20,isIpadSize: 35,isTabletSize: 40,isLargeTabletSize: 55,defaultSize: 24  ),
                                      fontWeight: FontWeight.bold),
                                ),
                               ),
                              const SizedBox(height: 6),
                              Text(
                                'You have applied to $numberofApply jobs this week.',
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.9)// لون النص في الثيم الداكن
                                      : Colors.black.withOpacity(0.7), // لون النص في الثيم الفاتح
                                  fontSize: Responsive.TextSize(context,isExtraSmallSize:9,isMobileSize: 11,isMobileLarge:16,isIpadSize: 30,isTabletSize: 32,isLargeTabletSize: 37,defaultSize: 20  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                 SizedBox(height: Responsive.TextSize(context,isExtraSmallSize:17,isMobileSize: 20,isMobileLarge:30,isIpadSize: 46,isTabletSize: 53,isLargeTabletSize: 55,defaultSize: 20  )),
                // Title
                 Text(
                  'Job Analytics',
                  style: TextStyle(fontSize: Responsive.TextSize(context,isExtraSmallSize:18,isMobileSize: 21,isMobileLarge:20,isIpadSize: 40,isTabletSize: 50,isLargeTabletSize: 60,defaultSize: 30  ), fontWeight: FontWeight.bold),
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
                        height: Responsive.TextSize(context,isExtraSmallSize:210,isMobileSize: 210,isMobileLarge:255,isIpadSize: 330,isTabletSize: 380,isLargeTabletSize: 460,defaultSize: 20  ), // Set height based on your content
                      ),

                      // Card content on top of the background
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Active Jobs',
                              style: TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.73) , fontSize: Responsive.TextSize(context,isExtraSmallSize:15,isMobileSize: 18,isMobileLarge:22,isIpadSize: 44,isTabletSize: 55,isLargeTabletSize: 65,defaultSize: 20  )),
                            ),
                            const SizedBox(height: 10),
                             Text(
                              '${ bloc.JobModels.isEmpty ?"42": bloc.JobModels.length} Jobs',
                              style:  TextStyle(
                                  color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.93) ,
                                  fontSize: Responsive.TextSize(context,isExtraSmallSize:28,isMobileSize: 32,isMobileLarge:30,isIpadSize: 46,isTabletSize: 53,isLargeTabletSize: 70,defaultSize: 20  ),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                             Text(
                              'You applied for $numberofApply jobs this month',
                              style:  TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.83), fontSize: Responsive.TextSize(context,isExtraSmallSize:12,isMobileSize: 14,isMobileLarge:20,isIpadSize: 38,isTabletSize: 40,isLargeTabletSize: 45,defaultSize: 20  )),
                            ),
                            const SizedBox(height: 22),
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
                                    style: TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.73),fontSize:Responsive.TextSize(context,isExtraSmallSize:10,isMobileSize: 12,isMobileLarge:20,isIpadSize: 28,isTabletSize: 31,isLargeTabletSize: 35,defaultSize: 20  ) ),
                                  ),
                                  Text(
                                    'Reached: $numberofApply  ',
                                    style:  TextStyle(color: iSDarkMode?Theme.of(context).textTheme.bodySmall?.color:Colors.white.withOpacity(0.73),fontSize:Responsive.TextSize(context,isExtraSmallSize:10,isMobileSize: 12,isMobileLarge:20,isIpadSize: 28,isTabletSize: 31,isLargeTabletSize: 35,defaultSize: 20  )),
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

                 SizedBox(height: Responsive.TextSize(context,isExtraSmallSize:20,isMobileSize: 24,isMobileLarge:20,isIpadSize: 33,isTabletSize: 40,isLargeTabletSize: 50,defaultSize: 230  )),

                // Bar Chart placeholder
                 Text(
                  'Applications Over Time',
                  style: TextStyle(fontSize: Responsive.TextSize(context,isExtraSmallSize:18,isMobileSize: 21,isMobileLarge:20,isIpadSize: 40,isTabletSize: 50,isLargeTabletSize: 60,defaultSize: 230  ), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(height: Responsive.TextSize(context,isExtraSmallSize:230,isMobileSize: 260,isMobileLarge:300,isIpadSize: 460,isTabletSize: 450,isLargeTabletSize:560,defaultSize: 230  ), child: _buildBarChart(context)),
                const SizedBox(height: 20),
                // Dashboard Stats
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDashboardItem(Icons.work, "Active Jobs", " ${ bloc.JobModels.isEmpty ?"42": bloc.JobModels.length} ", Colors.pink,iSDarkMode,context),
                    _buildDashboardItem(Icons.people, "Candidates", "298", Colors.yellow,iSDarkMode,context),
                    _buildDashboardItem(Icons.event, "Events", "54", Colors.blue,iSDarkMode,context),
                    _buildDashboardItem(Icons.check_circle, "To-dos", "48", Colors.green,iSDarkMode,context),
                  ],
                ),
                const SizedBox(height: 20),
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
                              ),context,
                              color: bloc.tagColors["All"],
                            )),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Software");
                          },
                          child: _tag("Software",
                              const Icon(Icons.computer, color: Colors.grey),context,
                            color:  bloc.tagColors["Software"],ISDarkMode: iSDarkMode,

                          ),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Design");
                          },
                          child: _tag("Design",
                              const Icon(Icons.design_services, color: Colors.grey),context,
                            color:  bloc.tagColors["Design"],ISDarkMode:iSDarkMode ,
                          ),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Management");
                          },
                          child: _tag("Management",
                              const Icon(Icons.manage_accounts, color: Colors.grey),context,
                              color: bloc.tagColors["Management"],ISDarkMode: iSDarkMode),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Developer");
                          },
                          child: _tag("Developer",
                              const Icon(Icons.developer_mode, color: Colors.grey),context,
                              color: bloc.tagColors["Developer"],ISDarkMode: iSDarkMode),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Security");
                          },
                          child: _tag("Security",
                              const Icon(Icons.security, color: Colors.grey),context,
                              color: bloc.tagColors["Security"],ISDarkMode: iSDarkMode),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            bloc.changecolor("Senior");
                          },
                          child: _tag(
                              "Senior", const Icon(Icons.scale, color: Colors.grey),context,
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
                      return buildCarouselSliderLoading();
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

                    return buildCarouselSliderDone(jobBanners, context);
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
                      return buildHomeProductsLoading();
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

                    return BuildHomeProductsDone(data, iSDarkMode);
                  },
                ), //Home
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tag(String tagName, Icon icon,context,
      {double width = 91, double height = 80, Color ?color = Colors.white,bool ISDarkMode=false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.center,
      height: Responsive.TextSize(context,isExtraSmallSize:height,isMobileSize: height,isMobileLarge:100,isIpadSize: 130,isTabletSize: 150,isLargeTabletSize: 155,defaultSize: 20  ),
      width:  Responsive.TextSize(context,isExtraSmallSize:width,isMobileSize: width,isMobileLarge:100,isIpadSize: 130,isTabletSize: 150,isLargeTabletSize: 155,defaultSize: 20  ),
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
            style:  TextStyle(color: ISDarkMode?Colors.white:Colors.grey, fontSize: Responsive.TextSize(context,isExtraSmallSize:12,isMobileSize: 12,isMobileLarge:15,isIpadSize: 21,isTabletSize: 40,isLargeTabletSize: 45,defaultSize: 20  )),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String label, String value, Color color,bool ISDarkMode,context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding:  EdgeInsets.all( Responsive.TextSize(context,isExtraSmallSize:15,isMobileSize: 16,isMobileLarge:19,isIpadSize: 22,isTabletSize: 25,isLargeTabletSize: 30,defaultSize: 20  )),
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
          Icon(icon, color: color, size:  Responsive.TextSize(context,isExtraSmallSize:15,isMobileSize: 33,isMobileLarge:38,isIpadSize: 59,isTabletSize: 70,isLargeTabletSize: 90,defaultSize: 30  )),
          const SizedBox(height: 10),
          Text(
            value,
            style:  TextStyle(
              fontSize:  Responsive.TextSize(context,isExtraSmallSize:15,isMobileSize: 20,isMobileLarge:25,isIpadSize: 44,isTabletSize: 50,isLargeTabletSize: 55,defaultSize: 20  ),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label,style: TextStyle(fontSize:  Responsive.TextSize(context,isExtraSmallSize:10,isMobileSize: 18,isMobileLarge:23,isIpadSize: 30,isTabletSize: 40,isLargeTabletSize: 45,defaultSize: 13  )),),
        ],
      ),
    );
  }

// Placeholder bar chart implementation (You can customize this)
  Widget _buildBarChart(context) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.TextSize(context,isExtraSmallSize:12,isMobileSize: 15,isMobileLarge:20,isIpadSize: 20,isTabletSize: 40,isLargeTabletSize: 45,defaultSize: 20  ),
                );
                switch (value.toInt()) {
                  case 0:
                    return  Text('Jan', style: style);
                  case 1:
                    return  Text('Feb', style: style);
                  case 2:
                    return  Text('Mar', style: style);
                  case 3:
                    return  Text('Apr', style: style);
                  case 4:
                    return  Text('May', style: style);
                  case 5:
                    return  Text('Jun', style: style);
                  case 6:
                    return  Text('Jul', style: style);
                  case 7:
                    return  Text('Aug', style: style);
                  default:
                    return Container();
                }
              },
            ),
          ),
        ),
        barGroups: [
          _makeBarGroup(0, 10, 5,context), // For January
          _makeBarGroup(1, 50, 30,context), // For February
          _makeBarGroup(2, 80, 50,context), // For March
          _makeBarGroup(3, 120, 60,context), // For April
          _makeBarGroup(4, 40, 20,context), // For May
          _makeBarGroup(5, 50, 30,context), // For June
          _makeBarGroup(6, 30, 15,context), // For July
          _makeBarGroup(7, 40, 20,context), // For August
        ],
      ),
    );
  }

// Helper method for bar chart groups
  BarChartGroupData _makeBarGroup(int x, double applied, double qualified,context) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: applied,
          color: Colors.blue,
          width: Responsive.TextSize(context,isExtraSmallSize:12,isMobileSize: 12,isMobileLarge:20,isIpadSize: 28,isTabletSize: 45,isLargeTabletSize: 50,defaultSize: 20  ),
        ),
        BarChartRodData(
          toY: qualified,
          color: Colors.green,
          width: Responsive.TextSize(context,isExtraSmallSize:12,isMobileSize: 12,isMobileLarge:20,isIpadSize: 28,isTabletSize: 46,isLargeTabletSize: 50,defaultSize: 20  ),
        ),
      ],
    );
  }




}
