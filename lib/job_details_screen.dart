import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobDetailsScreen extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String description;
  final String position;
  final double salaryMin;
  final double salaryMax;
  final String applyUrl;
  final String logoUrl;

  JobDetailsScreen({
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.position,
    required this.salaryMin,
    required this.salaryMax,
    required this.applyUrl,
    required this.logoUrl,
  });

  Future<void> applyForJob(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(applyUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "company": company,

        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully applied for $title')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply for $title')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
              Image.network(
                logoUrl.isNotEmpty ? logoUrl : 'https://example.com/default_logo.png',
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(position, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text(company, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
              SizedBox(height: 8),
              Text(location, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 8),
              Text('Salary: \$${salaryMin.toStringAsFixed(2)} - \$${salaryMax.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 16),
              Text(description, style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => applyForJob(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue[200]),
                    child: Text('Apply'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved $title')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue[200]),
                    child: Text('Save'),
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