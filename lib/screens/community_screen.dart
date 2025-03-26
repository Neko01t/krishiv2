import 'dart:math';
import 'package:flutter/material.dart';
import 'package:krishi/utils/map_utils.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart' as latlng;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// Earth's radius in meters
const double EARTH_RADIUS = 6378137.0;
double zoomLevel = 15;
// double areaMeters = 0.0;

/// Converts latitude & longitude to Cartesian (meters)
List<Offset> _convertLatLngToMeters(List<latlng.LatLng> points) {
  if (points.isEmpty) return [];

  double lat0 = points[0].latitude.radians; // Reference latitude (radians)
  double lon0 = points[0].longitude.radians; // Reference longitude (radians)

  return points.map((point) {
    double x = EARTH_RADIUS * (point.longitude.radians - lon0) * cos(lat0);
    double y = EARTH_RADIUS * (point.latitude.radians - lat0);
    return Offset(x, y);
  }).toList();
}

/// Function to calculate area of a polygon from latitude & longitude points
double calculatePolygonArea(List<latlng.LatLng> points) {
  if (points.length < 3) {
    return 0.0; // At least 3 points needed to form a polygon
  }

  List<Offset> xyPoints = _convertLatLngToMeters(points);
  double area = 0.0;
  int n = xyPoints.length;

  for (int i = 0; i < n; i++) {
    int j = (i + 1) % n; // Next vertex (wraps around for last vertex)
    area += xyPoints[i].dx * xyPoints[j].dy - xyPoints[j].dx * xyPoints[i].dy;
  }

  return (area.abs() / 2.0); // Return absolute area in square meters
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  double polygonArea = 0.0;
  double acres = 0.0;

  final MapController controller = MapController(
    location: latlng.LatLng(
      latlng.Angle.degree(19.8762),
      latlng.Angle.degree(75.3433),
    ),
    zoom: zoomLevel,
  );

  // 🔹 Store tapped locations (blue markers)
  List<latlng.LatLng> tappedLocations = [];

  // 🔹 Move map on drag
  void _onDrag(Offset delta) {
    setState(() {
      controller.center = latlng.LatLng(
        latlng.Angle.degree(
            controller.center.latitude.degrees + delta.dy * 0.0001),
        latlng.Angle.degree(
            controller.center.longitude.degrees - delta.dx * 0.0001),
      );
    });
  }

  void _onZoom(bool zoomIn) {
    setState(() {
      zoomLevel = zoomIn ? zoomLevel + 1 : zoomLevel - 1;
      zoomLevel =
          zoomLevel.clamp(1, 18); // Ensures zoom level stays between 1 and 18
      controller.zoom = zoomLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MapLayout(
      controller: controller,
      builder: (context, transformer) {
        return GestureDetector(
          onPanUpdate: (details) => _onDrag(details.delta),

          // 🔹 Handle Long Press Event to store tapped location
          onLongPressStart: (LongPressStartDetails details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final Offset localOffset =
                renderBox.globalToLocal(details.globalPosition);

            setState(() {
              tappedLocations.add(transformer.toLatLng(localOffset));
              polygonArea = calculatePolygonArea(tappedLocations);
              acres = MapUtils.squareMetersToAcres(polygonArea);
            });

            // print(
            //     "Tapped Locations: ${tappedLocations.map((p) => '(${p.latitude}, ${p.longitude})').toList()}");
            // double areaMeters = calculatePolygonArea(tappedLocations);
            // print("Polygon Area: ${areaMeters.toStringAsFixed(2)} m²");
          },

          child: Stack(
            children: [
              // 🔹 Map Tiles
              TileLayer(
                builder: (context, x, y, z) {
                  final tilesInZoom = pow(2.0, z).floor();
                  x = (x % tilesInZoom + tilesInZoom) % tilesInZoom;
                  y = (y % tilesInZoom + tilesInZoom) % tilesInZoom;
                  final url =
                      'https://www.google.com/maps/vt?lyrs=s&x=$x&y=$y&z=$z';
                  return CachedNetworkImage(imageUrl: url, fit: BoxFit.cover);
                },
              ),

              // 🔹 Draw blue markers for tapped locations
              for (var marker in tappedLocations)
                Positioned(
                  left: transformer.toOffset(marker).dx - 10,
                  top: transformer.toOffset(marker).dy - 10,
                  child: const Icon(Icons.location_on,
                      color: Colors.blue, size: 30),
                ),

              if (tappedLocations.length > 1)
                CustomPaint(
                  size: Size.infinite,
                  painter: MapLinePainter(
                      tappedLocations.map(transformer.toOffset).toList()),
                ),
              Positioned(
                bottom: 80,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (tappedLocations.isNotEmpty) {
                        tappedLocations.removeLast();
                      }
                    });
                  },
                  backgroundColor: const Color.fromARGB(255, 54, 244, 228),
                  child: const Icon(Icons.undo_rounded, color: Colors.white),
                ),
              ),

              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      tappedLocations.clear(); // 🔹 Clear all markers and lines
                    });
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    _onZoom(false);
                  },
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 140,
                child: FloatingActionButton(
                  onPressed: () {
                    _onZoom(true);
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
              Positioned(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 20),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          const BoxShadow(color: Colors.black12, blurRadius: 3)
                        ],
                      ),
                      child: Column(children: [
                        Text(
                            ['Area: ', acres.toStringAsFixed(2), ' m²']
                                .join(''),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ])))
            ],
          ),
        );
      },
    );
  }
}

// 🔹 Custom Painter for drawing lines
class MapLinePainter extends CustomPainter {
  final List<Offset> points;
  MapLinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    if (points.length > 7) return;

    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // 🔹 Close the shape by connecting last to first
    if (points.length > 3) {
      path.lineTo(points.first.dx, points.first.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
