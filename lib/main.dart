import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> images = <Widget>[];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter App',
      home: Scaffold(
        body: SafeArea(
          right: false,
          left: false,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: const Text('Ricks & Others'),
          
                centerTitle: true,
                // floating: true,
                iconTheme: const IconThemeData(fill: 1, weight: 1),
                forceElevated: true,
                expandedHeight: 200,
                backgroundColor: Colors.deepOrange,
                shadowColor: const Color.fromARGB(255, 82, 194, 88),
                elevation: 10,
                flexibleSpace: Image.network(
                  'https://pm1.aminoapps.com/6587/6b475663f6fa9a52402b19627ee952602f05ae7a_hq.jpg',
                  fit: BoxFit.cover
                ),
              ),
              FutureBuilder(
                future: fetchCharacterImages(images),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SliverGrid.extent(
                      maxCrossAxisExtent: 400,
                      children: images
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SquareImageWidget extends StatelessWidget {
  final String imageUrl;
  final String text;

  const SquareImageWidget({super.key, required this.imageUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            margin: const EdgeInsets.all(2.0),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
            ),
            child: FadeInImage(
              placeholder: const AssetImage('assets/portal-rick-and-morty.gif'),
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 600),
            ),
          ),
        ),
        Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

Future<void> fetchCharacterImages(images) async {
  // final List<SquareImageWidget> images = [];

  final random = Random();
  final baseUrl = 'https://rickandmortyapi.com/api/character/';

  for (int i = 0; i < random.nextInt(10) + 25; i++) {
    final characterId = random.nextInt(826) + 1;
    final characterUrl = '$baseUrl$characterId';
    final response = await http.get(Uri.parse(characterUrl));
    // print('Response ${characterId} ${response}');
    if (response.statusCode == 200) {
      inspect(response);
      final characterData = json.decode(response.body);
      final imageUrl = characterData['image'];
      final nameCharacter = characterData['name'];
      // print('Image URL ${imageUrl}');
      images.add(SquareImageWidget(imageUrl: imageUrl, text: nameCharacter ));
    }
  }
}
