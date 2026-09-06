// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DeckOptionsTable extends DeckOptions
    with TableInfo<$DeckOptionsTable, DeckOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newCardsPerDayMeta = const VerificationMeta(
    'newCardsPerDay',
  );
  @override
  late final GeneratedColumn<int> newCardsPerDay = GeneratedColumn<int>(
    'new_cards_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _reviewsPerDayMeta = const VerificationMeta(
    'reviewsPerDay',
  );
  @override
  late final GeneratedColumn<int> reviewsPerDay = GeneratedColumn<int>(
    'reviews_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(200),
  );
  static const VerificationMeta _learningStepsMinutesMeta =
      const VerificationMeta('learningStepsMinutes');
  @override
  late final GeneratedColumn<String> learningStepsMinutes =
      GeneratedColumn<String>(
        'learning_steps_minutes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('1,10'),
      );
  static const VerificationMeta _relearningStepsMinutesMeta =
      const VerificationMeta('relearningStepsMinutes');
  @override
  late final GeneratedColumn<String> relearningStepsMinutes =
      GeneratedColumn<String>(
        'relearning_steps_minutes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('10'),
      );
  static const VerificationMeta _maximumIntervalDaysMeta =
      const VerificationMeta('maximumIntervalDays');
  @override
  late final GeneratedColumn<int> maximumIntervalDays = GeneratedColumn<int>(
    'maximum_interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(36500),
  );
  static const VerificationMeta _desiredRetentionMeta = const VerificationMeta(
    'desiredRetention',
  );
  @override
  late final GeneratedColumn<double> desiredRetention = GeneratedColumn<double>(
    'desired_retention',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.9),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    newCardsPerDay,
    reviewsPerDay,
    learningStepsMinutes,
    relearningStepsMinutes,
    maximumIntervalDays,
    desiredRetention,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('new_cards_per_day')) {
      context.handle(
        _newCardsPerDayMeta,
        newCardsPerDay.isAcceptableOrUnknown(
          data['new_cards_per_day']!,
          _newCardsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('reviews_per_day')) {
      context.handle(
        _reviewsPerDayMeta,
        reviewsPerDay.isAcceptableOrUnknown(
          data['reviews_per_day']!,
          _reviewsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('learning_steps_minutes')) {
      context.handle(
        _learningStepsMinutesMeta,
        learningStepsMinutes.isAcceptableOrUnknown(
          data['learning_steps_minutes']!,
          _learningStepsMinutesMeta,
        ),
      );
    }
    if (data.containsKey('relearning_steps_minutes')) {
      context.handle(
        _relearningStepsMinutesMeta,
        relearningStepsMinutes.isAcceptableOrUnknown(
          data['relearning_steps_minutes']!,
          _relearningStepsMinutesMeta,
        ),
      );
    }
    if (data.containsKey('maximum_interval_days')) {
      context.handle(
        _maximumIntervalDaysMeta,
        maximumIntervalDays.isAcceptableOrUnknown(
          data['maximum_interval_days']!,
          _maximumIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('desired_retention')) {
      context.handle(
        _desiredRetentionMeta,
        desiredRetention.isAcceptableOrUnknown(
          data['desired_retention']!,
          _desiredRetentionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeckOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckOption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      newCardsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_cards_per_day'],
      )!,
      reviewsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reviews_per_day'],
      )!,
      learningStepsMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_steps_minutes'],
      )!,
      relearningStepsMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relearning_steps_minutes'],
      )!,
      maximumIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maximum_interval_days'],
      )!,
      desiredRetention: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}desired_retention'],
      )!,
    );
  }

  @override
  $DeckOptionsTable createAlias(String alias) {
    return $DeckOptionsTable(attachedDatabase, alias);
  }
}

class DeckOption extends DataClass implements Insertable<DeckOption> {
  final int id;
  final String name;
  final int newCardsPerDay;
  final int reviewsPerDay;

  /// Comma-separated minutes, e.g. `"1,10"`, matching Anki's step syntax.
  final String learningStepsMinutes;
  final String relearningStepsMinutes;
  final int maximumIntervalDays;

  /// Target probability of recall FSRS schedules intervals for, e.g. `0.9`.
  final double desiredRetention;
  const DeckOption({
    required this.id,
    required this.name,
    required this.newCardsPerDay,
    required this.reviewsPerDay,
    required this.learningStepsMinutes,
    required this.relearningStepsMinutes,
    required this.maximumIntervalDays,
    required this.desiredRetention,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['new_cards_per_day'] = Variable<int>(newCardsPerDay);
    map['reviews_per_day'] = Variable<int>(reviewsPerDay);
    map['learning_steps_minutes'] = Variable<String>(learningStepsMinutes);
    map['relearning_steps_minutes'] = Variable<String>(relearningStepsMinutes);
    map['maximum_interval_days'] = Variable<int>(maximumIntervalDays);
    map['desired_retention'] = Variable<double>(desiredRetention);
    return map;
  }

  DeckOptionsCompanion toCompanion(bool nullToAbsent) {
    return DeckOptionsCompanion(
      id: Value(id),
      name: Value(name),
      newCardsPerDay: Value(newCardsPerDay),
      reviewsPerDay: Value(reviewsPerDay),
      learningStepsMinutes: Value(learningStepsMinutes),
      relearningStepsMinutes: Value(relearningStepsMinutes),
      maximumIntervalDays: Value(maximumIntervalDays),
      desiredRetention: Value(desiredRetention),
    );
  }

  factory DeckOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckOption(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      newCardsPerDay: serializer.fromJson<int>(json['newCardsPerDay']),
      reviewsPerDay: serializer.fromJson<int>(json['reviewsPerDay']),
      learningStepsMinutes: serializer.fromJson<String>(
        json['learningStepsMinutes'],
      ),
      relearningStepsMinutes: serializer.fromJson<String>(
        json['relearningStepsMinutes'],
      ),
      maximumIntervalDays: serializer.fromJson<int>(
        json['maximumIntervalDays'],
      ),
      desiredRetention: serializer.fromJson<double>(json['desiredRetention']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'newCardsPerDay': serializer.toJson<int>(newCardsPerDay),
      'reviewsPerDay': serializer.toJson<int>(reviewsPerDay),
      'learningStepsMinutes': serializer.toJson<String>(learningStepsMinutes),
      'relearningStepsMinutes': serializer.toJson<String>(
        relearningStepsMinutes,
      ),
      'maximumIntervalDays': serializer.toJson<int>(maximumIntervalDays),
      'desiredRetention': serializer.toJson<double>(desiredRetention),
    };
  }

  DeckOption copyWith({
    int? id,
    String? name,
    int? newCardsPerDay,
    int? reviewsPerDay,
    String? learningStepsMinutes,
    String? relearningStepsMinutes,
    int? maximumIntervalDays,
    double? desiredRetention,
  }) => DeckOption(
    id: id ?? this.id,
    name: name ?? this.name,
    newCardsPerDay: newCardsPerDay ?? this.newCardsPerDay,
    reviewsPerDay: reviewsPerDay ?? this.reviewsPerDay,
    learningStepsMinutes: learningStepsMinutes ?? this.learningStepsMinutes,
    relearningStepsMinutes:
        relearningStepsMinutes ?? this.relearningStepsMinutes,
    maximumIntervalDays: maximumIntervalDays ?? this.maximumIntervalDays,
    desiredRetention: desiredRetention ?? this.desiredRetention,
  );
  DeckOption copyWithCompanion(DeckOptionsCompanion data) {
    return DeckOption(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      newCardsPerDay: data.newCardsPerDay.present
          ? data.newCardsPerDay.value
          : this.newCardsPerDay,
      reviewsPerDay: data.reviewsPerDay.present
          ? data.reviewsPerDay.value
          : this.reviewsPerDay,
      learningStepsMinutes: data.learningStepsMinutes.present
          ? data.learningStepsMinutes.value
          : this.learningStepsMinutes,
      relearningStepsMinutes: data.relearningStepsMinutes.present
          ? data.relearningStepsMinutes.value
          : this.relearningStepsMinutes,
      maximumIntervalDays: data.maximumIntervalDays.present
          ? data.maximumIntervalDays.value
          : this.maximumIntervalDays,
      desiredRetention: data.desiredRetention.present
          ? data.desiredRetention.value
          : this.desiredRetention,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckOption(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('newCardsPerDay: $newCardsPerDay, ')
          ..write('reviewsPerDay: $reviewsPerDay, ')
          ..write('learningStepsMinutes: $learningStepsMinutes, ')
          ..write('relearningStepsMinutes: $relearningStepsMinutes, ')
          ..write('maximumIntervalDays: $maximumIntervalDays, ')
          ..write('desiredRetention: $desiredRetention')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    newCardsPerDay,
    reviewsPerDay,
    learningStepsMinutes,
    relearningStepsMinutes,
    maximumIntervalDays,
    desiredRetention,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckOption &&
          other.id == this.id &&
          other.name == this.name &&
          other.newCardsPerDay == this.newCardsPerDay &&
          other.reviewsPerDay == this.reviewsPerDay &&
          other.learningStepsMinutes == this.learningStepsMinutes &&
          other.relearningStepsMinutes == this.relearningStepsMinutes &&
          other.maximumIntervalDays == this.maximumIntervalDays &&
          other.desiredRetention == this.desiredRetention);
}

class DeckOptionsCompanion extends UpdateCompanion<DeckOption> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> newCardsPerDay;
  final Value<int> reviewsPerDay;
  final Value<String> learningStepsMinutes;
  final Value<String> relearningStepsMinutes;
  final Value<int> maximumIntervalDays;
  final Value<double> desiredRetention;
  const DeckOptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.newCardsPerDay = const Value.absent(),
    this.reviewsPerDay = const Value.absent(),
    this.learningStepsMinutes = const Value.absent(),
    this.relearningStepsMinutes = const Value.absent(),
    this.maximumIntervalDays = const Value.absent(),
    this.desiredRetention = const Value.absent(),
  });
  DeckOptionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.newCardsPerDay = const Value.absent(),
    this.reviewsPerDay = const Value.absent(),
    this.learningStepsMinutes = const Value.absent(),
    this.relearningStepsMinutes = const Value.absent(),
    this.maximumIntervalDays = const Value.absent(),
    this.desiredRetention = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DeckOption> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? newCardsPerDay,
    Expression<int>? reviewsPerDay,
    Expression<String>? learningStepsMinutes,
    Expression<String>? relearningStepsMinutes,
    Expression<int>? maximumIntervalDays,
    Expression<double>? desiredRetention,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (newCardsPerDay != null) 'new_cards_per_day': newCardsPerDay,
      if (reviewsPerDay != null) 'reviews_per_day': reviewsPerDay,
      if (learningStepsMinutes != null)
        'learning_steps_minutes': learningStepsMinutes,
      if (relearningStepsMinutes != null)
        'relearning_steps_minutes': relearningStepsMinutes,
      if (maximumIntervalDays != null)
        'maximum_interval_days': maximumIntervalDays,
      if (desiredRetention != null) 'desired_retention': desiredRetention,
    });
  }

  DeckOptionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? newCardsPerDay,
    Value<int>? reviewsPerDay,
    Value<String>? learningStepsMinutes,
    Value<String>? relearningStepsMinutes,
    Value<int>? maximumIntervalDays,
    Value<double>? desiredRetention,
  }) {
    return DeckOptionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      newCardsPerDay: newCardsPerDay ?? this.newCardsPerDay,
      reviewsPerDay: reviewsPerDay ?? this.reviewsPerDay,
      learningStepsMinutes: learningStepsMinutes ?? this.learningStepsMinutes,
      relearningStepsMinutes:
          relearningStepsMinutes ?? this.relearningStepsMinutes,
      maximumIntervalDays: maximumIntervalDays ?? this.maximumIntervalDays,
      desiredRetention: desiredRetention ?? this.desiredRetention,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (newCardsPerDay.present) {
      map['new_cards_per_day'] = Variable<int>(newCardsPerDay.value);
    }
    if (reviewsPerDay.present) {
      map['reviews_per_day'] = Variable<int>(reviewsPerDay.value);
    }
    if (learningStepsMinutes.present) {
      map['learning_steps_minutes'] = Variable<String>(
        learningStepsMinutes.value,
      );
    }
    if (relearningStepsMinutes.present) {
      map['relearning_steps_minutes'] = Variable<String>(
        relearningStepsMinutes.value,
      );
    }
    if (maximumIntervalDays.present) {
      map['maximum_interval_days'] = Variable<int>(maximumIntervalDays.value);
    }
    if (desiredRetention.present) {
      map['desired_retention'] = Variable<double>(desiredRetention.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckOptionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('newCardsPerDay: $newCardsPerDay, ')
          ..write('reviewsPerDay: $reviewsPerDay, ')
          ..write('learningStepsMinutes: $learningStepsMinutes, ')
          ..write('relearningStepsMinutes: $relearningStepsMinutes, ')
          ..write('maximumIntervalDays: $maximumIntervalDays, ')
          ..write('desiredRetention: $desiredRetention')
          ..write(')'))
        .toString();
  }
}

