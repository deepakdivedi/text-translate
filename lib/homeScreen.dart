import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Translate text'),
        ),
        body: Center(
          child: FutureBuilder<TranslatedData>(
            future: getTranslatedData('ja','hello'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(snapshot.data.translatedText,style: TextStyle(fontSize: 58),),
                      SizedBox(
                        width : 500.0,
                        height: 500.0,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }


  Future<TranslatedData> getTranslatedData(String target,String textData) async {
    String url = "https://translation.googleapis.com/language/translate/v2?target=$target&key=APIKEY&q=$textData";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return TranslatedData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }
}

class TranslatedData {
  final String translatedText;
  final String detectedSourceLanguage;

  TranslatedData({this.translatedText, this.detectedSourceLanguage});

  factory TranslatedData.fromJson(Map<String, dynamic> json) {
    return TranslatedData(
        translatedText: json['data']['translations'][0]['translatedText'],
        detectedSourceLanguage: json['data']['translations'][0]['detectedSourceLanguage']);
  }
}
