import 'package:anthology_app/model/news_model.dart';
import 'package:flutter/material.dart';

class NewsController extends ChangeNotifier {
  final NewsRepository _repository = NewsRepository();

  List<Article> _articles = [];
  List<Podcast> _podcasts = [];
  bool _isLoading = false;
  String _error = '';

  List<Article> get articles => _articles;
  List<Podcast> get podcasts => _podcasts;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _articles = await _repository.getArticles();
    } catch (e) {
      _error = 'Failed to load articles: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPodcasts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _podcasts = await _repository.getPodcasts();
    } catch (e) {
      _error = 'Failed to load podcasts: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await Future.wait([
        _repository.getArticles().then((data) => _articles = data),
        _repository.getPodcasts().then((data) => _podcasts = data),
      ]);
    } catch (e) {
      _error = 'Failed to load data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class NewsRepository {
  Future<List<Article>> getArticles() async {
    // In a real app, this would make an API call
    // For demo purposes, we'll return mock data
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    return [
      Article(
        title: 'Why play tennis and become pro?',
        description: 'Tennis is a popular sport enjoyed by millions of people around the world, but it\'s not without its downsides. One of the biggest cons of playing tennis is the risk of injury. Tennis players are susceptible to a variety of injuries, from strains and sprains to more serious conditions like tennis elbow and rotator cuff tears.',
        imageUrl: 'assets/images/tennis.jpg',
        category: 'SPORTS',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Article(
        title: 'Global economy shows signs of recovery',
        description: 'Latest economic indicators suggest a rebound across major markets as inflation begins to stabilize.',
        imageUrl: 'assets/images/economy.jpg',
        category: 'ECONOMY',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Article(
        title: 'New breakthrough in renewable energy storage',
        description: 'Scientists have developed a more efficient battery technology that could accelerate the transition to sustainable energy.',
        imageUrl: 'assets/images/technology.jpg',
        category: 'TECHNOLOGY',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Article(
        title: 'The rise of digital nomad culture',
        description: 'How remote work is reshaping urban centers and travel destinations around the world.',
        imageUrl: 'assets/images/culture.jpg',
        category: 'CULTURE',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<List<Podcast>> getPodcasts() async {
    // Mock podcast data
    await Future.delayed(const Duration(seconds: 1));

    return [
      Podcast(
        title: 'Best new albums',
        category: 'CULTURE',
        imageUrl: 'assets/images/music.jpg',
      ),
      Podcast(
        title: 'What to do about pay gap?',
        category: 'WELLNESS',
        imageUrl: 'assets/images/wellness.jpg',
      ),
    ];
  }
}