import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6/providers/news_provider.dart';

class NewsListingScreen extends StatefulWidget {
  const NewsListingScreen({super.key});

  @override
  State<NewsListingScreen> createState() => _NewsListingScreenState();
}

class _NewsListingScreenState extends State<NewsListingScreen> {
  late NewsProvider _provider;
@override
  void initState() {
    super.initState();
    // Store provider reference before any async call
    _provider = Provider.of<NewsProvider>(context, listen: false);
    _fetchData();
  }

  Future<void> _fetchData() async {
    // No context used here; safe even if widget rebuilds
    await _provider.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final newsArticles = provider.newsArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Listing'),
        backgroundColor: Colors.blueAccent,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : newsArticles.isEmpty
          ? const Center(child: Text('No news articles available.'))
          : ListView.builder(
              itemCount: newsArticles.length,
              itemBuilder: (context, index) {
                final article = newsArticles[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  leading: Image.network(
                    article.urlToImage,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  onTap: () {
                    // Navigate to detail
                  },
                );
              },
            ),
    );
  }
}
