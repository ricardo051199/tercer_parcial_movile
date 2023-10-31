import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Movie {
  final String title;
  final String overview;
  final double voteAverage;
  final String releaseDate;
  final bool adult;
  final String posterPath;

  Movie({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.adult,
    required this.posterPath,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = 'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500'; 
  List<Movie> movies = [];
  int page = 1; 
  final int moviesPerPage = 10; 
  int cardNumber = 0;

  void decreaseNumber() {
    setState(() {
      if (cardNumber > 0) {
        cardNumber--;
      }
    });
  }

  void increaseNumber() {
    setState(() {
      if (cardNumber < movies.length - 1) {
        cardNumber++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPopularMovies();
  }


  Future<void> fetchPopularMovies() async {
    final response = await http.get(Uri.parse('$apiUrl&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      if (results is List) {
        movies = results
            .map((movieData) => Movie(
                  title: movieData['title'],
                  overview: movieData['overview'],
                  voteAverage: (movieData['vote_average'] as num).toDouble(),
                  releaseDate: movieData['release_date'],
                  adult: movieData['adult'],
                  posterPath: imageBaseUrl + movieData['poster_path'],
                ))
            .toList();
        setState(() {});
      }
    }
  }

  void nextPage() {
    page++;
    fetchPopularMovies();
  }

  void previousPage() {
    if (page > 1) {
      page--;
      fetchPopularMovies();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CINEMOV'),
        ),
        body: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              elevation: 4, 
              margin: const EdgeInsets.all(8), 
              child: ListTile(
                contentPadding: const EdgeInsets.all(8), 
                title: Text(
                  movie.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), 
                      child: Image.network(
                        movie.posterPath,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Precio por entrada : 30',
                      style: TextStyle(fontSize: 14,),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove), 
                      onPressed: () {
                        decreaseNumber();
                      },
                    ),
                    Text(cardNumber.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          increaseNumber();
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Número Confirmado'),
                              content: Text('El número es: $cardNumber'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Confirmar'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: previousPage,
              ),
              Text('Página $page'),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