class $DecksTable extends Decks with TableInfo<$DecksTable, Deck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _deckOptionsIdMeta = const VerificationMeta(
    'deckOptionsId',
  );
  @override
  late final GeneratedColumn<int> deckOptionsId = GeneratedColumn<int>(
    'deck_options_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES deck_options (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, deckOptionsId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('deck_options_id')) {
      context.handle(
        _deckOptionsIdMeta,
        deckOptionsId.isAcceptableOrUnknown(
          data['deck_options_id']!,
          _deckOptionsIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deckOptionsIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      deckOptionsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_options_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DecksTable createAlias(String alias) {
    return $DecksTable(attachedDatabase, alias);
  }
}

class Deck extends DataClass implements Insertable<Deck> {
  final int id;
  final String name;
  final int deckOptionsId;
  final DateTime createdAt;
  const Deck({
    required this.id,
    required this.name,
    required this.deckOptionsId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['deck_options_id'] = Variable<int>(deckOptionsId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DecksCompanion toCompanion(bool nullToAbsent) {
    return DecksCompanion(
      id: Value(id),
      name: Value(name),
      deckOptionsId: Value(deckOptionsId),
      createdAt: Value(createdAt),
    );
  }

  factory Deck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deck(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      deckOptionsId: serializer.fromJson<int>(json['deckOptionsId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'deckOptionsId': serializer.toJson<int>(deckOptionsId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Deck copyWith({
    int? id,
    String? name,
    int? deckOptionsId,
    DateTime? createdAt,
  }) => Deck(
    id: id ?? this.id,
    name: name ?? this.name,
    deckOptionsId: deckOptionsId ?? this.deckOptionsId,
    createdAt: createdAt ?? this.createdAt,
  );
  Deck copyWithCompanion(DecksCompanion data) {
    return Deck(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      deckOptionsId: data.deckOptionsId.present
          ? data.deckOptionsId.value
          : this.deckOptionsId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deck(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deckOptionsId: $deckOptionsId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, deckOptionsId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deck &&
          other.id == this.id &&
          other.name == this.name &&
          other.deckOptionsId == this.deckOptionsId &&
          other.createdAt == this.createdAt);
}

class DecksCompanion extends UpdateCompanion<Deck> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> deckOptionsId;
  final Value<DateTime> createdAt;
  const DecksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.deckOptionsId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DecksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int deckOptionsId,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       deckOptionsId = Value(deckOptionsId);
  static Insertable<Deck> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? deckOptionsId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (deckOptionsId != null) 'deck_options_id': deckOptionsId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DecksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? deckOptionsId,
    Value<DateTime>? createdAt,
  }) {
    return DecksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      deckOptionsId: deckOptionsId ?? this.deckOptionsId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (deckOptionsId.present) {
      map['deck_options_id'] = Variable<int>(deckOptionsId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deckOptionsId: $deckOptionsId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NoteTypesTable extends NoteTypes
    with TableInfo<$NoteTypesTable, NoteType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $NoteTypesTable createAlias(String alias) {
    return $NoteTypesTable(attachedDatabase, alias);
  }
}

class NoteType extends DataClass implements Insertable<NoteType> {
  final int id;
  final String name;
  const NoteType({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  NoteTypesCompanion toCompanion(bool nullToAbsent) {
    return NoteTypesCompanion(id: Value(id), name: Value(name));
  }

  factory NoteType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  NoteType copyWith({int? id, String? name}) =>
      NoteType(id: id ?? this.id, name: name ?? this.name);
  NoteType copyWithCompanion(NoteTypesCompanion data) {
    return NoteType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteType(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteType && other.id == this.id && other.name == this.name);
}

class NoteTypesCompanion extends UpdateCompanion<NoteType> {
  final Value<int> id;
  final Value<String> name;
  const NoteTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  NoteTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<NoteType> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  NoteTypesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return NoteTypesCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $FieldsTable extends Fields with TableInfo<$FieldsTable, NoteField> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteTypeIdMeta = const VerificationMeta(
    'noteTypeId',
  );
  @override
  late final GeneratedColumn<int> noteTypeId = GeneratedColumn<int>(
    'note_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES note_types (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  @override
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
    'ord',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, noteTypeId, name, ord];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteField> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_type_id')) {
      context.handle(
        _noteTypeIdMeta,
        noteTypeId.isAcceptableOrUnknown(
          data['note_type_id']!,
          _noteTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_noteTypeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ord')) {
      context.handle(
        _ordMeta,
        ord.isAcceptableOrUnknown(data['ord']!, _ordMeta),
      );
    } else if (isInserting) {
      context.missing(_ordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteField map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteField(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}note_type_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ord: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ord'],
      )!,
    );
  }

  @override
  $FieldsTable createAlias(String alias) {
    return $FieldsTable(attachedDatabase, alias);
  }
}

class NoteField extends DataClass implements Insertable<NoteField> {
  final int id;
  final int noteTypeId;
  final String name;

  /// Display/storage order among this note type's fields.
  final int ord;
  const NoteField({
    required this.id,
    required this.noteTypeId,
    required this.name,
    required this.ord,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_type_id'] = Variable<int>(noteTypeId);
    map['name'] = Variable<String>(name);
    map['ord'] = Variable<int>(ord);
    return map;
  }

  FieldsCompanion toCompanion(bool nullToAbsent) {
    return FieldsCompanion(
      id: Value(id),
      noteTypeId: Value(noteTypeId),
      name: Value(name),
      ord: Value(ord),
    );
  }

  factory NoteField.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteField(
      id: serializer.fromJson<int>(json['id']),
      noteTypeId: serializer.fromJson<int>(json['noteTypeId']),
      name: serializer.fromJson<String>(json['name']),
      ord: serializer.fromJson<int>(json['ord']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteTypeId': serializer.toJson<int>(noteTypeId),
      'name': serializer.toJson<String>(name),
      'ord': serializer.toJson<int>(ord),
    };
  }

  NoteField copyWith({int? id, int? noteTypeId, String? name, int? ord}) =>
      NoteField(
        id: id ?? this.id,
        noteTypeId: noteTypeId ?? this.noteTypeId,
        name: name ?? this.name,
        ord: ord ?? this.ord,
      );
  NoteField copyWithCompanion(FieldsCompanion data) {
    return NoteField(
      id: data.id.present ? data.id.value : this.id,
      noteTypeId: data.noteTypeId.present
          ? data.noteTypeId.value
          : this.noteTypeId,
      name: data.name.present ? data.name.value : this.name,
      ord: data.ord.present ? data.ord.value : this.ord,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteField(')
          ..write('id: $id, ')
          ..write('noteTypeId: $noteTypeId, ')
          ..write('name: $name, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteTypeId, name, ord);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteField &&
          other.id == this.id &&
          other.noteTypeId == this.noteTypeId &&
          other.name == this.name &&
          other.ord == this.ord);
}

class FieldsCompanion extends UpdateCompanion<NoteField> {
  final Value<int> id;
  final Value<int> noteTypeId;
  final Value<String> name;
  final Value<int> ord;
  const FieldsCompanion({
    this.id = const Value.absent(),
    this.noteTypeId = const Value.absent(),
    this.name = const Value.absent(),
    this.ord = const Value.absent(),
  });
  FieldsCompanion.insert({
    this.id = const Value.absent(),
    required int noteTypeId,
    required String name,
    required int ord,
  }) : noteTypeId = Value(noteTypeId),
       name = Value(name),
       ord = Value(ord);
  static Insertable<NoteField> custom({
    Expression<int>? id,
    Expression<int>? noteTypeId,
    Expression<String>? name,
    Expression<int>? ord,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteTypeId != null) 'note_type_id': noteTypeId,
      if (name != null) 'name': name,
      if (ord != null) 'ord': ord,
    });
  }

  FieldsCompanion copyWith({
    Value<int>? id,
    Value<int>? noteTypeId,
    Value<String>? name,
    Value<int>? ord,
  }) {
    return FieldsCompanion(
      id: id ?? this.id,
      noteTypeId: noteTypeId ?? this.noteTypeId,
      name: name ?? this.name,
      ord: ord ?? this.ord,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteTypeId.present) {
      map['note_type_id'] = Variable<int>(noteTypeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldsCompanion(')
          ..write('id: $id, ')
          ..write('noteTypeId: $noteTypeId, ')
          ..write('name: $name, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, CardTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteTypeIdMeta = const VerificationMeta(
    'noteTypeId',
  );
  @override
  late final GeneratedColumn<int> noteTypeId = GeneratedColumn<int>(
    'note_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES note_types (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frontMeta = const VerificationMeta('front');
  @override
  late final GeneratedColumn<String> front = GeneratedColumn<String>(
    'front',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backMeta = const VerificationMeta('back');
  @override
  late final GeneratedColumn<String> back = GeneratedColumn<String>(
    'back',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cssMeta = const VerificationMeta('css');
  @override
  late final GeneratedColumn<String> css = GeneratedColumn<String>(
    'css',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  @override
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
    'ord',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteTypeId,
    name,
    front,
    back,
    css,
    ord,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_type_id')) {
      context.handle(
        _noteTypeIdMeta,
        noteTypeId.isAcceptableOrUnknown(
          data['note_type_id']!,
          _noteTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_noteTypeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('front')) {
      context.handle(
        _frontMeta,
        front.isAcceptableOrUnknown(data['front']!, _frontMeta),
      );
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
        _backMeta,
        back.isAcceptableOrUnknown(data['back']!, _backMeta),
      );
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('css')) {
      context.handle(
        _cssMeta,
        css.isAcceptableOrUnknown(data['css']!, _cssMeta),
      );
    }
    if (data.containsKey('ord')) {
      context.handle(
        _ordMeta,
        ord.isAcceptableOrUnknown(data['ord']!, _ordMeta),
      );
    } else if (isInserting) {
      context.missing(_ordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}note_type_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      front: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front'],
      )!,
      back: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back'],
      )!,
      css: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}css'],
      )!,
      ord: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ord'],
      )!,
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }
}

class CardTemplate extends DataClass implements Insertable<CardTemplate> {
  final int id;
  final int noteTypeId;
  final String name;
  final String front;
  final String back;
  final String css;

  /// Order among this note type's templates; a [Cards.templateOrd] of `n`
  /// renders using the template with `ord == n` (except for Cloze note
  /// types, which have a single template and reinterpret `templateOrd` as
  /// the cloze deletion number).
  final int ord;
  const CardTemplate({
    required this.id,
    required this.noteTypeId,
    required this.name,
    required this.front,
    required this.back,
    required this.css,
    required this.ord,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_type_id'] = Variable<int>(noteTypeId);
    map['name'] = Variable<String>(name);
    map['front'] = Variable<String>(front);
    map['back'] = Variable<String>(back);
    map['css'] = Variable<String>(css);
    map['ord'] = Variable<int>(ord);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      noteTypeId: Value(noteTypeId),
      name: Value(name),
      front: Value(front),
      back: Value(back),
      css: Value(css),
      ord: Value(ord),
    );
  }

  factory CardTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardTemplate(
      id: serializer.fromJson<int>(json['id']),
      noteTypeId: serializer.fromJson<int>(json['noteTypeId']),
      name: serializer.fromJson<String>(json['name']),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      css: serializer.fromJson<String>(json['css']),
      ord: serializer.fromJson<int>(json['ord']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteTypeId': serializer.toJson<int>(noteTypeId),
      'name': serializer.toJson<String>(name),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'css': serializer.toJson<String>(css),
      'ord': serializer.toJson<int>(ord),
    };
  }

  CardTemplate copyWith({
    int? id,
    int? noteTypeId,
    String? name,
    String? front,
    String? back,
    String? css,
    int? ord,
  }) => CardTemplate(
    id: id ?? this.id,
    noteTypeId: noteTypeId ?? this.noteTypeId,
    name: name ?? this.name,
    front: front ?? this.front,
    back: back ?? this.back,
    css: css ?? this.css,
    ord: ord ?? this.ord,
  );
  CardTemplate copyWithCompanion(TemplatesCompanion data) {
    return CardTemplate(
      id: data.id.present ? data.id.value : this.id,
      noteTypeId: data.noteTypeId.present
          ? data.noteTypeId.value
          : this.noteTypeId,
      name: data.name.present ? data.name.value : this.name,
      front: data.front.present ? data.front.value : this.front,
      back: data.back.present ? data.back.value : this.back,
      css: data.css.present ? data.css.value : this.css,
      ord: data.ord.present ? data.ord.value : this.ord,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardTemplate(')
          ..write('id: $id, ')
          ..write('noteTypeId: $noteTypeId, ')
          ..write('name: $name, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('css: $css, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteTypeId, name, front, back, css, ord);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardTemplate &&
          other.id == this.id &&
          other.noteTypeId == this.noteTypeId &&
          other.name == this.name &&
          other.front == this.front &&
          other.back == this.back &&
          other.css == this.css &&
          other.ord == this.ord);
}

class TemplatesCompanion extends UpdateCompanion<CardTemplate> {
  final Value<int> id;
  final Value<int> noteTypeId;
  final Value<String> name;
  final Value<String> front;
  final Value<String> back;
  final Value<String> css;
  final Value<int> ord;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.noteTypeId = const Value.absent(),
    this.name = const Value.absent(),
    this.front = const Value.absent(),
    this.back = const Value.absent(),
    this.css = const Value.absent(),
    this.ord = const Value.absent(),
  });
  TemplatesCompanion.insert({
    this.id = const Value.absent(),
    required int noteTypeId,
    required String name,
    required String front,
    required String back,
    this.css = const Value.absent(),
    required int ord,
  }) : noteTypeId = Value(noteTypeId),
       name = Value(name),
       front = Value(front),
       back = Value(back),
       ord = Value(ord);
  static Insertable<CardTemplate> custom({
    Expression<int>? id,
    Expression<int>? noteTypeId,
    Expression<String>? name,
    Expression<String>? front,
    Expression<String>? back,
    Expression<String>? css,
    Expression<int>? ord,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteTypeId != null) 'note_type_id': noteTypeId,
      if (name != null) 'name': name,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (css != null) 'css': css,
      if (ord != null) 'ord': ord,
    });
  }

  TemplatesCompanion copyWith({
    Value<int>? id,
    Value<int>? noteTypeId,
    Value<String>? name,
    Value<String>? front,
    Value<String>? back,
    Value<String>? css,
    Value<int>? ord,
  }) {
    return TemplatesCompanion(
      id: id ?? this.id,
      noteTypeId: noteTypeId ?? this.noteTypeId,
      name: name ?? this.name,
      front: front ?? this.front,
      back: back ?? this.back,
      css: css ?? this.css,
      ord: ord ?? this.ord,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteTypeId.present) {
      map['note_type_id'] = Variable<int>(noteTypeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (front.present) {
      map['front'] = Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = Variable<String>(back.value);
    }
    if (css.present) {
      map['css'] = Variable<String>(css.value);
    }
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('noteTypeId: $noteTypeId, ')
          ..write('name: $name, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('css: $css, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteTypeIdMeta = const VerificationMeta(
    'noteTypeId',
  );
  @override
  late final GeneratedColumn<int> noteTypeId = GeneratedColumn<int>(
    'note_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES note_types (id)',
    ),
  );
  static const VerificationMeta _fieldValuesMeta = const VerificationMeta(
    'fieldValues',
  );
  @override
  late final GeneratedColumn<String> fieldValues = GeneratedColumn<String>(
    'field_values',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(' '),
  );
  static const VerificationMeta _firstFieldHashMeta = const VerificationMeta(
    'firstFieldHash',
  );
  @override
  late final GeneratedColumn<String> firstFieldHash = GeneratedColumn<String>(
    'first_field_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteTypeId,
    fieldValues,
    tags,
    firstFieldHash,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_type_id')) {
      context.handle(
        _noteTypeIdMeta,
        noteTypeId.isAcceptableOrUnknown(
          data['note_type_id']!,
          _noteTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_noteTypeIdMeta);
    }
    if (data.containsKey('field_values')) {
      context.handle(
        _fieldValuesMeta,
        fieldValues.isAcceptableOrUnknown(
          data['field_values']!,
          _fieldValuesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldValuesMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('first_field_hash')) {
      context.handle(
        _firstFieldHashMeta,
        firstFieldHash.isAcceptableOrUnknown(
          data['first_field_hash']!,
          _firstFieldHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstFieldHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}note_type_id'],
      )!,
      fieldValues: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_values'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      firstFieldHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_field_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final int noteTypeId;

  /// JSON-encoded `List<String>`, ordered to match this note type's
  /// [Fields.ord].
  final String fieldValues;

  /// Space-separated tags, padded with a leading/trailing space (Anki's
  /// convention), so a tag can be matched with a simple `LIKE '% tag %'`.
  final String tags;

  /// Hash of the first field's value, scoped to a note type, used to detect
  /// duplicate notes on creation/import.
  final String firstFieldHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Note({
    required this.id,
    required this.noteTypeId,
    required this.fieldValues,
    required this.tags,
    required this.firstFieldHash,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_type_id'] = Variable<int>(noteTypeId);
    map['field_values'] = Variable<String>(fieldValues);
    map['tags'] = Variable<String>(tags);
    map['first_field_hash'] = Variable<String>(firstFieldHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      noteTypeId: Value(noteTypeId),
      fieldValues: Value(fieldValues),
      tags: Value(tags),
      firstFieldHash: Value(firstFieldHash),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      noteTypeId: serializer.fromJson<int>(json['noteTypeId']),
      fieldValues: serializer.fromJson<String>(json['fieldValues']),
      tags: serializer.fromJson<String>(json['tags']),
      firstFieldHash: serializer.fromJson<String>(json['firstFieldHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteTypeId': serializer.toJson<int>(noteTypeId),
      'fieldValues': serializer.toJson<String>(fieldValues),
      'tags': serializer.toJson<String>(tags),
      'firstFieldHash': serializer.toJson<String>(firstFieldHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({
    int? id,
    int? noteTypeId,
    String? fieldValues,
    String? tags,
    String? firstFieldHash,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Note(
    id: id ?? this.id,
    noteTypeId: noteTypeId ?? this.noteTypeId,
    fieldValues: fieldValues ?? this.fieldValues,
    tags: tags ?? this.tags,
    firstFieldHash: firstFieldHash ?? this.firstFieldHash,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      noteTypeId: data.noteTypeId.present
          ? data.noteTypeId.value
          : this.noteTypeId,
      fieldValues: data.fieldValues.present
          ? data.fieldValues.value
          : this.fieldValues,
      tags: data.tags.present ? data.tags.value : this.tags,
      firstFieldHash: data.firstFieldHash.present
          ? data.firstFieldHash.value
          : this.firstFieldHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('noteTypeId: $noteTypeId, ')
          ..write('fieldValues: $fieldValues, ')
          ..write('tags: $tags, ')
          ..write('firstFieldHash: $firstFieldHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    noteTypeId,
    fieldValues,
    tags,
    firstFieldHash,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.noteTypeId == this.noteTypeId &&
          other.fieldValues == this.fieldValues &&
          other.tags == this.tags &&
          other.firstFieldHash == this.firstFieldHash &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<int> noteTypeId;
  final Value<String> fieldValues;
  final Value<String> tags;
  final Value<String> firstFieldHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.noteTypeId = const Value.absent(),
    this.fieldValues = const Value.absent(),
    this.tags = const Value.absent(),
    this.firstFieldHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required int noteTypeId,
    required String fieldValues,
    this.tags = const Value.absent(),
    required String firstFieldHash,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : noteTypeId = Value(noteTypeId),
       fieldValues = Value(fieldValues),
       firstFieldHash = Value(firstFieldHash);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<int>? noteTypeId,
    Expression<String>? fieldValues,
    Expression<String>? tags,
    Expression<String>? firstFieldHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteTypeId != null) 'note_type_id': noteTypeId,
      if (fieldValues != null) 'field_values': fieldValues,
      if (tags != null) 'tags': tags,
      if (firstFieldHash != null) 'first_field_hash': firstFieldHash,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<int>? noteTypeId,
    Value<String>? fieldValues,
    Value<String>? tags,
    Value<String>? firstFieldHash,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      noteTypeId: noteTypeId ?? this.noteTypeId,
      fieldValues: fieldValues ?? this.fieldValues,
      tags: tags ?? this.tags,
      firstFieldHash: firstFieldHash ?? this.firstFieldHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteTypeId.present) {
      map['note_type_id'] = Variable<int>(noteTypeId.value);
    }
    if (fieldValues.present) {
      map['field_values'] = Variable<String>(fieldValues.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (firstFieldHash.present) {
      map['first_field_hash'] = Variable<String>(firstFieldHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('noteTypeId: $noteTypeId, ')
          ..write('fieldValues: $fieldValues, ')
          ..write('tags: $tags, ')
          ..write('firstFieldHash: $firstFieldHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, StudyCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<int> noteId = GeneratedColumn<int>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id)',
    ),
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<int> deckId = GeneratedColumn<int>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES decks (id)',
    ),
  );
  static const VerificationMeta _templateOrdMeta = const VerificationMeta(
    'templateOrd',
  );
  @override
  late final GeneratedColumn<int> templateOrd = GeneratedColumn<int>(
    'template_ord',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CardQueue, String> queue =
      GeneratedColumn<String>(
        'queue',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CardQueue>($CardsTable.$converterqueue);
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<int> due = GeneratedColumn<int>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _flagMeta = const VerificationMeta('flag');
  @override
  late final GeneratedColumn<int> flag = GeneratedColumn<int>(
    'flag',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteId,
    deckId,
    templateOrd,
    queue,
    due,
    stability,
    difficulty,
    lapses,
    reps,
    flag,
    createdAt,
    lastReviewedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('template_ord')) {
      context.handle(
        _templateOrdMeta,
        templateOrd.isAcceptableOrUnknown(
          data['template_ord']!,
          _templateOrdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateOrdMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('flag')) {
      context.handle(
        _flagMeta,
        flag.isAcceptableOrUnknown(data['flag']!, _flagMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}note_id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_id'],
      )!,
      templateOrd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_ord'],
      )!,
      queue: $CardsTable.$converterqueue.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}queue'],
        )!,
      ),
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      ),
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      flag: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flag'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CardQueue, String, String> $converterqueue =
      const EnumNameConverter<CardQueue>(CardQueue.values);
}

class StudyCard extends DataClass implements Insertable<StudyCard> {
  final int id;
  final int noteId;
  final int deckId;
  final int templateOrd;
  final CardQueue queue;

  /// Meaning depends on [queue]: a day number for `review`/`newCard`, or a
  /// Unix timestamp (seconds) while in `learning`/`relearning`.
  final int due;
  final double? stability;
  final double? difficulty;
  final int lapses;
  final int reps;

  /// `0` = no flag, `1`-`7` = one of Anki's seven flag colors.
  final int flag;
  final DateTime createdAt;

  /// When this card was last graded, `null` if it never has been — the
  /// FSRS engine needs this to compute elapsed time for the next review.
  final DateTime? lastReviewedAt;

  /// When this card was moved to the trash, `null` if it isn't there.
  /// A soft delete: the row (and its scheduling state) stays put so
  /// restoring is lossless, but it's excluded from review/browse queries.
  final DateTime? deletedAt;
  const StudyCard({
    required this.id,
    required this.noteId,
    required this.deckId,
    required this.templateOrd,
    required this.queue,
    required this.due,
    this.stability,
    this.difficulty,
    required this.lapses,
    required this.reps,
    required this.flag,
    required this.createdAt,
    this.lastReviewedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_id'] = Variable<int>(noteId);
    map['deck_id'] = Variable<int>(deckId);
    map['template_ord'] = Variable<int>(templateOrd);
    {
      map['queue'] = Variable<String>($CardsTable.$converterqueue.toSql(queue));
    }
    map['due'] = Variable<int>(due);
    if (!nullToAbsent || stability != null) {
      map['stability'] = Variable<double>(stability);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<double>(difficulty);
    }
    map['lapses'] = Variable<int>(lapses);
    map['reps'] = Variable<int>(reps);
    map['flag'] = Variable<int>(flag);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      noteId: Value(noteId),
      deckId: Value(deckId),
      templateOrd: Value(templateOrd),
      queue: Value(queue),
      due: Value(due),
      stability: stability == null && nullToAbsent
          ? const Value.absent()
          : Value(stability),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      lapses: Value(lapses),
      reps: Value(reps),
      flag: Value(flag),
      createdAt: Value(createdAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory StudyCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyCard(
      id: serializer.fromJson<int>(json['id']),
      noteId: serializer.fromJson<int>(json['noteId']),
      deckId: serializer.fromJson<int>(json['deckId']),
      templateOrd: serializer.fromJson<int>(json['templateOrd']),
      queue: $CardsTable.$converterqueue.fromJson(
        serializer.fromJson<String>(json['queue']),
      ),
      due: serializer.fromJson<int>(json['due']),
      stability: serializer.fromJson<double?>(json['stability']),
      difficulty: serializer.fromJson<double?>(json['difficulty']),
      lapses: serializer.fromJson<int>(json['lapses']),
      reps: serializer.fromJson<int>(json['reps']),
      flag: serializer.fromJson<int>(json['flag']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteId': serializer.toJson<int>(noteId),
      'deckId': serializer.toJson<int>(deckId),
      'templateOrd': serializer.toJson<int>(templateOrd),
      'queue': serializer.toJson<String>(
        $CardsTable.$converterqueue.toJson(queue),
      ),
      'due': serializer.toJson<int>(due),
      'stability': serializer.toJson<double?>(stability),
      'difficulty': serializer.toJson<double?>(difficulty),
      'lapses': serializer.toJson<int>(lapses),
      'reps': serializer.toJson<int>(reps),
      'flag': serializer.toJson<int>(flag),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  StudyCard copyWith({
    int? id,
    int? noteId,
    int? deckId,
    int? templateOrd,
    CardQueue? queue,
    int? due,
    Value<double?> stability = const Value.absent(),
    Value<double?> difficulty = const Value.absent(),
    int? lapses,
    int? reps,
    int? flag,
    DateTime? createdAt,
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => StudyCard(
    id: id ?? this.id,
    noteId: noteId ?? this.noteId,
    deckId: deckId ?? this.deckId,
    templateOrd: templateOrd ?? this.templateOrd,
    queue: queue ?? this.queue,
    due: due ?? this.due,
    stability: stability.present ? stability.value : this.stability,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    lapses: lapses ?? this.lapses,
    reps: reps ?? this.reps,
    flag: flag ?? this.flag,
    createdAt: createdAt ?? this.createdAt,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  StudyCard copyWithCompanion(CardsCompanion data) {
    return StudyCard(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      templateOrd: data.templateOrd.present
          ? data.templateOrd.value
          : this.templateOrd,
      queue: data.queue.present ? data.queue.value : this.queue,
      due: data.due.present ? data.due.value : this.due,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      reps: data.reps.present ? data.reps.value : this.reps,
      flag: data.flag.present ? data.flag.value : this.flag,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyCard(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('deckId: $deckId, ')
          ..write('templateOrd: $templateOrd, ')
          ..write('queue: $queue, ')
          ..write('due: $due, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('lapses: $lapses, ')
          ..write('reps: $reps, ')
          ..write('flag: $flag, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    noteId,
    deckId,
    templateOrd,
    queue,
    due,
    stability,
    difficulty,
    lapses,
    reps,
    flag,
    createdAt,
    lastReviewedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyCard &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.deckId == this.deckId &&
          other.templateOrd == this.templateOrd &&
          other.queue == this.queue &&
          other.due == this.due &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.lapses == this.lapses &&
          other.reps == this.reps &&
          other.flag == this.flag &&
          other.createdAt == this.createdAt &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.deletedAt == this.deletedAt);
}

class CardsCompanion extends UpdateCompanion<StudyCard> {
  final Value<int> id;
  final Value<int> noteId;
  final Value<int> deckId;
  final Value<int> templateOrd;
  final Value<CardQueue> queue;
  final Value<int> due;
  final Value<double?> stability;
  final Value<double?> difficulty;
  final Value<int> lapses;
  final Value<int> reps;
  final Value<int> flag;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime?> deletedAt;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.deckId = const Value.absent(),
    this.templateOrd = const Value.absent(),
    this.queue = const Value.absent(),
    this.due = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.lapses = const Value.absent(),
    this.reps = const Value.absent(),
    this.flag = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required int noteId,
    required int deckId,
    required int templateOrd,
    required CardQueue queue,
    required int due,
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.lapses = const Value.absent(),
    this.reps = const Value.absent(),
    this.flag = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : noteId = Value(noteId),
       deckId = Value(deckId),
       templateOrd = Value(templateOrd),
       queue = Value(queue),
       due = Value(due);
  static Insertable<StudyCard> custom({
    Expression<int>? id,
    Expression<int>? noteId,
    Expression<int>? deckId,
    Expression<int>? templateOrd,
    Expression<String>? queue,
    Expression<int>? due,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<int>? lapses,
    Expression<int>? reps,
    Expression<int>? flag,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (deckId != null) 'deck_id': deckId,
      if (templateOrd != null) 'template_ord': templateOrd,
      if (queue != null) 'queue': queue,
      if (due != null) 'due': due,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (lapses != null) 'lapses': lapses,
      if (reps != null) 'reps': reps,
      if (flag != null) 'flag': flag,
      if (createdAt != null) 'created_at': createdAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  CardsCompanion copyWith({
    Value<int>? id,
    Value<int>? noteId,
    Value<int>? deckId,
    Value<int>? templateOrd,
    Value<CardQueue>? queue,
    Value<int>? due,
    Value<double?>? stability,
    Value<double?>? difficulty,
    Value<int>? lapses,
    Value<int>? reps,
    Value<int>? flag,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastReviewedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      deckId: deckId ?? this.deckId,
      templateOrd: templateOrd ?? this.templateOrd,
      queue: queue ?? this.queue,
      due: due ?? this.due,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      lapses: lapses ?? this.lapses,
      reps: reps ?? this.reps,
      flag: flag ?? this.flag,
      createdAt: createdAt ?? this.createdAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<int>(noteId.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<int>(deckId.value);
    }
    if (templateOrd.present) {
      map['template_ord'] = Variable<int>(templateOrd.value);
    }
    if (queue.present) {
      map['queue'] = Variable<String>(
        $CardsTable.$converterqueue.toSql(queue.value),
      );
    }
    if (due.present) {
      map['due'] = Variable<int>(due.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (flag.present) {
      map['flag'] = Variable<int>(flag.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('deckId: $deckId, ')
          ..write('templateOrd: $templateOrd, ')
          ..write('queue: $queue, ')
          ..write('due: $due, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('lapses: $lapses, ')
          ..write('reps: $reps, ')
          ..write('flag: $flag, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogTable extends ReviewLog
    with TableInfo<$ReviewLogTable, ReviewLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReviewRating, String> rating =
      GeneratedColumn<String>(
        'rating',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReviewRating>($ReviewLogTable.$converterrating);
  static const VerificationMeta _elapsedDaysMeta = const VerificationMeta(
    'elapsedDays',
  );
  @override
  late final GeneratedColumn<double> elapsedDays = GeneratedColumn<double>(
    'elapsed_days',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDaysMeta = const VerificationMeta(
    'scheduledDays',
  );
  @override
  late final GeneratedColumn<double> scheduledDays = GeneratedColumn<double>(
    'scheduled_days',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReviewCardState, String> state =
      GeneratedColumn<String>(
        'state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReviewCardState>($ReviewLogTable.$converterstate);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    reviewedAt,
    rating,
    elapsedDays,
    scheduledDays,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    }
    if (data.containsKey('elapsed_days')) {
      context.handle(
        _elapsedDaysMeta,
        elapsedDays.isAcceptableOrUnknown(
          data['elapsed_days']!,
          _elapsedDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedDaysMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
        _scheduledDaysMeta,
        scheduledDays.isAcceptableOrUnknown(
          data['scheduled_days']!,
          _scheduledDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
      rating: $ReviewLogTable.$converterrating.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rating'],
        )!,
      ),
      elapsedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elapsed_days'],
      )!,
      scheduledDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scheduled_days'],
      )!,
      state: $ReviewLogTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}state'],
        )!,
      ),
    );
  }

  @override
  $ReviewLogTable createAlias(String alias) {
    return $ReviewLogTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReviewRating, String, String> $converterrating =
      const EnumNameConverter<ReviewRating>(ReviewRating.values);
  static JsonTypeConverter2<ReviewCardState, String, String> $converterstate =
      const EnumNameConverter<ReviewCardState>(ReviewCardState.values);
}

class ReviewLogEntry extends DataClass implements Insertable<ReviewLogEntry> {
  final int id;
  final int cardId;
  final DateTime reviewedAt;
  final ReviewRating rating;
  final double elapsedDays;
  final double scheduledDays;
  final ReviewCardState state;
  const ReviewLogEntry({
    required this.id,
    required this.cardId,
    required this.reviewedAt,
    required this.rating,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    {
      map['rating'] = Variable<String>(
        $ReviewLogTable.$converterrating.toSql(rating),
      );
    }
    map['elapsed_days'] = Variable<double>(elapsedDays);
    map['scheduled_days'] = Variable<double>(scheduledDays);
    {
      map['state'] = Variable<String>(
        $ReviewLogTable.$converterstate.toSql(state),
      );
    }
    return map;
  }

  ReviewLogCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogCompanion(
      id: Value(id),
      cardId: Value(cardId),
      reviewedAt: Value(reviewedAt),
      rating: Value(rating),
      elapsedDays: Value(elapsedDays),
      scheduledDays: Value(scheduledDays),
      state: Value(state),
    );
  }

  factory ReviewLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLogEntry(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
      rating: $ReviewLogTable.$converterrating.fromJson(
        serializer.fromJson<String>(json['rating']),
      ),
      elapsedDays: serializer.fromJson<double>(json['elapsedDays']),
      scheduledDays: serializer.fromJson<double>(json['scheduledDays']),
      state: $ReviewLogTable.$converterstate.fromJson(
        serializer.fromJson<String>(json['state']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
      'rating': serializer.toJson<String>(
        $ReviewLogTable.$converterrating.toJson(rating),
      ),
      'elapsedDays': serializer.toJson<double>(elapsedDays),
      'scheduledDays': serializer.toJson<double>(scheduledDays),
      'state': serializer.toJson<String>(
        $ReviewLogTable.$converterstate.toJson(state),
      ),
    };
  }

  ReviewLogEntry copyWith({
    int? id,
    int? cardId,
    DateTime? reviewedAt,
    ReviewRating? rating,
    double? elapsedDays,
    double? scheduledDays,
    ReviewCardState? state,
  }) => ReviewLogEntry(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    rating: rating ?? this.rating,
    elapsedDays: elapsedDays ?? this.elapsedDays,
    scheduledDays: scheduledDays ?? this.scheduledDays,
    state: state ?? this.state,
  );
  ReviewLogEntry copyWithCompanion(ReviewLogCompanion data) {
    return ReviewLogEntry(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      rating: data.rating.present ? data.rating.value : this.rating,
      elapsedDays: data.elapsedDays.present
          ? data.elapsedDays.value
          : this.elapsedDays,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogEntry(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('rating: $rating, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    reviewedAt,
    rating,
    elapsedDays,
    scheduledDays,
    state,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLogEntry &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.reviewedAt == this.reviewedAt &&
          other.rating == this.rating &&
          other.elapsedDays == this.elapsedDays &&
          other.scheduledDays == this.scheduledDays &&
          other.state == this.state);
}

class ReviewLogCompanion extends UpdateCompanion<ReviewLogEntry> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<DateTime> reviewedAt;
  final Value<ReviewRating> rating;
  final Value<double> elapsedDays;
  final Value<double> scheduledDays;
  final Value<ReviewCardState> state;
  const ReviewLogCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.rating = const Value.absent(),
    this.elapsedDays = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.state = const Value.absent(),
  });
  ReviewLogCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    this.reviewedAt = const Value.absent(),
    required ReviewRating rating,
    required double elapsedDays,
    required double scheduledDays,
    required ReviewCardState state,
  }) : cardId = Value(cardId),
       rating = Value(rating),
       elapsedDays = Value(elapsedDays),
       scheduledDays = Value(scheduledDays),
       state = Value(state);
  static Insertable<ReviewLogEntry> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<DateTime>? reviewedAt,
    Expression<String>? rating,
    Expression<double>? elapsedDays,
    Expression<double>? scheduledDays,
    Expression<String>? state,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (rating != null) 'rating': rating,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (state != null) 'state': state,
    });
  }

  ReviewLogCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<DateTime>? reviewedAt,
    Value<ReviewRating>? rating,
    Value<double>? elapsedDays,
    Value<double>? scheduledDays,
    Value<ReviewCardState>? state,
  }) {
    return ReviewLogCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rating: rating ?? this.rating,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      state: state ?? this.state,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (rating.present) {
      map['rating'] = Variable<String>(
        $ReviewLogTable.$converterrating.toSql(rating.value),
      );
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = Variable<double>(elapsedDays.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<double>(scheduledDays.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(
        $ReviewLogTable.$converterstate.toSql(state.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('rating: $rating, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

class $MediaTable extends Media with TableInfo<$MediaTable, MediaFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refCountMeta = const VerificationMeta(
    'refCount',
  );
  @override
  late final GeneratedColumn<int> refCount = GeneratedColumn<int>(
    'ref_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [hash, filename, refCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('ref_count')) {
      context.handle(
        _refCountMeta,
        refCount.isAcceptableOrUnknown(data['ref_count']!, _refCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hash};
  @override
  MediaFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFile(
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      refCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ref_count'],
      )!,
    );
  }

  @override
  $MediaTable createAlias(String alias) {
    return $MediaTable(attachedDatabase, alias);
  }
}

class MediaFile extends DataClass implements Insertable<MediaFile> {
  final String hash;
  final String filename;
  final int refCount;
  const MediaFile({
    required this.hash,
    required this.filename,
    required this.refCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['hash'] = Variable<String>(hash);
    map['filename'] = Variable<String>(filename);
    map['ref_count'] = Variable<int>(refCount);
    return map;
  }

  MediaCompanion toCompanion(bool nullToAbsent) {
    return MediaCompanion(
      hash: Value(hash),
      filename: Value(filename),
      refCount: Value(refCount),
    );
  }

  factory MediaFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFile(
      hash: serializer.fromJson<String>(json['hash']),
      filename: serializer.fromJson<String>(json['filename']),
      refCount: serializer.fromJson<int>(json['refCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hash': serializer.toJson<String>(hash),
      'filename': serializer.toJson<String>(filename),
      'refCount': serializer.toJson<int>(refCount),
    };
  }

  MediaFile copyWith({String? hash, String? filename, int? refCount}) =>
      MediaFile(
        hash: hash ?? this.hash,
        filename: filename ?? this.filename,
        refCount: refCount ?? this.refCount,
      );
  MediaFile copyWithCompanion(MediaCompanion data) {
    return MediaFile(
      hash: data.hash.present ? data.hash.value : this.hash,
      filename: data.filename.present ? data.filename.value : this.filename,
      refCount: data.refCount.present ? data.refCount.value : this.refCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFile(')
          ..write('hash: $hash, ')
          ..write('filename: $filename, ')
          ..write('refCount: $refCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(hash, filename, refCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFile &&
          other.hash == this.hash &&
          other.filename == this.filename &&
          other.refCount == this.refCount);
}

class MediaCompanion extends UpdateCompanion<MediaFile> {
  final Value<String> hash;
  final Value<String> filename;
  final Value<int> refCount;
  final Value<int> rowid;
  const MediaCompanion({
    this.hash = const Value.absent(),
    this.filename = const Value.absent(),
    this.refCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaCompanion.insert({
    required String hash,
    required String filename,
    this.refCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : hash = Value(hash),
       filename = Value(filename);
  static Insertable<MediaFile> custom({
    Expression<String>? hash,
    Expression<String>? filename,
    Expression<int>? refCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hash != null) 'hash': hash,
      if (filename != null) 'filename': filename,
      if (refCount != null) 'ref_count': refCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaCompanion copyWith({
    Value<String>? hash,
    Value<String>? filename,
    Value<int>? refCount,
    Value<int>? rowid,
  }) {
    return MediaCompanion(
      hash: hash ?? this.hash,
      filename: filename ?? this.filename,
      refCount: refCount ?? this.refCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (refCount.present) {
      map['ref_count'] = Variable<int>(refCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaCompanion(')
          ..write('hash: $hash, ')
          ..write('filename: $filename, ')
          ..write('refCount: $refCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, AppSettings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, String> themeMode =
      GeneratedColumn<String>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(AppThemeMode.system.name),
      ).withConverter<AppThemeMode>($SettingsTable.$converterthemeMode);
  static const VerificationMeta _accentColorMeta = const VerificationMeta(
    'accentColor',
  );
  @override
  late final GeneratedColumn<int> accentColor = GeneratedColumn<int>(
    'accent_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardFontScaleMeta = const VerificationMeta(
    'cardFontScale',
  );
  @override
  late final GeneratedColumn<double> cardFontScale = GeneratedColumn<double>(
    'card_font_scale',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _cardFontFamilyMeta = const VerificationMeta(
    'cardFontFamily',
  );
  @override
  late final GeneratedColumn<String> cardFontFamily = GeneratedColumn<String>(
    'card_font_family',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerButtonCountMeta = const VerificationMeta(
    'answerButtonCount',
  );
  @override
  late final GeneratedColumn<int> answerButtonCount = GeneratedColumn<int>(
    'answer_button_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _reducedMotionMeta = const VerificationMeta(
    'reducedMotion',
  );
  @override
  late final GeneratedColumn<bool> reducedMotion = GeneratedColumn<bool>(
    'reduced_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduced_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoBackupEnabledMeta = const VerificationMeta(
    'autoBackupEnabled',
  );
  @override
  late final GeneratedColumn<bool> autoBackupEnabled = GeneratedColumn<bool>(
    'auto_backup_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_backup_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    accentColor,
    cardFontScale,
    cardFontFamily,
    answerButtonCount,
    reducedMotion,
    autoBackupEnabled,
    onboardingCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettings> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('accent_color')) {
      context.handle(
        _accentColorMeta,
        accentColor.isAcceptableOrUnknown(
          data['accent_color']!,
          _accentColorMeta,
        ),
      );
    }
    if (data.containsKey('card_font_scale')) {
      context.handle(
        _cardFontScaleMeta,
        cardFontScale.isAcceptableOrUnknown(
          data['card_font_scale']!,
          _cardFontScaleMeta,
        ),
      );
    }
    if (data.containsKey('card_font_family')) {
      context.handle(
        _cardFontFamilyMeta,
        cardFontFamily.isAcceptableOrUnknown(
          data['card_font_family']!,
          _cardFontFamilyMeta,
        ),
      );
    }
    if (data.containsKey('answer_button_count')) {
      context.handle(
        _answerButtonCountMeta,
        answerButtonCount.isAcceptableOrUnknown(
          data['answer_button_count']!,
          _answerButtonCountMeta,
        ),
      );
    }
    if (data.containsKey('reduced_motion')) {
      context.handle(
        _reducedMotionMeta,
        reducedMotion.isAcceptableOrUnknown(
          data['reduced_motion']!,
          _reducedMotionMeta,
        ),
      );
    }
    if (data.containsKey('auto_backup_enabled')) {
      context.handle(
        _autoBackupEnabledMeta,
        autoBackupEnabled.isAcceptableOrUnknown(
          data['auto_backup_enabled']!,
          _autoBackupEnabledMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettings(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: $SettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      accentColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent_color'],
      ),
      cardFontScale: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}card_font_scale'],
      )!,
      cardFontFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_font_family'],
      ),
      answerButtonCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answer_button_count'],
      )!,
      reducedMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduced_motion'],
      )!,
      autoBackupEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_backup_enabled'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppThemeMode, String, String> $converterthemeMode =
      const EnumNameConverter<AppThemeMode>(AppThemeMode.values);
}

class AppSettings extends DataClass implements Insertable<AppSettings> {
  final int id;
  final AppThemeMode themeMode;

  /// ARGB value of a user-chosen accent color; `null` uses the app default.
  final int? accentColor;

  /// Multiplier applied to card templates' base font size, e.g. `1.25`.
  final double cardFontScale;

  /// A CSS `font-family` override for card rendering; `null` uses each
  /// template's own CSS.
  final String? cardFontFamily;

  /// How many grading buttons the review screen shows, `2`-`4`.
  final int answerButtonCount;
  final bool reducedMotion;
  final bool autoBackupEnabled;
  final bool onboardingCompleted;
  const AppSettings({
    required this.id,
    required this.themeMode,
    this.accentColor,
    required this.cardFontScale,
    this.cardFontFamily,
    required this.answerButtonCount,
    required this.reducedMotion,
    required this.autoBackupEnabled,
    required this.onboardingCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['theme_mode'] = Variable<String>(
        $SettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    if (!nullToAbsent || accentColor != null) {
      map['accent_color'] = Variable<int>(accentColor);
    }
    map['card_font_scale'] = Variable<double>(cardFontScale);
    if (!nullToAbsent || cardFontFamily != null) {
      map['card_font_family'] = Variable<String>(cardFontFamily);
    }
    map['answer_button_count'] = Variable<int>(answerButtonCount);
    map['reduced_motion'] = Variable<bool>(reducedMotion);
    map['auto_backup_enabled'] = Variable<bool>(autoBackupEnabled);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      accentColor: accentColor == null && nullToAbsent
          ? const Value.absent()
          : Value(accentColor),
      cardFontScale: Value(cardFontScale),
      cardFontFamily: cardFontFamily == null && nullToAbsent
          ? const Value.absent()
          : Value(cardFontFamily),
      answerButtonCount: Value(answerButtonCount),
      reducedMotion: Value(reducedMotion),
      autoBackupEnabled: Value(autoBackupEnabled),
      onboardingCompleted: Value(onboardingCompleted),
    );
  }

  factory AppSettings.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettings(
      id: serializer.fromJson<int>(json['id']),
      themeMode: $SettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<String>(json['themeMode']),
      ),
      accentColor: serializer.fromJson<int?>(json['accentColor']),
      cardFontScale: serializer.fromJson<double>(json['cardFontScale']),
      cardFontFamily: serializer.fromJson<String?>(json['cardFontFamily']),
      answerButtonCount: serializer.fromJson<int>(json['answerButtonCount']),
      reducedMotion: serializer.fromJson<bool>(json['reducedMotion']),
      autoBackupEnabled: serializer.fromJson<bool>(json['autoBackupEnabled']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(
        $SettingsTable.$converterthemeMode.toJson(themeMode),
      ),
      'accentColor': serializer.toJson<int?>(accentColor),
      'cardFontScale': serializer.toJson<double>(cardFontScale),
      'cardFontFamily': serializer.toJson<String?>(cardFontFamily),
      'answerButtonCount': serializer.toJson<int>(answerButtonCount),
      'reducedMotion': serializer.toJson<bool>(reducedMotion),
      'autoBackupEnabled': serializer.toJson<bool>(autoBackupEnabled),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
    };
  }

  AppSettings copyWith({
    int? id,
    AppThemeMode? themeMode,
    Value<int?> accentColor = const Value.absent(),
    double? cardFontScale,
    Value<String?> cardFontFamily = const Value.absent(),
    int? answerButtonCount,
    bool? reducedMotion,
    bool? autoBackupEnabled,
    bool? onboardingCompleted,
  }) => AppSettings(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    accentColor: accentColor.present ? accentColor.value : this.accentColor,
    cardFontScale: cardFontScale ?? this.cardFontScale,
    cardFontFamily: cardFontFamily.present
        ? cardFontFamily.value
        : this.cardFontFamily,
    answerButtonCount: answerButtonCount ?? this.answerButtonCount,
    reducedMotion: reducedMotion ?? this.reducedMotion,
    autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );
  AppSettings copyWithCompanion(SettingsCompanion data) {
    return AppSettings(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      accentColor: data.accentColor.present
          ? data.accentColor.value
          : this.accentColor,
      cardFontScale: data.cardFontScale.present
          ? data.cardFontScale.value
          : this.cardFontScale,
      cardFontFamily: data.cardFontFamily.present
          ? data.cardFontFamily.value
          : this.cardFontFamily,
      answerButtonCount: data.answerButtonCount.present
          ? data.answerButtonCount.value
          : this.answerButtonCount,
      reducedMotion: data.reducedMotion.present
          ? data.reducedMotion.value
          : this.reducedMotion,
      autoBackupEnabled: data.autoBackupEnabled.present
          ? data.autoBackupEnabled.value
          : this.autoBackupEnabled,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettings(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColor: $accentColor, ')
          ..write('cardFontScale: $cardFontScale, ')
          ..write('cardFontFamily: $cardFontFamily, ')
          ..write('answerButtonCount: $answerButtonCount, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('autoBackupEnabled: $autoBackupEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    accentColor,
    cardFontScale,
    cardFontFamily,
    answerButtonCount,
    reducedMotion,
    autoBackupEnabled,
    onboardingCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettings &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.accentColor == this.accentColor &&
          other.cardFontScale == this.cardFontScale &&
          other.cardFontFamily == this.cardFontFamily &&
          other.answerButtonCount == this.answerButtonCount &&
          other.reducedMotion == this.reducedMotion &&
          other.autoBackupEnabled == this.autoBackupEnabled &&
          other.onboardingCompleted == this.onboardingCompleted);
}

class SettingsCompanion extends UpdateCompanion<AppSettings> {
  final Value<int> id;
  final Value<AppThemeMode> themeMode;
  final Value<int?> accentColor;
  final Value<double> cardFontScale;
  final Value<String?> cardFontFamily;
  final Value<int> answerButtonCount;
  final Value<bool> reducedMotion;
  final Value<bool> autoBackupEnabled;
  final Value<bool> onboardingCompleted;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.cardFontScale = const Value.absent(),
    this.cardFontFamily = const Value.absent(),
    this.answerButtonCount = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.autoBackupEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.cardFontScale = const Value.absent(),
    this.cardFontFamily = const Value.absent(),
    this.answerButtonCount = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.autoBackupEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  });
  static Insertable<AppSettings> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<int>? accentColor,
    Expression<double>? cardFontScale,
    Expression<String>? cardFontFamily,
    Expression<int>? answerButtonCount,
    Expression<bool>? reducedMotion,
    Expression<bool>? autoBackupEnabled,
    Expression<bool>? onboardingCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (accentColor != null) 'accent_color': accentColor,
      if (cardFontScale != null) 'card_font_scale': cardFontScale,
      if (cardFontFamily != null) 'card_font_family': cardFontFamily,
      if (answerButtonCount != null) 'answer_button_count': answerButtonCount,
      if (reducedMotion != null) 'reduced_motion': reducedMotion,
      if (autoBackupEnabled != null) 'auto_backup_enabled': autoBackupEnabled,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<AppThemeMode>? themeMode,
    Value<int?>? accentColor,
    Value<double>? cardFontScale,
    Value<String?>? cardFontFamily,
    Value<int>? answerButtonCount,
    Value<bool>? reducedMotion,
    Value<bool>? autoBackupEnabled,
    Value<bool>? onboardingCompleted,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      cardFontScale: cardFontScale ?? this.cardFontScale,
      cardFontFamily: cardFontFamily ?? this.cardFontFamily,
      answerButtonCount: answerButtonCount ?? this.answerButtonCount,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(
        $SettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<int>(accentColor.value);
    }
    if (cardFontScale.present) {
      map['card_font_scale'] = Variable<double>(cardFontScale.value);
    }
    if (cardFontFamily.present) {
      map['card_font_family'] = Variable<String>(cardFontFamily.value);
    }
    if (answerButtonCount.present) {
      map['answer_button_count'] = Variable<int>(answerButtonCount.value);
    }
    if (reducedMotion.present) {
      map['reduced_motion'] = Variable<bool>(reducedMotion.value);
    }
    if (autoBackupEnabled.present) {
      map['auto_backup_enabled'] = Variable<bool>(autoBackupEnabled.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColor: $accentColor, ')
          ..write('cardFontScale: $cardFontScale, ')
          ..write('cardFontFamily: $cardFontFamily, ')
          ..write('answerButtonCount: $answerButtonCount, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('autoBackupEnabled: $autoBackupEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DeckOptionsTable deckOptions = $DeckOptionsTable(this);
  late final $DecksTable decks = $DecksTable(this);
  late final $NoteTypesTable noteTypes = $NoteTypesTable(this);
  late final $FieldsTable fields = $FieldsTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $ReviewLogTable reviewLog = $ReviewLogTable(this);
  late final $MediaTable media = $MediaTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final Index idxNotesFirstFieldHash = Index(
    'idx_notes_first_field_hash',
    'CREATE INDEX idx_notes_first_field_hash ON notes (first_field_hash)',
  );
  late final Index idxCardsDeckQueueDue = Index(
    'idx_cards_deck_queue_due',
    'CREATE INDEX idx_cards_deck_queue_due ON cards (deck_id, queue, due)',
  );
  late final Index idxReviewLogCardId = Index(
    'idx_review_log_card_id',
    'CREATE INDEX idx_review_log_card_id ON review_log (card_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    deckOptions,
    decks,
    noteTypes,
    fields,
    templates,
    notes,
    cards,
    reviewLog,
    media,
    settings,
    idxNotesFirstFieldHash,
    idxCardsDeckQueueDue,
    idxReviewLogCardId,
  ];
}

typedef $$DeckOptionsTableCreateCompanionBuilder =
    DeckOptionsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> newCardsPerDay,
      Value<int> reviewsPerDay,
      Value<String> learningStepsMinutes,
      Value<String> relearningStepsMinutes,
      Value<int> maximumIntervalDays,
      Value<double> desiredRetention,
    });
typedef $$DeckOptionsTableUpdateCompanionBuilder =
    DeckOptionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> newCardsPerDay,
      Value<int> reviewsPerDay,
      Value<String> learningStepsMinutes,
      Value<String> relearningStepsMinutes,
      Value<int> maximumIntervalDays,
      Value<double> desiredRetention,
    });

final class $$DeckOptionsTableReferences
    extends BaseReferences<_$AppDatabase, $DeckOptionsTable, DeckOption> {
  $$DeckOptionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DecksTable, List<Deck>> _decksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.decks,
    aliasName: 'deck_options__id__decks__deck_options_id',
  );

  $$DecksTableProcessedTableManager get decksRefs {
    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.deckOptionsId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_decksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DeckOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $DeckOptionsTable> {
  $$DeckOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newCardsPerDay => $composableBuilder(
    column: $table.newCardsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewsPerDay => $composableBuilder(
    column: $table.reviewsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningStepsMinutes => $composableBuilder(
    column: $table.learningStepsMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relearningStepsMinutes => $composableBuilder(
    column: $table.relearningStepsMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maximumIntervalDays => $composableBuilder(
    column: $table.maximumIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get desiredRetention => $composableBuilder(
    column: $table.desiredRetention,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> decksRefs(
    Expression<bool> Function($$DecksTableFilterComposer f) f,
  ) {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.deckOptionsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeckOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeckOptionsTable> {
  $$DeckOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newCardsPerDay => $composableBuilder(
    column: $table.newCardsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewsPerDay => $composableBuilder(
    column: $table.reviewsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningStepsMinutes => $composableBuilder(
    column: $table.learningStepsMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relearningStepsMinutes => $composableBuilder(
    column: $table.relearningStepsMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maximumIntervalDays => $composableBuilder(
    column: $table.maximumIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get desiredRetention => $composableBuilder(
    column: $table.desiredRetention,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeckOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeckOptionsTable> {
  $$DeckOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get newCardsPerDay => $composableBuilder(
    column: $table.newCardsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewsPerDay => $composableBuilder(
    column: $table.reviewsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learningStepsMinutes => $composableBuilder(
    column: $table.learningStepsMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relearningStepsMinutes => $composableBuilder(
    column: $table.relearningStepsMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maximumIntervalDays => $composableBuilder(
    column: $table.maximumIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get desiredRetention => $composableBuilder(
    column: $table.desiredRetention,
    builder: (column) => column,
  );

  Expression<T> decksRefs<T extends Object>(
    Expression<T> Function($$DecksTableAnnotationComposer a) f,
  ) {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.deckOptionsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeckOptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeckOptionsTable,
          DeckOption,
          $$DeckOptionsTableFilterComposer,
          $$DeckOptionsTableOrderingComposer,
          $$DeckOptionsTableAnnotationComposer,
          $$DeckOptionsTableCreateCompanionBuilder,
          $$DeckOptionsTableUpdateCompanionBuilder,
          (DeckOption, $$DeckOptionsTableReferences),
          DeckOption,
          PrefetchHooks Function({bool decksRefs})
        > {
  $$DeckOptionsTableTableManager(_$AppDatabase db, $DeckOptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckOptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> newCardsPerDay = const Value.absent(),
                Value<int> reviewsPerDay = const Value.absent(),
                Value<String> learningStepsMinutes = const Value.absent(),
                Value<String> relearningStepsMinutes = const Value.absent(),
                Value<int> maximumIntervalDays = const Value.absent(),
                Value<double> desiredRetention = const Value.absent(),
              }) => DeckOptionsCompanion(
                id: id,
                name: name,
                newCardsPerDay: newCardsPerDay,
                reviewsPerDay: reviewsPerDay,
                learningStepsMinutes: learningStepsMinutes,
                relearningStepsMinutes: relearningStepsMinutes,
                maximumIntervalDays: maximumIntervalDays,
                desiredRetention: desiredRetention,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> newCardsPerDay = const Value.absent(),
                Value<int> reviewsPerDay = const Value.absent(),
                Value<String> learningStepsMinutes = const Value.absent(),
                Value<String> relearningStepsMinutes = const Value.absent(),
                Value<int> maximumIntervalDays = const Value.absent(),
                Value<double> desiredRetention = const Value.absent(),
              }) => DeckOptionsCompanion.insert(
                id: id,
                name: name,
                newCardsPerDay: newCardsPerDay,
                reviewsPerDay: reviewsPerDay,
                learningStepsMinutes: learningStepsMinutes,
                relearningStepsMinutes: relearningStepsMinutes,
                maximumIntervalDays: maximumIntervalDays,
                desiredRetention: desiredRetention,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeckOptionsTable, DeckOption>(table),
                  $$DeckOptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({decksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (decksRefs) db.decks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (decksRefs)
                    await $_getPrefetchedData<
                      DeckOption,
                      $DeckOptionsTable,
                      Deck
                    >(
                      currentTable: table,
                      referencedTable: $$DeckOptionsTableReferences
                          ._decksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DeckOptionsTableReferences(db, table, p0).decksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.deckOptionsId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DeckOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeckOptionsTable,
      DeckOption,
      $$DeckOptionsTableFilterComposer,
      $$DeckOptionsTableOrderingComposer,
      $$DeckOptionsTableAnnotationComposer,
      $$DeckOptionsTableCreateCompanionBuilder,
      $$DeckOptionsTableUpdateCompanionBuilder,
      (DeckOption, $$DeckOptionsTableReferences),
      DeckOption,
      PrefetchHooks Function({bool decksRefs})
    >;
typedef $$DecksTableCreateCompanionBuilder = DecksCompanion Function({
  Value<int> id,
  required String name,
  required int deckOptionsId,
  Value<DateTime> createdAt,
});
typedef $$DecksTableUpdateCompanionBuilder = DecksCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> deckOptionsId,
  Value<DateTime> createdAt,
});

final class $$DecksTableReferences
    extends BaseReferences<_$AppDatabase, $DecksTable, Deck> {
  $$DecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeckOptionsTable _deckOptionsIdTable(_$AppDatabase db) =>
      db.deckOptions.createAlias('decks__deck_options_id__deck_options__id');

  $$DeckOptionsTableProcessedTableManager get deckOptionsId {
    final $_column = $_itemColumn<int>('deck_options_id')!;

    final manager = $$DeckOptionsTableTableManager(
      $_db,
      $_db.deckOptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckOptionsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CardsTable, List<StudyCard>> _cardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cards,
    aliasName: 'decks__id__cards__deck_id',
  );

  $$CardsTableProcessedTableManager get cardsRefs {
    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DecksTableFilterComposer extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DeckOptionsTableFilterComposer get deckOptionsId {
    final $$DeckOptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckOptionsId,
      referencedTable: $db.deckOptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckOptionsTableFilterComposer(
            $db: $db,
            $table: $db.deckOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardsRefs(
    Expression<bool> Function($$CardsTableFilterComposer f) f,
  ) {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableOrderingComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DeckOptionsTableOrderingComposer get deckOptionsId {
    final $$DeckOptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckOptionsId,
      referencedTable: $db.deckOptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckOptionsTableOrderingComposer(
            $db: $db,
            $table: $db.deckOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DeckOptionsTableAnnotationComposer get deckOptionsId {
    final $$DeckOptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckOptionsId,
      referencedTable: $db.deckOptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckOptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.deckOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardsRefs<T extends Object>(
    Expression<T> Function($$CardsTableAnnotationComposer a) f,
  ) {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DecksTable,
          Deck,
          $$DecksTableFilterComposer,
          $$DecksTableOrderingComposer,
          $$DecksTableAnnotationComposer,
          $$DecksTableCreateCompanionBuilder,
          $$DecksTableUpdateCompanionBuilder,
          (Deck, $$DecksTableReferences),
          Deck,
          PrefetchHooks Function({bool deckOptionsId, bool cardsRefs})
        > {
  $$DecksTableTableManager(_$AppDatabase db, $DecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> deckOptionsId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DecksCompanion(
                id: id,
                name: name,
                deckOptionsId: deckOptionsId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int deckOptionsId,
                Value<DateTime> createdAt = const Value.absent(),
              }) => DecksCompanion.insert(
                id: id,
                name: name,
                deckOptionsId: deckOptionsId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DecksTable, Deck>(table),
                  $$DecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deckOptionsId = false, cardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardsRefs) db.cards],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deckOptionsId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.deckOptionsId,
                        referencedTable: $$DecksTableReferences
                            ._deckOptionsIdTable(db),
                        referencedColumn: $$DecksTableReferences
                            ._deckOptionsIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardsRefs)
                    await $_getPrefetchedData<Deck, $DecksTable, StudyCard>(
                      currentTable: table,
                      referencedTable: $$DecksTableReferences._cardsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$DecksTableReferences(db, table, p0).cardsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deckId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DecksTable,
      Deck,
      $$DecksTableFilterComposer,
      $$DecksTableOrderingComposer,
      $$DecksTableAnnotationComposer,
      $$DecksTableCreateCompanionBuilder,
      $$DecksTableUpdateCompanionBuilder,
      (Deck, $$DecksTableReferences),
      Deck,
      PrefetchHooks Function({bool deckOptionsId, bool cardsRefs})
    >;
typedef $$NoteTypesTableCreateCompanionBuilder = NoteTypesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$NoteTypesTableUpdateCompanionBuilder = NoteTypesCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$NoteTypesTableReferences
    extends BaseReferences<_$AppDatabase, $NoteTypesTable, NoteType> {
  $$NoteTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FieldsTable, List<NoteField>> _fieldsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.fields,
    aliasName: 'note_types__id__fields__note_type_id',
  );

  $$FieldsTableProcessedTableManager get fieldsRefs {
    final manager = $$FieldsTableTableManager(
      $_db,
      $_db.fields,
    ).filter((f) => f.noteTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fieldsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TemplatesTable, List<CardTemplate>>
  _templatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.templates,
    aliasName: 'note_types__id__templates__note_type_id',
  );

  $$TemplatesTableProcessedTableManager get templatesRefs {
    final manager = $$TemplatesTableTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.noteTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_templatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'note_types__id__notes__note_type_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.noteTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NoteTypesTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTypesTable> {
  $$NoteTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fieldsRefs(
    Expression<bool> Function($$FieldsTableFilterComposer f) f,
  ) {
    final $$FieldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fields,
      getReferencedColumn: (t) => t.noteTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldsTableFilterComposer(
            $db: $db,
            $table: $db.fields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> templatesRefs(
    Expression<bool> Function($$TemplatesTableFilterComposer f) f,
  ) {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.noteTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.noteTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NoteTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTypesTable> {
  $$NoteTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTypesTable> {
  $$NoteTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> fieldsRefs<T extends Object>(
    Expression<T> Function($$FieldsTableAnnotationComposer a) f,
  ) {
    final $$FieldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fields,
      getReferencedColumn: (t) => t.noteTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldsTableAnnotationComposer(
            $db: $db,
            $table: $db.fields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> templatesRefs<T extends Object>(
    Expression<T> Function($$TemplatesTableAnnotationComposer a) f,
  ) {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.noteTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.noteTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NoteTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteTypesTable,
          NoteType,
          $$NoteTypesTableFilterComposer,
          $$NoteTypesTableOrderingComposer,
          $$NoteTypesTableAnnotationComposer,
          $$NoteTypesTableCreateCompanionBuilder,
          $$NoteTypesTableUpdateCompanionBuilder,
          (NoteType, $$NoteTypesTableReferences),
          NoteType,
          PrefetchHooks Function({
            bool fieldsRefs,
            bool templatesRefs,
            bool notesRefs,
          })
        > {
  $$NoteTypesTableTableManager(_$AppDatabase db, $NoteTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => NoteTypesCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => NoteTypesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NoteTypesTable, NoteType>(table),
                  $$NoteTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fieldsRefs = false, templatesRefs = false, notesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fieldsRefs) db.fields,
                    if (templatesRefs) db.templates,
                    if (notesRefs) db.notes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fieldsRefs)
                        await $_getPrefetchedData<
                          NoteType,
                          $NoteTypesTable,
                          NoteField
                        >(
                          currentTable: table,
                          referencedTable: $$NoteTypesTableReferences
                              ._fieldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NoteTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).fieldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (templatesRefs)
                        await $_getPrefetchedData<
                          NoteType,
                          $NoteTypesTable,
                          CardTemplate
                        >(
                          currentTable: table,
                          referencedTable: $$NoteTypesTableReferences
                              ._templatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NoteTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).templatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          NoteType,
                          $NoteTypesTable,
                          Note
                        >(
                          currentTable: table,
                          referencedTable: $$NoteTypesTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NoteTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$NoteTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteTypesTable,
      NoteType,
      $$NoteTypesTableFilterComposer,
      $$NoteTypesTableOrderingComposer,
      $$NoteTypesTableAnnotationComposer,
      $$NoteTypesTableCreateCompanionBuilder,
      $$NoteTypesTableUpdateCompanionBuilder,
      (NoteType, $$NoteTypesTableReferences),
      NoteType,
      PrefetchHooks Function({
        bool fieldsRefs,
        bool templatesRefs,
        bool notesRefs,
      })
    >;
typedef $$FieldsTableCreateCompanionBuilder = FieldsCompanion Function({
  Value<int> id,
  required int noteTypeId,
  required String name,
  required int ord,
});
typedef $$FieldsTableUpdateCompanionBuilder = FieldsCompanion Function({
  Value<int> id,
  Value<int> noteTypeId,
  Value<String> name,
  Value<int> ord,
});

final class $$FieldsTableReferences
    extends BaseReferences<_$AppDatabase, $FieldsTable, NoteField> {
  $$FieldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NoteTypesTable _noteTypeIdTable(_$AppDatabase db) =>
      db.noteTypes.createAlias('fields__note_type_id__note_types__id');

  $$NoteTypesTableProcessedTableManager get noteTypeId {
    final $_column = $_itemColumn<int>('note_type_id')!;

    final manager = $$NoteTypesTableTableManager(
      $_db,
      $_db.noteTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FieldsTableFilterComposer
    extends Composer<_$AppDatabase, $FieldsTable> {
  $$FieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnFilters(column),
  );

  $$NoteTypesTableFilterComposer get noteTypeId {
    final $$NoteTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableFilterComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $FieldsTable> {
  $$FieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnOrderings(column),
  );

  $$NoteTypesTableOrderingComposer get noteTypeId {
    final $$NoteTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableOrderingComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FieldsTable> {
  $$FieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get ord =>
      $composableBuilder(column: $table.ord, builder: (column) => column);

  $$NoteTypesTableAnnotationComposer get noteTypeId {
    final $$NoteTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FieldsTable,
          NoteField,
          $$FieldsTableFilterComposer,
          $$FieldsTableOrderingComposer,
          $$FieldsTableAnnotationComposer,
          $$FieldsTableCreateCompanionBuilder,
          $$FieldsTableUpdateCompanionBuilder,
          (NoteField, $$FieldsTableReferences),
          NoteField,
          PrefetchHooks Function({bool noteTypeId})
        > {
  $$FieldsTableTableManager(_$AppDatabase db, $FieldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FieldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> noteTypeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> ord = const Value.absent(),
              }) => FieldsCompanion(
                id: id,
                noteTypeId: noteTypeId,
                name: name,
                ord: ord,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int noteTypeId,
                required String name,
                required int ord,
              }) => FieldsCompanion.insert(
                id: id,
                noteTypeId: noteTypeId,
                name: name,
                ord: ord,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FieldsTable, NoteField>(table),
                  $$FieldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteTypeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.noteTypeId,
                        referencedTable: $$FieldsTableReferences
                            ._noteTypeIdTable(db),
                        referencedColumn: $$FieldsTableReferences
                            ._noteTypeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FieldsTable,
      NoteField,
      $$FieldsTableFilterComposer,
      $$FieldsTableOrderingComposer,
      $$FieldsTableAnnotationComposer,
      $$FieldsTableCreateCompanionBuilder,
      $$FieldsTableUpdateCompanionBuilder,
      (NoteField, $$FieldsTableReferences),
      NoteField,
      PrefetchHooks Function({bool noteTypeId})
    >;
typedef $$TemplatesTableCreateCompanionBuilder = TemplatesCompanion Function({
  Value<int> id,
  required int noteTypeId,
  required String name,
  required String front,
  required String back,
  Value<String> css,
  required int ord,
});
typedef $$TemplatesTableUpdateCompanionBuilder = TemplatesCompanion Function({
  Value<int> id,
  Value<int> noteTypeId,
  Value<String> name,
  Value<String> front,
  Value<String> back,
  Value<String> css,
  Value<int> ord,
});

final class $$TemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $TemplatesTable, CardTemplate> {
  $$TemplatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NoteTypesTable _noteTypeIdTable(_$AppDatabase db) =>
      db.noteTypes.createAlias('templates__note_type_id__note_types__id');

  $$NoteTypesTableProcessedTableManager get noteTypeId {
    final $_column = $_itemColumn<int>('note_type_id')!;

    final manager = $$NoteTypesTableTableManager(
      $_db,
      $_db.noteTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get css => $composableBuilder(
    column: $table.css,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnFilters(column),
  );

  $$NoteTypesTableFilterComposer get noteTypeId {
    final $$NoteTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableFilterComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get css => $composableBuilder(
    column: $table.css,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnOrderings(column),
  );

  $$NoteTypesTableOrderingComposer get noteTypeId {
    final $$NoteTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableOrderingComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get front =>
      $composableBuilder(column: $table.front, builder: (column) => column);

  GeneratedColumn<String> get back =>
      $composableBuilder(column: $table.back, builder: (column) => column);

  GeneratedColumn<String> get css =>
      $composableBuilder(column: $table.css, builder: (column) => column);

  GeneratedColumn<int> get ord =>
      $composableBuilder(column: $table.ord, builder: (column) => column);

  $$NoteTypesTableAnnotationComposer get noteTypeId {
    final $$NoteTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplatesTable,
          CardTemplate,
          $$TemplatesTableFilterComposer,
          $$TemplatesTableOrderingComposer,
          $$TemplatesTableAnnotationComposer,
          $$TemplatesTableCreateCompanionBuilder,
          $$TemplatesTableUpdateCompanionBuilder,
          (CardTemplate, $$TemplatesTableReferences),
          CardTemplate,
          PrefetchHooks Function({bool noteTypeId})
        > {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> noteTypeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> front = const Value.absent(),
                Value<String> back = const Value.absent(),
                Value<String> css = const Value.absent(),
                Value<int> ord = const Value.absent(),
              }) => TemplatesCompanion(
                id: id,
                noteTypeId: noteTypeId,
                name: name,
                front: front,
                back: back,
                css: css,
                ord: ord,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int noteTypeId,
                required String name,
                required String front,
                required String back,
                Value<String> css = const Value.absent(),
                required int ord,
              }) => TemplatesCompanion.insert(
                id: id,
                noteTypeId: noteTypeId,
                name: name,
                front: front,
                back: back,
                css: css,
                ord: ord,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemplatesTable, CardTemplate>(table),
                  $$TemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteTypeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.noteTypeId,
                        referencedTable: $$TemplatesTableReferences
                            ._noteTypeIdTable(db),
                        referencedColumn: $$TemplatesTableReferences
                            ._noteTypeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplatesTable,
      CardTemplate,
      $$TemplatesTableFilterComposer,
      $$TemplatesTableOrderingComposer,
      $$TemplatesTableAnnotationComposer,
      $$TemplatesTableCreateCompanionBuilder,
      $$TemplatesTableUpdateCompanionBuilder,
      (CardTemplate, $$TemplatesTableReferences),
      CardTemplate,
      PrefetchHooks Function({bool noteTypeId})
    >;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  required int noteTypeId,
  required String fieldValues,
  Value<String> tags,
  required String firstFieldHash,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  Value<int> noteTypeId,
  Value<String> fieldValues,
  Value<String> tags,
  Value<String> firstFieldHash,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, Note> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NoteTypesTable _noteTypeIdTable(_$AppDatabase db) =>
      db.noteTypes.createAlias('notes__note_type_id__note_types__id');

  $$NoteTypesTableProcessedTableManager get noteTypeId {
    final $_column = $_itemColumn<int>('note_type_id')!;

    final manager = $$NoteTypesTableTableManager(
      $_db,
      $_db.noteTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CardsTable, List<StudyCard>> _cardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cards,
    aliasName: 'notes__id__cards__note_id',
  );

  $$CardsTableProcessedTableManager get cardsRefs {
    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldValues => $composableBuilder(
    column: $table.fieldValues,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstFieldHash => $composableBuilder(
    column: $table.firstFieldHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NoteTypesTableFilterComposer get noteTypeId {
    final $$NoteTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableFilterComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardsRefs(
    Expression<bool> Function($$CardsTableFilterComposer f) f,
  ) {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldValues => $composableBuilder(
    column: $table.fieldValues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstFieldHash => $composableBuilder(
    column: $table.firstFieldHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NoteTypesTableOrderingComposer get noteTypeId {
    final $$NoteTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableOrderingComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fieldValues => $composableBuilder(
    column: $table.fieldValues,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get firstFieldHash => $composableBuilder(
    column: $table.firstFieldHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$NoteTypesTableAnnotationComposer get noteTypeId {
    final $$NoteTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteTypeId,
      referencedTable: $db.noteTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.noteTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardsRefs<T extends Object>(
    Expression<T> Function($$CardsTableAnnotationComposer a) f,
  ) {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, $$NotesTableReferences),
          Note,
          PrefetchHooks Function({bool noteTypeId, bool cardsRefs})
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> noteTypeId = const Value.absent(),
                Value<String> fieldValues = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> firstFieldHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                noteTypeId: noteTypeId,
                fieldValues: fieldValues,
                tags: tags,
                firstFieldHash: firstFieldHash,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int noteTypeId,
                required String fieldValues,
                Value<String> tags = const Value.absent(),
                required String firstFieldHash,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                noteTypeId: noteTypeId,
                fieldValues: fieldValues,
                tags: tags,
                firstFieldHash: firstFieldHash,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotesTable, Note>(table),
                  $$NotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteTypeId = false, cardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardsRefs) db.cards],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteTypeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.noteTypeId,
                        referencedTable: $$NotesTableReferences
                            ._noteTypeIdTable(db),
                        referencedColumn: $$NotesTableReferences
                            ._noteTypeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardsRefs)
                    await $_getPrefetchedData<Note, $NotesTable, StudyCard>(
                      currentTable: table,
                      referencedTable: $$NotesTableReferences._cardsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$NotesTableReferences(db, table, p0).cardsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.noteId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, $$NotesTableReferences),
      Note,
      PrefetchHooks Function({bool noteTypeId, bool cardsRefs})
    >;
typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  required int noteId,
  required int deckId,
  required int templateOrd,
  required CardQueue queue,
  required int due,
  Value<double?> stability,
  Value<double?> difficulty,
  Value<int> lapses,
  Value<int> reps,
  Value<int> flag,
  Value<DateTime> createdAt,
  Value<DateTime?> lastReviewedAt,
  Value<DateTime?> deletedAt,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  Value<int> noteId,
  Value<int> deckId,
  Value<int> templateOrd,
  Value<CardQueue> queue,
  Value<int> due,
  Value<double?> stability,
  Value<double?> difficulty,
  Value<int> lapses,
  Value<int> reps,
  Value<int> flag,
  Value<DateTime> createdAt,
  Value<DateTime?> lastReviewedAt,
  Value<DateTime?> deletedAt,
});

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, StudyCard> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) =>
      db.notes.createAlias('cards__note_id__notes__id');

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<int>('note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DecksTable _deckIdTable(_$AppDatabase db) =>
      db.decks.createAlias('cards__deck_id__decks__id');

  $$DecksTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<int>('deck_id')!;

    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReviewLogTable, List<ReviewLogEntry>>
  _reviewLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLog,
    aliasName: 'cards__id__review_log__card_id',
  );

  $$ReviewLogTableProcessedTableManager get reviewLogRefs {
    final manager = $$ReviewLogTableTableManager(
      $_db,
      $_db.reviewLog,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get templateOrd => $composableBuilder(
    column: $table.templateOrd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CardQueue, CardQueue, String> get queue =>
      $composableBuilder(
        column: $table.queue,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableFilterComposer get deckId {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reviewLogRefs(
    Expression<bool> Function($$ReviewLogTableFilterComposer f) f,
  ) {
    final $$ReviewLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLog,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogTableFilterComposer(
            $db: $db,
            $table: $db.reviewLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateOrd => $composableBuilder(
    column: $table.templateOrd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queue => $composableBuilder(
    column: $table.queue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableOrderingComposer get deckId {
    final $$DecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableOrderingComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get templateOrd => $composableBuilder(
    column: $table.templateOrd,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CardQueue, String> get queue =>
      $composableBuilder(column: $table.queue, builder: (column) => column);

  GeneratedColumn<int> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get flag =>
      $composableBuilder(column: $table.flag, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableAnnotationComposer get deckId {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reviewLogRefs<T extends Object>(
    Expression<T> Function($$ReviewLogTableAnnotationComposer a) f,
  ) {
    final $$ReviewLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLog,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          StudyCard,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (StudyCard, $$CardsTableReferences),
          StudyCard,
          PrefetchHooks Function({bool noteId, bool deckId, bool reviewLogRefs})
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> noteId = const Value.absent(),
                Value<int> deckId = const Value.absent(),
                Value<int> templateOrd = const Value.absent(),
                Value<CardQueue> queue = const Value.absent(),
                Value<int> due = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> flag = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                noteId: noteId,
                deckId: deckId,
                templateOrd: templateOrd,
                queue: queue,
                due: due,
                stability: stability,
                difficulty: difficulty,
                lapses: lapses,
                reps: reps,
                flag: flag,
                createdAt: createdAt,
                lastReviewedAt: lastReviewedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int noteId,
                required int deckId,
                required int templateOrd,
                required CardQueue queue,
                required int due,
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> flag = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                noteId: noteId,
                deckId: deckId,
                templateOrd: templateOrd,
                queue: queue,
                due: due,
                stability: stability,
                difficulty: difficulty,
                lapses: lapses,
                reps: reps,
                flag: flag,
                createdAt: createdAt,
                lastReviewedAt: lastReviewedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardsTable, StudyCard>(table),
                  $$CardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({noteId = false, deckId = false, reviewLogRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (reviewLogRefs) db.reviewLog],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (noteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.noteId,
                            referencedTable: $$CardsTableReferences
                                ._noteIdTable(db),
                            referencedColumn: $$CardsTableReferences
                                ._noteIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (deckId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.deckId,
                            referencedTable: $$CardsTableReferences
                                ._deckIdTable(db),
                            referencedColumn: $$CardsTableReferences
                                ._deckIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reviewLogRefs)
                        await $_getPrefetchedData<
                          StudyCard,
                          $CardsTable,
                          ReviewLogEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._reviewLogRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      StudyCard,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (StudyCard, $$CardsTableReferences),
      StudyCard,
      PrefetchHooks Function({bool noteId, bool deckId, bool reviewLogRefs})
    >;
typedef $$ReviewLogTableCreateCompanionBuilder = ReviewLogCompanion Function({
  Value<int> id,
  required int cardId,
  Value<DateTime> reviewedAt,
  required ReviewRating rating,
  required double elapsedDays,
  required double scheduledDays,
  required ReviewCardState state,
});
typedef $$ReviewLogTableUpdateCompanionBuilder = ReviewLogCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<DateTime> reviewedAt,
  Value<ReviewRating> rating,
  Value<double> elapsedDays,
  Value<double> scheduledDays,
  Value<ReviewCardState> state,
});

final class $$ReviewLogTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewLogTable, ReviewLogEntry> {
  $$ReviewLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('review_log__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewLogTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogTable> {
  $$ReviewLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewRating, ReviewRating, String>
  get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewCardState, ReviewCardState, String>
  get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogTable> {
  $$ReviewLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogTable> {
  $$ReviewLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ReviewRating, String> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<double> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ReviewCardState, String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogTable,
          ReviewLogEntry,
          $$ReviewLogTableFilterComposer,
          $$ReviewLogTableOrderingComposer,
          $$ReviewLogTableAnnotationComposer,
          $$ReviewLogTableCreateCompanionBuilder,
          $$ReviewLogTableUpdateCompanionBuilder,
          (ReviewLogEntry, $$ReviewLogTableReferences),
          ReviewLogEntry,
          PrefetchHooks Function({bool cardId})
        > {
  $$ReviewLogTableTableManager(_$AppDatabase db, $ReviewLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
                Value<ReviewRating> rating = const Value.absent(),
                Value<double> elapsedDays = const Value.absent(),
                Value<double> scheduledDays = const Value.absent(),
                Value<ReviewCardState> state = const Value.absent(),
              }) => ReviewLogCompanion(
                id: id,
                cardId: cardId,
                reviewedAt: reviewedAt,
                rating: rating,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                state: state,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                Value<DateTime> reviewedAt = const Value.absent(),
                required ReviewRating rating,
                required double elapsedDays,
                required double scheduledDays,
                required ReviewCardState state,
              }) => ReviewLogCompanion.insert(
                id: id,
                cardId: cardId,
                reviewedAt: reviewedAt,
                rating: rating,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewLogTable, ReviewLogEntry>(table),
                  $$ReviewLogTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$ReviewLogTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$ReviewLogTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogTable,
      ReviewLogEntry,
      $$ReviewLogTableFilterComposer,
      $$ReviewLogTableOrderingComposer,
      $$ReviewLogTableAnnotationComposer,
      $$ReviewLogTableCreateCompanionBuilder,
      $$ReviewLogTableUpdateCompanionBuilder,
      (ReviewLogEntry, $$ReviewLogTableReferences),
      ReviewLogEntry,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$MediaTableCreateCompanionBuilder = MediaCompanion Function({
  required String hash,
  required String filename,
  Value<int> refCount,
  Value<int> rowid,
});
typedef $$MediaTableUpdateCompanionBuilder = MediaCompanion Function({
  Value<String> hash,
  Value<String> filename,
  Value<int> refCount,
  Value<int> rowid,
});

class $$MediaTableFilterComposer extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refCount => $composableBuilder(
    column: $table.refCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refCount => $composableBuilder(
    column: $table.refCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<int> get refCount =>
      $composableBuilder(column: $table.refCount, builder: (column) => column);
}

class $$MediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaTable,
          MediaFile,
          $$MediaTableFilterComposer,
          $$MediaTableOrderingComposer,
          $$MediaTableAnnotationComposer,
          $$MediaTableCreateCompanionBuilder,
          $$MediaTableUpdateCompanionBuilder,
          (MediaFile, BaseReferences<_$AppDatabase, $MediaTable, MediaFile>),
          MediaFile,
          PrefetchHooks Function()
        > {
  $$MediaTableTableManager(_$AppDatabase db, $MediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hash = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<int> refCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaCompanion(
                hash: hash,
                filename: filename,
                refCount: refCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hash,
                required String filename,
                Value<int> refCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaCompanion.insert(
                hash: hash,
                filename: filename,
                refCount: refCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaTable, MediaFile>(table),
                  BaseReferences<_$AppDatabase, $MediaTable, MediaFile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaTable,
      MediaFile,
      $$MediaTableFilterComposer,
      $$MediaTableOrderingComposer,
      $$MediaTableAnnotationComposer,
      $$MediaTableCreateCompanionBuilder,
      $$MediaTableUpdateCompanionBuilder,
      (MediaFile, BaseReferences<_$AppDatabase, $MediaTable, MediaFile>),
      MediaFile,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<AppThemeMode> themeMode,
  Value<int?> accentColor,
  Value<double> cardFontScale,
  Value<String?> cardFontFamily,
  Value<int> answerButtonCount,
  Value<bool> reducedMotion,
  Value<bool> autoBackupEnabled,
  Value<bool> onboardingCompleted,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<AppThemeMode> themeMode,
  Value<int?> accentColor,
  Value<double> cardFontScale,
  Value<String?> cardFontFamily,
  Value<int> answerButtonCount,
  Value<bool> reducedMotion,
  Value<bool> autoBackupEnabled,
  Value<bool> onboardingCompleted,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, String>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cardFontScale => $composableBuilder(
    column: $table.cardFontScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardFontFamily => $composableBuilder(
    column: $table.cardFontFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answerButtonCount => $composableBuilder(
    column: $table.answerButtonCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoBackupEnabled => $composableBuilder(
    column: $table.autoBackupEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cardFontScale => $composableBuilder(
    column: $table.cardFontScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardFontFamily => $composableBuilder(
    column: $table.cardFontFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answerButtonCount => $composableBuilder(
    column: $table.answerButtonCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoBackupEnabled => $composableBuilder(
    column: $table.autoBackupEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppThemeMode, String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cardFontScale => $composableBuilder(
    column: $table.cardFontScale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardFontFamily => $composableBuilder(
    column: $table.cardFontFamily,
    builder: (column) => column,
  );

  GeneratedColumn<int> get answerButtonCount => $composableBuilder(
    column: $table.answerButtonCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoBackupEnabled => $composableBuilder(
    column: $table.autoBackupEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          AppSettings,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            AppSettings,
            BaseReferences<_$AppDatabase, $SettingsTable, AppSettings>,
          ),
          AppSettings,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<int?> accentColor = const Value.absent(),
                Value<double> cardFontScale = const Value.absent(),
                Value<String?> cardFontFamily = const Value.absent(),
                Value<int> answerButtonCount = const Value.absent(),
                Value<bool> reducedMotion = const Value.absent(),
                Value<bool> autoBackupEnabled = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                themeMode: themeMode,
                accentColor: accentColor,
                cardFontScale: cardFontScale,
                cardFontFamily: cardFontFamily,
                answerButtonCount: answerButtonCount,
                reducedMotion: reducedMotion,
                autoBackupEnabled: autoBackupEnabled,
                onboardingCompleted: onboardingCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<int?> accentColor = const Value.absent(),
                Value<double> cardFontScale = const Value.absent(),
                Value<String?> cardFontFamily = const Value.absent(),
                Value<int> answerButtonCount = const Value.absent(),
                Value<bool> reducedMotion = const Value.absent(),
                Value<bool> autoBackupEnabled = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                accentColor: accentColor,
                cardFontScale: cardFontScale,
                cardFontFamily: cardFontFamily,
                answerButtonCount: answerButtonCount,
                reducedMotion: reducedMotion,
                autoBackupEnabled: autoBackupEnabled,
                onboardingCompleted: onboardingCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, AppSettings>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, AppSettings>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      AppSettings,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (AppSettings, BaseReferences<_$AppDatabase, $SettingsTable, AppSettings>),
      AppSettings,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DeckOptionsTableTableManager get deckOptions =>
      $$DeckOptionsTableTableManager(_db, _db.deckOptions);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db, _db.decks);
  $$NoteTypesTableTableManager get noteTypes =>
      $$NoteTypesTableTableManager(_db, _db.noteTypes);
  $$FieldsTableTableManager get fields =>
      $$FieldsTableTableManager(_db, _db.fields);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$ReviewLogTableTableManager get reviewLog =>
      $$ReviewLogTableTableManager(_db, _db.reviewLog);
  $$MediaTableTableManager get media =>
      $$MediaTableTableManager(_db, _db.media);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
