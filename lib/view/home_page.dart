import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_hub/bloc/movies_bloc_bloc.dart';
import 'package:movie_hub/bloc/movies_bloc_event.dart';
import 'package:movie_hub/bloc/movies_bloc_state.dart';
import 'package:movie_hub/models/movie_details_model.dart';
import 'package:movie_hub/services/api_services.dart';
import 'package:movie_hub/view/movie_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isLoadingNextPage = false;
  ScrollController scrollController = ScrollController();

  void onScroll() {
    if (scrollController.position.extentAfter == 0) {
      if (!isLoading && !isLoadingNextPage) {
        isLoadingNextPage = true;

        currentPage++;
        BlocProvider.of<MoviesBloc>(context)
            .add(FetchMoviesEvent(currentPage, context));
      }
    }
  }

  void initState() {
    super.initState();
    isLoadingNextPage = false;
    scrollController.addListener(() {
      onScroll();
    });
    BlocProvider.of<MoviesBloc>(context)
        .add(FetchMoviesEvent(currentPage, context));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: const Text(
          'Movies Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: currentPage == 1? MainAxisAlignment.center: MainAxisAlignment.start,
          children: [
            BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                isLoading = state is MoviesLoading;
                if (state is MoviesLoading && currentPage == 1) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MoviesError) {
                  return Center(child: Text(state.error));
                } else if (state is MoviesLoaded) {
                  final allMovies = state.movies;
                  isLoading = false;
                  return Expanded(
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (scrollInfo) {
                        if (!isLoading &&
                            scrollInfo is ScrollEndNotification &&
                            scrollInfo.metrics.extentAfter == 0) {
                          // User has reached the end of the list, load more movies
                          isLoadingMore = true;
                          currentPage++;
                          BlocProvider.of<MoviesBloc>(context)
                              .add(FetchMoviesEvent(currentPage, context));
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          final dataIndex = index % 20;
                          if (dataIndex < allMovies.length) {
                            final movies = allMovies[dataIndex];
                            final imageUrl =
                                'http://image.tmdb.org/t/p/w185/${movies.posterPath}';

                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    onTap: () async {
                                      MovieDetailsModel movieDetailsModel =
                                          await fetchMovieDetails(movies.id)
                                              as MovieDetailsModel;

                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailsScreen(
                                                movieDetails:
                                                    movieDetailsModel),
                                      ));
                                    },
                                    leading: Image.network(imageUrl,
                                        width: 100,
                                        height: 150,
                                        fit: BoxFit.cover),
                                    title: Text(
                                      movies.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      movies.overview,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 24,
                                    ),
                                  ),
                                ));
                          }
                        },
                        itemCount: currentPage * 20 + (isLoading ? 1 : 0),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
