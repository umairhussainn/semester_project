import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/concept.dart';
import '../providers/topic_provider.dart';

class AddEditConceptScreen extends StatefulWidget {
  final String topicId;
  final Concept? concept;

  const AddEditConceptScreen({
    super.key,  // Fixed super parameter
    required this.topicId,
    this.concept,
  });

  @override
  State<AddEditConceptScreen> createState() => _AddEditConceptScreenState();
}

class _AddEditConceptScreenState extends State<AddEditConceptScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late ConceptStatus _status;
  final List<TextEditingController> _resourceControllers = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.concept?.title ?? '');
    _descriptionController = TextEditingController(text: widget.concept?.description ?? '');
    _status = widget.concept?.status ?? ConceptStatus.toReview;

    if (widget.concept?.resources.isNotEmpty ?? false) {
      for (final resource in widget.concept!.resources) {
        _resourceControllers.add(TextEditingController(text: resource));
      }
    } else {
      _resourceControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final controller in _resourceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addResourceField() {
    setState(() {
      _resourceControllers.add(TextEditingController());
    });
  }

  void _removeResourceField(int index) {
    setState(() {
      _resourceControllers[index].dispose();
      _resourceControllers.removeAt(index);
    });
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final resources = _resourceControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final concept = Concept(
        id: widget.concept?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),  // Fixed null safety
        title: _titleController.text,
        description: _descriptionController.text,
        status: _status,
        resources: resources,
      );

      final topicProvider = context.read<TopicProvider>();

      if (widget.concept != null) {
        topicProvider.updateConcept(widget.topicId, concept);
      } else {
        topicProvider.addConcept(widget.topicId, concept);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.concept == null ? 'Add Concept' : 'Edit Concept'),
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
                  hintText: 'Enter concept title',
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
                  hintText: 'Enter concept description',
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
              const SizedBox(height: 16),
              DropdownButtonFormField<ConceptStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                items: ConceptStatus.values.map((status) {
                  String label;
                  Color color;

                  switch (status) {
                    case ConceptStatus.mastered:
                      label = 'Mastered';
                      color = Colors.green;
                      break;
                    case ConceptStatus.inProgress:
                      label = 'In Progress';
                      color = Colors.orange;
                      break;
                    case ConceptStatus.toReview:
                      label = 'To Review';
                      color = Colors.red;
                      break;
                  }

                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: color, size: 16),
                        const SizedBox(width: 8),
                        Text(label),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Resources',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addResourceField,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Resource'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._resourceControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Enter resource URL',
                            prefixIcon: const Icon(Icons.link),
                            suffixIcon: index > 0
                                ? IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _removeResourceField(index),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSave,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    widget.concept == null ? 'Create Concept' : 'Save Changes',
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