abstract interface class PluginLogger {
  void trace(String message);
  void debug(String message);
  void info(String message);
  void warn(String message);
  void error(String message, [Object? error, StackTrace? stack]);
}
