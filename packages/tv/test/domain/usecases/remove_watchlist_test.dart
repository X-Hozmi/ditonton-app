import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTV usecase;
  late MockTVRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = RemoveWatchlistTV(mockTvRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(mockTvRepository.removeWatchlist(tTvDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(tTvDetail);
    // assert
    verify(mockTvRepository.removeWatchlist(tTvDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
