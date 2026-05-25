enum LlmRole {
  system,
  user,
  assistant,
  tool;

  String get value => name; // 'system' | 'user' | 'assistant' | 'tool'

  static LlmRole fromValue(String value) => LlmRole.values.firstWhere(
    (r) => r.value == value,
    orElse: () => throw ArgumentError('Unknown LLM role: $value'),
  );
}
