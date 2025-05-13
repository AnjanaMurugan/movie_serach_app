import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';

import '../widget/movie_title.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        final state = context.read<MovieBloc>().state;
        if (state is MovieLoaded && state.hasMore && !state.isLoadingMore) {
          print('Triggering LoadMore, query: ${context.read<MovieBloc>().currentQuery}');
          if (context.read<MovieBloc>().currentQuery != null) {
            context.read<MovieBloc>().add(LoadMoreSearchMovies());
          } else {
            context.read<MovieBloc>().add(LoadMorePopularMovies());
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter movie name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Curved border
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (query) {
                context.read<MovieBloc>().add(SearchMoviess(query)); // Fixed
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                print('UI State: ${state.runtimeType}'); // Debug
                if (state is MovieInitial) {
                  return const Center(
                    child: Text(
                      'Search for a movie or wait for popular movies.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (state is MovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                } else if (state is MovieLoaded) {
                  if (state.movies.isEmpty) {
                    return const Center(
                      child: Text(
                        'No movies found. Try another search.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: state.movies.length,
                          itemBuilder: (context, index) {
                            final movie = state.movies[index];
                            return MovieTile(movie: movie);
                          },
                        ),
                      ),
                      if (state.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                    ],
                  );
                } else if (state is MovieError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'Something went wrong. Please try again.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}