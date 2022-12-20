import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_on_air_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnAirTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetOnAirTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  group('GetOnAirTvSeries Tests', () {
    group('execute', () {
      test('should get list of tv from the repository', () async {
        // arrange
        when(mockTvSeriesRepository.getOnAirTvSeries())
            .thenAnswer((_) async => Right(tTvSeries));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tTvSeries));
      });
    });
  });
}