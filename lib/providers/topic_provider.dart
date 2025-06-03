import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/concept.dart';
import '../data/mock_data.dart';

class TopicProvider with ChangeNotifier {
  final List<Topic> _topics = MockData.topics;

  List<Topic> get topics => _topics;

  void addTopic(Topic topic) {
    _topics.add(topic);
    notifyListeners();
  }

  void updateTopic(Topic updatedTopic) {
    final index = _topics.indexWhere((topic) => topic.id == updatedTopic.id);
    if (index != -1) {
      _topics[index] = updatedTopic;
      notifyListeners();
    }
  }

  // Added deleteTopic method
  void deleteTopic(String id) {
    _topics.removeWhere((topic) => topic.id == id);
    notifyListeners();
  }

  void addConcept(String topicId, Concept concept) {
    final topicIndex = _topics.indexWhere((topic) => topic.id == topicId);
    if (topicIndex != -1) {
      final topic = _topics[topicIndex];
      final updatedConcepts = List<Concept>.from(topic.concepts)..add(concept);
      _topics[topicIndex] = topic.copyWith(concepts: updatedConcepts);
      notifyListeners();
    }
  }

  void updateConcept(String topicId, Concept updatedConcept) {
    final topicIndex = _topics.indexWhere((topic) => topic.id == topicId);
    if (topicIndex != -1) {
      final topic = _topics[topicIndex];
      final conceptIndex = topic.concepts.indexWhere((c) => c.id == updatedConcept.id);
      if (conceptIndex != -1) {
        final updatedConcepts = List<Concept>.from(topic.concepts);
        updatedConcepts[conceptIndex] = updatedConcept;
        _topics[topicIndex] = topic.copyWith(concepts: updatedConcepts);
        notifyListeners();
      }
    }
  }

  // Added deleteConcept method
  void deleteConcept(String topicId, String conceptId) {
    final topicIndex = _topics.indexWhere((topic) => topic.id == topicId);
    if (topicIndex != -1) {
      final topic = _topics[topicIndex];
      final updatedConcepts = List<Concept>.from(topic.concepts)..removeWhere((c) => c.id == conceptId);
      _topics[topicIndex] = topic.copyWith(concepts: updatedConcepts);
      notifyListeners();
    }
  }
}