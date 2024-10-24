import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Home/Skeletonizer/SkeletonizerHelper.dart';
import 'job_details_screen.dart';
import 'job_location_screen.dart';
import 'job_role_screen.dart';
import '../JobsModel/JobsModel.dart';


class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  String searchQuery = '';
  String locationQuery = '';
  List<Job> jobResults = [];
  bool isLoading = false;
  void searchJobs() async {
    if (searchQuery.isEmpty && locationQuery.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('https://api.example.com/jobs?search=$searchQuery&location=$locationQuery'));
    if (response.statusCode == 200) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to load jobs. Please try again later.'),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [

              TextField(
                onTap: () async {
                  final jobName = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JobNameInputScreen()),
                  );
                  if (jobName != null) {
                    setState(() {
                      searchQuery = jobName;
                    });
                  }
                },
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Search job, company',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                onTap: () async {
                  final location = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JobLocationInputScreen()),
                  );
                  if (location != null) {
                    setState(() {
                      locationQuery = location;
                    });
                  }
                },
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on, color: Colors.grey[700]),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: searchQuery.isNotEmpty || locationQuery.isNotEmpty ? searchJobs : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Search', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: jobResults.length,
                  itemBuilder: (context, index) {
                    final Job item =  jobResults[index];
                    return ListTile(
                      title: Text(jobResults[index].position),
                      subtitle: Text('${jobResults[index].company} - ${jobResults[index].location}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsScreen( item:item ,image: logoDesigns[index%11],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
