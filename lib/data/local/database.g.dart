// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ListingsTable extends Listings
    with TableInfo<$ListingsTable, ListingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _neighbourhoodMeta = const VerificationMeta(
    'neighbourhood',
  );
  @override
  late final GeneratedColumn<String> neighbourhood = GeneratedColumn<String>(
    'neighbourhood',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bhkMeta = const VerificationMeta('bhk');
  @override
  late final GeneratedColumn<int> bhk = GeneratedColumn<int>(
    'bhk',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyRentMeta = const VerificationMeta(
    'monthlyRent',
  );
  @override
  late final GeneratedColumn<int> monthlyRent = GeneratedColumn<int>(
    'monthly_rent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositMonthsMeta = const VerificationMeta(
    'depositMonths',
  );
  @override
  late final GeneratedColumn<int> depositMonths = GeneratedColumn<int>(
    'deposit_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositAmountMeta = const VerificationMeta(
    'depositAmount',
  );
  @override
  late final GeneratedColumn<int> depositAmount = GeneratedColumn<int>(
    'deposit_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brokerageMeta = const VerificationMeta(
    'brokerage',
  );
  @override
  late final GeneratedColumn<int> brokerage = GeneratedColumn<int>(
    'brokerage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _societyChargesMeta = const VerificationMeta(
    'societyCharges',
  );
  @override
  late final GeneratedColumn<int> societyCharges = GeneratedColumn<int>(
    'society_charges',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maintenanceMeta = const VerificationMeta(
    'maintenance',
  );
  @override
  late final GeneratedColumn<int> maintenance = GeneratedColumn<int>(
    'maintenance',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ListingState, String> state =
      GeneratedColumn<String>(
        'state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ListingState>($ListingsTable.$converterstate);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    neighbourhood,
    bhk,
    monthlyRent,
    depositMonths,
    depositAmount,
    brokerage,
    societyCharges,
    maintenance,
    state,
    version,
    ownerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('neighbourhood')) {
      context.handle(
        _neighbourhoodMeta,
        neighbourhood.isAcceptableOrUnknown(
          data['neighbourhood']!,
          _neighbourhoodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_neighbourhoodMeta);
    }
    if (data.containsKey('bhk')) {
      context.handle(
        _bhkMeta,
        bhk.isAcceptableOrUnknown(data['bhk']!, _bhkMeta),
      );
    } else if (isInserting) {
      context.missing(_bhkMeta);
    }
    if (data.containsKey('monthly_rent')) {
      context.handle(
        _monthlyRentMeta,
        monthlyRent.isAcceptableOrUnknown(
          data['monthly_rent']!,
          _monthlyRentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyRentMeta);
    }
    if (data.containsKey('deposit_months')) {
      context.handle(
        _depositMonthsMeta,
        depositMonths.isAcceptableOrUnknown(
          data['deposit_months']!,
          _depositMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_depositMonthsMeta);
    }
    if (data.containsKey('deposit_amount')) {
      context.handle(
        _depositAmountMeta,
        depositAmount.isAcceptableOrUnknown(
          data['deposit_amount']!,
          _depositAmountMeta,
        ),
      );
    }
    if (data.containsKey('brokerage')) {
      context.handle(
        _brokerageMeta,
        brokerage.isAcceptableOrUnknown(data['brokerage']!, _brokerageMeta),
      );
    }
    if (data.containsKey('society_charges')) {
      context.handle(
        _societyChargesMeta,
        societyCharges.isAcceptableOrUnknown(
          data['society_charges']!,
          _societyChargesMeta,
        ),
      );
    }
    if (data.containsKey('maintenance')) {
      context.handle(
        _maintenanceMeta,
        maintenance.isAcceptableOrUnknown(
          data['maintenance']!,
          _maintenanceMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListingEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      neighbourhood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neighbourhood'],
      )!,
      bhk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bhk'],
      )!,
      monthlyRent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_rent'],
      )!,
      depositMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit_months'],
      )!,
      depositAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit_amount'],
      ),
      brokerage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brokerage'],
      ),
      societyCharges: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}society_charges'],
      ),
      maintenance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maintenance'],
      ),
      state: $ListingsTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}state'],
        )!,
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
    );
  }

  @override
  $ListingsTable createAlias(String alias) {
    return $ListingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ListingState, String, String> $converterstate =
      const EnumNameConverter<ListingState>(ListingState.values);
}

class ListingEntity extends DataClass implements Insertable<ListingEntity> {
  final String id;
  final String title;
  final String neighbourhood;
  final int bhk;
  final int monthlyRent;
  final int depositMonths;
  final int? depositAmount;
  final int? brokerage;
  final int? societyCharges;
  final int? maintenance;
  final ListingState state;
  final int version;
  final String ownerId;
  const ListingEntity({
    required this.id,
    required this.title,
    required this.neighbourhood,
    required this.bhk,
    required this.monthlyRent,
    required this.depositMonths,
    this.depositAmount,
    this.brokerage,
    this.societyCharges,
    this.maintenance,
    required this.state,
    required this.version,
    required this.ownerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['neighbourhood'] = Variable<String>(neighbourhood);
    map['bhk'] = Variable<int>(bhk);
    map['monthly_rent'] = Variable<int>(monthlyRent);
    map['deposit_months'] = Variable<int>(depositMonths);
    if (!nullToAbsent || depositAmount != null) {
      map['deposit_amount'] = Variable<int>(depositAmount);
    }
    if (!nullToAbsent || brokerage != null) {
      map['brokerage'] = Variable<int>(brokerage);
    }
    if (!nullToAbsent || societyCharges != null) {
      map['society_charges'] = Variable<int>(societyCharges);
    }
    if (!nullToAbsent || maintenance != null) {
      map['maintenance'] = Variable<int>(maintenance);
    }
    {
      map['state'] = Variable<String>(
        $ListingsTable.$converterstate.toSql(state),
      );
    }
    map['version'] = Variable<int>(version);
    map['owner_id'] = Variable<String>(ownerId);
    return map;
  }

  ListingsCompanion toCompanion(bool nullToAbsent) {
    return ListingsCompanion(
      id: Value(id),
      title: Value(title),
      neighbourhood: Value(neighbourhood),
      bhk: Value(bhk),
      monthlyRent: Value(monthlyRent),
      depositMonths: Value(depositMonths),
      depositAmount: depositAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(depositAmount),
      brokerage: brokerage == null && nullToAbsent
          ? const Value.absent()
          : Value(brokerage),
      societyCharges: societyCharges == null && nullToAbsent
          ? const Value.absent()
          : Value(societyCharges),
      maintenance: maintenance == null && nullToAbsent
          ? const Value.absent()
          : Value(maintenance),
      state: Value(state),
      version: Value(version),
      ownerId: Value(ownerId),
    );
  }

  factory ListingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListingEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      neighbourhood: serializer.fromJson<String>(json['neighbourhood']),
      bhk: serializer.fromJson<int>(json['bhk']),
      monthlyRent: serializer.fromJson<int>(json['monthlyRent']),
      depositMonths: serializer.fromJson<int>(json['depositMonths']),
      depositAmount: serializer.fromJson<int?>(json['depositAmount']),
      brokerage: serializer.fromJson<int?>(json['brokerage']),
      societyCharges: serializer.fromJson<int?>(json['societyCharges']),
      maintenance: serializer.fromJson<int?>(json['maintenance']),
      state: $ListingsTable.$converterstate.fromJson(
        serializer.fromJson<String>(json['state']),
      ),
      version: serializer.fromJson<int>(json['version']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'neighbourhood': serializer.toJson<String>(neighbourhood),
      'bhk': serializer.toJson<int>(bhk),
      'monthlyRent': serializer.toJson<int>(monthlyRent),
      'depositMonths': serializer.toJson<int>(depositMonths),
      'depositAmount': serializer.toJson<int?>(depositAmount),
      'brokerage': serializer.toJson<int?>(brokerage),
      'societyCharges': serializer.toJson<int?>(societyCharges),
      'maintenance': serializer.toJson<int?>(maintenance),
      'state': serializer.toJson<String>(
        $ListingsTable.$converterstate.toJson(state),
      ),
      'version': serializer.toJson<int>(version),
      'ownerId': serializer.toJson<String>(ownerId),
    };
  }

