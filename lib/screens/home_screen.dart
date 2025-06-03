import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/theme_provider.dart';
import '../providers/topic_provider.dart';
import '../models/topic.dart';
import 'add_edit_topic_screen.dart';
import 'topic_detail_screen.dart';
import '../widgets/profile_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyPilot'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              final themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          const ProfileIconButton(),
        ],
      ),
      body: Consumer<TopicProvider>(
        builder: (context, topicProvider, child) {
          final topics = topicProvider.topics;

          if (topics.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      size: 80,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No topics yet',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.outline,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start adding your study topics and track your progress!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Your First Topic'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEditTopicScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return TopicCard(topic: topic);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTopicScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final Topic topic;

  const TopicCard({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailScreen(topic: topic),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withAlpha(25),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      topic.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${topic.progressPercentage.toStringAsFixed(0)}%',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                topic.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 18),
              LinearPercentIndicator(
                percent: (topic.progressPercentage / 100).clamp(0.0, 1.0),
                lineHeight: 10,
                animation: true,
                animationDuration: 1200,
                backgroundColor: theme.colorScheme.surfaceVariant,
                progressColor: theme.colorScheme.primary,
                barRadius: const Radius.circular(6),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${topic.concepts.length} concept${topic.concepts.length == 1 ? '' : 's'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  Text(
                    'Tap to view details',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
