class Prediction {
  List<String> content;
  SafetyAttributes safetyAttributes;

  Prediction({required this.content, required this.safetyAttributes});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      content: List<String>.from(json['content']),
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
