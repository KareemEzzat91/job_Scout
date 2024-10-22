import 'package:flutter/material.dart';
 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../Helpers/FireStoreHelper/FireStoreHelper.dart';
import '../Home/Skeletonizer/SkeletonizerHelper.dart';
import '../JobsModel/JobsModel.dart';
import '../Maincubit/main_cubit.dart';
import '../SearchScreen/job_details_screen.dart'; // Adjust the import path as necessary
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String truncateHtml(String html, {int length = 200}) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = html.replaceAll(exp, '');

    // Truncate if necessary
    return (plainText.length > length)
        ? '${plainText.substring(0, length)}...'
        : plainText;
  }

  @override
  Widget build(BuildContext context) {
    final iSDarkMode = Theme.of(context).brightness ==Brightness.dark;

    return Scaffold(

      body: FutureBuilder<List<Job>>(
        future: FireStoreHelper().fetchSavedJobs(),
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
                        item: item,image: logoDesigns[index%11],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl:logoDesigns[index%11],
                          fit: BoxFit.scaleDown,
                          width: double.infinity,
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
                                    } else {}
                                    showDialog(context: context, builder: (c){
                                      return AlertDialog(
                                        title:  const Text("DO YOU WANT TO DELETE THIS ITEM ?"),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);


                                          }, child: const Text("NO")),
                                          TextButton(onPressed: ()async {
                                           await FireStoreHelper().deleteSavedJob(item);
                                            Navigator.pop(context);
                                            setState(() {
                                            });

                                          }, child: const Text("Yes")),
                                        ],

                                      );
                                    });

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
                        child:
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
