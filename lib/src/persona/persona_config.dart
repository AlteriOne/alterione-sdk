abstract interface class PersonaConfig {
  String get id;
  String get name;
  String get description;
  String get avatar;
  LlmPersonaConfig get llm;
  MemoryPersonaConfig get memory;
  List<String> get skillIds;
  PersonaStyle get style;

  // Содержимое текстовых файлов
  String get systemPrompt;
  String get rules;
  String get styleGuide;
  List<KnowledgeEntry> get knowledge;
  List<ExampleEntry> get examples;
}
