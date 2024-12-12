import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';

class FilterDialog extends StatefulWidget {
  
  final String? selectedSortBy;
  final String? selectedLanguage;
  final String? searchQuery;
  final Function(String?) onSortByChanged;
  final Function(String?) onLanguageChanged;
  final Function(String?) onSearchQueryChanged;

  const FilterDialog({
    super.key,
    required this.selectedLanguage,
    required this.searchQuery,
    required this.selectedSortBy,
    required this.onSortByChanged,
    required this.onLanguageChanged,
    required this.onSearchQueryChanged,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {

  String? _selectedSortBy;
  String? _selectedLanguage;
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.selectedSortBy;
    _selectedLanguage = widget.selectedLanguage;
    _searchQuery.text = widget.searchQuery ?? ''; 
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> languages = [
      'en',
      'ar',
      'de',
      'es',
      'fr',
      'it',
      'nl',
      'pt',
      'ru',
      'zh'
    ];
    final List<String> sortOptions = ['relevancy', 'popularity', 'publishedAt'];

    return AlertDialog(
      title: const Text('Filter Options'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchQuery,
              decoration: const InputDecoration(
                labelText: 'Search Query (q)',
                hintText: 'Enter keywords or phrases',
              ),
              onChanged: (value) {
                widget.onSearchQueryChanged(value.isNotEmpty ? value : 'latest');
              },
            ),
            const SizedBox(height: 20),
            
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                  widget.onLanguageChanged(newValue);
                });
              },
              items: languages
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      ))
                  .toList(),
              hint: const Text('Select Language'),
            ),
            const SizedBox(height: 20),
            
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedSortBy,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSortBy = newValue;
                  widget.onSortByChanged(newValue);
                });
              },
              items: sortOptions
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.capitalize()),
                      ))
                  .toList(),
              hint: const Text('Sort By'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Apply'),
          onPressed: () {
            context.read<NewsBloc>().add(
                  FetchNewsEvent(
                    query: _searchQuery.text.trim().isNotEmpty ? _searchQuery.text.trim() : 'latest',
                    sortBy: _selectedSortBy,
                    language: _selectedLanguage,
                  ),
                );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

extension StringCapitalization on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
