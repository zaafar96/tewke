// To parse this JSON data, do
//
//     final carbonIntensity = carbonIntensityFromJson(jsonString);

import 'dart:convert';

CarbonIntensity carbonIntensityFromJson(String str) =>
    CarbonIntensity.fromJson(json.decode(str));

String carbonIntensityToJson(CarbonIntensity data) =>
    json.encode(data.toJson());

class CarbonIntensity {
  String from;
  String to;
  Intensity intensity;

  CarbonIntensity({
    required this.from,
    required this.to,
    required this.intensity,
  });

  factory CarbonIntensity.fromJson(Map<String, dynamic> json) =>
      CarbonIntensity(
        from: json["from"],
        to: json["to"],
        intensity: Intensity.fromJson(json["intensity"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "intensity": intensity.toJson(),
      };
}

class Intensity {
  int forecast;
  int? actual;
  String index;

  Intensity({
    required this.forecast,
    required this.actual,
    required this.index,
  });

  factory Intensity.fromJson(Map<String, dynamic> json) => Intensity(
        forecast: json["forecast"],
        actual: json["actual"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "forecast": forecast,
        "actual": actual,
        "index": index,
      };
}
