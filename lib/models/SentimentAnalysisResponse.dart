class Prediction {
  String content;
  String title;
  SafetyAttributes safetyAttributes;

  Prediction({required this.content, required this.title, required this.safetyAttributes});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      content: json['content'],
      title: json['title'],
      safetyAttributes: SafetyAttributes.fromJson(json['safetyAttributes']),
    );
  }
}

class SafetyAttributes {
  List<double> scores;
  bool blocked;
  List<String> categories;

  SafetyAttributes({required this.scores, required this.blocked, required this.categories});

  factory SafetyAttributes.fromJson(Map<String, dynamic> json) {
    return SafetyAttributes(
      scores: List<double>.from(json['scores']),
      blocked: json['blocked'],
      categories: List<String>.from(json['categories']),
    );
  }
}
