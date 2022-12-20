import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetRecommendationsTvSeries {
  final TvSeriesRepository repository;

  GetRecommendationsTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(id) {
    return repository.getTvSeriesRecomendation(id);
  }
}