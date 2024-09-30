import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jobscout/HomeScreen/JobsModel/JobsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job item;

  JobDetailsScreen({required this.item});

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url); // Convert the string URL to a Uri
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ClipRect(
                child: CachedNetworkImage(
                  imageUrl: item.companyLogo, fit: BoxFit.fitWidth,height:350 ,placeholder: (c,e)=>Image.asset("assets/images/black.jpg", fit: BoxFit.cover),errorWidget: (c, u, e) => Image.asset(
                    "assets/images/linkedin.png"),
                ),

              ),
              SizedBox(height: 16),

              // Position
              Text(item.position ,style: GoogleFonts.monda(fontWeight: FontWeight.bold,fontSize: 25),),
              SizedBox(height: 8),

              // Company Name
              Text(
                item.company,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,  // Slightly bold for emphasis
                ),
              ),
              SizedBox(height: 8),

// Job Location
              Text(
                item.location,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),

// Salary Range
              Text(
                'Salary: \$${item.salaryMin.toStringAsFixed(2)} - \$${item.salaryMax.toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              // Job Description
              Html(
                data: item.description,
                style: {
                  "h3": Style(
                    fontSize: FontSize(22),  // Perfect for headings
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,  // Elegant and modern for headings
                    color: Colors.blueAccent,  // Set a nice color for headings
                  ),
                  "p": Style(
                    fontSize: FontSize(18),  // A bit larger for readability
                    fontFamily: GoogleFonts.roboto().fontFamily,  // Perfect for body text
                    color: Colors.black87,  // Standard dark text color
                  ),
                  "ul": Style(
                    padding:HtmlPaddings.symmetric()  ,  // Spacing around the list
                    fontFamily: GoogleFonts.openSans().fontFamily,  // Clean font for lists
                    fontSize: FontSize(16),
                    color: Colors.black87,  // Same color for consistency
                  ),
                  "li": Style(
                    margin: Margins.symmetric(),  // Spacing between list items
                    fontFamily: GoogleFonts.lato().fontFamily,  // Soft and readable for list items
                    fontSize: FontSize(16),
                    color: Colors.black87,  // Same color for consistency
                  ),
                },
              ),              SizedBox(height: 20),

              // Action Buttons (Apply, Save)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Apply Button
                  ElevatedButton(
                    onPressed: () => _launchUrl(item.applyUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[200],
                    ),
                    child: Text('Apply',style: GoogleFonts.aBeeZee(color: Colors.white),),
                  ),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(

                        SnackBar(content: Text('Saved ${item.position}',style:GoogleFonts.aclonica(color: Colors.blue[400],) ,)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[200],
                    ),
                    child: Text('Save',style: GoogleFonts.aBeeZee(color: Colors.white)),
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