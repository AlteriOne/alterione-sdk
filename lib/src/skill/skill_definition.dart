import 'skill_param.dart';

class SkillDefinition {
  final String id;
  final String name;
  final String description;
  final Map<String, SkillParam> parameters;
  final bool requiresConfirmation;
  final List<String> tags;

  const SkillDefinition({
    required this.id,
    required this.name,
    required this.description,
    this.parameters = const {},
    this.requiresConfirmation = false,
    this.tags = const [],
  });

  /// Конвертировать в MCP / OpenAI tool definition
  Map<String, dynamic> toToolDefinition() => {
    'name': id,
    'description': description,
    'inputSchema': {
      'type': 'object',
      'properties': {
        for (final e in parameters.entries) e.key: e.value.toSchema(),
      },
      'required': parameters.entries
          .where((e) => e.value.required)
          .map((e) => e.key)
          .toList(),
    },
  };
}
