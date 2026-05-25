// Базовый класс
import '../llm/llm_usage.dart';
import '../memory/memory_type.dart';
import '../plugin/plugin_type.dart';
import 'alterione_event.dart';



// ── System ───────────────────────────────────────
class SystemReadyEvent extends AlteriOneEvent {
  @override
  String get type => 'system.ready';
}

class SystemShutdownEvent extends AlteriOneEvent {
  @override
  String get type => 'system.shutdown';
}

// ── Persona ──────────────────────────────────────
class PersonaSwitchedEvent extends AlteriOneEvent {
  final String? from;
  final String to;
  @override
  String get type => 'persona.switched';
  PersonaSwitchedEvent({this.from, required this.to});
}

class PersonaCreatedEvent extends AlteriOneEvent {
  final String personaId;
  @override
  String get type => 'persona.created';
  PersonaCreatedEvent(this.personaId);
}

class PersonaDeletedEvent extends AlteriOneEvent {
  final String personaId;
  @override
  String get type => 'persona.deleted';
  PersonaDeletedEvent(this.personaId);
}

// ── Module ───────────────────────────────────────
class ModuleRegisteredEvent extends AlteriOneEvent {
  final String moduleId;
  final PluginType pluginType;
  @override
  String get type => 'module.registered';
  ModuleRegisteredEvent(this.moduleId, this.pluginType);
}

class ModuleCrashedEvent extends AlteriOneEvent {
  final String moduleId;
  final String? reason;
  @override
  String get type => 'module.crashed';
  ModuleCrashedEvent(this.moduleId, {this.reason});
}

class ModuleRecoveredEvent extends AlteriOneEvent {
  final String moduleId;
  @override
  String get type => 'module.recovered';
  ModuleRecoveredEvent(this.moduleId);
}

// ── Memory ───────────────────────────────────────
class MemoryStoredEvent extends AlteriOneEvent {
  final String personaId;
  final MemoryType memoryType;
  @override
  String get type => 'memory.stored';
  MemoryStoredEvent(this.personaId, this.memoryType);
}

// ── Agent ────────────────────────────────────────
class AgentRequestStartedEvent extends AlteriOneEvent {
  final String requestId;
  final String personaId;
  @override
  String get type => 'agent.request.started';
  AgentRequestStartedEvent(this.requestId, this.personaId);
}

class AgentResponseDoneEvent extends AlteriOneEvent {
  final String requestId;
  final LlmUsage usage;
  @override
  String get type => 'agent.response.done';
  AgentResponseDoneEvent(this.requestId, this.usage);
}

class SkillCalledEvent extends AlteriOneEvent {
  final String skillId;
  final String personaId;
  final String callId;
  @override
  String get type => 'skill.called';
  SkillCalledEvent(this.skillId, this.personaId, this.callId);
}
