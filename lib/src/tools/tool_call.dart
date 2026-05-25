import 'dart:convert';

class ToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  const ToolCall({
    required this.id,
    required this.name,
    required this.arguments,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': 'function',
    'function': {'name': name, 'arguments': jsonEncode(arguments)},
  };

  factory ToolCall.fromJson(Map<String, dynamic> json) {
    final fn = json['function'] as Map<String, dynamic>;
    final argsRaw = fn['arguments'];
    final args = argsRaw is String
        ? jsonDecode(argsRaw) as Map<String, dynamic>
        : argsRaw as Map<String, dynamic>;

    return ToolCall(
      id: json['id'] as String,
      name: fn['name'] as String,
      arguments: args,
    );
  }
}
