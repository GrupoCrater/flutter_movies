import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Para quitar banner DEBUG

      title: 'Catálogo Peliculas',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Catálogo Peliculas',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255)), //text color),
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
              top: 80,
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
            )
          ],
        ),
      ),
    );
  }
}
