import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

// Importaciones firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Servicios
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Movie>> getMovies() async {
  List<Movie> movies = [];
  CollectionReference collectionReference = db.collection('people');

  QuerySnapshot querySnapshot = await collectionReference.get();

  querySnapshot.docs.forEach((document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (data != null) {
      String titulo =
          data['Titulo'] ?? ''; // Si es nulo, asigna una cadena vacía
      int year = data['Año'] ??
          0; // Si es nulo, asigna 0 (o cualquier otro valor predeterminado)
      String genero = data['Genero'] ?? '';
      String director = data['Director'] ?? '';
      String imagen = data['Imagen'] ?? '';
      String sinopsis = data['Sinopsis'] ?? '';

      Movie movie = Movie(
        titulo: titulo,
        year: year,
        genero: genero,
        director: director,
        imagen: imagen,
        sinopsis: sinopsis,
      );
      movies.add(movie);
    }
  });

  return movies;
}

final logger = Logger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); //AQUI

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //Para quitar banner DEBUG
      title: 'Catálogo Peliculas',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catálogo Peliculas',
          style: TextStyle(
            color: Colors.white, //text color
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 46, 136),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://img.freepik.com/free-vector/cinema-realistic-poster-with-illuminated-bucket-popcorn-drink-3d-glasses-reel-tickets-blue-background-with-tapes-vector-illustration_1284-77070.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text('BIENVENIDO',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            ),
          ),

          //Boton flotante

          //Boton flotante
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MoviesInfoPage()),
                    );
                  },
                  tooltip: 'Movies Firebase',
                  child: const Text(
                    'Movies Firebase',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Movie {
  final String titulo;
  final int year;
  final String genero;
  final String director;
  final String imagen;
  final String sinopsis;

  Movie({
    required this.titulo,
    required this.year,
    required this.genero,
    required this.director,
    required this.imagen,
    required this.sinopsis,
  });
}

class MoviesInfoPage extends StatefulWidget {
  const MoviesInfoPage({Key? key}) : super(key: key);

  @override
  _MoviesInfoPageState createState() => _MoviesInfoPageState();
}

class _MoviesInfoPageState extends State<MoviesInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies Firebase',
          style: TextStyle(
            color: Colors.white, //text color
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 46, 136),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<Movie>>(
        future: getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Movie> movies = snapshot.data!;
            movies.sort(
                (a, b) => a.titulo.compareTo(b.titulo)); // Ordenar por título

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                Movie movie = movies[index];
                return Container(
                  margin: const EdgeInsets.all(
                      15), // Margen alrededor del contenedor
                  padding:
                      const EdgeInsets.all(8), // Relleno dentro del contenedor
                  decoration: BoxDecoration(
                    color: Colors.white, // Color de fondo blanco
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Sombra gris
                        spreadRadius: 2, // Extensión de la sombra
                        blurRadius: 5, // Desenfoque de la sombra
                        offset:
                            const Offset(0, 3), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        movie.titulo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                movie.imagen,
                                width: 400,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Año: ${movie.year}',
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Año: ${movie.genero}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
