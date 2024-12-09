import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app_clean_archi/core/theme/theme_manager.dart';

part 'theme_state.dart';


class ThemeCubit extends Cubit<bool> {

  ThemeCubit() : super(false); 

  Future<void> toggleTheme() async {
    final newTheme = !state;
    await ThemeManager.saveTheme(newTheme);
    emit(newTheme);
  }

  Future<void> loadTheme() async {
    final isDarkMode = await ThemeManager.loadTheme();
    emit(isDarkMode);
  }
}

