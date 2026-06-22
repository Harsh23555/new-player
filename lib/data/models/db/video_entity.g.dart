// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoEntityCollection on Isar {
  IsarCollection<VideoEntity> get videoEntitys => this.collection();
}

const VideoEntitySchema = CollectionSchema(
  name: r'VideoEntity',
  id: -7708770287237567472,
  properties: {
    r'dateAdded': PropertySchema(
      id: 0,
      name: r'dateAdded',
      type: IsarType.dateTime,
    ),
    r'dateModified': PropertySchema(
      id: 1,
      name: r'dateModified',
      type: IsarType.dateTime,
    ),
    r'duration': PropertySchema(
      id: 2,
      name: r'duration',
      type: IsarType.string,
    ),
    r'durationMs': PropertySchema(
      id: 3,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'height': PropertySchema(
      id: 4,
      name: r'height',
      type: IsarType.long,
    ),
    r'isDownloaded': PropertySchema(
      id: 5,
      name: r'isDownloaded',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 6,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'mimeType': PropertySchema(
      id: 7,
      name: r'mimeType',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 8,
      name: r'path',
      type: IsarType.string,
    ),
    r'playCount': PropertySchema(
      id: 9,
      name: r'playCount',
      type: IsarType.long,
    ),
    r'size': PropertySchema(
      id: 10,
      name: r'size',
      type: IsarType.long,
    ),
    r'thumbnailPath': PropertySchema(
      id: 11,
      name: r'thumbnailPath',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 12,
      name: r'title',
      type: IsarType.string,
    ),
    r'width': PropertySchema(
      id: 13,
      name: r'width',
      type: IsarType.long,
    )
  },
  estimateSize: _videoEntityEstimateSize,
  serialize: _videoEntitySerialize,
  deserialize: _videoEntityDeserialize,
  deserializeProp: _videoEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'path': IndexSchema(
      id: 8756705481922369689,
      name: r'path',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'path',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _videoEntityGetId,
  getLinks: _videoEntityGetLinks,
  attach: _videoEntityAttach,
  version: '3.1.0+1',
);

int _videoEntityEstimateSize(
  VideoEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.duration.length * 3;
  {
    final value = object.mimeType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.path.length * 3;
  {
    final value = object.thumbnailPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _videoEntitySerialize(
  VideoEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateAdded);
  writer.writeDateTime(offsets[1], object.dateModified);
  writer.writeString(offsets[2], object.duration);
  writer.writeLong(offsets[3], object.durationMs);
  writer.writeLong(offsets[4], object.height);
  writer.writeBool(offsets[5], object.isDownloaded);
  writer.writeBool(offsets[6], object.isFavorite);
  writer.writeString(offsets[7], object.mimeType);
  writer.writeString(offsets[8], object.path);
  writer.writeLong(offsets[9], object.playCount);
  writer.writeLong(offsets[10], object.size);
  writer.writeString(offsets[11], object.thumbnailPath);
  writer.writeString(offsets[12], object.title);
  writer.writeLong(offsets[13], object.width);
}

VideoEntity _videoEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VideoEntity();
  object.dateAdded = reader.readDateTime(offsets[0]);
  object.dateModified = reader.readDateTime(offsets[1]);
  object.duration = reader.readString(offsets[2]);
  object.durationMs = reader.readLong(offsets[3]);
  object.height = reader.readLong(offsets[4]);
  object.id = id;
  object.isDownloaded = reader.readBool(offsets[5]);
  object.isFavorite = reader.readBool(offsets[6]);
  object.mimeType = reader.readStringOrNull(offsets[7]);
  object.path = reader.readString(offsets[8]);
  object.playCount = reader.readLong(offsets[9]);
  object.size = reader.readLong(offsets[10]);
  object.thumbnailPath = reader.readStringOrNull(offsets[11]);
  object.title = reader.readString(offsets[12]);
  object.width = reader.readLong(offsets[13]);
  return object;
}

P _videoEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _videoEntityGetId(VideoEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoEntityGetLinks(VideoEntity object) {
  return [];
}

void _videoEntityAttach(
    IsarCollection<dynamic> col, Id id, VideoEntity object) {
  object.id = id;
}

extension VideoEntityByIndex on IsarCollection<VideoEntity> {
  Future<VideoEntity?> getByPath(String path) {
    return getByIndex(r'path', [path]);
  }

  VideoEntity? getByPathSync(String path) {
    return getByIndexSync(r'path', [path]);
  }

  Future<bool> deleteByPath(String path) {
    return deleteByIndex(r'path', [path]);
  }

  bool deleteByPathSync(String path) {
    return deleteByIndexSync(r'path', [path]);
  }

  Future<List<VideoEntity?>> getAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndex(r'path', values);
  }

  List<VideoEntity?> getAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'path', values);
  }

  Future<int> deleteAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'path', values);
  }

  int deleteAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'path', values);
  }

  Future<Id> putByPath(VideoEntity object) {
    return putByIndex(r'path', object);
  }

  Id putByPathSync(VideoEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'path', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPath(List<VideoEntity> objects) {
    return putAllByIndex(r'path', objects);
  }

  List<Id> putAllByPathSync(List<VideoEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'path', objects, saveLinks: saveLinks);
  }
}

