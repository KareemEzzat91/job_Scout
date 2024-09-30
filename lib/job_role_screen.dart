import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobNameInputScreen extends StatefulWidget {
  @override
  _JobNameInputScreenState createState() => _JobNameInputScreenState();
}

class _JobNameInputScreenState extends State<JobNameInputScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredSuggestions = [];
  bool isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });


    final response = await http.get(Uri.parse('https://api.example.com/jobs?query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _filteredSuggestions = List<String>.from(jsonData.map((job) => job['name'] as String)); // Adjust based on API response
      });
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load job suggestions. Please try again later.'),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  void _clearSearch() {
    _controller.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'What job are you looking for?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Enter job name',
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
                child: ListView.builder(
                  itemCount: _filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredSuggestions[index]),
                      onTap: () {
                        Navigator.pop(context, _filteredSuggestions[index]);
                      },
                    );
                  },
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[300],
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, _controller.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a job name.')),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}