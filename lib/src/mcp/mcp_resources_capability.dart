class McpResourcesCapability {
  final bool subscribe;
  final bool listChanged;

  const McpResourcesCapability({
    this.subscribe = false,
    this.listChanged = false,
  });

  Map<String, dynamic> toJson() => {
    if (subscribe) 'subscribe': true,
    if (listChanged) 'listChanged': true,
  };

  factory McpResourcesCapability.fromJson(Map<String, dynamic> json) =>
      McpResourcesCapability(
        subscribe: json['subscribe'] == true,
        listChanged: json['listChanged'] == true,
      );
}
