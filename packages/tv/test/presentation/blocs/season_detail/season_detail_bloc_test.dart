import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:tv/presentation/bloc/season/season_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'season_detail_bloc_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
void main() {
  late TVSeasonDetailBloc seasonDetailBloc;
  late MockGetSeasonDetail mockGetSeasonDetail;

  setUp(() {
    mockGetSeasonDetail = MockGetSeasonDetail();
    seasonDetailBloc = TVSeasonDetailBloc(getSeasonDetail: mockGetSeasonDetail);
  });

  const tId = 1;
  const tSeasonNumber = 1;

  test('initial state should be empty', () {
    expect(seasonDetailBloc.state, TVSeasonDetailState.initial());
  });

  blocTest<TVSeasonDetailBloc, TVSeasonDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => const Right(tSeasonDetail));
      return seasonDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSeasonDetail(tId, tSeasonNumber)),
    expect: () => [
      TVSeasonDetailState.initial().copyWith(seasonState: RequestState.Loading),
      TVSeasonDetailState.initial().copyWith(
        seasonState: RequestState.Loaded,
        seasonDetail: tSeasonDetail,
      ),
    ],
    verify: (bloc) => [
      verify(mockGetSeasonDetail.execute(tId, tSeasonNumber)),
      const FetchTVSeasonDetail(tId, tSeasonNumber).props,
    ],
  );

  blocTest<TVSeasonDetailBloc, TVSeasonDetailState>(
    'Should emit [Loading, Error] when get detail season is unsuccessful',
    build: () {
      when(mockGetSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return seasonDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSeasonDetail(tId, tSeasonNumber)),
    expect: () => [
      TVSeasonDetailState.initial().copyWith(seasonState: RequestState.Loading),
      TVSeasonDetailState.initial().copyWith(
        seasonState: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (bloc) => [
      verify(mockGetSeasonDetail.execute(tId, tSeasonNumber)),
      const FetchTVSeasonDetail(tId, tSeasonNumber).props,
    ],
  );
}
