import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../JobsModel/JobsModel.dart';
import '../Maincubit/main_cubit.dart';
import 'job_details_screen.dart';

class JobLocationInputScreen extends StatefulWidget {
  @override
  _JobLocationInputScreenState createState() => _JobLocationInputScreenState();
}

class _JobLocationInputScreenState extends State<JobLocationInputScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Job> _filteredSuggestions = [];
  bool isLoading = false;

  void _onSearchChanged(String query,List <Job>JOBS) async {
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });


    List <Job> results =JOBS.where((job)=>job.location.toLowerCase().contains(query.toLowerCase())).map((job)=>job ).toList();



    setState(() {
      _filteredSuggestions  = results;
      isLoading = false
      ;
    });

  }

  void _clearSearch() {
    _controller.clear();
    _onSearchChanged('',[]);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainCubit>();
    final list = bloc.JobModels;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue[400], title: Text('Location Search',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),

      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where is your location?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controller,
              onChanged: (val)=> _onSearchChanged(val,list),
              decoration: InputDecoration(
                hintText: 'Enter location',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[300],
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
              ),
              style: TextStyle(color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio: 0.8, // Adjusted aspect ratio to fit more content
                  ),
                  itemCount: _filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    final item = _filteredSuggestions[index];
                    return GestureDetector(
                      onTap:  (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsScreen(item:item ,
                            ),
                          ),
                        );

                      },
                      child: Container(

                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/flat.jpg'), // Your image path
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.05),
                              BlendMode.dstATop,
                            ),
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xff62cff4),
                              Color(0xff2c67f2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Company Logo
                            Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  _filteredSuggestions[index].companyLogo,
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
                            SizedBox(height: 10),

                            // Company Name
                            Text(
                              _filteredSuggestions[index].company,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // To avoid text overflow
                            ),
                            SizedBox(height: 5),

                            // Job Position
                            Text(
                              _filteredSuggestions[index].position,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),

                            // Location and Salary
                            Text(
                              _filteredSuggestions[index].location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "\$${_filteredSuggestions[index].salaryMin} - \$${_filteredSuggestions[index].salaryMax}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),

                            Spacer(),

                            // Buttons (Job Type, Work Mode, Location)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(0xff7ebdf8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
/*
                                        Icon(Icons.work_outline, color: Colors.white, size: 14),
*/
                                        SizedBox(width: 4),
                                        Text('On Site',  overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white, fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(0xff7ebdf8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
/*
                                        Icon(Icons.access_time_outlined, color: Colors.white, size: 14),
*/
                                        SizedBox(width: 4),
                                        Text('Part Time', style: TextStyle(color: Colors.white, fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text('Finish',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}