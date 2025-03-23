import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget {
  final Map<String, dynamic> weatherData;

  const WeatherScreen({super.key, required this.weatherData});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  List<Map<String, dynamic>> forecast = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  Future<Position> _getUserLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> fetchForecast() async {
    try {
      Position position = await _getUserLocation();
      final url = Uri.parse(
        'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=${position.latitude}&lon=${position.longitude}',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'YourAppName/1.0 (your.email@example.com)'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> timeseries =
            (data['properties']['timeseries'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();

        Map<String, Map<String, dynamic>> dailyForecast = {};
        for (var entry in timeseries) {
          DateTime date = DateTime.parse(entry['time']);
          String day = DateFormat('yyyy-MM-dd').format(date);
          if (!dailyForecast.containsKey(day)) {
            dailyForecast[day] = {
              'date': date,
              'temp': entry['data']['instant']['details']['air_temperature'],
            };
          }
        }

        setState(() {
          forecast = dailyForecast.values.take(7).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching weather: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather in ${widget.weatherData['name']}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade200,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Temperature Card
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text("${widget.weatherData['main']['temp']}°C",
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    widget.weatherData['weather'][0]
                                        ['description'],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Humidity & Wind Speed Row
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: Icon(Icons.water_drop,
                                      color: Colors.blue),
                                  title: Text("Humidity"),
                                  subtitle: Text(
                                      "${widget.weatherData['main']['humidity']}%"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: Icon(Icons.wind_power,
                                      color: Colors.green),
                                  title: Text("Wind Speed"),
                                  subtitle: Text(
                                      "${widget.weatherData['wind']['speed']} m/s"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Weather Forecast Chart
                        if (forecast.isNotEmpty)
                          SizedBox(
                            height: 250,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true, reservedSize: 40),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        if (index >= 0 &&
                                            index < forecast.length) {
                                          return Text(DateFormat('E')
                                              .format(forecast[index]['date']));
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: forecast
                                        .asMap()
                                        .entries
                                        .map((entry) => FlSpot(
                                            entry.key.toDouble(),
                                            entry.value['temp'].toDouble()))
                                        .toList(),
                                    isCurved: true,
                                    barWidth: 4,
                                    color: Colors.blue.shade200,
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 16),

                        // 7-Day Forecast
                        Text("7-Day Forecast",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),

                        SizedBox(
                          height: 110,
                          child: forecast.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: forecast.length,
                                  itemBuilder: (context, index) {
                                    var day = forecast[index];
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat('MMM d, E')
                                                    .format(day['date']),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.blue.shade800),
                                              ),
                                              SizedBox(height: 6),
                                              Text("${day['temp']}°C"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
