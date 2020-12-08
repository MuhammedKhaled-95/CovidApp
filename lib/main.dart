import 'package:covidapp/Model/Point.dart';
import 'package:covidapp/Model/Polygon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:covidapp/Controller/APIManager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var apiManager = FetchManger();
  Future<List<Point>> futurePoints;
  Future<List<CustomPoly>> futurePolygons;
  var flutterMap;
  var polygonLayer = new PolygonLayerOptions(polygons: []);
  var circuleLayer = new CircleLayerOptions(circles: []);
  var markerLayer = new MarkerLayerOptions(
    markers: [],
  );

  void getPoints() {
    futurePoints = apiManager.getPoints();
    futurePoints.then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              markerLayer.markers.add(new Marker(
                point: value[i].geometry.coordinates,
                builder: (ctx) => new Container(
                  child: new Icon(
                    Icons.pin_drop,
                    color: Colors.blue,
                    size: 35.0,
                  ),
                ),
              ))
            }
        });
  }

  void getPolygones() {
    futurePolygons = apiManager.getPolygons();
    futurePolygons.then((value) {
      for (int i = 0; i < value.length; i++) {
        var tempPoly = new Polygon(
            points: value[i].geometry.coordinates,
            color: Colors.blue.withOpacity(0.2),
            borderStrokeWidth: 2.0,
            borderColor: Colors.black);
        polygonLayer.polygons.add(tempPoly);
        var points = value[i].getMaxDistance();
        this.calcMidPoint(points,value[i]);
        polygonLayer.polygons.add(new Polygon(
            points: points,
            borderStrokeWidth: 2.0,
            borderColor: Colors.redAccent));
      }
    });
  }

  void calcMidPoint(List<LatLng> twoPoints,CustomPoly poly) {
    var diameter=poly.calculateDistance(twoPoints[0], twoPoints[1]);
    double lat = (twoPoints[0].latitude + twoPoints[1].latitude) / 2;
    double long = (twoPoints[0].longitude + twoPoints[1].longitude) / 2;
    LatLng result = LatLng(lat, long);
    markerLayer.markers.add(new Marker(
      point: result,
      builder: (ctx) => new Container(
        child: new Icon(
          Icons.pin_drop,
          color: Colors.red,
          size: 25.0,
        ),
      ),
    ));
    circuleLayer.circles.add(new CircleMarker(
      point: result,
      radius: (diameter/2)*1000,
      color: Colors.white.withOpacity(0.5),useRadiusInMeter: true,
      borderColor: Colors.red,borderStrokeWidth: 2.0
    ));
  }

  void _fetchAPI() {
    // (flutterMap as FlutterMap).layers.removeAt(1);
    // getPoints();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAPI,
        child: Icon(Icons.refresh),
      ),
      body: flutterMap,
    );
  }

  @override
  void initState() {
    super.initState();
    flutterMap = FlutterMap(
      options: new MapOptions(
        center: new LatLng(25.19430, 55.272646),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        markerLayer,
        polygonLayer,
        circuleLayer
      ],
    );
    getPoints();
    getPolygones();
  }
}
