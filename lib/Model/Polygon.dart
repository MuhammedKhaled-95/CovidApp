import 'package:covidapp/Model/Point.dart';
import 'package:latlong/latlong.dart';
import 'dart:math' show cos, sqrt, asin;

class CustomPoly{
  int id;
  String type;
  PolyGeometry geometry;
  Properties properties;

  CustomPoly({this.id, this.type,this.geometry,this.properties});

  factory CustomPoly.fromJson(Map<String, dynamic> json) {
    return CustomPoly(
      id: json['id'] as int,
      type: json['type'] as String,
      geometry: PolyGeometry.fromJson(json['geometry']),
      properties: Properties.fromJson(json['properties']),
    );
  }

  @override
  String toString() {
    return '${this.id},${this.type},${this.properties.categories},${this.properties.text}'
        ',${this.properties.name},${this.geometry.type},${this.geometry.coordinates.toString()}';
  }

  List<LatLng> getMaxDistance(){
    double maxDistance=0.0;
    List<LatLng> resultOfPoints=[];
      for(int i=0;i<this.geometry.coordinates.length-1;i++){
        for(int j=i+1;j<this.geometry.coordinates.length;j++){
            double result=calculateDistance(this.geometry.coordinates[i],this.geometry.coordinates[j]);
            if(maxDistance<result){
              maxDistance=result;
              resultOfPoints=[this.geometry.coordinates[i],this.geometry.coordinates[j]];
            }
        }
      }
      return resultOfPoints;
  }

  static double calculateDistance(LatLng p1,LatLng p2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((p2.latitude - p1.latitude) * p)/2 +
        c(p1.latitude * p) * c(p2.latitude * p) *
            (1 - c((p2.longitude - p1.longitude) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}

class PolyGeometry{
  String type;
  List<LatLng> coordinates;
  List<LatLng> maxMin;

  PolyGeometry({this.type, this.coordinates});

  factory PolyGeometry.fromJson(Map<String, dynamic> json) {
    PolyGeometry result=PolyGeometry(
        type: json['type'] as String,
      coordinates: [],
    );
    var coordinatesList=json['coordinates'][0];
    List<dynamic> coord= coordinatesList !=null ? List.from(coordinatesList) : null;
    List<double> latitude=[];
    List<double> longitude=[];
    for(int i=0;i<coord.length;i++){
      var point=new LatLng(coord[i][1],coord[i][0]);
      result.coordinates.add(point);
      latitude.add(point.latitude);
      longitude.add(point.longitude);
    }
    var minPoint=new LatLng(latitude.reduce((curr, next) => curr < next? curr: next),longitude.reduce((curr, next) => curr < next? curr: next));
    var maxPoint=new LatLng(latitude.reduce((curr, next) => curr > next? curr: next),longitude.reduce((curr, next) => curr > next? curr: next));
    result.maxMin=[minPoint,maxPoint];
    return result;
  }
}