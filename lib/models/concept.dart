// lib/models/concept.dart

enum ConceptStatus { mastered, inProgress, toReview }

class Concept {
  final String id;
  final String title;
  final String description;
  final ConceptStatus status;
  final List<String> resources;

  Concept({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.resources,
  });

  Concept copyWith({
    String? id,
    String? title,
    String? description,
    ConceptStatus? status,
    List<String>? resources,
  }) {
    return Concept(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      resources: resources ?? this.resources,
    );
  }
}
