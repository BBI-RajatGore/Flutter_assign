import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/pages/news_screen.dart';
import 'package:news_app_clean_archi/presentation/widgets/news_list_view.dart';

class MockNewsBloc extends Mock implements NewsBloc {}

void main() {
  late MockNewsBloc mockNewsBloc;

  setUp(() {
    mockNewsBloc = MockNewsBloc();
  });

  testWidgets('displays loading indicator when state is loading', (WidgetTester tester) async {
    when(mockNewsBloc.state).thenReturn(NewsLoadingState());

    await tester.pumpWidget(
      BlocProvider.value(
        value: mockNewsBloc,
        child: MaterialApp(
          home: NewsScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays list of news when state is loaded', (WidgetTester tester) async {

    final articles = [NewsArticle(title: "Test News", description: "Description",urlToImage: 'urlToImage', publishedAt: '1/2/3123')];
    
    when(mockNewsBloc.state).thenReturn(NewsLoadedState(articles: articles, hasMore: true));

    await tester.pumpWidget(
      BlocProvider.value(
        value: mockNewsBloc,
        child: MaterialApp(
          home: NewsScreen(),
        ),
      ),
    );

    expect(find.byType(NewsListView), findsOneWidget);
  });

  testWidgets('displays error message when state is error', (WidgetTester tester) async {
    when(mockNewsBloc.state).thenReturn(NewsErrorState("Error"));

    await tester.pumpWidget(
      BlocProvider.value(
        value: mockNewsBloc,
        child: MaterialApp(
          home: NewsScreen(),
        ),
      ),
    );

    expect(find.text('Error'), findsOneWidget);
  });
}
