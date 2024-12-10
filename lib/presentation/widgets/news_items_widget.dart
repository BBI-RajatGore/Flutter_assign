import 'package:flutter/material.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsArticle article;

  const NewsItemWidget({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = article.urlToImage ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl.isEmpty
                ? 'https://t4.ftcdn.net/jpg/02/09/53/11/360_F_209531103_vL5MaF5fWcdpVcXk5yREBk3KMcXE0X7m.jpg'
                : imageUrl,
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image, size: 40, color: Colors.grey);
            },
          ),
        ),
        title: Text(
          article.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          article.description ?? 'No description available.',
          style: const TextStyle(fontSize: 14),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
