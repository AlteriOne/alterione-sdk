class ToolDefinition {
  final String name;
  final String description;
  final Map<String, dynamic> inputSchema;

  ToolDefinition({required this.name, required this.description, required this.inputSchema}); // JSON Schema
}
