import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/topic.dart';
import '../models/concept.dart';
import '../providers/topic_provider.dart';
import 'add_edit_topic_screen.dart';
import 'add_edit_concept_screen.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailScreen({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTopicScreen(topic: topic),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Topic'),
                  content: const Text('Are you sure you want to delete this topic?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<TopicProvider>().deleteTopic(topic.id);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to home
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(76),
            child: Column(
              children: [
                Text(
                  '${topic.progressPercentage.toStringAsFixed(0)}% Mastered',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ProgressChart(topic: topic),
                ),
              ],
            ),
          ),
          Expanded(
            child: ConceptsList(topic: topic),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditConceptScreen(topicId: topic.id),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProgressChart extends StatelessWidget {
  final Topic topic;

  const ProgressChart({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    if (topic.concepts.isEmpty) {
      return const Center(
        child: Text('No concepts added yet'),
      );
    }

    final mastered = topic.concepts.where((c) => c.status == ConceptStatus.mastered).length;
    final inProgress = topic.concepts.where((c) => c.status == ConceptStatus.inProgress).length;
    final toReview = topic.concepts.where((c) => c.status == ConceptStatus.toReview).length;

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          if (mastered > 0)
            PieChartSectionData(
              value: mastered.toDouble(),
              title: 'Mastered\n$mastered',
              color: Colors.green,
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (inProgress > 0)
            PieChartSectionData(
              value: inProgress.toDouble(),
              title: 'In Progress\n$inProgress',
              color: Colors.orange,
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (toReview > 0)
            PieChartSectionData(
              value: toReview.toDouble(),
              title: 'To Review\n$toReview',
              color: Colors.red,
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class ConceptsList extends StatelessWidget {
  final Topic topic;

  const ConceptsList({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    if (topic.concepts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No concepts yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditConceptScreen(topicId: topic.id),
                  ),
                );
              },
              child: const Text('Add Your First Concept'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topic.concepts.length,
      itemBuilder: (context, index) {
        final concept = topic.concepts[index];
        return ConceptCard(
          concept: concept,
          topicId: topic.id,
        );
      },
    );
  }
}

class ConceptCard extends StatelessWidget {
  final Concept concept;
  final String topicId;

  const ConceptCard({
    super.key,
    required this.concept,
    required this.topicId,
  });

  Color _getStatusColor(ConceptStatus status) {
    switch (status) {
      case ConceptStatus.mastered:
        return Colors.green;
      case ConceptStatus.inProgress:
        return Colors.orange;
      case ConceptStatus.toReview:
        return Colors.red;
    }
  }

  String _getStatusText(ConceptStatus status) {
    switch (status) {
      case ConceptStatus.mastered:
        return 'Mastered';
      case ConceptStatus.inProgress:
        return 'In Progress';
      case ConceptStatus.toReview:
        return 'To Review';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    concept.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditConceptScreen(
                            topicId: topicId,
                            concept: concept,
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Concept'),
                          content: const Text('Are you sure you want to delete this concept?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<TopicProvider>().deleteConcept(topicId, concept.id);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              concept.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(concept.status).withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(concept.status),
                    ),
                  ),
                  child: Text(
                    _getStatusText(concept.status),
                    style: TextStyle(
                      color: _getStatusColor(concept.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => StatusSelectionDialog(
                        concept: concept,
                        topicId: topicId,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Change Status'),
                ),
              ],
            ),
            if (concept.resources.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Resources:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...concept.resources.map((resource) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        resource,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class StatusSelectionDialog extends StatelessWidget {
  final Concept concept;
  final String topicId;

  const StatusSelectionDialog({
    super.key,
    required this.concept,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ConceptStatus.values.map((status) => ListTile(
          title: Text(_getStatusText(status)),
          leading: Icon(
            Icons.circle,
            color: _getStatusColor(status),
          ),
          onTap: () {
            final updatedConcept = Concept(
              id: concept.id,
              title: concept.title,
              description: concept.description,
              status: status,
              resources: concept.resources,
            );
            context.read<TopicProvider>().updateConcept(topicId, updatedConcept);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  String _getStatusText(ConceptStatus status) {
    switch (status) {
      case ConceptStatus.mastered:
        return 'Mastered';
      case ConceptStatus.inProgress:
        return 'In Progress';
      case ConceptStatus.toReview:
        return 'To Review';
    }
  }

  Color _getStatusColor(ConceptStatus status) {
    switch (status) {
      case ConceptStatus.mastered:
        return Colors.green;
      case ConceptStatus.inProgress:
        return Colors.orange;
      case ConceptStatus.toReview:
        return Colors.red;
    }
  }
}
