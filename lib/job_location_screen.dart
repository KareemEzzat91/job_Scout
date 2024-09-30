import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobLocationInputScreen extends StatefulWidget {
  @override
  _JobLocationInputScreenState createState() => _JobLocationInputScreenState();
}

class _JobLocationInputScreenState extends State<JobLocationInputScreen> {
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

    try {
      final response = await http.get(Uri.parse('https://api.example.com/locations?query=$query'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _filteredSuggestions = List<String>.from(jsonData.map((location) => location['name'] as String));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to load locations. Please try again later.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _controller.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Where is your location?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
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
                child: ListView.builder(
                  itemCount: _filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _filteredSuggestions[index],
                        style: TextStyle(color: Colors.black),
                      ),
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
                Navigator.pop(context, _controller.text);
              },
              child: Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