  ListingEntity copyWith({
    String? id,
    String? title,
    String? neighbourhood,
    int? bhk,
    int? monthlyRent,
    int? depositMonths,
    Value<int?> depositAmount = const Value.absent(),
    Value<int?> brokerage = const Value.absent(),
    Value<int?> societyCharges = const Value.absent(),
    Value<int?> maintenance = const Value.absent(),
    ListingState? state,
    int? version,
    String? ownerId,
  }) => ListingEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    neighbourhood: neighbourhood ?? this.neighbourhood,
    bhk: bhk ?? this.bhk,
    monthlyRent: monthlyRent ?? this.monthlyRent,
    depositMonths: depositMonths ?? this.depositMonths,
    depositAmount: depositAmount.present
        ? depositAmount.value
        : this.depositAmount,
    brokerage: brokerage.present ? brokerage.value : this.brokerage,
    societyCharges: societyCharges.present
        ? societyCharges.value
        : this.societyCharges,
    maintenance: maintenance.present ? maintenance.value : this.maintenance,
    state: state ?? this.state,
    version: version ?? this.version,
    ownerId: ownerId ?? this.ownerId,
  );
  ListingEntity copyWithCompanion(ListingsCompanion data) {
    return ListingEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      neighbourhood: data.neighbourhood.present
          ? data.neighbourhood.value
          : this.neighbourhood,
      bhk: data.bhk.present ? data.bhk.value : this.bhk,
      monthlyRent: data.monthlyRent.present
          ? data.monthlyRent.value
          : this.monthlyRent,
      depositMonths: data.depositMonths.present
          ? data.depositMonths.value
          : this.depositMonths,
      depositAmount: data.depositAmount.present
          ? data.depositAmount.value
          : this.depositAmount,
      brokerage: data.brokerage.present ? data.brokerage.value : this.brokerage,
      societyCharges: data.societyCharges.present
          ? data.societyCharges.value
          : this.societyCharges,
      maintenance: data.maintenance.present
          ? data.maintenance.value
          : this.maintenance,
      state: data.state.present ? data.state.value : this.state,
      version: data.version.present ? data.version.value : this.version,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListingEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('neighbourhood: $neighbourhood, ')
          ..write('bhk: $bhk, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('depositMonths: $depositMonths, ')
          ..write('depositAmount: $depositAmount, ')
          ..write('brokerage: $brokerage, ')
          ..write('societyCharges: $societyCharges, ')
          ..write('maintenance: $maintenance, ')
          ..write('state: $state, ')
          ..write('version: $version, ')
          ..write('ownerId: $ownerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    neighbourhood,
    bhk,
    monthlyRent,
    depositMonths,
    depositAmount,
    brokerage,
    societyCharges,
    maintenance,
    state,
    version,
    ownerId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListingEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.neighbourhood == this.neighbourhood &&
          other.bhk == this.bhk &&
          other.monthlyRent == this.monthlyRent &&
          other.depositMonths == this.depositMonths &&
          other.depositAmount == this.depositAmount &&
          other.brokerage == this.brokerage &&
          other.societyCharges == this.societyCharges &&
          other.maintenance == this.maintenance &&
          other.state == this.state &&
          other.version == this.version &&
          other.ownerId == this.ownerId);
}

class ListingsCompanion extends UpdateCompanion<ListingEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> neighbourhood;
  final Value<int> bhk;
  final Value<int> monthlyRent;
  final Value<int> depositMonths;
  final Value<int?> depositAmount;
  final Value<int?> brokerage;
  final Value<int?> societyCharges;
  final Value<int?> maintenance;
  final Value<ListingState> state;
  final Value<int> version;
  final Value<String> ownerId;
  final Value<int> rowid;
  const ListingsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.neighbourhood = const Value.absent(),
    this.bhk = const Value.absent(),
    this.monthlyRent = const Value.absent(),
    this.depositMonths = const Value.absent(),
    this.depositAmount = const Value.absent(),
    this.brokerage = const Value.absent(),
    this.societyCharges = const Value.absent(),
    this.maintenance = const Value.absent(),
    this.state = const Value.absent(),
    this.version = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListingsCompanion.insert({
    required String id,
    required String title,
    required String neighbourhood,
    required int bhk,
    required int monthlyRent,
    required int depositMonths,
    this.depositAmount = const Value.absent(),
    this.brokerage = const Value.absent(),
    this.societyCharges = const Value.absent(),
    this.maintenance = const Value.absent(),
    required ListingState state,
    required int version,
    required String ownerId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       neighbourhood = Value(neighbourhood),
       bhk = Value(bhk),
       monthlyRent = Value(monthlyRent),
       depositMonths = Value(depositMonths),
       state = Value(state),
       version = Value(version),
       ownerId = Value(ownerId);
  static Insertable<ListingEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? neighbourhood,
    Expression<int>? bhk,
    Expression<int>? monthlyRent,
    Expression<int>? depositMonths,
    Expression<int>? depositAmount,
    Expression<int>? brokerage,
    Expression<int>? societyCharges,
    Expression<int>? maintenance,
    Expression<String>? state,
    Expression<int>? version,
    Expression<String>? ownerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (neighbourhood != null) 'neighbourhood': neighbourhood,
      if (bhk != null) 'bhk': bhk,
      if (monthlyRent != null) 'monthly_rent': monthlyRent,
      if (depositMonths != null) 'deposit_months': depositMonths,
      if (depositAmount != null) 'deposit_amount': depositAmount,
      if (brokerage != null) 'brokerage': brokerage,
      if (societyCharges != null) 'society_charges': societyCharges,
      if (maintenance != null) 'maintenance': maintenance,
      if (state != null) 'state': state,
      if (version != null) 'version': version,
      if (ownerId != null) 'owner_id': ownerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListingsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? neighbourhood,
    Value<int>? bhk,
    Value<int>? monthlyRent,
    Value<int>? depositMonths,
    Value<int?>? depositAmount,
    Value<int?>? brokerage,
    Value<int?>? societyCharges,
    Value<int?>? maintenance,
    Value<ListingState>? state,
    Value<int>? version,
    Value<String>? ownerId,
    Value<int>? rowid,
  }) {
    return ListingsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      neighbourhood: neighbourhood ?? this.neighbourhood,
      bhk: bhk ?? this.bhk,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      depositMonths: depositMonths ?? this.depositMonths,
      depositAmount: depositAmount ?? this.depositAmount,
      brokerage: brokerage ?? this.brokerage,
      societyCharges: societyCharges ?? this.societyCharges,
      maintenance: maintenance ?? this.maintenance,
      state: state ?? this.state,
      version: version ?? this.version,
      ownerId: ownerId ?? this.ownerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (neighbourhood.present) {
      map['neighbourhood'] = Variable<String>(neighbourhood.value);
    }
    if (bhk.present) {
      map['bhk'] = Variable<int>(bhk.value);
    }
    if (monthlyRent.present) {
      map['monthly_rent'] = Variable<int>(monthlyRent.value);
    }
    if (depositMonths.present) {
      map['deposit_months'] = Variable<int>(depositMonths.value);
    }
    if (depositAmount.present) {
      map['deposit_amount'] = Variable<int>(depositAmount.value);
    }
    if (brokerage.present) {
      map['brokerage'] = Variable<int>(brokerage.value);
    }
    if (societyCharges.present) {
      map['society_charges'] = Variable<int>(societyCharges.value);
    }
    if (maintenance.present) {
      map['maintenance'] = Variable<int>(maintenance.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(
        $ListingsTable.$converterstate.toSql(state.value),
      );
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListingsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('neighbourhood: $neighbourhood, ')
          ..write('bhk: $bhk, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('depositMonths: $depositMonths, ')
          ..write('depositAmount: $depositAmount, ')
          ..write('brokerage: $brokerage, ')
          ..write('societyCharges: $societyCharges, ')
          ..write('maintenance: $maintenance, ')
          ..write('state: $state, ')
          ..write('version: $version, ')
          ..write('ownerId: $ownerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RequestsTable extends Requests
    with TableInfo<$RequestsTable, RequestEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _listingIdMeta = const VerificationMeta(
    'listingId',
  );
  @override
  late final GeneratedColumn<String> listingId = GeneratedColumn<String>(
    'listing_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES listings (id)',
    ),
  );
  static const VerificationMeta _renterIdMeta = const VerificationMeta(
    'renterId',
  );
  @override
  late final GeneratedColumn<String> renterId = GeneratedColumn<String>(
    'renter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RequestKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RequestKind>($RequestsTable.$converterkind);
  static const VerificationMeta _preferredWindowMeta = const VerificationMeta(
    'preferredWindow',
  );
  @override
  late final GeneratedColumn<String> preferredWindow = GeneratedColumn<String>(
    'preferred_window',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RequestStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RequestStatus>($RequestsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncState>($RequestsTable.$convertersyncState);
  static const VerificationMeta _clientListingVersionMeta =
      const VerificationMeta('clientListingVersion');
  @override
  late final GeneratedColumn<int> clientListingVersion = GeneratedColumn<int>(
    'client_listing_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reopenReasonMeta = const VerificationMeta(
    'reopenReason',
  );
  @override
  late final GeneratedColumn<String> reopenReason = GeneratedColumn<String>(
    'reopen_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idempotencyKey,
    listingId,
    renterId,
    kind,
    preferredWindow,
    note,
    status,
    syncState,
    clientListingVersion,
    reopenReason,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequestEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('listing_id')) {
      context.handle(
        _listingIdMeta,
        listingId.isAcceptableOrUnknown(data['listing_id']!, _listingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listingIdMeta);
    }
    if (data.containsKey('renter_id')) {
      context.handle(
        _renterIdMeta,
        renterId.isAcceptableOrUnknown(data['renter_id']!, _renterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_renterIdMeta);
    }
    if (data.containsKey('preferred_window')) {
      context.handle(
        _preferredWindowMeta,
        preferredWindow.isAcceptableOrUnknown(
          data['preferred_window']!,
          _preferredWindowMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredWindowMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('client_listing_version')) {
      context.handle(
        _clientListingVersionMeta,
        clientListingVersion.isAcceptableOrUnknown(
          data['client_listing_version']!,
          _clientListingVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientListingVersionMeta);
    }
    if (data.containsKey('reopen_reason')) {
      context.handle(
        _reopenReasonMeta,
        reopenReason.isAcceptableOrUnknown(
          data['reopen_reason']!,
          _reopenReasonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequestEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequestEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      listingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}listing_id'],
      )!,
      renterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}renter_id'],
      )!,
      kind: $RequestsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      preferredWindow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_window'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      status: $RequestsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      syncState: $RequestsTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      clientListingVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_listing_version'],
      )!,
      reopenReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reopen_reason'],
      ),
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
  $RequestsTable createAlias(String alias) {
    return $RequestsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RequestKind, String, String> $converterkind =
      const EnumNameConverter<RequestKind>(RequestKind.values);
  static JsonTypeConverter2<RequestStatus, String, String> $converterstatus =
      const EnumNameConverter<RequestStatus>(RequestStatus.values);
  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class RequestEntity extends DataClass implements Insertable<RequestEntity> {
  final String id;
  final String idempotencyKey;
  final String listingId;
  final String renterId;
  final RequestKind kind;
  final String preferredWindow;
  final String note;
  final RequestStatus status;
  final SyncState syncState;
  final int clientListingVersion;
  final String? reopenReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RequestEntity({
    required this.id,
    required this.idempotencyKey,
    required this.listingId,
    required this.renterId,
    required this.kind,
    required this.preferredWindow,
    required this.note,
    required this.status,
    required this.syncState,
    required this.clientListingVersion,
    this.reopenReason,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['listing_id'] = Variable<String>(listingId);
    map['renter_id'] = Variable<String>(renterId);
    {
      map['kind'] = Variable<String>($RequestsTable.$converterkind.toSql(kind));
    }
    map['preferred_window'] = Variable<String>(preferredWindow);
    map['note'] = Variable<String>(note);
    {
      map['status'] = Variable<String>(
        $RequestsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['sync_state'] = Variable<String>(
        $RequestsTable.$convertersyncState.toSql(syncState),
      );
    }
    map['client_listing_version'] = Variable<int>(clientListingVersion);
    if (!nullToAbsent || reopenReason != null) {
      map['reopen_reason'] = Variable<String>(reopenReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RequestsCompanion toCompanion(bool nullToAbsent) {
    return RequestsCompanion(
      id: Value(id),
      idempotencyKey: Value(idempotencyKey),
      listingId: Value(listingId),
      renterId: Value(renterId),
      kind: Value(kind),
      preferredWindow: Value(preferredWindow),
      note: Value(note),
      status: Value(status),
      syncState: Value(syncState),
      clientListingVersion: Value(clientListingVersion),
      reopenReason: reopenReason == null && nullToAbsent
          ? const Value.absent()
          : Value(reopenReason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RequestEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequestEntity(
      id: serializer.fromJson<String>(json['id']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      listingId: serializer.fromJson<String>(json['listingId']),
      renterId: serializer.fromJson<String>(json['renterId']),
      kind: $RequestsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      preferredWindow: serializer.fromJson<String>(json['preferredWindow']),
      note: serializer.fromJson<String>(json['note']),
      status: $RequestsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      syncState: $RequestsTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      clientListingVersion: serializer.fromJson<int>(
        json['clientListingVersion'],
      ),
      reopenReason: serializer.fromJson<String?>(json['reopenReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'listingId': serializer.toJson<String>(listingId),
      'renterId': serializer.toJson<String>(renterId),
      'kind': serializer.toJson<String>(
        $RequestsTable.$converterkind.toJson(kind),
      ),
      'preferredWindow': serializer.toJson<String>(preferredWindow),
      'note': serializer.toJson<String>(note),
      'status': serializer.toJson<String>(
        $RequestsTable.$converterstatus.toJson(status),
      ),
      'syncState': serializer.toJson<String>(
        $RequestsTable.$convertersyncState.toJson(syncState),
      ),
      'clientListingVersion': serializer.toJson<int>(clientListingVersion),
      'reopenReason': serializer.toJson<String?>(reopenReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RequestEntity copyWith({
    String? id,
    String? idempotencyKey,
    String? listingId,
    String? renterId,
    RequestKind? kind,
    String? preferredWindow,
    String? note,
    RequestStatus? status,
    SyncState? syncState,
    int? clientListingVersion,
    Value<String?> reopenReason = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RequestEntity(
    id: id ?? this.id,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    listingId: listingId ?? this.listingId,
    renterId: renterId ?? this.renterId,
    kind: kind ?? this.kind,
    preferredWindow: preferredWindow ?? this.preferredWindow,
    note: note ?? this.note,
    status: status ?? this.status,
    syncState: syncState ?? this.syncState,
    clientListingVersion: clientListingVersion ?? this.clientListingVersion,
    reopenReason: reopenReason.present ? reopenReason.value : this.reopenReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RequestEntity copyWithCompanion(RequestsCompanion data) {
    return RequestEntity(
      id: data.id.present ? data.id.value : this.id,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      listingId: data.listingId.present ? data.listingId.value : this.listingId,
      renterId: data.renterId.present ? data.renterId.value : this.renterId,
      kind: data.kind.present ? data.kind.value : this.kind,
      preferredWindow: data.preferredWindow.present
          ? data.preferredWindow.value
          : this.preferredWindow,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      clientListingVersion: data.clientListingVersion.present
          ? data.clientListingVersion.value
          : this.clientListingVersion,
      reopenReason: data.reopenReason.present
          ? data.reopenReason.value
          : this.reopenReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequestEntity(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('listingId: $listingId, ')
          ..write('renterId: $renterId, ')
          ..write('kind: $kind, ')
          ..write('preferredWindow: $preferredWindow, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('syncState: $syncState, ')
          ..write('clientListingVersion: $clientListingVersion, ')
          ..write('reopenReason: $reopenReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idempotencyKey,
    listingId,
    renterId,
    kind,
    preferredWindow,
    note,
    status,
    syncState,
    clientListingVersion,
    reopenReason,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestEntity &&
          other.id == this.id &&
          other.idempotencyKey == this.idempotencyKey &&
          other.listingId == this.listingId &&
          other.renterId == this.renterId &&
          other.kind == this.kind &&
          other.preferredWindow == this.preferredWindow &&
          other.note == this.note &&
          other.status == this.status &&
          other.syncState == this.syncState &&
          other.clientListingVersion == this.clientListingVersion &&
          other.reopenReason == this.reopenReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RequestsCompanion extends UpdateCompanion<RequestEntity> {
  final Value<String> id;
  final Value<String> idempotencyKey;
  final Value<String> listingId;
  final Value<String> renterId;
  final Value<RequestKind> kind;
  final Value<String> preferredWindow;
  final Value<String> note;
  final Value<RequestStatus> status;
  final Value<SyncState> syncState;
  final Value<int> clientListingVersion;
  final Value<String?> reopenReason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RequestsCompanion({
    this.id = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.listingId = const Value.absent(),
    this.renterId = const Value.absent(),
    this.kind = const Value.absent(),
    this.preferredWindow = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.syncState = const Value.absent(),
    this.clientListingVersion = const Value.absent(),
    this.reopenReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RequestsCompanion.insert({
    required String id,
    required String idempotencyKey,
    required String listingId,
    required String renterId,
    required RequestKind kind,
    required String preferredWindow,
    required String note,
    required RequestStatus status,
    required SyncState syncState,
    required int clientListingVersion,
    this.reopenReason = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idempotencyKey = Value(idempotencyKey),
       listingId = Value(listingId),
       renterId = Value(renterId),
       kind = Value(kind),
       preferredWindow = Value(preferredWindow),
       note = Value(note),
       status = Value(status),
       syncState = Value(syncState),
       clientListingVersion = Value(clientListingVersion),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RequestEntity> custom({
    Expression<String>? id,
    Expression<String>? idempotencyKey,
    Expression<String>? listingId,
    Expression<String>? renterId,
    Expression<String>? kind,
    Expression<String>? preferredWindow,
    Expression<String>? note,
    Expression<String>? status,
    Expression<String>? syncState,
    Expression<int>? clientListingVersion,
    Expression<String>? reopenReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (listingId != null) 'listing_id': listingId,
      if (renterId != null) 'renter_id': renterId,
      if (kind != null) 'kind': kind,
      if (preferredWindow != null) 'preferred_window': preferredWindow,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (syncState != null) 'sync_state': syncState,
      if (clientListingVersion != null)
        'client_listing_version': clientListingVersion,
      if (reopenReason != null) 'reopen_reason': reopenReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RequestsCompanion copyWith({
    Value<String>? id,
    Value<String>? idempotencyKey,
    Value<String>? listingId,
    Value<String>? renterId,
    Value<RequestKind>? kind,
    Value<String>? preferredWindow,
    Value<String>? note,
    Value<RequestStatus>? status,
    Value<SyncState>? syncState,
    Value<int>? clientListingVersion,
    Value<String?>? reopenReason,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RequestsCompanion(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      listingId: listingId ?? this.listingId,
      renterId: renterId ?? this.renterId,
      kind: kind ?? this.kind,
      preferredWindow: preferredWindow ?? this.preferredWindow,
      note: note ?? this.note,
      status: status ?? this.status,
      syncState: syncState ?? this.syncState,
      clientListingVersion: clientListingVersion ?? this.clientListingVersion,
      reopenReason: reopenReason ?? this.reopenReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (listingId.present) {
      map['listing_id'] = Variable<String>(listingId.value);
    }
    if (renterId.present) {
      map['renter_id'] = Variable<String>(renterId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $RequestsTable.$converterkind.toSql(kind.value),
      );
    }
    if (preferredWindow.present) {
      map['preferred_window'] = Variable<String>(preferredWindow.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $RequestsTable.$converterstatus.toSql(status.value),
      );
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $RequestsTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (clientListingVersion.present) {
      map['client_listing_version'] = Variable<int>(clientListingVersion.value);
    }
    if (reopenReason.present) {
      map['reopen_reason'] = Variable<String>(reopenReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestsCompanion(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('listingId: $listingId, ')
          ..write('renterId: $renterId, ')
          ..write('kind: $kind, ')
          ..write('preferredWindow: $preferredWindow, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('syncState: $syncState, ')
          ..write('clientListingVersion: $clientListingVersion, ')
          ..write('reopenReason: $reopenReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditEventEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correlationIdMeta = const VerificationMeta(
    'correlationId',
  );
  @override
  late final GeneratedColumn<String> correlationId = GeneratedColumn<String>(
    'correlation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentMeta = const VerificationMeta(
    'component',
  );
  @override
  late final GeneratedColumn<String> component = GeneratedColumn<String>(
    'component',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AuditEventType, String>
  eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AuditEventType>($AuditEventsTable.$convertereventType);
  static const VerificationMeta _previousStateMeta = const VerificationMeta(
    'previousState',
  );
  @override
  late final GeneratedColumn<String> previousState = GeneratedColumn<String>(
    'previous_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newStateMeta = const VerificationMeta(
    'newState',
  );
  @override
  late final GeneratedColumn<String> newState = GeneratedColumn<String>(
    'new_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ruleOrErrorCodeMeta = const VerificationMeta(
    'ruleOrErrorCode',
  );
  @override
  late final GeneratedColumn<String> ruleOrErrorCode = GeneratedColumn<String>(
    'rule_or_error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    correlationId,
    component,
    eventType,
    previousState,
    newState,
    ruleOrErrorCode,
    summary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditEventEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('correlation_id')) {
      context.handle(
        _correlationIdMeta,
        correlationId.isAcceptableOrUnknown(
          data['correlation_id']!,
          _correlationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correlationIdMeta);
    }
    if (data.containsKey('component')) {
      context.handle(
        _componentMeta,
        component.isAcceptableOrUnknown(data['component']!, _componentMeta),
      );
    } else if (isInserting) {
      context.missing(_componentMeta);
    }
    if (data.containsKey('previous_state')) {
      context.handle(
        _previousStateMeta,
        previousState.isAcceptableOrUnknown(
          data['previous_state']!,
          _previousStateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousStateMeta);
    }
    if (data.containsKey('new_state')) {
      context.handle(
        _newStateMeta,
        newState.isAcceptableOrUnknown(data['new_state']!, _newStateMeta),
      );
    } else if (isInserting) {
      context.missing(_newStateMeta);
    }
    if (data.containsKey('rule_or_error_code')) {
      context.handle(
        _ruleOrErrorCodeMeta,
        ruleOrErrorCode.isAcceptableOrUnknown(
          data['rule_or_error_code']!,
          _ruleOrErrorCodeMeta,
        ),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEventEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEventEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      correlationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correlation_id'],
      )!,
      component: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component'],
      )!,
      eventType: $AuditEventsTable.$convertereventType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}event_type'],
        )!,
      ),
      previousState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_state'],
      )!,
      newState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_state'],
      )!,
      ruleOrErrorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_or_error_code'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AuditEventType, String, String>
  $convertereventType = const EnumNameConverter<AuditEventType>(
    AuditEventType.values,
  );
}

class AuditEventEntity extends DataClass
    implements Insertable<AuditEventEntity> {
  final int id;
  final DateTime timestamp;
  final String correlationId;
  final String component;
  final AuditEventType eventType;
  final String previousState;
  final String newState;
  final String? ruleOrErrorCode;
  final String summary;
  const AuditEventEntity({
    required this.id,
    required this.timestamp,
    required this.correlationId,
    required this.component,
    required this.eventType,
    required this.previousState,
    required this.newState,
    this.ruleOrErrorCode,
    required this.summary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['correlation_id'] = Variable<String>(correlationId);
    map['component'] = Variable<String>(component);
    {
      map['event_type'] = Variable<String>(
        $AuditEventsTable.$convertereventType.toSql(eventType),
      );
    }
    map['previous_state'] = Variable<String>(previousState);
    map['new_state'] = Variable<String>(newState);
    if (!nullToAbsent || ruleOrErrorCode != null) {
      map['rule_or_error_code'] = Variable<String>(ruleOrErrorCode);
    }
    map['summary'] = Variable<String>(summary);
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      correlationId: Value(correlationId),
      component: Value(component),
      eventType: Value(eventType),
      previousState: Value(previousState),
      newState: Value(newState),
      ruleOrErrorCode: ruleOrErrorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleOrErrorCode),
      summary: Value(summary),
    );
  }

  factory AuditEventEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEventEntity(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      correlationId: serializer.fromJson<String>(json['correlationId']),
      component: serializer.fromJson<String>(json['component']),
      eventType: $AuditEventsTable.$convertereventType.fromJson(
        serializer.fromJson<String>(json['eventType']),
      ),
      previousState: serializer.fromJson<String>(json['previousState']),
      newState: serializer.fromJson<String>(json['newState']),
      ruleOrErrorCode: serializer.fromJson<String?>(json['ruleOrErrorCode']),
      summary: serializer.fromJson<String>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'correlationId': serializer.toJson<String>(correlationId),
      'component': serializer.toJson<String>(component),
      'eventType': serializer.toJson<String>(
        $AuditEventsTable.$convertereventType.toJson(eventType),
      ),
      'previousState': serializer.toJson<String>(previousState),
      'newState': serializer.toJson<String>(newState),
      'ruleOrErrorCode': serializer.toJson<String?>(ruleOrErrorCode),
      'summary': serializer.toJson<String>(summary),
    };
  }

  AuditEventEntity copyWith({
    int? id,
    DateTime? timestamp,
    String? correlationId,
    String? component,
    AuditEventType? eventType,
    String? previousState,
    String? newState,
    Value<String?> ruleOrErrorCode = const Value.absent(),
    String? summary,
  }) => AuditEventEntity(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    correlationId: correlationId ?? this.correlationId,
    component: component ?? this.component,
    eventType: eventType ?? this.eventType,
    previousState: previousState ?? this.previousState,
    newState: newState ?? this.newState,
    ruleOrErrorCode: ruleOrErrorCode.present
        ? ruleOrErrorCode.value
        : this.ruleOrErrorCode,
    summary: summary ?? this.summary,
  );
  AuditEventEntity copyWithCompanion(AuditEventsCompanion data) {
    return AuditEventEntity(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      correlationId: data.correlationId.present
          ? data.correlationId.value
          : this.correlationId,
      component: data.component.present ? data.component.value : this.component,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      previousState: data.previousState.present
          ? data.previousState.value
          : this.previousState,
      newState: data.newState.present ? data.newState.value : this.newState,
      ruleOrErrorCode: data.ruleOrErrorCode.present
          ? data.ruleOrErrorCode.value
          : this.ruleOrErrorCode,
      summary: data.summary.present ? data.summary.value : this.summary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventEntity(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('correlationId: $correlationId, ')
          ..write('component: $component, ')
          ..write('eventType: $eventType, ')
          ..write('previousState: $previousState, ')
          ..write('newState: $newState, ')
          ..write('ruleOrErrorCode: $ruleOrErrorCode, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    correlationId,
    component,
    eventType,
    previousState,
    newState,
    ruleOrErrorCode,
    summary,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEventEntity &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.correlationId == this.correlationId &&
          other.component == this.component &&
          other.eventType == this.eventType &&
          other.previousState == this.previousState &&
          other.newState == this.newState &&
          other.ruleOrErrorCode == this.ruleOrErrorCode &&
          other.summary == this.summary);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEventEntity> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> correlationId;
  final Value<String> component;
  final Value<AuditEventType> eventType;
  final Value<String> previousState;
  final Value<String> newState;
  final Value<String?> ruleOrErrorCode;
  final Value<String> summary;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.correlationId = const Value.absent(),
    this.component = const Value.absent(),
    this.eventType = const Value.absent(),
    this.previousState = const Value.absent(),
    this.newState = const Value.absent(),
    this.ruleOrErrorCode = const Value.absent(),
    this.summary = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required String correlationId,
    required String component,
    required AuditEventType eventType,
    required String previousState,
    required String newState,
    this.ruleOrErrorCode = const Value.absent(),
    required String summary,
  }) : timestamp = Value(timestamp),
       correlationId = Value(correlationId),
       component = Value(component),
       eventType = Value(eventType),
       previousState = Value(previousState),
       newState = Value(newState),
       summary = Value(summary);
  static Insertable<AuditEventEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? correlationId,
    Expression<String>? component,
    Expression<String>? eventType,
    Expression<String>? previousState,
    Expression<String>? newState,
    Expression<String>? ruleOrErrorCode,
    Expression<String>? summary,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (correlationId != null) 'correlation_id': correlationId,
      if (component != null) 'component': component,
      if (eventType != null) 'event_type': eventType,
      if (previousState != null) 'previous_state': previousState,
      if (newState != null) 'new_state': newState,
      if (ruleOrErrorCode != null) 'rule_or_error_code': ruleOrErrorCode,
      if (summary != null) 'summary': summary,
    });
  }

  AuditEventsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? correlationId,
    Value<String>? component,
    Value<AuditEventType>? eventType,
    Value<String>? previousState,
    Value<String>? newState,
    Value<String?>? ruleOrErrorCode,
    Value<String>? summary,
  }) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      correlationId: correlationId ?? this.correlationId,
      component: component ?? this.component,
      eventType: eventType ?? this.eventType,
      previousState: previousState ?? this.previousState,
      newState: newState ?? this.newState,
      ruleOrErrorCode: ruleOrErrorCode ?? this.ruleOrErrorCode,
      summary: summary ?? this.summary,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (correlationId.present) {
      map['correlation_id'] = Variable<String>(correlationId.value);
    }
    if (component.present) {
      map['component'] = Variable<String>(component.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(
        $AuditEventsTable.$convertereventType.toSql(eventType.value),
      );
    }
    if (previousState.present) {
      map['previous_state'] = Variable<String>(previousState.value);
    }
    if (newState.present) {
      map['new_state'] = Variable<String>(newState.value);
    }
    if (ruleOrErrorCode.present) {
      map['rule_or_error_code'] = Variable<String>(ruleOrErrorCode.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('correlationId: $correlationId, ')
          ..write('component: $component, ')
          ..write('eventType: $eventType, ')
          ..write('previousState: $previousState, ')
          ..write('newState: $newState, ')
          ..write('ruleOrErrorCode: $ruleOrErrorCode, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ListingsTable listings = $ListingsTable(this);
  late final $RequestsTable requests = $RequestsTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    listings,
    requests,
    auditEvents,
  ];
}

typedef $$ListingsTableCreateCompanionBuilder =
    ListingsCompanion Function({
      required String id,
      required String title,
      required String neighbourhood,
      required int bhk,
      required int monthlyRent,
      required int depositMonths,
      Value<int?> depositAmount,
      Value<int?> brokerage,
      Value<int?> societyCharges,
      Value<int?> maintenance,
      required ListingState state,
      required int version,
      required String ownerId,
      Value<int> rowid,
    });
typedef $$ListingsTableUpdateCompanionBuilder =
    ListingsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> neighbourhood,
      Value<int> bhk,
      Value<int> monthlyRent,
      Value<int> depositMonths,
      Value<int?> depositAmount,
      Value<int?> brokerage,
      Value<int?> societyCharges,
      Value<int?> maintenance,
      Value<ListingState> state,
      Value<int> version,
      Value<String> ownerId,
      Value<int> rowid,
    });

final class $$ListingsTableReferences
    extends BaseReferences<_$AppDatabase, $ListingsTable, ListingEntity> {
  $$ListingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RequestsTable, List<RequestEntity>>
  _requestsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.requests,
    aliasName: 'listings__id__requests__listing_id',
  );

  $$RequestsTableProcessedTableManager get requestsRefs {
    final manager = $$RequestsTableTableManager(
      $_db,
      $_db.requests,
    ).filter((f) => f.listingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ListingsTableFilterComposer
    extends Composer<_$AppDatabase, $ListingsTable> {
  $$ListingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neighbourhood => $composableBuilder(
    column: $table.neighbourhood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bhk => $composableBuilder(
    column: $table.bhk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depositMonths => $composableBuilder(
    column: $table.depositMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brokerage => $composableBuilder(
    column: $table.brokerage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get societyCharges => $composableBuilder(
    column: $table.societyCharges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maintenance => $composableBuilder(
    column: $table.maintenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ListingState, ListingState, String>
  get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> requestsRefs(
    Expression<bool> Function($$RequestsTableFilterComposer f) f,
  ) {
    final $$RequestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.listingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestsTableFilterComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ListingsTable> {
  $$ListingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neighbourhood => $composableBuilder(
    column: $table.neighbourhood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bhk => $composableBuilder(
    column: $table.bhk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depositMonths => $composableBuilder(
    column: $table.depositMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brokerage => $composableBuilder(
    column: $table.brokerage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get societyCharges => $composableBuilder(
    column: $table.societyCharges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maintenance => $composableBuilder(
    column: $table.maintenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListingsTable> {
  $$ListingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get neighbourhood => $composableBuilder(
    column: $table.neighbourhood,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bhk =>
      $composableBuilder(column: $table.bhk, builder: (column) => column);

  GeneratedColumn<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get depositMonths => $composableBuilder(
    column: $table.depositMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brokerage =>
      $composableBuilder(column: $table.brokerage, builder: (column) => column);

  GeneratedColumn<int> get societyCharges => $composableBuilder(
    column: $table.societyCharges,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maintenance => $composableBuilder(
    column: $table.maintenance,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ListingState, String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  Expression<T> requestsRefs<T extends Object>(
    Expression<T> Function($$RequestsTableAnnotationComposer a) f,
  ) {
    final $$RequestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.listingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestsTableAnnotationComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListingsTable,
          ListingEntity,
          $$ListingsTableFilterComposer,
          $$ListingsTableOrderingComposer,
          $$ListingsTableAnnotationComposer,
          $$ListingsTableCreateCompanionBuilder,
          $$ListingsTableUpdateCompanionBuilder,
          (ListingEntity, $$ListingsTableReferences),
          ListingEntity,
          PrefetchHooks Function({bool requestsRefs})
        > {
  $$ListingsTableTableManager(_$AppDatabase db, $ListingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> neighbourhood = const Value.absent(),
                Value<int> bhk = const Value.absent(),
                Value<int> monthlyRent = const Value.absent(),
                Value<int> depositMonths = const Value.absent(),
                Value<int?> depositAmount = const Value.absent(),
                Value<int?> brokerage = const Value.absent(),
                Value<int?> societyCharges = const Value.absent(),
                Value<int?> maintenance = const Value.absent(),
                Value<ListingState> state = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListingsCompanion(
                id: id,
                title: title,
                neighbourhood: neighbourhood,
                bhk: bhk,
                monthlyRent: monthlyRent,
                depositMonths: depositMonths,
                depositAmount: depositAmount,
                brokerage: brokerage,
                societyCharges: societyCharges,
                maintenance: maintenance,
                state: state,
                version: version,
                ownerId: ownerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String neighbourhood,
                required int bhk,
                required int monthlyRent,
                required int depositMonths,
                Value<int?> depositAmount = const Value.absent(),
                Value<int?> brokerage = const Value.absent(),
                Value<int?> societyCharges = const Value.absent(),
                Value<int?> maintenance = const Value.absent(),
                required ListingState state,
                required int version,
                required String ownerId,
                Value<int> rowid = const Value.absent(),
              }) => ListingsCompanion.insert(
                id: id,
                title: title,
                neighbourhood: neighbourhood,
                bhk: bhk,
                monthlyRent: monthlyRent,
                depositMonths: depositMonths,
                depositAmount: depositAmount,
                brokerage: brokerage,
                societyCharges: societyCharges,
                maintenance: maintenance,
                state: state,
                version: version,
                ownerId: ownerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListingsTable, ListingEntity>(table),
                  $$ListingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({requestsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (requestsRefs) db.requests],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (requestsRefs)
                    await $_getPrefetchedDataByColumns<
                      ListingEntity,
                      $ListingsTable,
                      RequestEntity,
                      $RequestsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ListingsTableReferences
                          ._requestsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ListingsTableReferences(db, table, p0).requestsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'listing_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ListingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListingsTable,
      ListingEntity,
      $$ListingsTableFilterComposer,
      $$ListingsTableOrderingComposer,
      $$ListingsTableAnnotationComposer,
      $$ListingsTableCreateCompanionBuilder,
      $$ListingsTableUpdateCompanionBuilder,
      (ListingEntity, $$ListingsTableReferences),
      ListingEntity,
      PrefetchHooks Function({bool requestsRefs})
    >;
typedef $$RequestsTableCreateCompanionBuilder =
    RequestsCompanion Function({
      required String id,
      required String idempotencyKey,
      required String listingId,
      required String renterId,
      required RequestKind kind,
      required String preferredWindow,
      required String note,
      required RequestStatus status,
      required SyncState syncState,
      required int clientListingVersion,
      Value<String?> reopenReason,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RequestsTableUpdateCompanionBuilder =
    RequestsCompanion Function({
      Value<String> id,
      Value<String> idempotencyKey,
      Value<String> listingId,
      Value<String> renterId,
      Value<RequestKind> kind,
      Value<String> preferredWindow,
      Value<String> note,
      Value<RequestStatus> status,
      Value<SyncState> syncState,
      Value<int> clientListingVersion,
      Value<String?> reopenReason,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RequestsTableReferences
    extends BaseReferences<_$AppDatabase, $RequestsTable, RequestEntity> {
  $$RequestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ListingsTable _listingIdTable(_$AppDatabase db) =>
      db.listings.createAlias('requests__listing_id__listings__id');

  $$ListingsTableProcessedTableManager get listingId {
    final $_column = $_itemColumn<String>('listing_id')!;

    final manager = $$ListingsTableTableManager(
      $_db,
      $_db.listings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RequestsTableFilterComposer
    extends Composer<_$AppDatabase, $RequestsTable> {
  $$RequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get renterId => $composableBuilder(
    column: $table.renterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RequestKind, RequestKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get preferredWindow => $composableBuilder(
    column: $table.preferredWindow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RequestStatus, RequestStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get clientListingVersion => $composableBuilder(
    column: $table.clientListingVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reopenReason => $composableBuilder(
    column: $table.reopenReason,
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

  $$ListingsTableFilterComposer get listingId {
    final $$ListingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listingId,
      referencedTable: $db.listings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListingsTableFilterComposer(
            $db: $db,
            $table: $db.listings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $RequestsTable> {
  $$RequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get renterId => $composableBuilder(
    column: $table.renterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredWindow => $composableBuilder(
    column: $table.preferredWindow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clientListingVersion => $composableBuilder(
    column: $table.clientListingVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reopenReason => $composableBuilder(
    column: $table.reopenReason,
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

  $$ListingsTableOrderingComposer get listingId {
    final $$ListingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listingId,
      referencedTable: $db.listings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListingsTableOrderingComposer(
            $db: $db,
            $table: $db.listings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequestsTable> {
  $$RequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get renterId =>
      $composableBuilder(column: $table.renterId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RequestKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get preferredWindow => $composableBuilder(
    column: $table.preferredWindow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RequestStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<int> get clientListingVersion => $composableBuilder(
    column: $table.clientListingVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reopenReason => $composableBuilder(
    column: $table.reopenReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ListingsTableAnnotationComposer get listingId {
    final $$ListingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listingId,
      referencedTable: $db.listings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListingsTableAnnotationComposer(
            $db: $db,
            $table: $db.listings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequestsTable,
          RequestEntity,
          $$RequestsTableFilterComposer,
          $$RequestsTableOrderingComposer,
          $$RequestsTableAnnotationComposer,
          $$RequestsTableCreateCompanionBuilder,
          $$RequestsTableUpdateCompanionBuilder,
          (RequestEntity, $$RequestsTableReferences),
          RequestEntity,
          PrefetchHooks Function({bool listingId})
        > {
  $$RequestsTableTableManager(_$AppDatabase db, $RequestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> listingId = const Value.absent(),
                Value<String> renterId = const Value.absent(),
                Value<RequestKind> kind = const Value.absent(),
                Value<String> preferredWindow = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<RequestStatus> status = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<int> clientListingVersion = const Value.absent(),
                Value<String?> reopenReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequestsCompanion(
                id: id,
                idempotencyKey: idempotencyKey,
                listingId: listingId,
                renterId: renterId,
                kind: kind,
                preferredWindow: preferredWindow,
                note: note,
                status: status,
                syncState: syncState,
                clientListingVersion: clientListingVersion,
                reopenReason: reopenReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idempotencyKey,
                required String listingId,
                required String renterId,
                required RequestKind kind,
                required String preferredWindow,
                required String note,
                required RequestStatus status,
                required SyncState syncState,
                required int clientListingVersion,
                Value<String?> reopenReason = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RequestsCompanion.insert(
                id: id,
                idempotencyKey: idempotencyKey,
                listingId: listingId,
                renterId: renterId,
                kind: kind,
                preferredWindow: preferredWindow,
                note: note,
                status: status,
                syncState: syncState,
                clientListingVersion: clientListingVersion,
                reopenReason: reopenReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RequestsTable, RequestEntity>(table),
                  $$RequestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listingId = false}) {
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
                    if (listingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listingId,
                                referencedTable: $$RequestsTableReferences
                                    ._listingIdTable(db),
                                referencedColumn: $$RequestsTableReferences
                                    ._listingIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$RequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequestsTable,
      RequestEntity,
      $$RequestsTableFilterComposer,
      $$RequestsTableOrderingComposer,
      $$RequestsTableAnnotationComposer,
      $$RequestsTableCreateCompanionBuilder,
      $$RequestsTableUpdateCompanionBuilder,
      (RequestEntity, $$RequestsTableReferences),
      RequestEntity,
      PrefetchHooks Function({bool listingId})
    >;
typedef $$AuditEventsTableCreateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required String correlationId,
      required String component,
      required AuditEventType eventType,
      required String previousState,
      required String newState,
      Value<String?> ruleOrErrorCode,
      required String summary,
    });
typedef $$AuditEventsTableUpdateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> correlationId,
      Value<String> component,
      Value<AuditEventType> eventType,
      Value<String> previousState,
      Value<String> newState,
      Value<String?> ruleOrErrorCode,
      Value<String> summary,
    });

class $$AuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableFilterComposer({
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

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get component => $composableBuilder(
    column: $table.component,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AuditEventType, AuditEventType, String>
  get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newState => $composableBuilder(
    column: $table.newState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleOrErrorCode => $composableBuilder(
    column: $table.ruleOrErrorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get component => $composableBuilder(
    column: $table.component,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newState => $composableBuilder(
    column: $table.newState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleOrErrorCode => $composableBuilder(
    column: $table.ruleOrErrorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get component =>
      $composableBuilder(column: $table.component, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AuditEventType, String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newState =>
      $composableBuilder(column: $table.newState, builder: (column) => column);

  GeneratedColumn<String> get ruleOrErrorCode => $composableBuilder(
    column: $table.ruleOrErrorCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);
}

class $$AuditEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditEventsTable,
          AuditEventEntity,
          $$AuditEventsTableFilterComposer,
          $$AuditEventsTableOrderingComposer,
          $$AuditEventsTableAnnotationComposer,
          $$AuditEventsTableCreateCompanionBuilder,
          $$AuditEventsTableUpdateCompanionBuilder,
          (
            AuditEventEntity,
            BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEventEntity>,
          ),
          AuditEventEntity,
          PrefetchHooks Function()
        > {
  $$AuditEventsTableTableManager(_$AppDatabase db, $AuditEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> correlationId = const Value.absent(),
                Value<String> component = const Value.absent(),
                Value<AuditEventType> eventType = const Value.absent(),
                Value<String> previousState = const Value.absent(),
                Value<String> newState = const Value.absent(),
                Value<String?> ruleOrErrorCode = const Value.absent(),
                Value<String> summary = const Value.absent(),
              }) => AuditEventsCompanion(
                id: id,
                timestamp: timestamp,
                correlationId: correlationId,
                component: component,
                eventType: eventType,
                previousState: previousState,
                newState: newState,
                ruleOrErrorCode: ruleOrErrorCode,
                summary: summary,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required String correlationId,
                required String component,
                required AuditEventType eventType,
                required String previousState,
                required String newState,
                Value<String?> ruleOrErrorCode = const Value.absent(),
                required String summary,
              }) => AuditEventsCompanion.insert(
                id: id,
                timestamp: timestamp,
                correlationId: correlationId,
                component: component,
                eventType: eventType,
                previousState: previousState,
                newState: newState,
                ruleOrErrorCode: ruleOrErrorCode,
                summary: summary,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditEventsTable, AuditEventEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AuditEventsTable,
                    AuditEventEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditEventsTable,
      AuditEventEntity,
      $$AuditEventsTableFilterComposer,
      $$AuditEventsTableOrderingComposer,
      $$AuditEventsTableAnnotationComposer,
      $$AuditEventsTableCreateCompanionBuilder,
      $$AuditEventsTableUpdateCompanionBuilder,
      (
        AuditEventEntity,
        BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEventEntity>,
      ),
      AuditEventEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ListingsTableTableManager get listings =>
      $$ListingsTableTableManager(_db, _db.listings);
  $$RequestsTableTableManager get requests =>
      $$RequestsTableTableManager(_db, _db.requests);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
}
