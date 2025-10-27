import 'package:flutter/material.dart';
import 'package:reflectify/utils/quote_service.dart';

class DailyQuoteCard extends StatelessWidget {
  final VoidCallback? onRefresh;

  const DailyQuoteCard({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final quote = QuoteService.getDailyQuote();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8A5DF4).withOpacity(0.3),
            const Color(0xFFD62F6D).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: Colors.white.withOpacity(0.7),
                size: 32,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Daily Inspiration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (onRefresh != null)
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  onPressed: onRefresh,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            quote.text,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '— ${quote.author}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
