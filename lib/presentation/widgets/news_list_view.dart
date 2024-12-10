import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/widgets/loading_widget.dart';
import 'package:news_app_clean_archi/presentation/widgets/news_items_widget.dart';

class NewsListView extends StatefulWidget {
  final ScrollController scrollController;

  const NewsListView({Key? key, required this.scrollController}) : super(key: key);

  @override
  _NewsListViewState createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {

  int? expandedIndex;  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadingState) {
          return LoadingWidget();
        } else if (state is NewsLoadedState) {
          return _buildNewsList(state.articles, context, state.hasMore);
        } else if (state is NewsErrorState) {
          return ErrorWidget(state.message);
        } else {
          return const Center(child: Text('No Data Available'));
        }
      },
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles, BuildContext context, bool hasMore) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsBloc>().add(FetchNewsEvent());
      },
      child: ListView.builder(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(8.0),
        itemCount: articles.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == articles.length) {
            return const LoadingWidget(); 
          }

          final article = articles[index];

          return NewsItemWidget(
            article: article,
            isExpanded: expandedIndex == index,
            onTap: () {
              setState(() {
                expandedIndex = expandedIndex == index ? null : index;  
              });
            },
          );
        },
      ),
    );
  }
}
