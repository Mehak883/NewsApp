// ignore_for_file: avoid_print, file_names
import 'package:flutter/foundation.dart';
import 'package:newsapp/Models/Model.dart';
import 'package:newsapp/Utilities/FirebaseDatabase.dart';

class NewsProv with ChangeNotifier {
  List<Newsmodel> newslist = [];
  Future<List<Newsmodel>> fetchNews(String type) async {
    try {
      print(type);
      final newsdata = await FirebaseStore.getQueryData(type);
      newslist = newsdata;
      print(newslist.length);
      notifyListeners();
    } catch (e) {
      print('An error occurred: $e');
    }
    return newslist;
  }
  Future<List<Newsmodel>> fetchLatestNews(String type) async {
    try {
      print(type);
      final newsdata = await FirebaseStore.getLatestData(type);
      newslist = newsdata;
      print(newslist.length);
      notifyListeners();
    } catch (e) {
      print('An error occurred: $e');
    }
    return newslist;
  }
}
