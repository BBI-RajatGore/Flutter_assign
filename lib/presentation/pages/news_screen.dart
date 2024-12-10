import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
import 'package:news_app_clean_archi/presentation/widgets/news_list_view.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    super.initState();

    context.read<NewsBloc>().add(FetchNewsEvent());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<NewsBloc>().add(LoadMoreNewsEvent());
      }
      
    });

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDarkMode) {
              return IconButton(
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                tooltip: 'Toggle Theme',
              );
            },
          ),
        ],
      ),
      body: NewsListView(scrollController: _scrollController),
    );
  }
}

