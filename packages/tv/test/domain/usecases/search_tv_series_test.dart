import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/search_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTV usecase;
  late MockTVRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = SearchTV(mockTvRepository);
  });

  final tTv = <TV>[];
  const tQuery = 'Game of Thrones';

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.searchTV(tQuery)).thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTv));
  });
}
