import 'dart:math';

class Quote {
  final String text;
  final String author;
  final String category;

  const Quote({
    required this.text,
    required this.author,
    this.category = 'motivation',
  });
}

class QuoteService {
  static final _random = Random();

  static const List<Quote> _quotes = [
    Quote(
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
      category: 'motivation',
    ),
    Quote(
      text: 'Believe you can and you\'re halfway there.',
      author: 'Theodore Roosevelt',
      category: 'confidence',
    ),
    Quote(
      text: 'Start where you are. Use what you have. Do what you can.',
      author: 'Arthur Ashe',
      category: 'action',
    ),
    Quote(
      text:
          'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      author: 'Winston Churchill',
      category: 'perseverance',
    ),
    Quote(
      text:
          'The future belongs to those who believe in the beauty of their dreams.',
      author: 'Eleanor Roosevelt',
      category: 'dreams',
    ),
    Quote(
      text: 'Don\'t watch the clock; do what it does. Keep going.',
      author: 'Sam Levenson',
      category: 'productivity',
    ),
    Quote(
      text: 'Everything you\'ve ever wanted is on the other side of fear.',
      author: 'George Addair',
      category: 'courage',
    ),
    Quote(
      text:
          'You are never too old to set another goal or to dream a new dream.',
      author: 'C.S. Lewis',
      category: 'growth',
    ),
    Quote(
      text: 'The only impossible journey is the one you never begin.',
      author: 'Tony Robbins',
      category: 'action',
    ),
    Quote(
      text: 'Success is the sum of small efforts repeated day in and day out.',
      author: 'Robert Collier',
      category: 'consistency',
    ),
    Quote(
      text:
          'Your time is limited, don\'t waste it living someone else\'s life.',
      author: 'Steve Jobs',
      category: 'authenticity',
    ),
    Quote(
      text:
          'The best time to plant a tree was 20 years ago. The second best time is now.',
      author: 'Chinese Proverb',
      category: 'action',
    ),
    Quote(
      text:
          'Do not wait; the time will never be \'just right.\' Start where you stand.',
      author: 'Napoleon Hill',
      category: 'action',
    ),
    Quote(
      text: 'Great things never come from comfort zones.',
      author: 'Anonymous',
      category: 'growth',
    ),
    Quote(
      text: 'Dream big and dare to fail.',
      author: 'Norman Vaughan',
      category: 'dreams',
    ),
    Quote(
      text:
          'The harder you work for something, the greater you\'ll feel when you achieve it.',
      author: 'Anonymous',
      category: 'achievement',
    ),
    Quote(
      text: 'Don\'t stop when you\'re tired. Stop when you\'re done.',
      author: 'Anonymous',
      category: 'perseverance',
    ),
    Quote(
      text: 'Wake up with determination. Go to bed with satisfaction.',
      author: 'Anonymous',
      category: 'daily',
    ),
    Quote(
      text: 'Do something today that your future self will thank you for.',
      author: 'Anonymous',
      category: 'action',
    ),
    Quote(
      text: 'Little things make big days.',
      author: 'Anonymous',
      category: 'gratitude',
    ),
    Quote(
      text: 'It\'s going to be hard, but hard does not mean impossible.',
      author: 'Anonymous',
      category: 'perseverance',
    ),
    Quote(
      text: 'Success doesn\'t just find you. You have to go out and get it.',
      author: 'Anonymous',
      category: 'action',
    ),
    Quote(
      text: 'The key to success is to focus on goals, not obstacles.',
      author: 'Anonymous',
      category: 'focus',
    ),
    Quote(
      text: 'Push yourself, because no one else is going to do it for you.',
      author: 'Anonymous',
      category: 'motivation',
    ),
    Quote(
      text: 'Great things never came from comfort zones.',
      author: 'Anonymous',
      category: 'growth',
    ),
  ];

  static Quote getDailyQuote() {
    // Get quote based on day of year for consistency throughout the day
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year))
        .inDays;
    final index = dayOfYear % _quotes.length;
    return _quotes[index];
  }

  static Quote getRandomQuote() {
    return _quotes[_random.nextInt(_quotes.length)];
  }

  static List<Quote> getQuotesByCategory(String category) {
    return _quotes.where((q) => q.category == category).toList();
  }

  static List<String> getAllCategories() {
    return _quotes.map((q) => q.category).toSet().toList();
  }
}
