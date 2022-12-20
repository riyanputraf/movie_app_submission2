import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_detail_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetDetailTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetDetailTvSeries(mockTvSeriesRepository);
  });

  final tId = 1;

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesDetail(tId))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvSeriesDetail));
  });
}