// test/bloc_test/generate_ad_bloc_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:adora_mobile_app/features/ads/domain/model/ad_result.dart';
import 'package:adora_mobile_app/features/ads/domain/usecases/generate_ad_usecase.dart';
import 'package:adora_mobile_app/features/ads/presentation/bloc/generate_ad_bloc.dart';

/// A fake to satisfy mocktail’s type system when we use `any<String>()`
class _FakeString extends Fake {}

class MockGenerateAdUseCase extends Mock implements GenerateAdUseCase {}

void main() {
  late GenerateAdBloc bloc;
  late MockGenerateAdUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGenerateAdUseCase();
    bloc = GenerateAdBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('1) initial state is GenerateAdInitial', () {
    expect(bloc.state, isA<GenerateAdInitial>());
  });

  test('2) emits [Loading, Success] when useCase returns AdResult', () async {
    final adResult = AdResult('http://img.png', 7);
    when(() => mockUseCase.call(any<String>()))
      .thenAnswer((_) async => adResult);

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<GenerateAdLoading>(),
        predicate<GenerateAdSuccess>((state) =>
          state.imageUrl == 'http://img.png'
          && state.remainingCredits == 7
        ),
      ]),
    );

    bloc.add(GenerateAdRequested('some prompt'));
  });

  test('3) emits [Loading, Failure] when useCase throws', () async {
    when(() => mockUseCase.call(any<String>()))
      .thenThrow(Exception('network error'));

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<GenerateAdLoading>(),
        predicate<GenerateAdFailure>((state) =>
          state.error.contains('network error')
        ),
      ]),
    );

    bloc.add(GenerateAdRequested('anything'));
  });

  test('4) calls useCase with exactly the given prompt', () async {
    final adResult = AdResult('u', 1);
    when(() => mockUseCase.call(any<String>()))
      .thenAnswer((_) async => adResult);

    bloc.add(GenerateAdRequested('hello-world'));
    await untilCalled(() => mockUseCase.call('hello-world'));
    verify(() => mockUseCase.call('hello-world')).called(1);
  });

  test('6) emits Loading immediately when request is added', () {
    final adResult = AdResult('x', 2);
    when(() => mockUseCase.call(any<String>()))
      .thenAnswer((_) async => adResult);

    final stream = bloc.stream.asBroadcastStream();
    bloc.add(GenerateAdRequested('quick'));

    // We only care that Loading shows up at some point
    expectLater(stream, emitsThrough(isA<GenerateAdLoading>()));
  });

  test('7) supports back-to-back requests', () async {
    final first  = AdResult('one', 10);
    final second = AdResult('two',  9);
    when(() => mockUseCase.call('one')).thenAnswer((_) async => first);
    when(() => mockUseCase.call('two')).thenAnswer((_) async => second);

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<GenerateAdLoading>(),          // for 'one'
        isA<GenerateAdSuccess>(),          
        isA<GenerateAdLoading>(),          // for 'two'
        predicate<GenerateAdSuccess>((s) => s.imageUrl == 'two'),
      ]),
    );

    bloc.add(GenerateAdRequested('one'));
    await Future<void>.delayed(Duration.zero);
    bloc.add(GenerateAdRequested('two'));
  });

  test('8) failure state carries exception text verbatim', () async {
    when(() => mockUseCase.call(any<String>()))
      .thenThrow(Exception('boom-boom'));

    expectLater(
      bloc.stream,
      emitsThrough(predicate<GenerateAdFailure>((s) =>
        s.error.contains('boom-boom')
      )),
    );

    bloc.add(GenerateAdRequested('failcase'));
  });
}
