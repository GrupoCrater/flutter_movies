import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

//Text, Row, Column, Stack y Container
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.blue,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LdSW Widgets', //Text
          style:
              TextStyle(color: Color.fromARGB(255, 255, 255, 255)), //text color
        ),
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Colors.grey[200], //Color de fondo de palicacion
      body: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: 350,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    child: Text("JC"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Julio César Salazar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 83, 83, 83),
                    ),
                  )
                ],
              ),
              const Text(
                  "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor.",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey)),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Image.network(
                    "https://ichef.bbci.co.uk/ace/ws/640/cpsprodpb/11774/production/_123004517_mediaitem123003832.jpg"),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text("Me gusta", style: textStyle)),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Comentar",
                            style: textStyle,
                          )),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Compartir",
                            style: textStyle,
                          )),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
