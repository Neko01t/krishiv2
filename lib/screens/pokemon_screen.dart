import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  PokemonScreenState createState() => PokemonScreenState();
}

class PokemonScreenState extends State<PokemonScreen> {
  List<dynamic> _pokemonCards = [];
  int currentIndex = 0;
  bool _isLoading = true;

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
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 300,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokémon Cards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CarouselSlider.builder(
                itemCount: _isLoading ? 5 : _pokemonCards.length,
                options: CarouselOptions(
                  height: 500,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.7,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  if (_isLoading) {
                    return _buildLoadingCard();
                  }
                  var card = _pokemonCards[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (card['images'] != null &&
                              card['images']['large'] != null)
                            Image.network(
                              card['images']['large'],
                              height: 350,
                              fit: BoxFit.cover,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              card['name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }
}
