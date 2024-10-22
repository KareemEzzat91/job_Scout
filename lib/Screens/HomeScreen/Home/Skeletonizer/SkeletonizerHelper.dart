
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Helpers/FireStoreHelper/FireStoreHelper.dart';
import '../../../../Helpers/kconstnt/constants.dart';
import '../../../../Helpers/responsive/responsive.dart';
import '../../JobsModel/JobsModel.dart';
import '../../Maincubit/main_cubit.dart';
import '../../SearchScreen/job_details_screen.dart';


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
List<String> logoDesigns = [
  "https://techboard.com.au/wp-content/uploads/2015/09/aurora_labs_logo-MASTER.jpg",
  "https://static.vecteezy.com/system/resources/previews/020/396/436/original/eot-letter-logo-design-on-white-background-eot-creative-circle-letter-logo-concept-eot-letter-design-vector.jpg",
  "https://global.discourse-cdn.com/flex003/uploads/jupresear/original/2X/a/a589fc15db03f6af129cdc63bed96958b4710356.jpeg"
  ,  "https://gust-production.s3.amazonaws.com/uploads/startup/logo_image/722636/1.png",
  "https://th.bing.com/th/id/R.99f73e4d2f2f29f269f0245f275a8eff?rik=Ra5eCA9cexqnDQ&riu=http%3a%2f%2fgoldengateobgyn.org%2fwp-content%2fuploads%2f2016%2f03%2falto_pharmacy.jpg&ehk=hMbqoZ4F0wKBt6ju9Cxh2GiYRyZj4QTBsA81HLea26w%3d&risl=&pid=ImgRaw&r=0"

      "https://s5.cdn.memeburn.com/wp-content/uploads/2019/03/BurnM-65.jpg",
  "https://i.pinimg.com/originals/80/5e/be/805ebe40b10a2e7e1461cd021990ac31.png",
  "https://img.freepik.com/premium-vector/creative-letter-s-logotype-abstract-hexagon-with-pixel-technology-logo-design-creative-dynamic-round-logotype-connection-symbol-design_144543-1685.jpg",
  "https://t3.ftcdn.net/jpg/01/02/97/52/240_F_102975288_L4aqjlxXoZrkg0CVvBXmnS78obUY9NFL.jpg",
  "https://www.panoramaed.com/hs-fs/hubfs/PanoramaEducation_Logo_Vertical_Digital_FullColor.png?width=733&name=PanoramaEducation_Logo_Vertical_Digital_FullColor.png",
  "https://openvisualfx.com/wp-content/uploads/2019/10/linkedin-icon-logo-png-transparent.png",
  "https://th.bing.com/th/id/OIP.uPHUV6PTGKLPb9jC04sHRgHaEK?w=1600&h=900&rs=1&pid=ImgDetMain",
  "https://images.g2crowd.com/uploads/product/image/large_detail/large_detail_99a0bed55d4f2f75e47e38d39afa6c96/brightly-theworxhub.png",
];



ListView BuildHomeProductsDone(List<Job> data, bool iSDarkMode) {
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
                item: item,image: logoDesigns[index%11],
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
                    imageUrl: logoDesigns[index%12],
                    fit: BoxFit.scaleDown,width: double.infinity,
                    height: 200,
                    placeholder: (context, url) => Image.asset("assets/images/black.jpg", width: double.infinity,fit: BoxFit.cover),
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
}

ListView buildHomeProductsLoading() {
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

CarouselSlider buildCarouselSliderDone(List<Job> jobBanners, BuildContext context) {
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
                  item: jobBanners[i],image:logoDesigns[i%11] ,
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
                          imageUrl: logoDesigns[i%11],
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
                          width: Responsive.TextSize(context,isExtraSmallSize:180,isMobileSize: 200,isMobileLarge:250,isIpadSize: 300,isTabletSize: 400,isLargeTabletSize: 500,defaultSize: 20  ),
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
                              width:  Responsive.TextSize(context,isExtraSmallSize:70,isMobileSize: 70,isMobileLarge:90,isIpadSize: 100,isTabletSize: 110,isLargeTabletSize: 120,defaultSize: 10  ),
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
}

CarouselSlider buildCarouselSliderLoading() {
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

