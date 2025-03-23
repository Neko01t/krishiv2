import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  PokemonScreenState createState() => PokemonScreenState();
}

class PokemonScreenState extends State<PokemonScreen> {
  List<dynamic> _pokemonCards = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchPokemonCards();
  }

  Future<void> fetchPokemonCards() async {
    final response =
        await http.get(Uri.parse('https://api.pokemontcg.io/v2/cards'));
    if (response.statusCode == 200) {
      setState(() {
        _pokemonCards = json.decode(response.body)['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon Cards')),
      body: _pokemonCards.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: CarouselSlider.builder(
                    itemCount: _pokemonCards.length,
                    options: CarouselOptions(
                      height: 700,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      var card = _pokemonCards[index];
                      bool isCenter = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (card['images'] != null &&
                                  card['images']['large'] != null)
                                Image.network(
                                  card['images']['large'],
                                  height: isCenter ? 280 : 200,
                                  fit: BoxFit.cover,
                                ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  card['name'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontFamily: 'Pokemon',
                                    fontSize: 24,
                                    fontWeight: FontWeight
                                        .bold, // This will use 'Pokemon Solid.ttf'
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
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
