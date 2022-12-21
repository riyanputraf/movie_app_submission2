import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecase/get_movie_recommendations.dart';

part 'recommendation_movies_event.dart';
part 'recommendation_movies_state.dart';

class RecommendationMoviesBloc
    extends Bloc<RecommendationMoviesEvent, RecommendationMoviesState> {
  final GetMovieRecommendations _getMovieRecommendations;

  RecommendationMoviesBloc(this._getMovieRecommendations)
      : super(RecommendationMoviesEmpty()) {
    on<FetchRecommendationMovies>((event, emit) async {
      final id = event.id;
      emit(RecommendationMoviesLoading());

      final result = await _getMovieRecommendations.execute(id);

      result.fold((failure) {
        emit(RecommendationMoviesError(failure.message));
      }, (data) {
        emit(RecommendationMoviesHasData(data));
      });
    });
  }
}
