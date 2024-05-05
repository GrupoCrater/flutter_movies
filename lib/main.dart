import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

// Importaciones firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Servicios

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
          Positioned(
            top: 70,
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
                          builder: (context) => const PokeInfoPage()),
                    );
                  },
                  tooltip: 'Pokemon API',
                  child: const Text(
                    'Pokemon API',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),

          //Boton flotante
        ],
      ),
    );
  }
}

class PokeInfoPage extends StatefulWidget {
  const PokeInfoPage({Key? key}) : super(key: key);

  @override
  _PokeInfoPageState createState() => _PokeInfoPageState();
}

class _PokeInfoPageState extends State<PokeInfoPage> {
  late Future<List<Map<String, dynamic>>> pokemonDataList = Future.value([]);

  Future<List<Map<String, dynamic>>> fetchData() async {
    final List<Future<Map<String, dynamic>>> futures = [];
    for (int i = 1; i <= 20; i++) {
      futures.add(http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'))
          .then((response) {
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load data for Pokemon $i');
        }
      }));
    }
    return Future.wait(futures);
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        pokemonDataList = Future.value(data);
      });
    }).catchError((error) {
      logger.e('Error fetching data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información de Pokémon',
          style: TextStyle(
            color: Colors.white, //text color
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 46, 136),
      ),
      body: Container(
        color: const Color.fromARGB(255, 223, 223, 223),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: pokemonDataList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error:${snapshot.error}'));
            } else {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final pokemonData = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(20),
                        width: 370,
                        child: Column(
                          children: [
                            Text(
                              '${pokemonData['name'] ?? 'Nombre no disponible'}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Image.network(
                              pokemonData['sprites']?['front_default'] ??
                                  'URL_POR_DEFECTO_SI_ES_NULO',
                              height: 100,
                              width: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Altura:  ${pokemonData['height'] ?? 'Altura no disponible'}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Peso:  ${pokemonData['weight'] ?? 'Peso no disponible'}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No se han cargado datos'));
              }
            }
          },
        ),
      ),
    );
  }
}
