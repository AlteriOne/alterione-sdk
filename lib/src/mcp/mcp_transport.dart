import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'mcp_message.dart';

/// Абстракция транспорта MCP.
abstract interface class AlteriOneMcpTransport {
  Stream<McpMessage> get incoming;
  Future<void> send(McpMessage message);
  bool get isOpen;
  Future<void> close();
}
