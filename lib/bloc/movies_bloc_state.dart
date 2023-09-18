import 'package:equatable/equatable.dart';

import '../models/movies_model.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;

  MoviesLoaded(this.movies);

  @override
  List<Object?> get props => [movies];

  @override
  String toString() => 'MoviesLoaded(movies: $movies)';
}

class MoviesError extends MoviesState {
  final String error;

  MoviesError(this.error);

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'MoviesError(error: $error)';
}
