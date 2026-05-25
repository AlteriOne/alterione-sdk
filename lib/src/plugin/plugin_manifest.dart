import 'plugin_permission.dart';
import 'plugin_type.dart';

class PluginManifest {
  final String id; // 'alterione-memory-sqlite'
  final String version; // '1.0.0'
  final PluginType type; // memory / llm / skill / generic
  final List<String> capabilities;
  final List<PluginPermission> permissions;
  final Map<String, dynamic> configSchema;

  PluginManifest({
    required this.id,
    required this.version,
    required this.type,
    required this.capabilities,
    required this.permissions,
    required this.configSchema,
  });
}
