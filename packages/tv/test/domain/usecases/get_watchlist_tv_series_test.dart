import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTV usecase;
  late MockTVRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = GetWatchlistTV(mockTvRepository);
  });

  final tTvList = [tTv];

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getWatchlistTV())
        .thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvList));
  });
}
