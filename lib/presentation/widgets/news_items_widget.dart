import 'package:flutter/material.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';

class NewsItemWidget extends StatelessWidget {

  final NewsArticle article;
  final bool isExpanded; 
  final VoidCallback onTap;  

  const NewsItemWidget({
    Key? key,
    required this.article,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = article.urlToImage ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            onTap: onTap, 
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
            subtitle: AnimatedCrossFade(
              firstChild: Text(
                article.description ?? 'No description available.',
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                article.description ?? 'No description available.',
                style: const TextStyle(fontSize: 14),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200), 
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0, 
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.arrow_downward),
            ),
          ),
        ],
      ),
    );
  }
}
