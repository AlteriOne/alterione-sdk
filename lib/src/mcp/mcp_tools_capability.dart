class McpToolsCapability {
  /// Сервер может уведомлять об изменении списка инструментов
  final bool listChanged;

  const McpToolsCapability({this.listChanged = false});

  Map<String, dynamic> toJson() => {if (listChanged) 'listChanged': true};

  factory McpToolsCapability.fromJson(Map<String, dynamic> json) =>
      McpToolsCapability(listChanged: json['listChanged'] == true);
}
