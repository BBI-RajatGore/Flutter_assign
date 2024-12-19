import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/core/theme/theme_manager.dart';

class ThemeCubit extends Cubit<bool> {

  final ThemeManager themeManager; 

  ThemeCubit({required this.themeManager}) : super(false);

  Future<void> toggleTheme() async {
    final newTheme = !state;
    await themeManager.saveTheme(newTheme);
    emit(newTheme);
  }

  Future<void> loadTheme() async {
    final isDarkMode = await themeManager.loadTheme();
    emit(isDarkMode);
  }
}

