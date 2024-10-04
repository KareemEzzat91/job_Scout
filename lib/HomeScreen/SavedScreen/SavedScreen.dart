import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../FireStoreHelper/FireStoreHelper.dart';
import '../JobsModel/JobsModel.dart';
import '../Maincubit/main_cubit.dart';
import '../SearchScreen/job_details_screen.dart'; // Adjust the import path as necessary

class Savedscreen extends StatelessWidget {
  const Savedscreen({super.key});

  Future<List<Job>> fetchSavedJobs() async {
    List<Job> savedJobs = [];
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("SavedJobs").get();
      for (var doc in querySnapshot.docs) {
        savedJobs.add(Job.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print("Error fetching jobs: $e");
    }
    return savedJobs;
  }
  String truncateHtml(String html, {int length = 200}) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = html.replaceAll(exp, '');

    // Truncate if necessary
    return (plainText.length > length)
        ? plainText.substring(0, length) + '...'
        : plainText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<Job>>(
        future: fetchSavedJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching jobs'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Saved Jobs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          }

          final savedJobs = snapshot.data!;
          return ListView.builder(
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final item = savedJobs[index];

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
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                      // Display image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: item.companyLogo,
                          fit: BoxFit.scaleDown,
                          height: 200,
                          placeholder: (context, url) => Image.asset("assets/images/black.jpg", fit: BoxFit.cover),
                          errorWidget: (context, url, error) => Center(child: Image.asset("assets/images/linkedin.png")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.position,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            BlocBuilder<MainCubit, MainState>(
                              builder: (context, state) {
                                FireStoreHelper().checkifexist(item);
                                item.savedColor = FireStoreHelper().isTrue ? Colors.blue : Colors.grey;

                                return IconButton(
                                  onPressed: () {
                                    final newColor = item.savedColor == Colors.grey ? Colors.blue : Colors.grey;
                                    context.read<MainCubit>().changeColor(index, newColor);

                                    if (item.savedColor == Colors.grey) {
                                      FireStoreHelper().addToFirestore(item);
                                    } else {
                                      // Handle removal
                                    }
                                  },
                                  icon: Icon(Icons.bookmark, color: item.savedColor, size: 30),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          item.company,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          item.location,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: /*Text(
                          item.description,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )*/
                        Html(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${item.salaryMin.toStringAsFixed(1)} - \$${item.salaryMax.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
                                  color: const Color(0xff09555c),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Text('Apply', style: TextStyle(color: Colors.white)),
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
    );
  }

  void _launchUrl(String url) async {
    // Implement URL launching logic here
  }
}
