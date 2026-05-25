import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'mcp_message.dart';
import 'mcp_transport.dart';

/// Socket транспорт — для отладки или распределённых деплоев.
class SocketMcpTransport implements AlteriOneMcpTransport {
  final Socket _socket;
  final _controller = StreamController<McpMessage>.broadcast();
  bool _open = true;

  SocketMcpTransport(this._socket) {
    _socket
        .transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>)
        .transform(const LineSplitter())
        .listen(
          (line) {
            final t = line.trim();
            if (t.isEmpty) return;
            try {
              _controller.add(
                McpMessage.fromJson(jsonDecode(t) as Map<String, dynamic>),
              );
            } catch (_) {}
          },
          onDone: () {
            _open = false;
            _controller.close();
          },
        );
  }

  @override
  Stream<McpMessage> get incoming => _controller.stream;
  @override
  bool get isOpen => _open;

  @override
  Future<void> send(McpMessage message) async {
    if (!_open) throw StateError('Transport is closed');
    _socket.writeln(jsonEncode(message.toJson()));
  }

  @override
  Future<void> close() async {
    _open = false;
    await _socket.close();
    await _controller.close();
  }
}
