/// stdio транспорт — основной для скомпилированных модулей.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'mcp_message.dart';
import 'mcp_transport.dart';

class StdioMcpTransport implements AlteriOneMcpTransport {
  final _controller = StreamController<McpMessage>.broadcast();
  StreamSubscription<String>? _sub;
  bool _open = true;

  StdioMcpTransport() {
    _sub = stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          _onLine,
          onDone: () {
            _open = false;
            _controller.close();
          },
          onError: _controller.addError,
        );
  }

  void _onLine(String line) {
    final t = line.trim();
    if (t.isEmpty) return;
    try {
      _controller.add(
        McpMessage.fromJson(jsonDecode(t) as Map<String, dynamic>),
      );
    } catch (_) {
      // Невалидный JSON — игнорируем
    }
  }

  @override
  Stream<McpMessage> get incoming => _controller.stream;
  @override
  bool get isOpen => _open;

  @override
  Future<void> send(McpMessage message) async {
    if (!_open) throw StateError('Transport is closed');
    stdout.writeln(jsonEncode(message.toJson()));
  }

  @override
  Future<void> close() async {
    _open = false;
    await _sub?.cancel();
    await _controller.close();
  }
}
