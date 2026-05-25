import 'skill_call.dart';
import 'skill_definition.dart';
import 'skill_result.dart';

abstract interface class AlteriOneSkill {
  SkillDefinition get definition;
  Future<SkillResult> execute(SkillCall call);
}
