enum SkillParamType {
  string,
  number,
  integer,
  boolean,
  object,
  array;

  String get jsonType => switch (this) {
    string => 'string',
    number => 'number',
    integer => 'integer',
    boolean => 'boolean',
    object => 'object',
    array => 'array',
  };
}
