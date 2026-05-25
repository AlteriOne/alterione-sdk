class PersonaRules {
  final List<String> rules;
  final List<String> constraints;
  final List<String> behaviors;

  const PersonaRules({
    this.rules = const [],
    this.constraints = const [],
    this.behaviors = const [],
  });

  factory PersonaRules.fromMarkdown(String markdown) =>
      _PersonaRulesParser().parse(markdown);

  bool get isEmpty => rules.isEmpty && constraints.isEmpty && behaviors.isEmpty;

  /// Форматированная строка для системного промпта
  String toPromptString() {
    final buf = StringBuffer();

    if (rules.isNotEmpty) {
      buf.writeln('## Rules');
      for (final r in rules) buf.writeln('- $r');
    }

    if (constraints.isNotEmpty) {
      buf.writeln('\n## Constraints');
      for (final c in constraints) buf.writeln('- $c');
    }

    if (behaviors.isNotEmpty) {
      buf.writeln('\n## Behaviors');
      for (final b in behaviors) buf.writeln('- $b');
    }

    return buf.toString().trim();
  }
}

class _PersonaRulesParser {
  PersonaRules parse(String markdown) {
    final rules = <String>[];
    final constraints = <String>[];
    final behaviors = <String>[];

    var currentSection = rules; // default секция

    for (final line in markdown.split('\n')) {
      final trimmed = line.trim();

      if (trimmed.startsWith('## Rules')) {
        currentSection = rules;
        continue;
      }
      if (trimmed.startsWith('## Constraints')) {
        currentSection = constraints;
        continue;
      }
      if (trimmed.startsWith('## Behaviors')) {
        currentSection = behaviors;
        continue;
      }

      // Элемент списка (- или *)
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        currentSection.add(trimmed.substring(2).trim());
      }
    }

    return PersonaRules(
      rules: rules,
      constraints: constraints,
      behaviors: behaviors,
    );
  }
}
