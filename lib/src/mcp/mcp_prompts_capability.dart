class McpPromptsCapability {
  final bool listChanged;
  const McpPromptsCapability({this.listChanged = false});
  Map<String, dynamic> toJson() => {if (listChanged) 'listChanged': true};
  factory McpPromptsCapability.fromJson(Map<String, dynamic> json) =>
      McpPromptsCapability(listChanged: json['listChanged'] == true);
}

class McpLoggingCapability {
  const McpLoggingCapability();
  Map<String, dynamic> toJson() => {};
}
