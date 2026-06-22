// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsEntityCollection on Isar {
  IsarCollection<SettingsEntity> get settingsEntitys => this.collection();
}

const SettingsEntitySchema = CollectionSchema(
  name: r'SettingsEntity',
  id: -7271317039764597112,
  properties: {
    r'audioSortAscending': PropertySchema(
      id: 0,
      name: r'audioSortAscending',
      type: IsarType.bool,
    ),
    r'audioSortBy': PropertySchema(
      id: 1,
      name: r'audioSortBy',
      type: IsarType.string,
    ),
    r'autoScanOnStart': PropertySchema(
      id: 2,
      name: r'autoScanOnStart',
      type: IsarType.bool,
    ),
    r'backgroundPlayback': PropertySchema(
      id: 3,
      name: r'backgroundPlayback',
      type: IsarType.bool,
    ),
    r'defaultPlaybackSpeed': PropertySchema(
      id: 4,
      name: r'defaultPlaybackSpeed',
      type: IsarType.double,
    ),
    r'downloadPath': PropertySchema(
      id: 5,
      name: r'downloadPath',
      type: IsarType.string,
    ),
    r'isDarkMode': PropertySchema(
      id: 6,
      name: r'isDarkMode',
      type: IsarType.bool,
    ),
    r'lastAudioPath': PropertySchema(
      id: 7,
      name: r'lastAudioPath',
      type: IsarType.string,
    ),
    r'lastAudioPosition': PropertySchema(
      id: 8,
      name: r'lastAudioPosition',
      type: IsarType.long,
    ),
    r'maxConcurrentDownloads': PropertySchema(
      id: 9,
      name: r'maxConcurrentDownloads',
      type: IsarType.long,
    ),
    r'pipEnabled': PropertySchema(
      id: 10,
      name: r'pipEnabled',
      type: IsarType.bool,
    ),
    r'showAudioArtwork': PropertySchema(
      id: 11,
      name: r'showAudioArtwork',
      type: IsarType.bool,
    ),
    r'showDownloadNotification': PropertySchema(
      id: 12,
      name: r'showDownloadNotification',
      type: IsarType.bool,
    ),
    r'showVideoThumbnail': PropertySchema(
      id: 13,
      name: r'showVideoThumbnail',
      type: IsarType.bool,
    ),
    r'skipDuration': PropertySchema(
      id: 14,
      name: r'skipDuration',
      type: IsarType.long,
    ),
    r'useDynamicColor': PropertySchema(
      id: 15,
      name: r'useDynamicColor',
      type: IsarType.bool,
    ),
    r'videoGridColumns': PropertySchema(
      id: 16,
      name: r'videoGridColumns',
      type: IsarType.string,
    ),
    r'videoSortAscending': PropertySchema(
      id: 17,
      name: r'videoSortAscending',
      type: IsarType.bool,
    ),
    r'videoSortBy': PropertySchema(
      id: 18,
      name: r'videoSortBy',
      type: IsarType.string,
    )
  },
  estimateSize: _settingsEntityEstimateSize,
  serialize: _settingsEntitySerialize,
  deserialize: _settingsEntityDeserialize,
  deserializeProp: _settingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsEntityGetId,
  getLinks: _settingsEntityGetLinks,
  attach: _settingsEntityAttach,
  version: '3.1.0+1',
);

int _settingsEntityEstimateSize(
  SettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.audioSortBy.length * 3;
  bytesCount += 3 + object.downloadPath.length * 3;
  bytesCount += 3 + object.lastAudioPath.length * 3;
  bytesCount += 3 + object.videoGridColumns.length * 3;
  bytesCount += 3 + object.videoSortBy.length * 3;
  return bytesCount;
}

void _settingsEntitySerialize(
  SettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.audioSortAscending);
  writer.writeString(offsets[1], object.audioSortBy);
  writer.writeBool(offsets[2], object.autoScanOnStart);
  writer.writeBool(offsets[3], object.backgroundPlayback);
  writer.writeDouble(offsets[4], object.defaultPlaybackSpeed);
  writer.writeString(offsets[5], object.downloadPath);
  writer.writeBool(offsets[6], object.isDarkMode);
  writer.writeString(offsets[7], object.lastAudioPath);
  writer.writeLong(offsets[8], object.lastAudioPosition);
  writer.writeLong(offsets[9], object.maxConcurrentDownloads);
  writer.writeBool(offsets[10], object.pipEnabled);
  writer.writeBool(offsets[11], object.showAudioArtwork);
  writer.writeBool(offsets[12], object.showDownloadNotification);
  writer.writeBool(offsets[13], object.showVideoThumbnail);
  writer.writeLong(offsets[14], object.skipDuration);
  writer.writeBool(offsets[15], object.useDynamicColor);
  writer.writeString(offsets[16], object.videoGridColumns);
  writer.writeBool(offsets[17], object.videoSortAscending);
  writer.writeString(offsets[18], object.videoSortBy);
}

