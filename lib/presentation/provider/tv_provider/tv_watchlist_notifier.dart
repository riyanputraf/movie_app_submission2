import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_watchlist_tv.dart';
import 'package:flutter/material.dart';

class TvWatchlistNotifier extends ChangeNotifier {
  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistTvState = RequestState.Empty;
  RequestState get watchlistTvState => _watchlistTvState;

  String _message = '';
  String get message => _message;

  TvWatchlistNotifier({required this.getWatchlistTvSeries});

  final GetWatchlistTvSeries getWatchlistTvSeries;

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistTvState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
          (failure) {
        _watchlistTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvData) {
        _watchlistTvState = RequestState.Loaded;
        _watchlistTvSeries = tvData;
        notifyListeners();
      },
    );
  }
}