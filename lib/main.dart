import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'views/video_cell.dart';

void main() {
  runApp(RealWorldApp());
}

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  var _isLoading = true;

  var videos;

  _fetchData() async {
    print('Attempting to fetch data from network');

    final url = 'https://api.letsbuildthatapp.com/youtube/home_feed';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // print(response.body);

      final map = json.decode(response.body);
      final videosJson = map["videos"];

      // videosJson.forEach((video) {
      //   print(video["name"]);
      // });

      setState(() {
        _isLoading = false;
        this.videos = videosJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Real World App Bar'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                print('Reloading...');
                setState(() {
                  _isLoading = true;
                });
                _fetchData();
              },
            ),
          ],
        ),
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: this.videos != null ? this.videos.length : 0,
                  itemBuilder: (context, i) {
                    final video = this.videos[i];
                    return FlatButton(
                      padding: EdgeInsets.all(0.0),
                      child: VideoCell(video),
                      onPressed: () {
                        print('Video cell tapped: $i');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Text('Detail detail detail'),
      ),
    );
  }
}
