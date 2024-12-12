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

    final width = MediaQuery.of(context).size.width;

    String imageUrl = article.urlToImage ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              imageUrl.isEmpty
                  ? 'https://t4.ftcdn.net/jpg/02/09/53/11/360_F_209531103_vL5MaF5fWcdpVcXk5yREBk3KMcXE0X7m.jpg'
                  : imageUrl,
              width: width, 
              height: (width > 600) ? 300 : 175,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 40, color: Colors.grey);
              },
            ),
          ),

     
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              article.title,
              style:  TextStyle(fontWeight: FontWeight.w800, fontSize: (width > 600)? 20 : 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: AnimatedCrossFade(
              firstChild: Text(
                
                article.description ?? 'No description available.',
                style:  TextStyle(fontSize:  (width > 600)? 18 : 16),
                maxLines: (width > 600) ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                article.description ?? 'No description available.',
                style:  TextStyle(fontSize: (width > 600)? 18 : 16),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ),

      
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: onTap, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
