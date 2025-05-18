import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:anthology_app/controller/news_controller.dart';
import '../model/news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when the screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsController>(context, listen: false).loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'the news',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              ' dispatch.',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Sign in'),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Subscribe'),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: const CategoryTabs(),
          ),
        ),
      ),
      body: Consumer<NewsController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.articles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.isNotEmpty && controller.articles.isEmpty) {
            return Center(child: Text(controller.error));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured article
                  if (controller.articles.isNotEmpty)
                    FeaturedArticle(article: controller.articles.first),

                  const SizedBox(height: 24),

                  // Related podcasts
                  Text(
                    'Related podcasts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.podcasts.length,
                      itemBuilder: (context, index) {
                        return PodcastCard(podcast: controller.podcasts[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Podcast platforms
                  Text(
                    'More ways how to listen',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      PlatformButton(
                        icon: Icons.apple,
                        label: 'Apple Podcasts',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      PlatformButton(
                        icon: Icons.play_arrow,
                        label: 'Google Play',
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // More articles
                  Text(
                    'Latest News',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.articles.length > 1
                        ? controller.articles.length - 1 : 0,
                    itemBuilder: (context, index) {
                      // Skip the first article as it's shown as featured
                      return ArticleCard(article: controller.articles[index + 1]);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Category tabs
class CategoryTabs extends StatelessWidget {
  const CategoryTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = ['LATEST', 'WORLD', 'SPORTS', 'CULTURE', 'WELLNESS', 'ECONOMY'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Text(
              category,
              style: TextStyle(
                fontWeight: category == 'LATEST' ? FontWeight.bold : FontWeight.normal,
                color: category == 'LATEST' ? Colors.black : Colors.grey[600],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Featured article widget
class FeaturedArticle extends StatelessWidget {
  final Article article;

  const FeaturedArticle({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          article.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              article.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.image, size: 48, color: Colors.grey[400]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Podcast card widget
class PodcastCard extends StatelessWidget {
  final Podcast podcast;

  const PodcastCard({Key? key, required this.podcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                podcast.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.image, size: 24, color: Colors.grey[400]),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            podcast.category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            podcast.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Platform button widget
class PlatformButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const PlatformButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

// Article card widget
class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  article.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.image, size: 24, color: Colors.grey[400]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}