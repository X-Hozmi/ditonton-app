import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTVRepository mockTvRepository;
  late GetTopRatedTV usecase;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = GetTopRatedTV(mockTvRepository);
  });

  final tTv = <TV>[];

  test('should get list of top rated tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getTopRatedTV()).thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}
