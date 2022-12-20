import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/search_tv_series.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSearchNotifier provider;
  late MockSearchTvSeries mockSearchTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvSeries = MockSearchTvSeries();
    provider = TvSearchNotifier(searchTvSeries: mockSearchTvSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTvModel = TvSeries(
      backdropPath: '/rkB4LyZHo1NHXFEDHl9vSD9r1lI.jpg',
      genreIds: [16, 10765, 10759, 18],
      id: 94605,
      name: 'Arcane',
      originCountry: ['US'],
      originalName: "Arcane",
      overview:
      "Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.",
      popularity: 88.071,
      posterPath: '/xQ6GijOFnxTyUzqiwGpVxgfcgqI.jpg',
      voteAverage: 8.7,
      voteCount: 2622);
  final tTvList = <TvSeries>[tTvModel];
  final tQuery = 'arcane';

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
            () async {
          // arrange
          when(mockSearchTvSeries.execute(tQuery))
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchTvSearch(tQuery);
          // assert
          expect(provider.state, RequestState.Loaded);
          expect(provider.searchTvResult, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
