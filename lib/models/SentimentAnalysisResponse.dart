class Prediction {
  List<String> content;
  CitationMetadata citationMetadata;
  SafetyAttributes safetyAttributes;

  Prediction({required this.content, required this.citationMetadata, required this.safetyAttributes});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      content: List<String>.from(json['content']),
      citationMetadata: CitationMetadata.fromJson(json['citationMetadata']),
      safetyAttributes: SafetyAttributes.fromJson(json['safetyAttributes']),
    );
  }
}

class CitationMetadata {
  List<dynamic> citations;

  CitationMetadata({required this.citations});

  factory CitationMetadata.fromJson(Map<String, dynamic> json) {
    return CitationMetadata(
      citations: List<dynamic>.from(json['citations']),
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
