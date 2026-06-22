// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentlyPlayedEntityCollection on Isar {
  IsarCollection<RecentlyPlayedEntity> get recentlyPlayedEntitys =>
      this.collection();
}

const RecentlyPlayedEntitySchema = CollectionSchema(
  name: r'RecentlyPlayedEntity',
  id: 2313323638749217169,
  properties: {
    r'artworkPath': PropertySchema(
      id: 0,
      name: r'artworkPath',
      type: IsarType.string,
    ),
    r'mediaPath': PropertySchema(
      id: 1,
      name: r'mediaPath',
      type: IsarType.string,
    ),
    r'mediaType': PropertySchema(
      id: 2,
      name: r'mediaType',
      type: IsarType.string,
    ),
    r'playedAt': PropertySchema(
      id: 3,
      name: r'playedAt',
      type: IsarType.dateTime,
    ),
    r'positionMs': PropertySchema(
      id: 4,
      name: r'positionMs',
      type: IsarType.long,
    ),
    r'subtitle': PropertySchema(
      id: 5,
      name: r'subtitle',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _recentlyPlayedEntityEstimateSize,
  serialize: _recentlyPlayedEntitySerialize,
  deserialize: _recentlyPlayedEntityDeserialize,
  deserializeProp: _recentlyPlayedEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'mediaPath': IndexSchema(
      id: -2477637615030973134,
      name: r'mediaPath',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mediaPath',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _recentlyPlayedEntityGetId,
  getLinks: _recentlyPlayedEntityGetLinks,
  attach: _recentlyPlayedEntityAttach,
  version: '3.1.0+1',
);

int _recentlyPlayedEntityEstimateSize(
  RecentlyPlayedEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.artworkPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.mediaPath.length * 3;
  bytesCount += 3 + object.mediaType.length * 3;
  bytesCount += 3 + object.subtitle.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _recentlyPlayedEntitySerialize(
  RecentlyPlayedEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.artworkPath);
  writer.writeString(offsets[1], object.mediaPath);
  writer.writeString(offsets[2], object.mediaType);
  writer.writeDateTime(offsets[3], object.playedAt);
  writer.writeLong(offsets[4], object.positionMs);
  writer.writeString(offsets[5], object.subtitle);
  writer.writeString(offsets[6], object.title);
}

RecentlyPlayedEntity _recentlyPlayedEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentlyPlayedEntity();
  object.artworkPath = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.mediaPath = reader.readString(offsets[1]);
  object.mediaType = reader.readString(offsets[2]);
  object.playedAt = reader.readDateTime(offsets[3]);
  object.positionMs = reader.readLong(offsets[4]);
  object.subtitle = reader.readString(offsets[5]);
  object.title = reader.readString(offsets[6]);
  return object;
}

P _recentlyPlayedEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentlyPlayedEntityGetId(RecentlyPlayedEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentlyPlayedEntityGetLinks(
    RecentlyPlayedEntity object) {
  return [];
}

void _recentlyPlayedEntityAttach(
    IsarCollection<dynamic> col, Id id, RecentlyPlayedEntity object) {
  object.id = id;
}

extension RecentlyPlayedEntityQueryWhereSort
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QWhere> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecentlyPlayedEntityQueryWhere
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QWhereClause> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
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

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
      mediaPathEqualTo(String mediaPath) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mediaPath',
        value: [mediaPath],
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
      mediaPathNotEqualTo(String mediaPath) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaPath',
              lower: [],
              upper: [mediaPath],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaPath',
              lower: [mediaPath],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaPath',
              lower: [mediaPath],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaPath',
              lower: [],
              upper: [mediaPath],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RecentlyPlayedEntityQueryFilter on QueryBuilder<RecentlyPlayedEntity,
    RecentlyPlayedEntity, QFilterCondition> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'artworkPath',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'artworkPath',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artworkPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artworkPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artworkPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artworkPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artworkPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artworkPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      artworkPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artworkPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      artworkPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artworkPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artworkPath',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> artworkPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artworkPath',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      mediaPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      mediaPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaPath',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaPath',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      mediaTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      mediaTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> mediaTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> playedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> playedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> playedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> playedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> positionMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> positionMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> positionMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> positionMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      subtitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      subtitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subtitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> subtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension RecentlyPlayedEntityQueryObject on QueryBuilder<RecentlyPlayedEntity,
    RecentlyPlayedEntity, QFilterCondition> {}

extension RecentlyPlayedEntityQueryLinks on QueryBuilder<RecentlyPlayedEntity,
    RecentlyPlayedEntity, QFilterCondition> {}

extension RecentlyPlayedEntityQuerySortBy
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QSortBy> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByArtworkPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artworkPath', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByArtworkPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artworkPath', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension RecentlyPlayedEntityQuerySortThenBy
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QSortThenBy> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByArtworkPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artworkPath', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByArtworkPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artworkPath', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension RecentlyPlayedEntityQueryWhereDistinct
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
      distinctByArtworkPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artworkPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
      distinctByMediaPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
      distinctByMediaType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
      distinctByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playedAt');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
      distinctByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMs');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
      distinctBySubtitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension RecentlyPlayedEntityQueryProperty on QueryBuilder<
    RecentlyPlayedEntity, RecentlyPlayedEntity, QQueryProperty> {
  QueryBuilder<RecentlyPlayedEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String?, QQueryOperations>
      artworkPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artworkPath');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
      mediaPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaPath');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
      mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, DateTime, QQueryOperations>
      playedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playedAt');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, int, QQueryOperations>
      positionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMs');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
      subtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtitle');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
