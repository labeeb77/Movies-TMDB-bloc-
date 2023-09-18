import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_hub/models/movies_model.dart';
import 'package:movie_hub/services/api_services.dart';

import 'movies_bloc_event.dart';
import 'movies_bloc_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(MoviesLoading()) {
    on<FetchMoviesEvent>((event, emit) async {
      await handleFetchMovies(event.context, event.page, emit);
    });
  }

  Future<void> handleFetchMovies(
    BuildContext context,
    int page,
    Emitter<MoviesState> emit,
  ) async {
    try {
      final List<Movie> movies = await fetchTrendingMovies(context, page);
      emit(MoviesLoaded(movies));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }
}
