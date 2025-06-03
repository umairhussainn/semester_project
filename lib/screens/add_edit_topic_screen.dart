import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../providers/topic_provider.dart';

class AddEditTopicScreen extends StatefulWidget {
  final Topic? topic;

  const AddEditTopicScreen({
    super.key,  // Fixed super parameter
    this.topic,
  });

  @override
  State<AddEditTopicScreen> createState() => _AddEditTopicScreenState();
}

class _AddEditTopicScreenState extends State<AddEditTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.topic?.title ?? '');
    _descriptionController = TextEditingController(text: widget.topic?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final topicProvider = context.read<TopicProvider>();

      if (widget.topic != null) {
        final updatedTopic = Topic(
          id: widget.topic!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          concepts: widget.topic!.concepts,
        );
        topicProvider.updateTopic(updatedTopic);
      } else {
        final newTopic = Topic(
          id: DateTime.now().millisecondsSinceEpoch.toString(),  // Added ID
          title: _titleController.text,
          description: _descriptionController.text,
          concepts: [],  // Added concepts
        );
        topicProvider.addTopic(newTopic);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic == null ? 'Add Topic' : 'Edit Topic'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter topic title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter topic description',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSave,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    widget.topic == null ? 'Create Topic' : 'Save Changes',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}