import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTVRepository mockTvRepository;
  late GetPopularTV usecase;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = GetPopularTV(mockTvRepository);
  });

  final tTv = <TV>[];

  test('should get list of popular tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getPopularTV()).thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}
