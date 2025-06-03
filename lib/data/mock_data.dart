import '../models/topic.dart';
import '../models/concept.dart';

class MockData {
  static final List<Topic> topics = [
    Topic(
      id: "1",  // Added ID
      title: 'Flutter Development',
      description: 'Learning Flutter framework and Dart programming',
      concepts: [
        Concept(
          id: "1-1",  // Added ID
          title: 'Widgets',
          description: 'Understanding basic and advanced widgets in Flutter',
          status: ConceptStatus.mastered,
          resources: [
            'https://docs.flutter.dev/ui/widgets',
            'https://flutter.dev/docs/development/ui/widgets-intro',
          ],
        ),
        Concept(
          id: "1-2",  // Added ID
          title: 'State Management',
          description: 'Different state management approaches in Flutter',
          status: ConceptStatus.inProgress,
          resources: [
            'https://docs.flutter.dev/data-and-backend/state-mgmt/intro',
            'https://pub.dev/packages/provider',
          ],
        ),
      ],
    ),
    Topic(
      id: "2",  // Added ID
      title: 'Data Structures',
      description: 'Fundamental data structures and algorithms',
      concepts: [
        Concept(
          id: "2-1",  // Added ID
          title: 'Arrays and Lists',
          description: 'Understanding array operations and list implementations',
          status: ConceptStatus.mastered,
          resources: [
            'https://www.geeksforgeeks.org/array-data-structure/',
            'https://www.programiz.com/dsa/array',
          ],
        ),
        Concept(
          id: "2-2",  // Added ID
          title: 'Binary Trees',
          description: 'Tree data structure and its operations',
          status: ConceptStatus.toReview,
          resources: [
            'https://www.geeksforgeeks.org/binary-tree-data-structure/',
          ],
        ),
      ],
    ),
    Topic(
      id: "3",  // Added ID
      title: 'Machine Learning',
      description: 'Introduction to ML concepts and algorithms',
      concepts: [
        Concept(
          id: "3-1",  // Added ID
          title: 'Linear Regression',
          description: 'Understanding linear regression and its applications',
          status: ConceptStatus.inProgress,
          resources: [
            'https://www.coursera.org/learn/machine-learning',
            'https://scikit-learn.org/stable/modules/linear_model.html',
          ],
        ),
      ],
    ),
  ];
}