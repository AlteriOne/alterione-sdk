import 'mcp_prompts_capability.dart';
import 'mcp_resources_capability.dart';
import 'mcp_tools_capability.dart';

class McpCapabilities {
  final McpToolsCapability?     tools;
  final McpResourcesCapability? resources;
  final McpPromptsCapability?   prompts;
  final McpLoggingCapability?   logging;

  const McpCapabilities({
    this.tools,
    this.resources,
    this.prompts,
    this.logging,
  });

  /// Только tools — стандарт для большинства AlteriOne модулей
  factory McpCapabilities.toolsOnly() =>
      const McpCapabilities(tools: McpToolsCapability());

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (tools     != null) json['tools']     = tools!.toJson();
    if (resources != null) json['resources'] = resources!.toJson();
    if (prompts   != null) json['prompts']   = prompts!.toJson();
    if (logging   != null) json['logging']   = logging!.toJson();
    return json;
  }

  factory McpCapabilities.fromJson(Map<String, dynamic> json) =>
      McpCapabilities(
        tools:     json['tools']     != null
                   ? McpToolsCapability.fromJson(json['tools'])     : null,
        resources: json['resources'] != null
                   ? McpResourcesCapability.fromJson(json['resources']) : null,
      );
}