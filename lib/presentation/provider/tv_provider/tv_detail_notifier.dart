import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_detail_tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_recommendations_tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/save_tv_watchlist.dart';
import 'package:flutter/material.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const tvWatchlistAddSuccessMessage = 'Added to Watchlist';
  static const tvWatchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetDetailTvSeries getDetailTvSeries;
  final GetRecommendationsTvSeries getRecommendationsTvSeries;
  final GetWatchListTvStatus getWatchListTvStatus;
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvWatchlist;

  TvDetailNotifier({
    required this.getDetailTvSeries,
    required this.getRecommendationsTvSeries,
    required this.getWatchListTvStatus,
    required this.saveTvWatchlist,
    required this.removeTvWatchlist,
  });

  late TvSeriesDetail _tvSeries;
  TvSeriesDetail get tvSeries => _tvSeries;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<TvSeries> _tvRecommendations = [];
  List<TvSeries> get tvRecommendations => _tvRecommendations;

  RequestState _tvRecommendationsState = RequestState.Empty;
  RequestState get tvRecommendationsState => _tvRecommendationsState;

  String _message = '';
  String get message => _message;

  bool _tvIsAddedtoWatchlist = false;
  bool get tvIsAddedtoWatchlist => _tvIsAddedtoWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailTvResult = await getDetailTvSeries.execute(id);
    final recommendationsTvResult =
    await getRecommendationsTvSeries.execute(id);
    detailTvResult.fold(
          (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvSeries) {
        _tvRecommendationsState = RequestState.Loading;
        _tvSeries = tvSeries;
        recommendationsTvResult.fold(
              (failure) {
            _tvRecommendationsState = RequestState.Error;
            _message = failure.message;
          },
              (tvSeries) {
            _tvRecommendationsState = RequestState.Loaded;
            _tvRecommendations = tvSeries;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _tvWatchlistMessage = '';
  String get tvWatchlistMessage => _tvWatchlistMessage;

  Future<void> addTvWatchlist(TvSeriesDetail tvSeries) async {
    final result = await saveTvWatchlist.execute(tvSeries);

    await result.fold(
          (failure) async {
        _tvWatchlistMessage = failure.message;
      },
          (succsessMessage) async {
        _tvWatchlistMessage = succsessMessage;
      },
    );

    await loadTvWatchlistStatus(tvSeries.id);
  }

  Future<void> removeTvFromWatchlist(TvSeriesDetail tvSeries) async {
    final result = await removeTvWatchlist.execute(tvSeries);

    await result.fold(
          (failure) async {
        _tvWatchlistMessage = failure.message;
      },
          (successMessage) async {
        _tvWatchlistMessage = successMessage;
      },
    );

    await loadTvWatchlistStatus(tvSeries.id);
  }

  Future<void> loadTvWatchlistStatus(int id) async {
    final result = await getWatchListTvStatus.execute(id);
    _tvIsAddedtoWatchlist = result;
    notifyListeners();
  }
}