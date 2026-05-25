import 'plugin_context.dart';
import 'plugin_manifest.dart';

abstract interface class AlteriOnePlugin {
  PluginManifest get manifest;
  Future<void> onInitialize(PluginContext ctx);
  Future<void> onDispose();
}
