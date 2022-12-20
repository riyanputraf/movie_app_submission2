import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_on_air_tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../movie_detail_notifier_test.mocks.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetOnAirTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvListNotifier provider;
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = TvListNotifier(
      getOnAirTvSeries: mockGetOnAirTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tTv = TvSeries(
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      name: 'name',
      originCountry: ['id'],
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      voteAverage: 1,
      voteCount: 1);
  final tTvList = <TvSeries>[tTv];

  group('On Air TV Series', () {
    test('initialState should be Empty', () {
      expect(provider.onAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnAirTvSeries();
      // assert
      verify(mockGetOnAirTvSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnAirTvSeries();
      // assert
      expect(provider.onAirState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchOnAirTvSeries();
      // assert
      expect(provider.onAirState, RequestState.Loaded);
      expect(provider.onAirTvSeries, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnAirTvSeries();
      // assert
      expect(provider.onAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Popular TV Series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularTvSeriesState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change movies data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchPopularTvSeries();
          // assert
          expect(provider.popularTvSeriesState, RequestState.Loaded);
          expect(provider.popularTvSeries, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularTvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedTvSeriesState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchTopRatedTvSeries();
          // assert
          expect(provider.topRatedTvSeriesState, RequestState.Loaded);
          expect(provider.topRatedTvSeries, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedTvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
