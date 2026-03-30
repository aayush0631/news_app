import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6/features/news/viewmodel/news_viewmodel.dart';
import 'package:week6/features/bookmarks/viewmodel/booking_viewmodel.dart';
import 'package:week6/core/models/bookmarked_news.dart';
import 'package:week6/core/widgets/app_bottom_bar.dart';
import 'package:week6/features/bookmarks/view/booking_list_page.dart';
import 'package:week6/core/viewmodel/theme_viewmodel.dart';

class NewsListingScreen extends StatefulWidget {
  const NewsListingScreen({super.key});

  @override
  State<NewsListingScreen> createState() => _NewsListingScreenState();
}

class _NewsListingScreenState extends State<NewsListingScreen> {
  late NewsProvider _provider;
  final SearchController _searchController = SearchController();

  int _currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<NewsProvider>(context, listen: false);
    pages = [const _NewsListBody(), const BookmarkListPage()];
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _provider.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Listings'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () async {
              context.read<ThemeViewmodel>().toggleTheme();
            },
            icon: Icon(
              context.watch<ThemeViewmodel>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),

          /// Refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.fetchNews(),
          ),

          /// Search
          SearchAnchor(
            searchController: _searchController,
            builder: (context, controller) => IconButton(
              onPressed: controller.openView,
              icon: const Icon(Icons.search),
            ),
            suggestionsBuilder: (context, controller) {
              final query = controller.value.text.toLowerCase();

              final suggestions = provider.newsArticles
                  .where(
                    (article) => article.title.toLowerCase().contains(query),
                  )
                  .map(
                    (article) =>
                        ListTile(title: Text(article.title), onTap: () {}),
                  )
                  .toList();
              return suggestions;
            },
          ),
        ],
      ),
      body: pages[_currentIndex],

      /// Bottom Navigation
      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class _NewsListBody extends StatelessWidget {
  const _NewsListBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final bookmarkController = context.watch<BookmarkController>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.errorMessage!.isNotEmpty) {
      return Center(child: Text(provider.errorMessage!));
    }

    if (provider.newsArticles.isEmpty) {
      return const Center(child: Text('No news articles available.'));
    }

    return ListView.builder(
      itemCount: provider.newsArticles.length,
      itemBuilder: (context, index) {
        final article = provider.newsArticles[index];

        final isBookmarked = bookmarkController.isBookmarked(article.url);

        return ListTile(
          title: Text(article.title),
          subtitle: Text(article.description),

          leading: Image.network(
            article.urlToImage,
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),

          trailing: IconButton(
            onPressed: () {
              final bookmarkedNews = BookmarkedNews(
                title: article.title,
                description: article.description,
                urlToImage: article.urlToImage,
                url: article.url,
              );

              if (isBookmarked) {
                bookmarkController.removeBookmark(bookmarkedNews);
              } else {
                bookmarkController.addBookmark(bookmarkedNews);
              }
            },
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.blue : null,
            ),
          ),
          onTap: () {
            // Optional: Open article detail page or webview
          },
        );
      },
    );
  }
}
