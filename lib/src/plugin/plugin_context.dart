import 'plugin_config_exception.dart';
import 'plugin_logger.dart';

class PluginContext {
  final String agentVersion;
  final String pluginId;
  final Map<String, dynamic> config;
  final PluginLogger logger;
  final String dataDir; // директория для данных плагина

  const PluginContext({
    required this.agentVersion,
    required this.pluginId,
    required this.config,
    required this.logger,
    required this.dataDir,
  });

  /// Получить типизированное значение конфига
  T get<T>(String key, {T? defaultValue}) {
    final value = config[key];
    if (value == null) {
      if (defaultValue != null) return defaultValue;
      throw PluginConfigException(pluginId, key, 'required but not provided');
    }
    if (value is! T) {
      throw PluginConfigException(
        pluginId,
        key,
        'expected $T, got ${value.runtimeType}',
      );
    }
    return value;
  }

  T? getOptional<T>(String key) => config[key] as T?;
}
