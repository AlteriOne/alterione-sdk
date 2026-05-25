# alterione-sdk

> Official Dart SDK for building [AlteriOne](https://alteri.one)-compatible modules, plugins, and skills.

[![pub.dev](https://img.shields.io/pub/v/alterione_sdk.svg)](https://pub.dev/packages/alterione_sdk)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.3.0-blue)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**alterione-sdk** provides the interfaces, contracts, data models, and MCP base classes needed to extend AlteriOne with custom memory backends, LLM providers, skills, and pipeline processors.

> **This package contains no business logic** — only pure interfaces and models.  
> It is the only AlteriOne package published to pub.dev.

---

## Installation

```yaml
# pubspec.yaml
dependencies:
  alterione_sdk: ^0.1.0
```

```bash
dart pub get
```

---

## What's Included

```
alterione_sdk
  │
  ├── Plugin system
  │   ├── AlteriOnePlugin         — base plugin interface
  │   ├── AlteriOneMcpServer      — base MCP server class
  │   ├── PluginManifest          — plugin identity and capabilities
  │   ├── PluginContext           — initialization context
  │   └── PluginLogger            — logging interface
  │
  ├── Memory
  │   ├── AlteriOneMemoryStore    — memory backend interface
  │   ├── MemoryEntry             — stored memory unit
  │   ├── MemoryQuery             — retrieval query
  │   └── MemoryType              — shortTerm / longTerm / episodic / semantic
  │
  ├── LLM
  │   ├── AlteriOneLlmProvider    — LLM backend interface
  │   ├── LlmRequest / Response   — request and response models
  │   ├── LlmMessage / LlmRole    — conversation messages
  │   ├── LlmChunk                — streaming token
  │   ├── LlmUsage                — token statistics
  │   └── ToolCall                — tool use from LLM
  │
  ├── Skills
  │   ├── AlteriOneSkill          — skill interface
  │   ├── SkillDefinition         — what the skill can do
  │   ├── SkillParam              — parameter schema
  │   ├── SkillCall               — invocation with arguments
  │   └── SkillResult             — execution result
  │
  ├── Persona
  │   ├── PersonaConfig           — persona settings
  │   └── PersonaRules            — parsed rules from markdown
  │
  ├── MCP Protocol
  │   ├── AlteriOneMcpTransport   — transport interface
  │   ├── StdioMcpTransport       — stdio implementation
  │   ├── SocketMcpTransport      — socket implementation
  │   ├── McpMessage              — JSON-RPC 2.0 message
  │   ├── McpError                — error model
  │   └── McpCapabilities         — capability declarations
  │
  └── Events
      ├── AlteriOneEvent          — base event class
      └── EventBus                — stream-based event bus
```

---

## Building a Memory Module

```dart
import 'package:alterione_sdk/alterione_sdk.dart';

class MyMemoryModule extends AlteriOneMcpServer
    implements AlteriOneMemoryStore {

  @override
  PluginManifest get manifest => PluginManifest(
    id: 'my-memory-module',
    version: '1.0.0',
    type: PluginType.memory,
    capabilities: ['store', 'recall', 'forget'],
    permissions: [PluginPermission.fileSystem],
    memoryTypes: ['short_term', 'long_term'],
  );

  @override
  Future<void> onInitialize(PluginContext ctx) async {
    final dbPath = ctx.get<String>('db_path', defaultValue: './memory.db');
    ctx.logger.info('Memory module initializing at $dbPath');
    await _initDatabase(dbPath);
  }

  @override
  Future<void> store(MemoryEntry entry) async {
    await _db.insert(entry);
  }

  @override
  Future<List<MemoryEntry>> recall(MemoryQuery query) async {
    return _db.search(query);
  }

  @override
  Future<void> forget(String entryId) async {
    await _db.delete(entryId);
  }

  @override
  Future<void> onDispose() async {
    await _db.close();
  }
}

// bin/main.dart
void main() async {
  final module = MyMemoryModule(
    transport: StdioMcpTransport(),
  );
  await module.onInitialize(/* context from agent */);
  await module.serve(); // starts MCP listen loop
}
```

---

## Building an LLM Provider

```dart
import 'package:alterione_sdk/alterione_sdk.dart';

class MyLlmProvider extends AlteriOneMcpServer
    implements AlteriOneLlmProvider {

  @override
  PluginManifest get manifest => PluginManifest(
    id: 'my-llm-provider',
    version: '1.0.0',
    type: PluginType.llm,
    capabilities: ['complete', 'stream'],
    permissions: [PluginPermission.network],
  );

  @override
  Future<LlmResponse> complete(LlmRequest request) async {
    // Call your LLM endpoint here
    final response = await _httpClient.post(
      _endpoint,
      body: jsonEncode(request.toOpenAiJson()),
    );
    return LlmResponse.fromOpenAiJson(jsonDecode(response.body));
  }

  @override
  Stream<LlmChunk> stream(LlmRequest request) async* {
    // SSE streaming from your LLM
    final stream = await _httpClient.postStream(
      _endpoint,
      body: jsonEncode({...request.toOpenAiJson(), 'stream': true}),
    );
    await for (final chunk in _parseSse(stream)) {
      yield chunk;
    }
  }
}
```

---

## Building a Skill

```dart
import 'package:alterione_sdk/alterione_sdk.dart';

class WebSearchSkill implements AlteriOneSkill {

  @override
  SkillDefinition get definition => SkillDefinition(
    id: 'web_search',
    name: 'Web Search',
    description: 'Search the web for current information.',
    parameters: {
      'query': SkillParam(
        type: SkillParamType.string,
        description: 'Search query',
        required: true,
      ),
      'max_results': SkillParam(
        type: SkillParamType.integer,
        description: 'Number of results to return',
        required: false,
        defaultValue: 5,
      ),
    },
  );

  @override
  Future<SkillResult> execute(SkillCall call) async {
    final stopwatch = Stopwatch()..start();
    try {
      final query      = call.arg<String>('query');
      final maxResults = call.argOptional<int>('max_results') ?? 5;

      final results = await _search(query, maxResults);

      return SkillResult.ok(call.callId, results, stopwatch.elapsed);
    } catch (e) {
      return SkillResult.err(call.callId, e.toString(), stopwatch.elapsed);
    }
  }
}
```

---

## MCP Transport

Modules communicate with the agent via **newline-delimited JSON** (NDJSON) over stdio.

```dart
// Use StdioMcpTransport in production (compiled module)
final transport = StdioMcpTransport();

// Use SocketMcpTransport for debugging
final transport = SocketMcpTransport(await Socket.connect('localhost', 9000));
```

All MCP messages follow [JSON-RPC 2.0](https://www.jsonrpc.org/specification):

```json
// Request (agent → module)
{"jsonrpc":"2.0","id":"1","method":"tools/call","params":{"name":"store","arguments":{}}}

// Response (module → agent)
{"jsonrpc":"2.0","id":"1","result":{"content":[{"type":"text","text":"ok"}]}}
```

---

## Plugin Manifest

Every module must declare a manifest:

```dart
PluginManifest(
  id: 'my-plugin',               // unique ID, kebab-case
  version: '1.0.0',              // semver
  type: PluginType.memory,       // memory | llm | skill | processor | generic
  capabilities: ['store','recall'],
  permissions: [
    PluginPermission.fileSystem,
    PluginPermission.network,
  ],
  configSchema: {                // optional: JSON Schema for config validation
    'db_path': {'type': 'string'},
  },
)
```

---

## Plugin Types

| Type | Interface | Use for |
|---|---|---|
| `memory` | `AlteriOneMemoryStore` | Storage backends |
| `llm` | `AlteriOneLlmProvider` | LLM integrations |
| `skill` | `AlteriOneSkill` | Agent tools |
| `processor` | `RequestProcessor` | Pipeline steps |
| `generic` | `AlteriOnePlugin` | Everything else |

---

## Events

```dart
// AlteriOneEvent is the base for all framework events
class MyCustomEvent extends AlteriOneEvent {
  final String data;
  MyCustomEvent(this.data);

  @override
  String get type => 'my_plugin.custom';
}

// EventBus usage (passed via PluginContext in future versions)
final bus = EventBus();
bus.listen<PersonaSwitchedEvent>((event) {
  print('Persona changed to ${event.to}');
});
bus.fire(MyCustomEvent('hello'));
```

---

## MemoryEntry

```dart
final entry = MemoryEntry(
  id:        'mem-001',
  personaId: 'work',
  type:      MemoryType.longTerm,
  content:   'User prefers concise responses without bullet points.',
  metadata:  {'source': 'user_feedback', 'confidence': 0.9},
  createdAt: DateTime.now(),
  expiresAt: DateTime.now().add(Duration(days: 90)),
);
```

---

## Module Naming Convention

| Where | Format | Example |
|---|---|---|
| pub.dev package | `alterione_{type}_{name}` | `alterione_memory_sqlite` |
| GitHub repo | `module-{type}-{name}` | `module-memory-sqlite` |
| Binary / module ID | `alterione-{type}-{name}` | `alterione-memory-sqlite` |
| Dart class | `{Name}Module` | `SqliteMemoryModule` |

---

## Minimal pubspec.yaml for a Module

```yaml
name: alterione_memory_sqlite
description: SQLite memory backend for AlteriOne.
version: 1.0.0
homepage: https://github.com/alterione/module-memory-sqlite

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  alterione_sdk: ^0.1.0
  sqlite3: ^2.0.0

dev_dependencies:
  test: ^1.24.0
  lints: ^3.0.0
```

---

## Plugin Template

Start from the official template:

```bash
git clone https://github.com/alterione/alterione-plugin-template my-plugin
cd my-plugin
dart pub get
```

---

## API Reference

Full API documentation: [pub.dev/packages/alterione_sdk](https://pub.dev/packages/alterione_sdk)

---

## Contributing

This package is the foundation of the AlteriOne ecosystem.  
For interface changes, open a discussion before submitting a PR.

See [CONTRIBUTING.md](CONTRIBUTING.md) and [alterione.one](https://alteri.one).

---

## License

MIT — see [LICENSE](LICENSE)