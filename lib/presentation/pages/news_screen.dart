// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
// import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
// import 'package:news_app_clean_archi/presentation/widgets/filter_dialog.dart';
// import 'package:news_app_clean_archi/presentation/widgets/news_list_view.dart';

// class NewsScreen extends StatefulWidget {
//   @override
//   _NewsScreenState createState() => _NewsScreenState();
// }

// class _NewsScreenState extends State<NewsScreen> {

//   final ScrollController _scrollController = ScrollController();

//   String? _selectedSortBy = 'publishedAt';
//   String? _selectedLanguage = 'en';
//   String? _searchQuery = "latest";
//   bool _isFabVisible = true;

//   @override
//   void initState() {
//     super.initState();
//     context.read<NewsBloc>().add(
//           FetchNewsEvent(
//             query: _searchQuery,
//             sortBy: _selectedSortBy,
//             language: _selectedLanguage,
//           ),
//         );

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels > 100 && !_isFabVisible) {
//         setState(() {
//           _isFabVisible = true;
//         });
//       } else if (_scrollController.position.pixels <= 100 && _isFabVisible) {
//         setState(() {
//           _isFabVisible = false;
//         });
//       }

//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         context.read<NewsBloc>().add(
//               LoadMoreNewsEvent(
//                 query: _searchQuery,
//                 sortBy: _selectedSortBy,
//                 language: _selectedLanguage,
//               ),
//             );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToTop() {
//     _scrollController.animateTo(
//       0.0,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return FilterDialog(
//           onSortByChanged: (String? newSortBy) {
//             setState(() {
//               _selectedSortBy = newSortBy ?? 'publishedAt';
//             });
//           },
//           onLanguageChanged: (String? newLanguage) {
//             setState(() {
//               _selectedLanguage = newLanguage ?? 'en';
//             });
//           },
//           onSearchQueryChanged: (String? newQuery) {
//             setState(() {
//               _searchQuery = newQuery ?? 'latest';
//             });
//           },
//           selectedLanguage: _selectedLanguage,
//           searchQuery: _searchQuery,
//           selectedSortBy: _selectedSortBy,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'News App',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         actions: [
//           BlocBuilder<ThemeCubit, bool>(
//             builder: (context, isDarkMode) {
//               return IconButton(
//                 icon: Icon(
//                   isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   context.read<ThemeCubit>().toggleTheme();
//                 },
//                 tooltip: 'Toggle Theme',
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: _showFilterDialog,
//             tooltip: 'Filter and Sort',
//           ),
//         ],
//       ),
//       body: NewsListView(scrollController: _scrollController),
//       floatingActionButton: _isFabVisible
//           ? FloatingActionButton(
//               elevation: 8,
//               shape: const CircleBorder(),
//               onPressed: _scrollToTop,
//               tooltip: 'Scroll to Top',
//               child: const Icon(
//                 Icons.arrow_upward,
//                 color: Colors.white,
//               ),
//             )
//           : null,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
import 'package:news_app_clean_archi/presentation/widgets/filter_dialog.dart';
import 'package:news_app_clean_archi/presentation/widgets/news_list_view.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  
  final ScrollController _scrollController = ScrollController();

  String? _selectedSortBy = 'publishedAt';
  String? _selectedLanguage = 'en';
  String? _searchQuery = "latest";
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(
          FetchNewsEvent(
            query: _searchQuery,
            sortBy: _selectedSortBy,
            language: _selectedLanguage,
          ),
        );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 100 && !_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      } else if (_scrollController.position.pixels <= 100 && _isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<NewsBloc>().add(
              LoadMoreNewsEvent(
                query: _searchQuery,
                sortBy: _selectedSortBy,
                language: _selectedLanguage,
              ),
            );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onSortByChanged: (String? newSortBy) {
            setState(() {
              _selectedSortBy = newSortBy ?? 'publishedAt';
            });
          },
          onLanguageChanged: (String? newLanguage) {
            setState(() {
              _selectedLanguage = newLanguage ?? 'en';
            });
          },
          onSearchQueryChanged: (String? newQuery) {
            setState(() {
              _searchQuery = newQuery ?? 'latest';
            });
          },
          selectedLanguage: _selectedLanguage,
          searchQuery: _searchQuery,
          selectedSortBy: _selectedSortBy,
        );
      },
    );
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
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter and Sort',
          ),
        ],
      ),
      body: NewsListView(scrollController: _scrollController),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              elevation: 8,
              shape: const CircleBorder(),
              onPressed: _scrollToTop,
              tooltip: 'Scroll to Top',
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
