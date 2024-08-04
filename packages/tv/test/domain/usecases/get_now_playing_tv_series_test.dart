import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTVRepository mockTvRepository;
  late GetNowPlayingTV usecase;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = GetNowPlayingTV(mockTvRepository);
  });

  final tTv = <TV>[];

  test('should get list of now playing tv series from the repository',
      () async {
    // arrange
    when(mockTvRepository.getNowPlayingTV())
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}
