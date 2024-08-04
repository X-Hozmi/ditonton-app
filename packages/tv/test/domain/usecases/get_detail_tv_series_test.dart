import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVDetail usecase;
  late MockTVRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = GetTVDetail(mockTvRepository);
  });

  const tId = 1;

  test('should get tv series detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTVDetail(tId))
        .thenAnswer((_) async => const Right(tTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, const Right(tTvDetail));
  });
}
