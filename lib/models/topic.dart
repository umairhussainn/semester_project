// lib/models/topic.dart

import 'concept.dart';

class Topic {
  final String id;
  final String title;
  final String description;
  final double progress;
  final List<Concept> concepts;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    this.progress = 0.0,
    required this.concepts,
  });

  Topic copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    List<Concept>? concepts,
  }) {
    return Topic(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      concepts: concepts ?? this.concepts,
    );
  }

  double get progressPercentage {
    if (concepts.isEmpty) return 0.0;
    final masteredCount = concepts.where((c) => c.status == ConceptStatus.mastered).length;
    return (masteredCount / concepts.length) * 100;
  }
}
