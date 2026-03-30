import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6/features/bookmarks/viewmodel/booking_viewmodel.dart';
import 'package:week6/core/models/bookmarked_news.dart';

/// Displays list of bookmarked news articles
class BookmarkListPage extends StatelessWidget {
  const BookmarkListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BookmarkedNews> bookmarks =
        context.watch<BookmarkController>().bookmarks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),

      body: bookmarks.isEmpty
          ? const Center(
              child: Text('No bookmarks yet!'),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final article = bookmarks[index];

                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.description),

                  leading: Image.network(
                    article.urlToImage,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context
                          .read<BookmarkController>()
                          .removeBookmark(article);
                    },
                  ),

                  onTap: () {
                    // Optional: open detail page
                  },
                );
              },
            ),
    );
  }
}