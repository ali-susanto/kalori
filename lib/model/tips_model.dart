class TipsModel {
  TipsModel({
    required this.image,
    required this.title,
    required this.headline,
    required this.content,
    required this.id,
  });

  String? image;
  String? title;
  String? headline;
  String? content;
  String? id;

  factory TipsModel.fromJson(Map<String, dynamic> json) => TipsModel(
        image: json["image"] as String,
        title: json["title"] as String,
        headline: json["headline"] as String,
        content: json["content"] as String,
        id: json["id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "headline": headline,
        "content": content,
        "id": id,
      };
}
