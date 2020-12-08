import 'package:latlong/latlong.dart';

class Point {
   int id;
   String type;
   Geometry geometry;
   Properties properties;

  Point({this.id, this.type,this.geometry,this.properties});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'] as int,
      type: json['type'] as String,
      geometry: Geometry.fromJson(json['geometry']),
      properties: Properties.fromJson(json['properties']),
    );
  }

   @override
  String toString() {
    return '${this.id},${this.type},${this.properties.categories},${this.properties.text}'
        ',${this.properties.name},${this.geometry.type},${this.geometry.coordinates.toString()}';
  }
}

class Properties{
  String categories;
  String text;
  String name;

  Properties({this.categories, this.text,this.name});

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      categories: json['categories'] as String,
      text: json['text'] as String,
      name: json['name'] as String,
    );
  }
}

class Geometry{
  String type;
  LatLng coordinates;

  Geometry({this.type, this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    var coordinatesList=json['coordinates'];
    List<double> coord= coordinatesList !=null ? List.from(coordinatesList) : null;
    return Geometry(
      type: json['type'] as String,
      coordinates: new LatLng(coord[1],coord[0]),
    );
  }
}