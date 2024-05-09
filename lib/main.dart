import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

// Importaciones firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Servicios
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Movie>> getMovies() async {
  List<Movie> movies = [];
  QuerySnapshot querySnapshot = await db.collection('people').get();

  querySnapshot.docs.forEach((document) {
    String documentId = document.id; // Obtener el ID del documento
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null) {
      String titulo = data['Titulo'] ?? '';
      int year = data['Año'] ?? 0;
      String genero = data['Genero'] ?? '';
      String director = data['Director'] ?? '';
      String imagen = data['Imagen'] ?? '';
      String sinopsis = data['Sinopsis'] ?? '';

      Movie movie = Movie(
        id: documentId, // Asignar el ID del documento al objeto Movie
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
  final String id;
  final String titulo;
  final int year;
  final String genero;
  final String director;
  final String imagen;
  final String sinopsis;

  Movie({
    required this.id,
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
  Future<void> refreshMovies() async {
    setState(() {});
  }

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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                          movie: movie,
                          onMovieDeleted: refreshMovies,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(
                        15), // Margen alrededor del contenedor
                    padding: const EdgeInsets.all(
                        8), // Relleno dentro del contenedor
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
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarPeliculaScreen()),
          );
        },
        backgroundColor: Colors.green, // Color del botón flotante
        foregroundColor: Colors.white, // Color del icono
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AgregarPeliculaScreen extends StatelessWidget {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController directorController = TextEditingController();
  final TextEditingController sinopsisController = TextEditingController();
  final TextEditingController imagenController = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> guardarPelicula(BuildContext context) async {
    try {
      await db.collection('people').add({
        'Titulo': tituloController.text,
        'Año': int.parse(anoController.text),
        'Genero': generoController.text,
        'Sinopsis': sinopsisController.text,
        'Imagen': imagenController.text,
      });

      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 100), () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pelicula con exito'),
        ));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MoviesInfoPage(),
        ));
      });
    } catch (e) {
      print('Error al guardar la pelicula: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pelicula'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextFormField(
                controller: anoController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: generoController,
                decoration: const InputDecoration(labelText: 'Género'),
              ),
              TextFormField(
                controller: directorController,
                decoration: const InputDecoration(labelText: 'Director'),
              ),
              TextFormField(
                controller: sinopsisController,
                decoration: const InputDecoration(labelText: 'Sinopsis'),
              ),
              TextFormField(
                controller: imagenController,
                decoration: const InputDecoration(labelText: 'Imagen'),
              ),
              const SizedBox(height: 40.0),
              Center(
                child: SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      guardarPelicula(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green[800] ?? Colors.green),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  final VoidCallback onMovieDeleted;

  const MovieDetailPage(
      {Key? key, required this.movie, required this.onMovieDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.titulo,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 46, 136),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                movie.imagen,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Text(
                        'Año: ${movie.year}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: Text(
                        'Genero: ${movie.genero}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Director: ${movie.director}',
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Sinopsis:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                movie.sinopsis,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Logica para eliminar la pelicula
                        if (movie.id != null && movie.id.isNotEmpty) {
                          try {
                            // Eliminar la pelicula de la base de datos
                            await db
                                .collection('people')
                                .doc(movie.id)
                                .delete();
                            logger.i('Pelicula eliminada con ID: ${movie.id}');
                            onMovieDeleted(); // Llamar a la función de actualización

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Pelicula eliminada con éxito'),
                            ));

                            // Rregesar a la vista "Movies FIrebase"
                            Navigator.pop(context);
                          } catch (e) {
                            logger.e('Error al eliminar la película: ${e}');
                          }
                        } else {
                          logger.e('El ID de la película es nulo o vacío.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[800],
                      ),
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
