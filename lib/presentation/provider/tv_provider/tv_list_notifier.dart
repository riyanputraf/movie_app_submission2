import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_on_air_tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_top_rated_tv.dart';
import 'package:flutter/material.dart';

class TvListNotifier extends ChangeNotifier {
  var _onAirTvSeries = <TvSeries>[];
  List<TvSeries> get onAirTvSeries => _onAirTvSeries;

  RequestState _onAirState = RequestState.Empty;
  RequestState get onAirState => _onAirState;

  var _popularTvSeries = <TvSeries>[];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularTvSeriesState = RequestState.Empty;
  RequestState get popularTvSeriesState => _popularTvSeriesState;

  var _topRatedTvSeries = <TvSeries>[];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedTvSeriesState = RequestState.Empty;
  RequestState get topRatedTvSeriesState => _topRatedTvSeriesState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getOnAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  });

  final GetOnAirTvSeries getOnAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> fetchOnAirTvSeries() async {
    _onAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvSeries.execute();
    result.fold(
          (failure) {
        _onAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvSeriesData) {
        _onAirState = RequestState.Loaded;
        _onAirTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvSeries() async {
    _popularTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
          (failure) {
        _popularTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvSeriesData) {
        _popularTvSeriesState = RequestState.Loaded;
        _popularTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
          (failure) {
        _topRatedTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvSeriesData) {
        _topRatedTvSeriesState = RequestState.Loaded;
        _topRatedTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}