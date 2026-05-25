class PluginConfigException implements Exception {
  final String pluginId;
  final String key;
  final String reason;

  const PluginConfigException(this.pluginId, this.key, this.reason);

  @override
  String toString() => 'PluginConfigException[$pluginId]: key "$key" — $reason';
}
