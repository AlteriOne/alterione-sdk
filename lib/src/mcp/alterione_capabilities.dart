import '../plugin/plugin_permission.dart';
import '../plugin/plugin_type.dart';

class AlteriOneCapabilities {
  final PluginType pluginType;
  final List<String> capabilities;
  final List<PluginPermission> permissions;
  final List<String> memoryTypes; // только для memory плагинов

  const AlteriOneCapabilities({
    required this.pluginType,
    this.capabilities = const [],
    this.permissions = const [],
    this.memoryTypes = const [],
  });

  Map<String, dynamic> toJson() => {
    'pluginType': pluginType.name,
    'capabilities': capabilities,
    'permissions': permissions.map((p) => p.name).toList(),
    if (memoryTypes.isNotEmpty) 'memoryTypes': memoryTypes,
  };

  factory AlteriOneCapabilities.fromJson(Map<String, dynamic> json) =>
      AlteriOneCapabilities(
        pluginType: PluginType.values.byName(json['pluginType'] as String),
        capabilities: List<String>.from(json['capabilities'] ?? []),
        permissions: (json['permissions'] as List? ?? [])
            .map((p) => PluginPermission.values.byName(p as String))
            .toList(),
        memoryTypes: List<String>.from(json['memoryTypes'] ?? []),
      );
}
