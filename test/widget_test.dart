



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
import 'package:news_app_clean_archi/presentation/pages/news_screen.dart';
import 'package:news_app_clean_archi/presentation/widgets/loading_widget.dart';

class MockNewsBloc extends Mock implements NewsBloc {}

class MockThemeCubit extends Mock implements ThemeCubit {}

void main() {

  late MockNewsBloc mockNewsBloc;
  late MockThemeCubit mockThemeCubit;

  setUp(() {
    mockNewsBloc = MockNewsBloc();
    mockThemeCubit = MockThemeCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>.value(value: mockNewsBloc),
          BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
        ],
        child: NewsScreen(),
      ),
    );
  }

  group('NewsScreen Widget Tests', () {
    testWidgets('should display LoadingWidget when state is NewsLoadingState',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNewsBloc.state).thenReturn(NewsLoadingState());

      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets(
        'should display a list of news articles when state is NewsLoadedState',
        (WidgetTester tester) async {

      final articles = [
        NewsArticle(
          title: 'Test News 1',
          description: 'Description 1',
          urlToImage: 'https://example.com/image1.jpg', publishedAt: '1/22/2023',
          
        ),
        NewsArticle(
          title: 'Test News 2',
          description: 'Description 2',
          urlToImage: 'https://example.com/image2.jpg',publishedAt: '1/22/2023',
        ),
      ];

      when(() => mockNewsBloc.state).thenReturn(NewsLoadedState(
        articles: articles,
        hasMore: false,
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Test News 1'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.text('Test News 2'), findsOneWidget);
      expect(find.text('Description 2'), findsOneWidget);

    });

    testWidgets('should display error message when state is NewsErrorState',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNewsBloc.state).thenReturn(NewsErrorState('Error loading news'));

      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Error loading news'), findsOneWidget);
    });

    testWidgets('should display empty message when no articles are available',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNewsBloc.state).thenReturn(NewsLoadedState(
        articles: [],
        hasMore: false,
      ));

      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('No News for applied Filters'), findsOneWidget);
    });
  });
}