import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';

class NewsListView extends StatelessWidget {
  final ScrollController scrollController;

  const NewsListView({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadingState) {
          return _buildLoadingState();
        } else if (state is NewsLoadedState) {
          return _buildNewsList(state.articles, context, state.hasMore);
        } else if (state is NewsErrorState) {
          return _buildErrorState(state.message, context);
        } else {
          return const Center(child: Text('No Data Available'));
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles, BuildContext context, bool hasMore) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsBloc>().add(FetchNewsEvent());
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemCount: articles.length + (hasMore ? 1 : 0), 
        itemBuilder: (context, index) {
          if (index == articles.length) {
            return _buildLoadingState(); 
          }

          final article = articles[index];
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
        },
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<NewsBloc>().add(FetchNewsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}