SettingsEntity _settingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsEntity();
  object.audioSortAscending = reader.readBool(offsets[0]);
  object.audioSortBy = reader.readString(offsets[1]);
  object.autoScanOnStart = reader.readBool(offsets[2]);
  object.backgroundPlayback = reader.readBool(offsets[3]);
  object.defaultPlaybackSpeed = reader.readDouble(offsets[4]);
  object.downloadPath = reader.readString(offsets[5]);
  object.id = id;
  object.isDarkMode = reader.readBool(offsets[6]);
  object.lastAudioPath = reader.readString(offsets[7]);
  object.lastAudioPosition = reader.readLong(offsets[8]);
  object.maxConcurrentDownloads = reader.readLong(offsets[9]);
  object.pipEnabled = reader.readBool(offsets[10]);
  object.showAudioArtwork = reader.readBool(offsets[11]);
  object.showDownloadNotification = reader.readBool(offsets[12]);
  object.showVideoThumbnail = reader.readBool(offsets[13]);
  object.skipDuration = reader.readLong(offsets[14]);
  object.useDynamicColor = reader.readBool(offsets[15]);
  object.videoGridColumns = reader.readString(offsets[16]);
  object.videoSortAscending = reader.readBool(offsets[17]);
  object.videoSortBy = reader.readString(offsets[18]);
  return object;
}

P _settingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsEntityGetId(SettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsEntityGetLinks(SettingsEntity object) {
  return [];
}

void _settingsEntityAttach(
    IsarCollection<dynamic> col, Id id, SettingsEntity object) {
  object.id = id;
}

extension SettingsEntityQueryWhereSort
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhere> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsEntityQueryWhere
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhereClause> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idBetween(
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

extension SettingsEntityQueryFilter
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortAscendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioSortAscending',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioSortBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioSortBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioSortBy',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      audioSortByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioSortBy',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      autoScanOnStartEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoScanOnStart',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      backgroundPlaybackEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backgroundPlayback',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      defaultPlaybackSpeedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultPlaybackSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      defaultPlaybackSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultPlaybackSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      defaultPlaybackSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultPlaybackSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      defaultPlaybackSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultPlaybackSpeed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadPath',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      downloadPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadPath',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      isDarkModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDarkMode',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAudioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAudioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAudioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAudioPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastAudioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastAudioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastAudioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastAudioPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAudioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastAudioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPositionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAudioPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPositionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAudioPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPositionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAudioPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      lastAudioPositionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAudioPosition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxConcurrentDownloadsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxConcurrentDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxConcurrentDownloadsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxConcurrentDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxConcurrentDownloadsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxConcurrentDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxConcurrentDownloadsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxConcurrentDownloads',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      pipEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pipEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      showAudioArtworkEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showAudioArtwork',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      showDownloadNotificationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showDownloadNotification',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      showVideoThumbnailEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showVideoThumbnail',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      skipDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skipDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      skipDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skipDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      skipDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skipDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      skipDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skipDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      useDynamicColorEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useDynamicColor',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoGridColumns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoGridColumns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoGridColumns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoGridColumns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoGridColumns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoGridColumns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoGridColumns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoGridColumns',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoGridColumns',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoGridColumnsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoGridColumns',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortAscendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoSortAscending',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoSortBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoSortBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoSortBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoSortBy',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      videoSortByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoSortBy',
        value: '',
      ));
    });
  }
}

extension SettingsEntityQueryObject
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQueryLinks
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQuerySortBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByAudioSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortAscending', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByAudioSortAscendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortAscending', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByAudioSortBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortBy', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByAudioSortByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortBy', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByAutoScanOnStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoScanOnStart', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByAutoScanOnStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoScanOnStart', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByBackgroundPlayback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPlayback', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByBackgroundPlaybackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPlayback', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByDefaultPlaybackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByDefaultPlaybackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByDownloadPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPath', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByDownloadPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPath', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByIsDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByLastAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPath', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByLastAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPath', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByLastAudioPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPosition', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByLastAudioPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPosition', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByMaxConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxConcurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByMaxConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxConcurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByPipEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipEnabled', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByPipEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipEnabled', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByShowAudioArtwork() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAudioArtwork', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByShowAudioArtworkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAudioArtwork', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByShowDownloadNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDownloadNotification', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByShowDownloadNotificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDownloadNotification', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByShowVideoThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoThumbnail', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByShowVideoThumbnailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoThumbnail', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortBySkipDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipDuration', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortBySkipDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipDuration', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByUseDynamicColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDynamicColor', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByUseDynamicColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDynamicColor', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByVideoGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoGridColumns', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByVideoGridColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoGridColumns', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByVideoSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortAscending', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByVideoSortAscendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortAscending', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByVideoSortBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortBy', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByVideoSortByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortBy', Sort.desc);
    });
  }
}

extension SettingsEntityQuerySortThenBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortThenBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByAudioSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortAscending', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByAudioSortAscendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortAscending', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByAudioSortBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortBy', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByAudioSortByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSortBy', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByAutoScanOnStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoScanOnStart', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByAutoScanOnStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoScanOnStart', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByBackgroundPlayback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPlayback', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByBackgroundPlaybackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPlayback', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByDefaultPlaybackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByDefaultPlaybackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByDownloadPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPath', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByDownloadPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPath', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByIsDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByLastAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPath', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByLastAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPath', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByLastAudioPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPosition', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByLastAudioPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAudioPosition', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByMaxConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxConcurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByMaxConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxConcurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByPipEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipEnabled', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByPipEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipEnabled', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByShowAudioArtwork() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAudioArtwork', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByShowAudioArtworkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAudioArtwork', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByShowDownloadNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDownloadNotification', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByShowDownloadNotificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDownloadNotification', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByShowVideoThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoThumbnail', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByShowVideoThumbnailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoThumbnail', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenBySkipDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipDuration', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenBySkipDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipDuration', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByUseDynamicColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDynamicColor', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByUseDynamicColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDynamicColor', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByVideoGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoGridColumns', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByVideoGridColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoGridColumns', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByVideoSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortAscending', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByVideoSortAscendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortAscending', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByVideoSortBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortBy', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByVideoSortByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoSortBy', Sort.desc);
    });
  }
}

extension SettingsEntityQueryWhereDistinct
    on QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> {
  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByAudioSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioSortAscending');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByAudioSortBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioSortBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByAutoScanOnStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoScanOnStart');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByBackgroundPlayback() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backgroundPlayback');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByDefaultPlaybackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPlaybackSpeed');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByDownloadPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDarkMode');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByLastAudioPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAudioPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByLastAudioPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAudioPosition');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByMaxConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxConcurrentDownloads');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByPipEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pipEnabled');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByShowAudioArtwork() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showAudioArtwork');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByShowDownloadNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showDownloadNotification');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByShowVideoThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showVideoThumbnail');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctBySkipDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skipDuration');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByUseDynamicColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useDynamicColor');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByVideoGridColumns({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoGridColumns',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByVideoSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoSortAscending');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByVideoSortBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoSortBy', caseSensitive: caseSensitive);
    });
  }
}

extension SettingsEntityQueryProperty
    on QueryBuilder<SettingsEntity, SettingsEntity, QQueryProperty> {
  QueryBuilder<SettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      audioSortAscendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioSortAscending');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations> audioSortByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioSortBy');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      autoScanOnStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoScanOnStart');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      backgroundPlaybackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundPlayback');
    });
  }

  QueryBuilder<SettingsEntity, double, QQueryOperations>
      defaultPlaybackSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPlaybackSpeed');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
      downloadPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadPath');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> isDarkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDarkMode');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
      lastAudioPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAudioPath');
    });
  }

  QueryBuilder<SettingsEntity, int, QQueryOperations>
      lastAudioPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAudioPosition');
    });
  }

  QueryBuilder<SettingsEntity, int, QQueryOperations>
      maxConcurrentDownloadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxConcurrentDownloads');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> pipEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pipEnabled');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      showAudioArtworkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showAudioArtwork');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      showDownloadNotificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showDownloadNotification');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      showVideoThumbnailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showVideoThumbnail');
    });
  }

  QueryBuilder<SettingsEntity, int, QQueryOperations> skipDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skipDuration');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      useDynamicColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useDynamicColor');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations>
      videoGridColumnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoGridColumns');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      videoSortAscendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoSortAscending');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations> videoSortByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoSortBy');
    });
  }
}
