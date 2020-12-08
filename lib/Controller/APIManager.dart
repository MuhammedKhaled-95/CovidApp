import 'package:covidapp/Model/Polygon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:covidapp/Model/Point.dart';

class FetchManger {
  static const pointsURL = "http://84.205.104.9:8001/world/Acc_point_v/";
  static const polyURL = "http://84.205.104.9:8001/world/Acc_poly_v/";

  Future<List<Point>> getPoints() async {
    List<Point> result = [];
    var response = await http.get(pointsURL);
    if (response.statusCode == 200) {
      List<dynamic> returnedPoints =
          convert.jsonDecode(response.body)["features"];
      for (int i = 0; i < returnedPoints.length; i++) {
        Point singleEntry = Point.fromJson(returnedPoints[i]);
        result.add(singleEntry);
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return result;
  }

  Future<List<CustomPoly>> getPolygons() async {
    List<CustomPoly> result = [];
    var response = await http.get(polyURL);
    if (response.statusCode == 200) {
      List<dynamic> returnedPoints =
          convert.jsonDecode(response.body)["features"];
      for (int i = 0; i < returnedPoints.length; i++) {
        CustomPoly singleEntry = CustomPoly.fromJson(returnedPoints[i]);
        result.add(singleEntry);
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return result;
  }
}
