import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTV usecase;
  late MockTVRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = SaveWatchlistTV(mockTvRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(mockTvRepository.saveWatchlist(tTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(tTvDetail);
    // assert
    verify(mockTvRepository.saveWatchlist(tTvDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
