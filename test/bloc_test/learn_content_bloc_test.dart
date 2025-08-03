// test/learn_content_bloc_test.dart

import 'dart:async';

import 'package:adora_mobile_app/features/learn_content/domain/entity/article_entity.dart';
import 'package:adora_mobile_app/features/learn_content/domain/usecases/get_news_usecase.dart';
import 'package:adora_mobile_app/features/learn_content/presentation/bloc/learn_content_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1) Create a Mock for GetNewsUseCase
class MockGetNewsUseCase extends Mock implements GetNewsUseCase {}

void main() {
  late LearnContentBloc bloc;
  late MockGetNewsUseCase mockGetNews;

  // 2) Dummy articles
  final dummyArticles = List.generate(
    3,
    (i) => ArticleEntity(
      title: 'Title $i',
      description: 'Desc $i',
      url: 'http://example.com/$i',
      imageUrl: 'http://example.com/img/$i.png',
      publishedAt: DateTime(2023, 1, i + 1),
    ),
  );

  setUp(() {
    mockGetNews = MockGetNewsUseCase();
    bloc = LearnContentBloc(mockGetNews);
  });

  tearDown(() {
    bloc.close();
  });

  test('1) initial state is LearnContentInitial', () {
    expect(bloc.state, isA<LearnContentInitial>());
  });

  test('2) empty query emits LearnContentError with prompt', () {
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LearnContentError>().having(
          (e) => e.message,
          'message',
          'Please enter a search term',
        ),
      ]),
    );

    bloc.add(FetchNewsRequested(''));
  });

  test('3) whitespace-only query emits same error', () {
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LearnContentError>().having(
          (e) => e.message,
          'message',
          'Please enter a search term',
        ),
      ]),
    );

    bloc.add(FetchNewsRequested('   '));
  });

  test('4) valid query → loading then loaded(empty)', () {
    when(() => mockGetNews.call('foo'))
        .thenAnswer((_) async => <ArticleEntity>[]);

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LearnContentLoading>(),
        isA<LearnContentLoaded>().having(
          (s) => s.articles,
          'articles',
          isEmpty,
        ),
      ]),
    );

    bloc.add(FetchNewsRequested('foo'));
  });

  test('5) valid query → loading then loaded(non-empty)', () {
    when(() => mockGetNews.call('bar'))
        .thenAnswer((_) async => dummyArticles);

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LearnContentLoading>(),
        isA<LearnContentLoaded>().having(
          (s) => s.articles,
          'articles',
          dummyArticles,
        ),
      ]),
    );

    bloc.add(FetchNewsRequested('bar'));
  });
  test('7) exception in useCase emits loading then error', () {
    when(() => mockGetNews.call('err'))
        .thenThrow(Exception('network failed'));

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LearnContentLoading>(),
        isA<LearnContentError>().having(
          (e) => e.message,
          'message',
          contains('Exception: network failed'),
        ),
      ]),
    );

    bloc.add(FetchNewsRequested('err'));
  });

  test('8) error then success sequence', () async {
    when(() => mockGetNews.call('ok'))
        .thenAnswer((_) async => dummyArticles);

    final expected = [
      isA<LearnContentError>(),
      isA<LearnContentLoading>(),
      isA<LearnContentLoaded>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(FetchNewsRequested(''));      // → error
    await Future.delayed(Duration.zero);
    bloc.add(FetchNewsRequested('ok'));    // → loading + loaded
  });

  test('9) empty query does NOT emit loading', () {
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LearnContentError>(),
        emitsDone,
      ]),
    );

    bloc.add(FetchNewsRequested(''));
    bloc.close();
  });

  test('10) exact exception message is preserved', () {
    when(() => mockGetNews.call('boom'))
        .thenThrow(Exception('boom!'));

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LearnContentLoading>(),
        predicate<LearnContentError>(
          (state) => state.message == 'Exception: boom!',
        ),
      ]),
    );

    bloc.add(FetchNewsRequested('boom'));
  });
}
