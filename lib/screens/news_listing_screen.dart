import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week4/providers/news_provider.dart';

class NewsListingScreen extends StatefulWidget {
  const NewsListingScreen({super.key});

  @override
  State<NewsListingScreen> createState() => _NewsListingScreenState();
}

class _NewsListingScreenState extends State<NewsListingScreen> {
  @override
  void initState() {
    super.initState();
    print('init state called');
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<NewsProvider>().fetchNews());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final newsArticles = provider.newsArticles;

    return Scaffold(
      appBar: AppBar(title: const Text('News Listing')),
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
              onTap: () {
                // Navigate to detail
              },
            );
          },
        ),
    );
  }
}
