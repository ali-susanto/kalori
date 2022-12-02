import 'dart:convert';

List<OutputDetectionModel> ouputModelDetectionFromJson(String str) =>
    List<OutputDetectionModel>.from(
        json.decode(str).map((x) => OutputDetectionModel.fromJson(x)));

String ouputModelDetectionToJson(List<OutputDetectionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OutputDetectionModel {
  OutputDetectionModel({
    required this.rect,
    required this.confidenceInClass,
    required this.detectedClass,
  });

  Rect rect;
  String confidenceInClass;
  String detectedClass;

  factory OutputDetectionModel.fromJson(Map<String, dynamic> json) =>
      OutputDetectionModel(
        rect: Rect.fromJson(json["rect"]),
        confidenceInClass: json["confidenceInClass"],
        detectedClass: json["detectedClass"],
      );

  Map<String, dynamic> toJson() => {
        "rect": rect.toJson(),
        "confidenceInClass": confidenceInClass,
        "detectedClass": detectedClass,
      };
}

class Rect {
  Rect({
    required this.w,
    required this.x,
    required this.h,
    required this.y,
  });

  String w;
  String x;
  String h;
  String y;

  factory Rect.fromJson(Map<String, dynamic> json) => Rect(
        w: json["w"],
        x: json["x"],
        h: json["h"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "w": w,
        "x": x,
        "h": h,
        "y": y,
      };
}