extension VideoEntityQueryWhereSort
    on QueryBuilder<VideoEntity, VideoEntity, QWhere> {
  QueryBuilder<VideoEntity, VideoEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VideoEntityQueryWhere
    on QueryBuilder<VideoEntity, VideoEntity, QWhereClause> {
  QueryBuilder<VideoEntity, VideoEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterWhereClause> pathEqualTo(
      String path) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'path',
        value: [path],
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterWhereClause> pathNotEqualTo(
      String path) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [],
              upper: [path],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [path],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [path],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [],
              upper: [path],
              includeUpper: false,
            ));
      }
    });
  }
}

extension VideoEntityQueryFilter
    on QueryBuilder<VideoEntity, VideoEntity, QFilterCondition> {
  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateAddedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateAddedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateAddedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateAddedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateAdded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateModifiedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateModified',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateModifiedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateModified',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateModifiedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateModified',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      dateModifiedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateModified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> durationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> durationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> durationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'duration',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'duration',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      durationMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> heightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      heightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> heightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> heightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      isDownloadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> mimeTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> mimeTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mimeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> mimeTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mimeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      mimeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      playCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      playCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      playCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      playCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> sizeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> sizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> sizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> sizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thumbnailPath',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thumbnailPath',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbnailPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'thumbnailPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      thumbnailPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'thumbnailPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      titleGreaterThan(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> widthEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition>
      widthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> widthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterFilterCondition> widthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VideoEntityQueryObject
    on QueryBuilder<VideoEntity, VideoEntity, QFilterCondition> {}

extension VideoEntityQueryLinks
    on QueryBuilder<VideoEntity, VideoEntity, QFilterCondition> {}

extension VideoEntityQuerySortBy
    on QueryBuilder<VideoEntity, VideoEntity, QSortBy> {
  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy>
      sortByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy>
      sortByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByThumbnailPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy>
      sortByThumbnailPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension VideoEntityQuerySortThenBy
    on QueryBuilder<VideoEntity, VideoEntity, QSortThenBy> {
  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy>
      thenByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy>
      thenByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByThumbnailPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy>
      thenByThumbnailPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension VideoEntityQueryWhereDistinct
    on QueryBuilder<VideoEntity, VideoEntity, QDistinct> {
  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAdded');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateModified');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByDuration(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMs');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDownloaded');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByMimeType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mimeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCount');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'size');
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByThumbnailPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thumbnailPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoEntity, VideoEntity, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension VideoEntityQueryProperty
    on QueryBuilder<VideoEntity, VideoEntity, QQueryProperty> {
  QueryBuilder<VideoEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VideoEntity, DateTime, QQueryOperations> dateAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAdded');
    });
  }

  QueryBuilder<VideoEntity, DateTime, QQueryOperations> dateModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateModified');
    });
  }

  QueryBuilder<VideoEntity, String, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<VideoEntity, int, QQueryOperations> durationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMs');
    });
  }

  QueryBuilder<VideoEntity, int, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<VideoEntity, bool, QQueryOperations> isDownloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDownloaded');
    });
  }

  QueryBuilder<VideoEntity, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<VideoEntity, String?, QQueryOperations> mimeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mimeType');
    });
  }

  QueryBuilder<VideoEntity, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<VideoEntity, int, QQueryOperations> playCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCount');
    });
  }

  QueryBuilder<VideoEntity, int, QQueryOperations> sizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'size');
    });
  }

  QueryBuilder<VideoEntity, String?, QQueryOperations> thumbnailPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thumbnailPath');
    });
  }

  QueryBuilder<VideoEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<VideoEntity, int, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
