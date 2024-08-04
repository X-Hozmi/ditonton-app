import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:tv/presentation/bloc/search/search_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchTV])
void main() {
  late TVSearchBloc searchTVBloc;
  late MockSearchTV mockSearchTV;

  setUp(() {
    mockSearchTV = MockSearchTV();
    searchTVBloc = TVSearchBloc(searchTV: mockSearchTV);
  });

  test('initial state should be empty', () {
    expect(searchTVBloc.state, TVSearchState.initial());
  });

  final tTVList = <TV>[tTv];
  const tQuery = 'spongebob';

  blocTest<TVSearchBloc, TVSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => Right(tTVList));
      return searchTVBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSearchState.initial().copyWith(state: RequestState.Loading),
      TVSearchState.initial().copyWith(
        state: RequestState.Loaded,
        searchResult: tTVList,
      ),
    ],
    verify: (_) => [
      verify(mockSearchTV.execute(tQuery)),
      const FetchTVSearch(tQuery).props,
    ],
  );

  blocTest<TVSearchBloc, TVSearchState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => const Right([]));
      return searchTVBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSearchState.initial().copyWith(state: RequestState.Loading),
      TVSearchState.initial().copyWith(state: RequestState.Empty),
    ],
    verify: (_) => [
      verify(mockSearchTV.execute(tQuery)),
      const FetchTVSearch(tQuery).props,
    ],
  );

  blocTest<TVSearchBloc, TVSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchTVBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSearchState.initial().copyWith(state: RequestState.Loading),
      TVSearchState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) => [
      verify(mockSearchTV.execute(tQuery)),
      const FetchTVSearch(tQuery).props,
    ],
  );
}
