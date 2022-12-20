// To parse this JSON data, do
//
//     final tvSeriesResponse = tvSeriesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/tv.dart';

TvResponse tvSeriesResponseFromJson(String str) =>
    TvResponse.fromJson(json.decode(str));

String tvSeriesResponseToJson(TvResponse data) =>
    json.encode(data.toJson());

class TvResponse {
  TvResponse({
    required this.tvList,
  });

  List<TvModel> tvList;

  factory TvResponse.fromJson(Map<String, dynamic> json) =>
      TvResponse(
        tvList: List<TvModel>.from(
            json["results"].map((x) => TvModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(tvList.map((x) => x.toJson())),
  };
}

class TvModel extends Equatable {
  TvModel({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String name;
  final List<String> originCountry;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
    backdropPath: json["backdrop_path"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    name: json["name"],
    originCountry: List<String>.from(json["origin_country"].map((x) => x)),
    originalName: json["original_name"],
    overview: json["overview"],
    popularity: json["popularity"].toDouble(),
    posterPath: json["poster_path"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "name": name,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    // "original_language": originalLanguageValues.reverse[originalLanguage],
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TvSeries toEntity() {
    return TvSeries(
      backdropPath: this.backdropPath,
      genreIds: this.genreIds,
      id: this.id,
      name: this.name,
      originCountry: this.originCountry,
      originalName: this.originalName,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    genreIds,
    id,
    name,
    originCountry,
    originalName,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
  ];
}
