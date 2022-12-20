import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_uses_cases/get_on_air_tv.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/entities/tv.dart';

class TvOnAirNotifier extends ChangeNotifier {
  final GetOnAirTvSeries getOnAirTvSeries;

  TvOnAirNotifier(this.getOnAirTvSeries);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvSeries> _tvSeries = [];
  List<TvSeries> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnAirTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvSeries.execute();

    result.fold((failure) {
      _message = failure.message;
      _state = RequestState.Error;
      notifyListeners();
    }, (tvData) {
      _tvSeries = tvData;
      _state = RequestState.Loaded;
      notifyListeners();
    });
  }
}
