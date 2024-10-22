import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Helpers/FireStoreHelper/FireStoreHelper.dart';
import '../../../Helpers/kconstnt/constants.dart';
import '../JobsModel/JobsModel.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job item;
  final String image;

  const JobDetailsScreen({super.key, required this.item,required this.image });

  Future<void> _launchUrl(String url) async {
    final Uri url0 = Uri.parse(url); // Convert the string URL to a Uri
    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  }

  String checkImage() {
    String imageUrl = item.companyLogo;
    try {
      if (imageUrl.isEmpty) {
        return "assets/images/linkedin.png";
      }
      return imageUrl;
    } catch (e) {
      print("Error: $e");
      return "assets/images/linkedin.png"; // Fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          item.position,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: item.id,
                  child: CachedNetworkImage(
                    imageUrl:image,
                    fit: BoxFit.fitWidth,
                    height: 350,
                    placeholder: (context, url) => Image.asset("assets/images/black.jpg", fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Center(
                      child: Image.asset("assets/images/linkedin.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Position
              Text(
                item.position,
                style: GoogleFonts.monda(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Company Name
              Text(
                item.company,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: isDarkTheme ? Colors.grey[300] : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Job Location
              Text(
                item.location,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),

              // Salary Range
              Text(
                'Salary: \$${item.salaryMin.toStringAsFixed(2)} - \$${item.salaryMax.toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // Job Description
              Html(
                data: item.description,
                style: {
                  "h3": Style(
                    fontSize: FontSize(22),
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: Colors.blueAccent,
                  ),
                  "p": Style(
                    fontSize: FontSize(18),
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    color: isDarkTheme ? Colors.white : Colors.black87,
                  ),
                  "ul": Style(
                    padding: HtmlPaddings.symmetric(),
                    fontFamily: GoogleFonts.openSans().fontFamily,
                    fontSize: FontSize(16),
                    color: isDarkTheme ? Colors.white : Colors.black87,
                  ),
                  "li": Style(
                    margin: Margins.symmetric(),
                    fontFamily: GoogleFonts.lato().fontFamily,
                    fontSize: FontSize(16),
                    color: isDarkTheme ? Colors.white : Colors.black87,
                  ),
                },
              ),
              const SizedBox(height: 20),

              // Action Buttons (Apply, Save)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Apply Button
                  ElevatedButton(
                    onPressed: () => _launchUrl(item.applyUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.aBeeZee(color: Colors.white),
                    ),
                  ),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      FireStoreHelper().addToFirestoreUser(item);
                      FireStoreHelper().checkifexist(item);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            FireStoreHelper().isTrue ? ' Saved ${item.position}' : 'Already saved ${item.position}',
                            style: GoogleFonts.aclonica(color: Colors.blue[400]),
                          ),
                        ),
                      );
                      FireStoreHelper().addnumofapplytimes(numberofApply++);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                    ),
                    child: Text('Save', style: GoogleFonts.aBeeZee(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
