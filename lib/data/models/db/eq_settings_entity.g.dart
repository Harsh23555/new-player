// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eq_settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEqSettingsEntityCollection on Isar {
  IsarCollection<EqSettingsEntity> get eqSettingsEntitys => this.collection();
}

const EqSettingsEntitySchema = CollectionSchema(
  name: r'EqSettingsEntity',
  id: 6644584589028732506,
  properties: {
    r'bassBoost': PropertySchema(
      id: 0,
      name: r'bassBoost',
      type: IsarType.long,
    ),
    r'enabled': PropertySchema(
      id: 1,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'gains': PropertySchema(
      id: 2,
      name: r'gains',
      type: IsarType.doubleList,
    ),
    r'preamp': PropertySchema(
      id: 3,
      name: r'preamp',
      type: IsarType.double,
    ),
    r'preset': PropertySchema(
      id: 4,
      name: r'preset',
      type: IsarType.string,
    ),
    r'virtualizer': PropertySchema(
      id: 5,
      name: r'virtualizer',
      type: IsarType.long,
    )
  },
  estimateSize: _eqSettingsEntityEstimateSize,
  serialize: _eqSettingsEntitySerialize,
  deserialize: _eqSettingsEntityDeserialize,
  deserializeProp: _eqSettingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _eqSettingsEntityGetId,
  getLinks: _eqSettingsEntityGetLinks,
  attach: _eqSettingsEntityAttach,
  version: '3.1.0+1',
);

int _eqSettingsEntityEstimateSize(
  EqSettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.gains.length * 8;
  bytesCount += 3 + object.preset.length * 3;
  return bytesCount;
}

void _eqSettingsEntitySerialize(
  EqSettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bassBoost);
  writer.writeBool(offsets[1], object.enabled);
  writer.writeDoubleList(offsets[2], object.gains);
  writer.writeDouble(offsets[3], object.preamp);
  writer.writeString(offsets[4], object.preset);
  writer.writeLong(offsets[5], object.virtualizer);
}

EqSettingsEntity _eqSettingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EqSettingsEntity();
  object.bassBoost = reader.readLong(offsets[0]);
  object.enabled = reader.readBool(offsets[1]);
  object.gains = reader.readDoubleList(offsets[2]) ?? [];
  object.id = id;
  object.preamp = reader.readDouble(offsets[3]);
  object.preset = reader.readString(offsets[4]);
  object.virtualizer = reader.readLong(offsets[5]);
  return object;
}

P _eqSettingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _eqSettingsEntityGetId(EqSettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _eqSettingsEntityGetLinks(EqSettingsEntity object) {
  return [];
}

void _eqSettingsEntityAttach(
    IsarCollection<dynamic> col, Id id, EqSettingsEntity object) {
  object.id = id;
}

extension EqSettingsEntityQueryWhereSort
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QWhere> {
  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EqSettingsEntityQueryWhere
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QWhereClause> {
  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EqSettingsEntityQueryFilter
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QFilterCondition> {
  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      bassBoostEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bassBoost',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      bassBoostGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bassBoost',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      bassBoostLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bassBoost',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      bassBoostBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bassBoost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gains',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gains',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gains',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gains',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gains',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gains',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gains',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gains',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gains',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      gainsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gains',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      preampEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preamp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      preampGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preamp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      preampLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preamp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      preampBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preset',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preset',
        value: '',
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      presetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preset',
        value: '',
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      virtualizerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'virtualizer',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      virtualizerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'virtualizer',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      virtualizerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'virtualizer',
        value: value,
      ));
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterFilterCondition>
      virtualizerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'virtualizer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EqSettingsEntityQueryObject
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QFilterCondition> {}

extension EqSettingsEntityQueryLinks
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QFilterCondition> {}

extension EqSettingsEntityQuerySortBy
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QSortBy> {
  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByBassBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByBassBoostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByPreamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preamp', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByPreampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preamp', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preset', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preset', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByVirtualizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      sortByVirtualizerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.desc);
    });
  }
}

extension EqSettingsEntityQuerySortThenBy
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QSortThenBy> {
  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByBassBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByBassBoostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByPreamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preamp', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByPreampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preamp', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preset', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preset', Sort.desc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByVirtualizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.asc);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QAfterSortBy>
      thenByVirtualizerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.desc);
    });
  }
}

extension EqSettingsEntityQueryWhereDistinct
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QDistinct> {
  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QDistinct>
      distinctByBassBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bassBoost');
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QDistinct>
      distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QDistinct>
      distinctByGains() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gains');
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QDistinct>
      distinctByPreamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preamp');
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QDistinct> distinctByPreset(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preset', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EqSettingsEntity, EqSettingsEntity, QDistinct>
      distinctByVirtualizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'virtualizer');
    });
  }
}

extension EqSettingsEntityQueryProperty
    on QueryBuilder<EqSettingsEntity, EqSettingsEntity, QQueryProperty> {
  QueryBuilder<EqSettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EqSettingsEntity, int, QQueryOperations> bassBoostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bassBoost');
    });
  }

  QueryBuilder<EqSettingsEntity, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<EqSettingsEntity, List<double>, QQueryOperations>
      gainsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gains');
    });
  }

  QueryBuilder<EqSettingsEntity, double, QQueryOperations> preampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preamp');
    });
  }

  QueryBuilder<EqSettingsEntity, String, QQueryOperations> presetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preset');
    });
  }

  QueryBuilder<EqSettingsEntity, int, QQueryOperations> virtualizerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'virtualizer');
    });
  }
}
