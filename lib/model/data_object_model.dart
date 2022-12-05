import 'dart:convert';

List<DataObjectModel> valueObjectFromJson(String str) =>
    List<DataObjectModel>.from(
        json.decode(str).map((x) => DataObjectModel.fromJson(x)));

String valueObjectToJson(List<DataObjectModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataObjectModel {
  DataObjectModel({
    required this.nama,
    required this.kandungan,
  });

  String nama;
  Kandungan kandungan;

  factory DataObjectModel.fromJson(Map<String, dynamic> json) =>
      DataObjectModel(
        nama: json["nama"],
        kandungan: Kandungan.fromJson(json["kandungan"]),
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "kandungan": kandungan.toJson(),
      };
}

class Kandungan {
  Kandungan({
    required this.karbohidrat,
    required this.protein,
    required this.kalori,
  });

  String karbohidrat;
  String protein;
  String kalori;

  factory Kandungan.fromJson(Map<String, dynamic> json) => Kandungan(
      karbohidrat: json["karbohidrat"],
      protein: json["protein"],
      kalori: json["kalori"]);

  Map<String, dynamic> toJson() =>
      {"karbohidrat": karbohidrat, "protein": protein, "kalori": kalori};
}

class DataObjectDetection {
  String? nama;
  String? karbohidrat;
  String? protein;
  String? kalori;

  DataObjectDetection(
      {required this.nama,
      required this.karbohidrat,
      required this.protein,
      required this.kalori});
}
