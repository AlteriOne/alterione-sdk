// Наследуют все модули — memory, llm, skill
import '../plugin/alterione_plugin.dart';
import '../plugin/plugin_context.dart';
import 'mcp_error.dart';
import 'mcp_message.dart';
import 'mcp_transport.dart';

abstract class AlteriOneMcpServer implements AlteriOnePlugin {
  final AlteriOneMcpTransport transport;
  late final PluginContext _ctx;

  AlteriOneMcpServer({required this.transport});

  @override
  Future<void> onInitialize(PluginContext ctx) async {
    _ctx = ctx;
  }

  // Точка входа — запускает loop
  Future<void> serve() async {
    await for (final message in transport.incoming) {
      try {
        final response = await _dispatch(message);
        if (response != null) await transport.send(response);
      } catch (e, st) {
        await transport.send(_errorResponse(message.id, e));
      }
    }
  }

  Future<McpMessage?> _dispatch(McpMessage msg) async {
    return switch (msg.method) {
      'initialize' => _handleInitialize(msg),
      'ping' => _handlePing(msg),
      'tools/list' => _handleToolsList(msg),
      'tools/call' => _handleToolCall(msg),
      'notifications/cancelled' => null,
      _ => _handleUnknown(msg),
    };
  }

  // Инициализация — отдаём манифест
  Future<McpMessage> _handleInitialize(McpMessage msg) async {
    return McpMessage.result(msg.id, {
      'protocolVersion': '2024-11-05',
      'serverInfo': {'name': manifest.id, 'version': manifest.version},
      'capabilities': {'tools': {}},
      'meta': {
        'alterione': {
          'pluginType': manifest.type.name,
          'capabilities': manifest.capabilities,
          'permissions': manifest.permissions.map((p) => p.name).toList(),
        },
      },
    });
  }

  // Список инструментов — реализует модуль
  Future<McpMessage> _handleToolsList(McpMessage msg);

  // Вызов инструмента — реализует модуль
  Future<McpMessage> _handleToolCall(McpMessage msg);

  McpMessage _handlePing(McpMessage msg) =>
      McpMessage.result(msg.id, {'pong': true});

  McpMessage _errorResponse(dynamic id, Object error) =>
      McpMessage.error(id, McpError.internalError, error.toString());

  Future<McpMessage?> _handleUnknown(McpMessage msg);
}
