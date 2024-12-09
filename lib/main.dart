// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app_clean_archi/core/theme/app_theme.dart';
// import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
// import 'package:news_app_clean_archi/presentation/pages/news_screen.dart';
// import 'package:news_app_clean_archi/service_locator.dart';

// void main() async {

//   WidgetsFlutterBinding.ensureInitialized();

//   initServiceLocator();

//   // load saved theme first 
//   final themeCubit = getIt<ThemeCubit>();
//   await themeCubit.loadTheme();


//   runApp(
//     BlocProvider(
//       create: (context) => themeCubit, 
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, bool>(
//       builder: (context, isDarkMode) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'News App',
//           theme: isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme(),
//           home: NewsScreen(),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/core/theme/app_theme.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
import 'package:news_app_clean_archi/presentation/pages/news_screen.dart';
import 'package:news_app_clean_archi/service_locator.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initServiceLocator();

  // Load saved theme first 
  final themeCubit = getIt<ThemeCubit>();
  await themeCubit.loadTheme();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => themeCubit),
        BlocProvider<NewsBloc>(create: (_) => getIt<NewsBloc>(),),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App',
          theme: isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme(),
          home: NewsScreen(),
        );
      },
    );
  }
}

