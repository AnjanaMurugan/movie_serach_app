// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:movie_search_app/domain/entities/movie_entity.dart';
//
// import 'package:movie_search_app/domain/usecases/movies_list_popular.dart';
// import 'package:movie_search_app/domain/usecases/serach_movies.dart';
// import 'package:movie_search_app/presentation/bloc/movie_bloc.dart';
// import 'package:movie_search_app/presentation/bloc/movie_event.dart';
//
//
// @GenerateMocks([SearchMovies, GetPopularMovies])
// void main() {
//   late MovieBloc movieBloc;
//   late MockSearchMovies mockSearchMovies;
//   late MockGetPopularMovies mockGetPopularMovies;
//
//   // Sample movie data for testing
//   final movie1 = MovieEntity(
//     id: 1,
//     title: 'Movie 1',
//     posterPath: '/poster1.jpg',
//     releaseDate: '2023-01-01',
//   );
//   final movie2 = MovieEntity(
//     id: 2,
//     title: 'Movie 2',
//     posterPath: '/poster2.jpg',
//     releaseDate: '2023-02-01',
//   );
//   final movieList = [movie1, movie2];
//
//   setUp(() {
//     mockSearchMovies = MockSearchMovies();
//     mockGetPopularMovies = MockGetPopularMovies();
//     movieBloc = MovieBloc(mockSearchMovies, mockGetPopularMovies);
//   });
//
//   tearDown(() {
//     movieBloc.close();
//   });
//
//   group('MovieBloc', () {
//     test('initial state is MovieInitial', () {
//       expect(movieBloc.state, isA<MovieInitial>());
//     });
//
//     group('FetchPopularMovies', () {
//       blocTest<MovieBloc, MovieState>(
//         'emits [MovieLoading, MovieLoaded] when FetchPopularMovies succeeds',
//         build: () {
//           when(mockGetPopularMovies(page: 1)).thenAnswer((_) async => movieList);
//           return movieBloc;
//         },
//         act: (bloc) => bloc.add(FetchPopularMovies()),
//         expect: () => [
//           isA<MovieLoading>(),
//           isA<MovieLoaded>()
//               .having((state) => state.movies, 'movies', movieList)
//               .having((state) => state.hasMore, 'hasMore', false)
//               .having((state) => state.isLoadingMore, 'isLoadingMore', false),
//         ],
//       );
//
//       blocTest<MovieBloc, MovieState>(
//         'emits [MovieLoading, MovieError] when FetchPopularMovies fails',
//         build: () {
//           when(mockGetPopularMovies(page: 1)).thenThrow(Exception('API Error'));
//           return movieBloc;
//         },
//         act: (bloc) => bloc.add(FetchPopularMovies()),
//         expect: () => [
//           isA<MovieLoading>(),
//           isA<MovieError>().having(
//                   (state) => state.message, 'message', contains('Failed to fetch popular movies')),
//         ],
//       );
//     });
//
//     group('SearchMoviess', () {
//       blocTest<MovieBloc, MovieState>(
//         'emits [MovieLoading, MovieLoaded] when SearchMoviess succeeds',
//         build: () {
//           when(mockSearchMovies('Avengers', page: 1)).thenAnswer((_) async => movieList);
//           return movieBloc;
//         },
//         act: (bloc) => bloc.add(const SearchMoviess('Avengers')),
//         expect: () => [
//           isA<MovieLoading>(),
//           isA<MovieLoaded>()
//               .having((state) => state.movies, 'movies', movieList)
//               .having((state) => state.hasMore, 'hasMore', false)
//               .having((state) => state.isLoadingMore, 'isLoadingMore', false),
//         ],
//       );
//
//       blocTest<MovieBloc, MovieState>(
//         'triggers FetchPopularMovies when SearchMoviess query is empty',
//         build: () {
//           when(mockGetPopularMovies(page: 1)).thenAnswer((_) async => movieList);
//           return movieBloc;
//         },
//         act: (bloc) => bloc.add(const SearchMoviess('')),
//         expect: () => [
//           isA<MovieLoading>(),
//           isA<MovieLoaded>()
//               .having((state) => state.movies, 'movies', movieList)
//               .having((state) => state.hasMore, 'hasMore', false)
//               .having((state) => state.isLoadingMore, 'isLoadingMore', false),
//         ],
//       );
//
//       blocTest<MovieBloc, MovieState>(
//         'emits [MovieLoading, MovieError] when SearchMoviess fails',
//         build: () {
//           when(mockSearchMovies('Avengers', page: 1)).thenThrow(Exception('API Error'));
//           return movieBloc;
//         },
//         act: (bloc) => bloc.add(const SearchMoviess('Avengers')),
//         expect: () => [
//           isA<MovieLoading>(),
//           isA<MovieError>()
//               .having((state) => state.message, 'message', contains('Failed to fetch movies')),
//         ],
//       );
//     });
//
//     group('LoadMorePopularMovies', () {
//       blocTest<MovieBloc, MovieState>(
//         'emits [MovieLoaded] with updated movies when LoadMorePopularMovies succeeds',
//         build: () {
//           when(mockGetPopularMovies(page: 2)).thenAnswer((_) async => [movie2]);
//           return movieBloc;
//         },
//         seed: () => MovieLoaded(
//           movies: movieList,
//           hasMore: true,
//           isLoadingMore: false,
//         ),
//         act: (bloc) => bloc.add(LoadMorePopularMovies()),
//         expect: () => [
//           isA<MovieLoaded>().having((state) => state.isLoadingMore, 'isLoadingMore', true),
//           isA<MovieLoaded>()
//               .having((state) => state.movies, 'movies', [...movieList, movie2])
//               .having((state) => state.hasMore, 'hasMore', false)
//               .having((state) => state.isLoadingMore, 'isLoadingMore', false),
//         ],
//       );
//
//       blocTest<MovieBloc, MovieState>(
//         'does not emit new state when hasMore is false',
//         build: () => movieBloc,
//         seed: () => const MovieLoaded(
//           movies: [],
//           hasMore: false,
//           isLoadingMore: false,
//         ),
//         act: (bloc) => bloc.add(LoadMorePopularMovies()),
//         expect: () => [],
//       );
//     });
//
//     group('LoadMoreSearchMovies', () {
//       blocTest<MovieBloc, MovieState>(
//         'emits [MovieLoaded] with updated movies when LoadMoreSearchMovies succeeds',
//         build: () {
//           when(mockSearchMovies('Avengers', page: 2)).thenAnswer((_) async => [movie2]);
//           return movieBloc;
//         },
//         seed: () => MovieLoaded(
//           movies: movieList,
//           hasMore: true,
//           isLoadingMore: false,
//         ),
//         act: (bloc) {
//           bloc.currentQuery = 'Avengers';
//           bloc.add(LoadMoreSearchMovies());
//         },
//         expect: () => [
//           isA<MovieLoaded>().having((state) => state.isLoadingMore, 'isLoadingMore', true),
//           isA<MovieLoaded>()
//               .having((state) => state.movies, 'movies', [...movieList, movie2])
//               .having((state) => state.hasMore, 'hasMore', false)
//               .having((state) => state.isLoadingMore, 'isLoadingMore', false),
//         ],
//       );
//
//       blocTest<MovieBloc, MovieState>(
//         'emits [MovieLoaded] with isLoadingMore false when LoadMoreSearchMovies fails',
//         build: () {
//           when(mockSearchMovies('Avengers', page: 2)).thenThrow(Exception('API Error'));
//           return movieBloc;
//         },
//         seed: () => MovieLoaded(
//           movies: movieList,
//           hasMore: true,
//           isLoadingMore: false,
//         ),
//         act: (bloc) {
//           bloc.currentQuery = 'Avengers';
//           bloc.add(LoadMoreSearchMovies());
//         },
//         expect: () => [
//           isA<MovieLoaded>().having((state) => state.isLoadingMore, 'isLoadingMore', true),
//           isA<MovieLoaded>()
//               .having((state) => state.movies, 'movies', movieList)
//               .having((state) => state.isLoadingMore, 'isLoadingMore', false),
//         ],
//       );
//     });
//   });
// }