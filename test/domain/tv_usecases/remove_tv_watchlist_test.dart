import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/remove_tv_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveTvWatchlist(mockTvSeriesRepository);
  });

  test('should remove watchlist tv from repository', () async {
    // arrange
    when(mockTvSeriesRepository.removeTvWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.removeTvWatchlist(testTvSeriesDetail));
    expect(result, Right('Removed from watchlist'));
  });
}