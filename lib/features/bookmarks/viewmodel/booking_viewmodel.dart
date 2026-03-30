import 'package:flutter/material.dart';
import 'package:week6/core/models/bookmarked_news.dart';

class BookmarkController extends ChangeNotifier {
  final List<BookmarkedNews> bookmarks = [];

  void addBookmark(BookmarkedNews news) {
    if (!bookmarks.any((b) => b.url == news.url)) {
      bookmarks.add(news);
      notifyListeners();
    }
  }
  
  void removeBookmark(BookmarkedNews news) {
    bookmarks.removeWhere((b) => b.url == news.url);
    notifyListeners();
  }

  bool isBookmarked(String url) {
    return bookmarks.any((b) => b.url == url);
  }
}