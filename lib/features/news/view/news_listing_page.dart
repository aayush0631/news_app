import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6/features/news/viewmodel/news_viewmodel.dart';
import 'package:week6/core/widgets/app_bottom_bar.dart';
import 'package:week6/features/bookmarks/view/booking_list_page.dart';
import 'package:week6/core/viewmodel/theme_viewmodel.dart';
import 'package:week6/features/bookmarks/viewmodel/booking_viewmodel.dart';
import 'package:week6/core/models/bookmarked_news.dart';

class NewsListingScreen extends StatefulWidget {
  const NewsListingScreen({super.key});

  @override
  State<NewsListingScreen> createState() => _NewsListingScreenState();
}

class _NewsListingScreenState extends State<NewsListingScreen> {
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    final pages = [const NewsListBody(), const BookmarkListPage()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Listings'),
        backgroundColor: Colors.blueAccent,
        actions: [
          /// Theme Toggle
          IconButton(
            onPressed: () {
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
            onPressed: provider.fetchNews,
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

              final suggestions = provider
                  .getFilteredArticles(query)
                  .map(
                    (article) =>
                        ListTile(title: Text(article.title), onTap: () {}),
                  )
                  .toList();

              return suggestions.isEmpty
                  ? const [ListTile(title: Text('No results found'))]
                  : suggestions;
            },
          ),
        ],
      ),

      body: pages[provider.currentIndex],

      bottomNavigationBar: AppBottomBar(
        currentIndex: provider.currentIndex,
        onTap: provider.updateCurrentIndex,
      ),
    );
  }
}

class NewsListBody extends StatelessWidget {
  const NewsListBody({super.key});

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
        );
      },
    );
  }
}
