import 'package:flutter/cupertino.dart';

abstract class MoviesEvent {}

class FetchMoviesEvent extends MoviesEvent{
  final int page;
 final BuildContext context;
  FetchMoviesEvent(this.page, this.context);
}