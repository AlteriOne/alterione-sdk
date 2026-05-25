class SkillCall {
  final String skillId;
  final String callId; // ID из LLM tool call
  final Map<String, dynamic> arguments;
  final String personaId;
  final DateTime createdAt;

  SkillCall({
    required this.skillId,
    required this.callId,
    required this.arguments,
    required this.personaId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  T arg<T>(String key) {
    final value = arguments[key];
    if (value == null) throw ArgumentError('Missing argument: $key');
    return value as T;
  }

  T? argOptional<T>(String key) => arguments[key] as T?;
}
