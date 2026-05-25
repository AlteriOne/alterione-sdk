import 'skill_param_type.dart';

class SkillParam {
  final SkillParamType type;
  final String description;
  final bool required;
  final dynamic defaultValue;
  final List<dynamic>? enumValues;
  final SkillParam? items; // для array

  const SkillParam({
    required this.type,
    required this.description,
    this.required = false,
    this.defaultValue,
    this.enumValues,
    this.items,
  });

  Map<String, dynamic> toSchema() {
    final schema = <String, dynamic>{
      'type': type.jsonType,
      'description': description,
    };
    if (defaultValue != null) schema['default'] = defaultValue;
    if (enumValues != null) schema['enum'] = enumValues;
    if (type == SkillParamType.array && items != null) {
      schema['items'] = items!.toSchema();
    }
    return schema;
  }
}
