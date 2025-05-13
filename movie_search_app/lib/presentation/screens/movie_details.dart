import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';




class MovieDetails extends StatefulWidget {
  final MovieEntity movie;
  const MovieDetails({super.key, required this.movie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 500,
              floating: false,
              pinned: true,
              backgroundColor: Colors.black87,
              iconTheme: const IconThemeData(color: Colors.white), // White back arrow
              flexibleSpace: FlexibleSpaceBar(

                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.movie.posterPath != null)
                      Image.network(
                        'https://image.tmdb.org/t/p/w780${widget.movie.posterPath}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[900],
                          child: const Icon(Icons.broken_image, color: Colors.grey, size: 100),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text(
                            widget.movie.title,
                            style: const TextStyle(color: Colors.purple, fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Release Date: ${widget.movie.releaseDate ?? 'Unknown'}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rating: ${widget.movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'}/10',
                            style: TextStyle(fontSize: 16, color: Colors.yellow[400]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Overview',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.movie.overview ?? 'No overview available',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
