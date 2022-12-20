import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  TvSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) => TvSeriesTable(
    id: tvSeries.id,
    name: tvSeries.name,
    posterPath: tvSeries.posterPath,
    overview: tvSeries.overview,
  );

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
    id: map['id'],
    name: map['name'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  factory TvSeriesTable.fromDTO(TvModel tvSeries) => TvSeriesTable(
    id: tvSeries.id,
    name: tvSeries.name,
    posterPath: tvSeries.posterPath,
    overview: tvSeries.overview,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'posterPath': posterPath,
    'overview': overview,
  };

  TvSeries toEntity() => TvSeries.watchlist(
    id: id,
    name: name,
    posterPath: posterPath,
    overview: overview,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    posterPath,
    overview,
  ];
}