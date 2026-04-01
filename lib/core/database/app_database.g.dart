// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InstalacionesTable extends Instalaciones
    with TableInfo<$InstalacionesTable, Instalacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstalacionesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, titulo, fechaCreacion, estado];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'instalaciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Instalacione> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Instalacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Instalacione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
    );
  }

  @override
  $InstalacionesTable createAlias(String alias) {
    return $InstalacionesTable(attachedDatabase, alias);
  }
}

class Instalacione extends DataClass implements Insertable<Instalacione> {
  final int id;
  final String titulo;
  final DateTime fechaCreacion;
  final String estado;
  const Instalacione({
    required this.id,
    required this.titulo,
    required this.fechaCreacion,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titulo'] = Variable<String>(titulo);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  InstalacionesCompanion toCompanion(bool nullToAbsent) {
    return InstalacionesCompanion(
      id: Value(id),
      titulo: Value(titulo),
      fechaCreacion: Value(fechaCreacion),
      estado: Value(estado),
    );
  }

  factory Instalacione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Instalacione(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'estado': serializer.toJson<String>(estado),
    };
  }

  Instalacione copyWith({
    int? id,
    String? titulo,
    DateTime? fechaCreacion,
    String? estado,
  }) => Instalacione(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    estado: estado ?? this.estado,
  );
  Instalacione copyWithCompanion(InstalacionesCompanion data) {
    return Instalacione(
      id: data.id.present ? data.id.value : this.id,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Instalacione(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titulo, fechaCreacion, estado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Instalacione &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.fechaCreacion == this.fechaCreacion &&
          other.estado == this.estado);
}

class InstalacionesCompanion extends UpdateCompanion<Instalacione> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<DateTime> fechaCreacion;
  final Value<String> estado;
  const InstalacionesCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.estado = const Value.absent(),
  });
  InstalacionesCompanion.insert({
    this.id = const Value.absent(),
    required String titulo,
    required DateTime fechaCreacion,
    required String estado,
  }) : titulo = Value(titulo),
       fechaCreacion = Value(fechaCreacion),
       estado = Value(estado);
  static Insertable<Instalacione> custom({
    Expression<int>? id,
    Expression<String>? titulo,
    Expression<DateTime>? fechaCreacion,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (estado != null) 'estado': estado,
    });
  }

  InstalacionesCompanion copyWith({
    Value<int>? id,
    Value<String>? titulo,
    Value<DateTime>? fechaCreacion,
    Value<String>? estado,
  }) {
    return InstalacionesCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstalacionesCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $DimensionamientosTable extends Dimensionamientos
    with TableInfo<$DimensionamientosTable, Dimensionamiento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DimensionamientosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _instalacionIdMeta = const VerificationMeta(
    'instalacionId',
  );
  @override
  late final GeneratedColumn<int> instalacionId = GeneratedColumn<int>(
    'instalacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES instalaciones (id)',
    ),
  );
  static const VerificationMeta _tipoRedMeta = const VerificationMeta(
    'tipoRed',
  );
  @override
  late final GeneratedColumn<String> tipoRed = GeneratedColumn<String>(
    'tipo_red',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _potenciaKwMeta = const VerificationMeta(
    'potenciaKw',
  );
  @override
  late final GeneratedColumn<double> potenciaKw = GeneratedColumn<double>(
    'potencia_kw',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanciaMetrosMeta = const VerificationMeta(
    'distanciaMetros',
  );
  @override
  late final GeneratedColumn<double> distanciaMetros = GeneratedColumn<double>(
    'distancia_metros',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _corrienteCalculadaAMeta =
      const VerificationMeta('corrienteCalculadaA');
  @override
  late final GeneratedColumn<double> corrienteCalculadaA =
      GeneratedColumn<double>(
        'corriente_calculada_a',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _caidaTensionPorcentajeMeta =
      const VerificationMeta('caidaTensionPorcentaje');
  @override
  late final GeneratedColumn<double> caidaTensionPorcentaje =
      GeneratedColumn<double>(
        'caida_tension_porcentaje',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _calibreCableAwgMeta = const VerificationMeta(
    'calibreCableAwg',
  );
  @override
  late final GeneratedColumn<String> calibreCableAwg = GeneratedColumn<String>(
    'calibre_cable_awg',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    instalacionId,
    tipoRed,
    potenciaKw,
    distanciaMetros,
    corrienteCalculadaA,
    caidaTensionPorcentaje,
    calibreCableAwg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dimensionamientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dimensionamiento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('instalacion_id')) {
      context.handle(
        _instalacionIdMeta,
        instalacionId.isAcceptableOrUnknown(
          data['instalacion_id']!,
          _instalacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instalacionIdMeta);
    }
    if (data.containsKey('tipo_red')) {
      context.handle(
        _tipoRedMeta,
        tipoRed.isAcceptableOrUnknown(data['tipo_red']!, _tipoRedMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoRedMeta);
    }
    if (data.containsKey('potencia_kw')) {
      context.handle(
        _potenciaKwMeta,
        potenciaKw.isAcceptableOrUnknown(data['potencia_kw']!, _potenciaKwMeta),
      );
    } else if (isInserting) {
      context.missing(_potenciaKwMeta);
    }
    if (data.containsKey('distancia_metros')) {
      context.handle(
        _distanciaMetrosMeta,
        distanciaMetros.isAcceptableOrUnknown(
          data['distancia_metros']!,
          _distanciaMetrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanciaMetrosMeta);
    }
    if (data.containsKey('corriente_calculada_a')) {
      context.handle(
        _corrienteCalculadaAMeta,
        corrienteCalculadaA.isAcceptableOrUnknown(
          data['corriente_calculada_a']!,
          _corrienteCalculadaAMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_corrienteCalculadaAMeta);
    }
    if (data.containsKey('caida_tension_porcentaje')) {
      context.handle(
        _caidaTensionPorcentajeMeta,
        caidaTensionPorcentaje.isAcceptableOrUnknown(
          data['caida_tension_porcentaje']!,
          _caidaTensionPorcentajeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caidaTensionPorcentajeMeta);
    }
    if (data.containsKey('calibre_cable_awg')) {
      context.handle(
        _calibreCableAwgMeta,
        calibreCableAwg.isAcceptableOrUnknown(
          data['calibre_cable_awg']!,
          _calibreCableAwgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calibreCableAwgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dimensionamiento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dimensionamiento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      instalacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}instalacion_id'],
      )!,
      tipoRed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_red'],
      )!,
      potenciaKw: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}potencia_kw'],
      )!,
      distanciaMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distancia_metros'],
      )!,
      corrienteCalculadaA: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}corriente_calculada_a'],
      )!,
      caidaTensionPorcentaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}caida_tension_porcentaje'],
      )!,
      calibreCableAwg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calibre_cable_awg'],
      )!,
    );
  }

  @override
  $DimensionamientosTable createAlias(String alias) {
    return $DimensionamientosTable(attachedDatabase, alias);
  }
}

class Dimensionamiento extends DataClass
    implements Insertable<Dimensionamiento> {
  final int id;
  final int instalacionId;
  final String tipoRed;
  final double potenciaKw;
  final double distanciaMetros;
  final double corrienteCalculadaA;
  final double caidaTensionPorcentaje;
  final String calibreCableAwg;
  const Dimensionamiento({
    required this.id,
    required this.instalacionId,
    required this.tipoRed,
    required this.potenciaKw,
    required this.distanciaMetros,
    required this.corrienteCalculadaA,
    required this.caidaTensionPorcentaje,
    required this.calibreCableAwg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['instalacion_id'] = Variable<int>(instalacionId);
    map['tipo_red'] = Variable<String>(tipoRed);
    map['potencia_kw'] = Variable<double>(potenciaKw);
    map['distancia_metros'] = Variable<double>(distanciaMetros);
    map['corriente_calculada_a'] = Variable<double>(corrienteCalculadaA);
    map['caida_tension_porcentaje'] = Variable<double>(caidaTensionPorcentaje);
    map['calibre_cable_awg'] = Variable<String>(calibreCableAwg);
    return map;
  }

  DimensionamientosCompanion toCompanion(bool nullToAbsent) {
    return DimensionamientosCompanion(
      id: Value(id),
      instalacionId: Value(instalacionId),
      tipoRed: Value(tipoRed),
      potenciaKw: Value(potenciaKw),
      distanciaMetros: Value(distanciaMetros),
      corrienteCalculadaA: Value(corrienteCalculadaA),
      caidaTensionPorcentaje: Value(caidaTensionPorcentaje),
      calibreCableAwg: Value(calibreCableAwg),
    );
  }

  factory Dimensionamiento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dimensionamiento(
      id: serializer.fromJson<int>(json['id']),
      instalacionId: serializer.fromJson<int>(json['instalacionId']),
      tipoRed: serializer.fromJson<String>(json['tipoRed']),
      potenciaKw: serializer.fromJson<double>(json['potenciaKw']),
      distanciaMetros: serializer.fromJson<double>(json['distanciaMetros']),
      corrienteCalculadaA: serializer.fromJson<double>(
        json['corrienteCalculadaA'],
      ),
      caidaTensionPorcentaje: serializer.fromJson<double>(
        json['caidaTensionPorcentaje'],
      ),
      calibreCableAwg: serializer.fromJson<String>(json['calibreCableAwg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'instalacionId': serializer.toJson<int>(instalacionId),
      'tipoRed': serializer.toJson<String>(tipoRed),
      'potenciaKw': serializer.toJson<double>(potenciaKw),
      'distanciaMetros': serializer.toJson<double>(distanciaMetros),
      'corrienteCalculadaA': serializer.toJson<double>(corrienteCalculadaA),
      'caidaTensionPorcentaje': serializer.toJson<double>(
        caidaTensionPorcentaje,
      ),
      'calibreCableAwg': serializer.toJson<String>(calibreCableAwg),
    };
  }

  Dimensionamiento copyWith({
    int? id,
    int? instalacionId,
    String? tipoRed,
    double? potenciaKw,
    double? distanciaMetros,
    double? corrienteCalculadaA,
    double? caidaTensionPorcentaje,
    String? calibreCableAwg,
  }) => Dimensionamiento(
    id: id ?? this.id,
    instalacionId: instalacionId ?? this.instalacionId,
    tipoRed: tipoRed ?? this.tipoRed,
    potenciaKw: potenciaKw ?? this.potenciaKw,
    distanciaMetros: distanciaMetros ?? this.distanciaMetros,
    corrienteCalculadaA: corrienteCalculadaA ?? this.corrienteCalculadaA,
    caidaTensionPorcentaje:
        caidaTensionPorcentaje ?? this.caidaTensionPorcentaje,
    calibreCableAwg: calibreCableAwg ?? this.calibreCableAwg,
  );
  Dimensionamiento copyWithCompanion(DimensionamientosCompanion data) {
    return Dimensionamiento(
      id: data.id.present ? data.id.value : this.id,
      instalacionId: data.instalacionId.present
          ? data.instalacionId.value
          : this.instalacionId,
      tipoRed: data.tipoRed.present ? data.tipoRed.value : this.tipoRed,
      potenciaKw: data.potenciaKw.present
          ? data.potenciaKw.value
          : this.potenciaKw,
      distanciaMetros: data.distanciaMetros.present
          ? data.distanciaMetros.value
          : this.distanciaMetros,
      corrienteCalculadaA: data.corrienteCalculadaA.present
          ? data.corrienteCalculadaA.value
          : this.corrienteCalculadaA,
      caidaTensionPorcentaje: data.caidaTensionPorcentaje.present
          ? data.caidaTensionPorcentaje.value
          : this.caidaTensionPorcentaje,
      calibreCableAwg: data.calibreCableAwg.present
          ? data.calibreCableAwg.value
          : this.calibreCableAwg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dimensionamiento(')
          ..write('id: $id, ')
          ..write('instalacionId: $instalacionId, ')
          ..write('tipoRed: $tipoRed, ')
          ..write('potenciaKw: $potenciaKw, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('corrienteCalculadaA: $corrienteCalculadaA, ')
          ..write('caidaTensionPorcentaje: $caidaTensionPorcentaje, ')
          ..write('calibreCableAwg: $calibreCableAwg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    instalacionId,
    tipoRed,
    potenciaKw,
    distanciaMetros,
    corrienteCalculadaA,
    caidaTensionPorcentaje,
    calibreCableAwg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dimensionamiento &&
          other.id == this.id &&
          other.instalacionId == this.instalacionId &&
          other.tipoRed == this.tipoRed &&
          other.potenciaKw == this.potenciaKw &&
          other.distanciaMetros == this.distanciaMetros &&
          other.corrienteCalculadaA == this.corrienteCalculadaA &&
          other.caidaTensionPorcentaje == this.caidaTensionPorcentaje &&
          other.calibreCableAwg == this.calibreCableAwg);
}

class DimensionamientosCompanion extends UpdateCompanion<Dimensionamiento> {
  final Value<int> id;
  final Value<int> instalacionId;
  final Value<String> tipoRed;
  final Value<double> potenciaKw;
  final Value<double> distanciaMetros;
  final Value<double> corrienteCalculadaA;
  final Value<double> caidaTensionPorcentaje;
  final Value<String> calibreCableAwg;
  const DimensionamientosCompanion({
    this.id = const Value.absent(),
    this.instalacionId = const Value.absent(),
    this.tipoRed = const Value.absent(),
    this.potenciaKw = const Value.absent(),
    this.distanciaMetros = const Value.absent(),
    this.corrienteCalculadaA = const Value.absent(),
    this.caidaTensionPorcentaje = const Value.absent(),
    this.calibreCableAwg = const Value.absent(),
  });
  DimensionamientosCompanion.insert({
    this.id = const Value.absent(),
    required int instalacionId,
    required String tipoRed,
    required double potenciaKw,
    required double distanciaMetros,
    required double corrienteCalculadaA,
    required double caidaTensionPorcentaje,
    required String calibreCableAwg,
  }) : instalacionId = Value(instalacionId),
       tipoRed = Value(tipoRed),
       potenciaKw = Value(potenciaKw),
       distanciaMetros = Value(distanciaMetros),
       corrienteCalculadaA = Value(corrienteCalculadaA),
       caidaTensionPorcentaje = Value(caidaTensionPorcentaje),
       calibreCableAwg = Value(calibreCableAwg);
  static Insertable<Dimensionamiento> custom({
    Expression<int>? id,
    Expression<int>? instalacionId,
    Expression<String>? tipoRed,
    Expression<double>? potenciaKw,
    Expression<double>? distanciaMetros,
    Expression<double>? corrienteCalculadaA,
    Expression<double>? caidaTensionPorcentaje,
    Expression<String>? calibreCableAwg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (instalacionId != null) 'instalacion_id': instalacionId,
      if (tipoRed != null) 'tipo_red': tipoRed,
      if (potenciaKw != null) 'potencia_kw': potenciaKw,
      if (distanciaMetros != null) 'distancia_metros': distanciaMetros,
      if (corrienteCalculadaA != null)
        'corriente_calculada_a': corrienteCalculadaA,
      if (caidaTensionPorcentaje != null)
        'caida_tension_porcentaje': caidaTensionPorcentaje,
      if (calibreCableAwg != null) 'calibre_cable_awg': calibreCableAwg,
    });
  }

  DimensionamientosCompanion copyWith({
    Value<int>? id,
    Value<int>? instalacionId,
    Value<String>? tipoRed,
    Value<double>? potenciaKw,
    Value<double>? distanciaMetros,
    Value<double>? corrienteCalculadaA,
    Value<double>? caidaTensionPorcentaje,
    Value<String>? calibreCableAwg,
  }) {
    return DimensionamientosCompanion(
      id: id ?? this.id,
      instalacionId: instalacionId ?? this.instalacionId,
      tipoRed: tipoRed ?? this.tipoRed,
      potenciaKw: potenciaKw ?? this.potenciaKw,
      distanciaMetros: distanciaMetros ?? this.distanciaMetros,
      corrienteCalculadaA: corrienteCalculadaA ?? this.corrienteCalculadaA,
      caidaTensionPorcentaje:
          caidaTensionPorcentaje ?? this.caidaTensionPorcentaje,
      calibreCableAwg: calibreCableAwg ?? this.calibreCableAwg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (instalacionId.present) {
      map['instalacion_id'] = Variable<int>(instalacionId.value);
    }
    if (tipoRed.present) {
      map['tipo_red'] = Variable<String>(tipoRed.value);
    }
    if (potenciaKw.present) {
      map['potencia_kw'] = Variable<double>(potenciaKw.value);
    }
    if (distanciaMetros.present) {
      map['distancia_metros'] = Variable<double>(distanciaMetros.value);
    }
    if (corrienteCalculadaA.present) {
      map['corriente_calculada_a'] = Variable<double>(
        corrienteCalculadaA.value,
      );
    }
    if (caidaTensionPorcentaje.present) {
      map['caida_tension_porcentaje'] = Variable<double>(
        caidaTensionPorcentaje.value,
      );
    }
    if (calibreCableAwg.present) {
      map['calibre_cable_awg'] = Variable<String>(calibreCableAwg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DimensionamientosCompanion(')
          ..write('id: $id, ')
          ..write('instalacionId: $instalacionId, ')
          ..write('tipoRed: $tipoRed, ')
          ..write('potenciaKw: $potenciaKw, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('corrienteCalculadaA: $corrienteCalculadaA, ')
          ..write('caidaTensionPorcentaje: $caidaTensionPorcentaje, ')
          ..write('calibreCableAwg: $calibreCableAwg')
          ..write(')'))
        .toString();
  }
}

class $CatalogoMaterialesTable extends CatalogoMateriales
    with TableInfo<$CatalogoMaterialesTable, CatalogoMateriale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoMaterialesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadMedidaMeta = const VerificationMeta(
    'unidadMedida',
  );
  @override
  late final GeneratedColumn<String> unidadMedida = GeneratedColumn<String>(
    'unidad_medida',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoria,
    nombre,
    precioUnitario,
    unidadMedida,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_materiales';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoMateriale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('unidad_medida')) {
      context.handle(
        _unidadMedidaMeta,
        unidadMedida.isAcceptableOrUnknown(
          data['unidad_medida']!,
          _unidadMedidaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unidadMedidaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoMateriale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoMateriale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      unidadMedida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad_medida'],
      )!,
    );
  }

  @override
  $CatalogoMaterialesTable createAlias(String alias) {
    return $CatalogoMaterialesTable(attachedDatabase, alias);
  }
}

class CatalogoMateriale extends DataClass
    implements Insertable<CatalogoMateriale> {
  final int id;
  final String categoria;
  final String nombre;
  final double precioUnitario;
  final String unidadMedida;
  const CatalogoMateriale({
    required this.id,
    required this.categoria,
    required this.nombre,
    required this.precioUnitario,
    required this.unidadMedida,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['categoria'] = Variable<String>(categoria);
    map['nombre'] = Variable<String>(nombre);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['unidad_medida'] = Variable<String>(unidadMedida);
    return map;
  }

  CatalogoMaterialesCompanion toCompanion(bool nullToAbsent) {
    return CatalogoMaterialesCompanion(
      id: Value(id),
      categoria: Value(categoria),
      nombre: Value(nombre),
      precioUnitario: Value(precioUnitario),
      unidadMedida: Value(unidadMedida),
    );
  }

  factory CatalogoMateriale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoMateriale(
      id: serializer.fromJson<int>(json['id']),
      categoria: serializer.fromJson<String>(json['categoria']),
      nombre: serializer.fromJson<String>(json['nombre']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      unidadMedida: serializer.fromJson<String>(json['unidadMedida']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoria': serializer.toJson<String>(categoria),
      'nombre': serializer.toJson<String>(nombre),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'unidadMedida': serializer.toJson<String>(unidadMedida),
    };
  }

  CatalogoMateriale copyWith({
    int? id,
    String? categoria,
    String? nombre,
    double? precioUnitario,
    String? unidadMedida,
  }) => CatalogoMateriale(
    id: id ?? this.id,
    categoria: categoria ?? this.categoria,
    nombre: nombre ?? this.nombre,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    unidadMedida: unidadMedida ?? this.unidadMedida,
  );
  CatalogoMateriale copyWithCompanion(CatalogoMaterialesCompanion data) {
    return CatalogoMateriale(
      id: data.id.present ? data.id.value : this.id,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      unidadMedida: data.unidadMedida.present
          ? data.unidadMedida.value
          : this.unidadMedida,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoMateriale(')
          ..write('id: $id, ')
          ..write('categoria: $categoria, ')
          ..write('nombre: $nombre, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('unidadMedida: $unidadMedida')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoria, nombre, precioUnitario, unidadMedida);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoMateriale &&
          other.id == this.id &&
          other.categoria == this.categoria &&
          other.nombre == this.nombre &&
          other.precioUnitario == this.precioUnitario &&
          other.unidadMedida == this.unidadMedida);
}

class CatalogoMaterialesCompanion extends UpdateCompanion<CatalogoMateriale> {
  final Value<int> id;
  final Value<String> categoria;
  final Value<String> nombre;
  final Value<double> precioUnitario;
  final Value<String> unidadMedida;
  const CatalogoMaterialesCompanion({
    this.id = const Value.absent(),
    this.categoria = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.unidadMedida = const Value.absent(),
  });
  CatalogoMaterialesCompanion.insert({
    this.id = const Value.absent(),
    required String categoria,
    required String nombre,
    required double precioUnitario,
    required String unidadMedida,
  }) : categoria = Value(categoria),
       nombre = Value(nombre),
       precioUnitario = Value(precioUnitario),
       unidadMedida = Value(unidadMedida);
  static Insertable<CatalogoMateriale> custom({
    Expression<int>? id,
    Expression<String>? categoria,
    Expression<String>? nombre,
    Expression<double>? precioUnitario,
    Expression<String>? unidadMedida,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoria != null) 'categoria': categoria,
      if (nombre != null) 'nombre': nombre,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (unidadMedida != null) 'unidad_medida': unidadMedida,
    });
  }

  CatalogoMaterialesCompanion copyWith({
    Value<int>? id,
    Value<String>? categoria,
    Value<String>? nombre,
    Value<double>? precioUnitario,
    Value<String>? unidadMedida,
  }) {
    return CatalogoMaterialesCompanion(
      id: id ?? this.id,
      categoria: categoria ?? this.categoria,
      nombre: nombre ?? this.nombre,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      unidadMedida: unidadMedida ?? this.unidadMedida,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (unidadMedida.present) {
      map['unidad_medida'] = Variable<String>(unidadMedida.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoMaterialesCompanion(')
          ..write('id: $id, ')
          ..write('categoria: $categoria, ')
          ..write('nombre: $nombre, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('unidadMedida: $unidadMedida')
          ..write(')'))
        .toString();
  }
}

class $CotizacionesTable extends Cotizaciones
    with TableInfo<$CotizacionesTable, Cotizacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CotizacionesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _instalacionIdMeta = const VerificationMeta(
    'instalacionId',
  );
  @override
  late final GeneratedColumn<int> instalacionId = GeneratedColumn<int>(
    'instalacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES instalaciones (id)',
    ),
  );
  static const VerificationMeta _nivelComplejidadMeta = const VerificationMeta(
    'nivelComplejidad',
  );
  @override
  late final GeneratedColumn<String> nivelComplejidad = GeneratedColumn<String>(
    'nivel_complejidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMaterialesMeta = const VerificationMeta(
    'totalMateriales',
  );
  @override
  late final GeneratedColumn<double> totalMateriales = GeneratedColumn<double>(
    'total_materiales',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalManoObraMeta = const VerificationMeta(
    'totalManoObra',
  );
  @override
  late final GeneratedColumn<double> totalManoObra = GeneratedColumn<double>(
    'total_mano_obra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _granTotalMeta = const VerificationMeta(
    'granTotal',
  );
  @override
  late final GeneratedColumn<double> granTotal = GeneratedColumn<double>(
    'gran_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaValidezMeta = const VerificationMeta(
    'fechaValidez',
  );
  @override
  late final GeneratedColumn<DateTime> fechaValidez = GeneratedColumn<DateTime>(
    'fecha_validez',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    instalacionId,
    nivelComplejidad,
    totalMateriales,
    totalManoObra,
    granTotal,
    fechaValidez,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cotizaciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cotizacione> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('instalacion_id')) {
      context.handle(
        _instalacionIdMeta,
        instalacionId.isAcceptableOrUnknown(
          data['instalacion_id']!,
          _instalacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instalacionIdMeta);
    }
    if (data.containsKey('nivel_complejidad')) {
      context.handle(
        _nivelComplejidadMeta,
        nivelComplejidad.isAcceptableOrUnknown(
          data['nivel_complejidad']!,
          _nivelComplejidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nivelComplejidadMeta);
    }
    if (data.containsKey('total_materiales')) {
      context.handle(
        _totalMaterialesMeta,
        totalMateriales.isAcceptableOrUnknown(
          data['total_materiales']!,
          _totalMaterialesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalMaterialesMeta);
    }
    if (data.containsKey('total_mano_obra')) {
      context.handle(
        _totalManoObraMeta,
        totalManoObra.isAcceptableOrUnknown(
          data['total_mano_obra']!,
          _totalManoObraMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalManoObraMeta);
    }
    if (data.containsKey('gran_total')) {
      context.handle(
        _granTotalMeta,
        granTotal.isAcceptableOrUnknown(data['gran_total']!, _granTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_granTotalMeta);
    }
    if (data.containsKey('fecha_validez')) {
      context.handle(
        _fechaValidezMeta,
        fechaValidez.isAcceptableOrUnknown(
          data['fecha_validez']!,
          _fechaValidezMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaValidezMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cotizacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cotizacione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      instalacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}instalacion_id'],
      )!,
      nivelComplejidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nivel_complejidad'],
      )!,
      totalMateriales: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_materiales'],
      )!,
      totalManoObra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_mano_obra'],
      )!,
      granTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gran_total'],
      )!,
      fechaValidez: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_validez'],
      )!,
    );
  }

  @override
  $CotizacionesTable createAlias(String alias) {
    return $CotizacionesTable(attachedDatabase, alias);
  }
}

class Cotizacione extends DataClass implements Insertable<Cotizacione> {
  final int id;
  final int instalacionId;
  final String nivelComplejidad;
  final double totalMateriales;
  final double totalManoObra;
  final double granTotal;
  final DateTime fechaValidez;
  const Cotizacione({
    required this.id,
    required this.instalacionId,
    required this.nivelComplejidad,
    required this.totalMateriales,
    required this.totalManoObra,
    required this.granTotal,
    required this.fechaValidez,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['instalacion_id'] = Variable<int>(instalacionId);
    map['nivel_complejidad'] = Variable<String>(nivelComplejidad);
    map['total_materiales'] = Variable<double>(totalMateriales);
    map['total_mano_obra'] = Variable<double>(totalManoObra);
    map['gran_total'] = Variable<double>(granTotal);
    map['fecha_validez'] = Variable<DateTime>(fechaValidez);
    return map;
  }

  CotizacionesCompanion toCompanion(bool nullToAbsent) {
    return CotizacionesCompanion(
      id: Value(id),
      instalacionId: Value(instalacionId),
      nivelComplejidad: Value(nivelComplejidad),
      totalMateriales: Value(totalMateriales),
      totalManoObra: Value(totalManoObra),
      granTotal: Value(granTotal),
      fechaValidez: Value(fechaValidez),
    );
  }

  factory Cotizacione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cotizacione(
      id: serializer.fromJson<int>(json['id']),
      instalacionId: serializer.fromJson<int>(json['instalacionId']),
      nivelComplejidad: serializer.fromJson<String>(json['nivelComplejidad']),
      totalMateriales: serializer.fromJson<double>(json['totalMateriales']),
      totalManoObra: serializer.fromJson<double>(json['totalManoObra']),
      granTotal: serializer.fromJson<double>(json['granTotal']),
      fechaValidez: serializer.fromJson<DateTime>(json['fechaValidez']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'instalacionId': serializer.toJson<int>(instalacionId),
      'nivelComplejidad': serializer.toJson<String>(nivelComplejidad),
      'totalMateriales': serializer.toJson<double>(totalMateriales),
      'totalManoObra': serializer.toJson<double>(totalManoObra),
      'granTotal': serializer.toJson<double>(granTotal),
      'fechaValidez': serializer.toJson<DateTime>(fechaValidez),
    };
  }

  Cotizacione copyWith({
    int? id,
    int? instalacionId,
    String? nivelComplejidad,
    double? totalMateriales,
    double? totalManoObra,
    double? granTotal,
    DateTime? fechaValidez,
  }) => Cotizacione(
    id: id ?? this.id,
    instalacionId: instalacionId ?? this.instalacionId,
    nivelComplejidad: nivelComplejidad ?? this.nivelComplejidad,
    totalMateriales: totalMateriales ?? this.totalMateriales,
    totalManoObra: totalManoObra ?? this.totalManoObra,
    granTotal: granTotal ?? this.granTotal,
    fechaValidez: fechaValidez ?? this.fechaValidez,
  );
  Cotizacione copyWithCompanion(CotizacionesCompanion data) {
    return Cotizacione(
      id: data.id.present ? data.id.value : this.id,
      instalacionId: data.instalacionId.present
          ? data.instalacionId.value
          : this.instalacionId,
      nivelComplejidad: data.nivelComplejidad.present
          ? data.nivelComplejidad.value
          : this.nivelComplejidad,
      totalMateriales: data.totalMateriales.present
          ? data.totalMateriales.value
          : this.totalMateriales,
      totalManoObra: data.totalManoObra.present
          ? data.totalManoObra.value
          : this.totalManoObra,
      granTotal: data.granTotal.present ? data.granTotal.value : this.granTotal,
      fechaValidez: data.fechaValidez.present
          ? data.fechaValidez.value
          : this.fechaValidez,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cotizacione(')
          ..write('id: $id, ')
          ..write('instalacionId: $instalacionId, ')
          ..write('nivelComplejidad: $nivelComplejidad, ')
          ..write('totalMateriales: $totalMateriales, ')
          ..write('totalManoObra: $totalManoObra, ')
          ..write('granTotal: $granTotal, ')
          ..write('fechaValidez: $fechaValidez')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    instalacionId,
    nivelComplejidad,
    totalMateriales,
    totalManoObra,
    granTotal,
    fechaValidez,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cotizacione &&
          other.id == this.id &&
          other.instalacionId == this.instalacionId &&
          other.nivelComplejidad == this.nivelComplejidad &&
          other.totalMateriales == this.totalMateriales &&
          other.totalManoObra == this.totalManoObra &&
          other.granTotal == this.granTotal &&
          other.fechaValidez == this.fechaValidez);
}

class CotizacionesCompanion extends UpdateCompanion<Cotizacione> {
  final Value<int> id;
  final Value<int> instalacionId;
  final Value<String> nivelComplejidad;
  final Value<double> totalMateriales;
  final Value<double> totalManoObra;
  final Value<double> granTotal;
  final Value<DateTime> fechaValidez;
  const CotizacionesCompanion({
    this.id = const Value.absent(),
    this.instalacionId = const Value.absent(),
    this.nivelComplejidad = const Value.absent(),
    this.totalMateriales = const Value.absent(),
    this.totalManoObra = const Value.absent(),
    this.granTotal = const Value.absent(),
    this.fechaValidez = const Value.absent(),
  });
  CotizacionesCompanion.insert({
    this.id = const Value.absent(),
    required int instalacionId,
    required String nivelComplejidad,
    required double totalMateriales,
    required double totalManoObra,
    required double granTotal,
    required DateTime fechaValidez,
  }) : instalacionId = Value(instalacionId),
       nivelComplejidad = Value(nivelComplejidad),
       totalMateriales = Value(totalMateriales),
       totalManoObra = Value(totalManoObra),
       granTotal = Value(granTotal),
       fechaValidez = Value(fechaValidez);
  static Insertable<Cotizacione> custom({
    Expression<int>? id,
    Expression<int>? instalacionId,
    Expression<String>? nivelComplejidad,
    Expression<double>? totalMateriales,
    Expression<double>? totalManoObra,
    Expression<double>? granTotal,
    Expression<DateTime>? fechaValidez,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (instalacionId != null) 'instalacion_id': instalacionId,
      if (nivelComplejidad != null) 'nivel_complejidad': nivelComplejidad,
      if (totalMateriales != null) 'total_materiales': totalMateriales,
      if (totalManoObra != null) 'total_mano_obra': totalManoObra,
      if (granTotal != null) 'gran_total': granTotal,
      if (fechaValidez != null) 'fecha_validez': fechaValidez,
    });
  }

  CotizacionesCompanion copyWith({
    Value<int>? id,
    Value<int>? instalacionId,
    Value<String>? nivelComplejidad,
    Value<double>? totalMateriales,
    Value<double>? totalManoObra,
    Value<double>? granTotal,
    Value<DateTime>? fechaValidez,
  }) {
    return CotizacionesCompanion(
      id: id ?? this.id,
      instalacionId: instalacionId ?? this.instalacionId,
      nivelComplejidad: nivelComplejidad ?? this.nivelComplejidad,
      totalMateriales: totalMateriales ?? this.totalMateriales,
      totalManoObra: totalManoObra ?? this.totalManoObra,
      granTotal: granTotal ?? this.granTotal,
      fechaValidez: fechaValidez ?? this.fechaValidez,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (instalacionId.present) {
      map['instalacion_id'] = Variable<int>(instalacionId.value);
    }
    if (nivelComplejidad.present) {
      map['nivel_complejidad'] = Variable<String>(nivelComplejidad.value);
    }
    if (totalMateriales.present) {
      map['total_materiales'] = Variable<double>(totalMateriales.value);
    }
    if (totalManoObra.present) {
      map['total_mano_obra'] = Variable<double>(totalManoObra.value);
    }
    if (granTotal.present) {
      map['gran_total'] = Variable<double>(granTotal.value);
    }
    if (fechaValidez.present) {
      map['fecha_validez'] = Variable<DateTime>(fechaValidez.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CotizacionesCompanion(')
          ..write('id: $id, ')
          ..write('instalacionId: $instalacionId, ')
          ..write('nivelComplejidad: $nivelComplejidad, ')
          ..write('totalMateriales: $totalMateriales, ')
          ..write('totalManoObra: $totalManoObra, ')
          ..write('granTotal: $granTotal, ')
          ..write('fechaValidez: $fechaValidez')
          ..write(')'))
        .toString();
  }
}

class $CotizacionItemsTable extends CotizacionItems
    with TableInfo<$CotizacionItemsTable, CotizacionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CotizacionItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cotizacionIdMeta = const VerificationMeta(
    'cotizacionId',
  );
  @override
  late final GeneratedColumn<int> cotizacionId = GeneratedColumn<int>(
    'cotizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cotizaciones (id)',
    ),
  );
  static const VerificationMeta _materialIdMeta = const VerificationMeta(
    'materialId',
  );
  @override
  late final GeneratedColumn<int> materialId = GeneratedColumn<int>(
    'material_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalogo_materiales (id)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioHistoricoMeta = const VerificationMeta(
    'precioHistorico',
  );
  @override
  late final GeneratedColumn<double> precioHistorico = GeneratedColumn<double>(
    'precio_historico',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cotizacionId,
    materialId,
    cantidad,
    precioHistorico,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cotizacion_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CotizacionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cotizacion_id')) {
      context.handle(
        _cotizacionIdMeta,
        cotizacionId.isAcceptableOrUnknown(
          data['cotizacion_id']!,
          _cotizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cotizacionIdMeta);
    }
    if (data.containsKey('material_id')) {
      context.handle(
        _materialIdMeta,
        materialId.isAcceptableOrUnknown(data['material_id']!, _materialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materialIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_historico')) {
      context.handle(
        _precioHistoricoMeta,
        precioHistorico.isAcceptableOrUnknown(
          data['precio_historico']!,
          _precioHistoricoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioHistoricoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CotizacionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CotizacionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cotizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cotizacion_id'],
      )!,
      materialId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}material_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cantidad'],
      )!,
      precioHistorico: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_historico'],
      )!,
    );
  }

  @override
  $CotizacionItemsTable createAlias(String alias) {
    return $CotizacionItemsTable(attachedDatabase, alias);
  }
}

class CotizacionItem extends DataClass implements Insertable<CotizacionItem> {
  final int id;
  final int cotizacionId;
  final int materialId;
  final double cantidad;
  final double precioHistorico;
  const CotizacionItem({
    required this.id,
    required this.cotizacionId,
    required this.materialId,
    required this.cantidad,
    required this.precioHistorico,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cotizacion_id'] = Variable<int>(cotizacionId);
    map['material_id'] = Variable<int>(materialId);
    map['cantidad'] = Variable<double>(cantidad);
    map['precio_historico'] = Variable<double>(precioHistorico);
    return map;
  }

  CotizacionItemsCompanion toCompanion(bool nullToAbsent) {
    return CotizacionItemsCompanion(
      id: Value(id),
      cotizacionId: Value(cotizacionId),
      materialId: Value(materialId),
      cantidad: Value(cantidad),
      precioHistorico: Value(precioHistorico),
    );
  }

  factory CotizacionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CotizacionItem(
      id: serializer.fromJson<int>(json['id']),
      cotizacionId: serializer.fromJson<int>(json['cotizacionId']),
      materialId: serializer.fromJson<int>(json['materialId']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      precioHistorico: serializer.fromJson<double>(json['precioHistorico']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cotizacionId': serializer.toJson<int>(cotizacionId),
      'materialId': serializer.toJson<int>(materialId),
      'cantidad': serializer.toJson<double>(cantidad),
      'precioHistorico': serializer.toJson<double>(precioHistorico),
    };
  }

  CotizacionItem copyWith({
    int? id,
    int? cotizacionId,
    int? materialId,
    double? cantidad,
    double? precioHistorico,
  }) => CotizacionItem(
    id: id ?? this.id,
    cotizacionId: cotizacionId ?? this.cotizacionId,
    materialId: materialId ?? this.materialId,
    cantidad: cantidad ?? this.cantidad,
    precioHistorico: precioHistorico ?? this.precioHistorico,
  );
  CotizacionItem copyWithCompanion(CotizacionItemsCompanion data) {
    return CotizacionItem(
      id: data.id.present ? data.id.value : this.id,
      cotizacionId: data.cotizacionId.present
          ? data.cotizacionId.value
          : this.cotizacionId,
      materialId: data.materialId.present
          ? data.materialId.value
          : this.materialId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioHistorico: data.precioHistorico.present
          ? data.precioHistorico.value
          : this.precioHistorico,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CotizacionItem(')
          ..write('id: $id, ')
          ..write('cotizacionId: $cotizacionId, ')
          ..write('materialId: $materialId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioHistorico: $precioHistorico')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cotizacionId, materialId, cantidad, precioHistorico);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CotizacionItem &&
          other.id == this.id &&
          other.cotizacionId == this.cotizacionId &&
          other.materialId == this.materialId &&
          other.cantidad == this.cantidad &&
          other.precioHistorico == this.precioHistorico);
}

class CotizacionItemsCompanion extends UpdateCompanion<CotizacionItem> {
  final Value<int> id;
  final Value<int> cotizacionId;
  final Value<int> materialId;
  final Value<double> cantidad;
  final Value<double> precioHistorico;
  const CotizacionItemsCompanion({
    this.id = const Value.absent(),
    this.cotizacionId = const Value.absent(),
    this.materialId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioHistorico = const Value.absent(),
  });
  CotizacionItemsCompanion.insert({
    this.id = const Value.absent(),
    required int cotizacionId,
    required int materialId,
    required double cantidad,
    required double precioHistorico,
  }) : cotizacionId = Value(cotizacionId),
       materialId = Value(materialId),
       cantidad = Value(cantidad),
       precioHistorico = Value(precioHistorico);
  static Insertable<CotizacionItem> custom({
    Expression<int>? id,
    Expression<int>? cotizacionId,
    Expression<int>? materialId,
    Expression<double>? cantidad,
    Expression<double>? precioHistorico,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cotizacionId != null) 'cotizacion_id': cotizacionId,
      if (materialId != null) 'material_id': materialId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioHistorico != null) 'precio_historico': precioHistorico,
    });
  }

  CotizacionItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? cotizacionId,
    Value<int>? materialId,
    Value<double>? cantidad,
    Value<double>? precioHistorico,
  }) {
    return CotizacionItemsCompanion(
      id: id ?? this.id,
      cotizacionId: cotizacionId ?? this.cotizacionId,
      materialId: materialId ?? this.materialId,
      cantidad: cantidad ?? this.cantidad,
      precioHistorico: precioHistorico ?? this.precioHistorico,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cotizacionId.present) {
      map['cotizacion_id'] = Variable<int>(cotizacionId.value);
    }
    if (materialId.present) {
      map['material_id'] = Variable<int>(materialId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (precioHistorico.present) {
      map['precio_historico'] = Variable<double>(precioHistorico.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CotizacionItemsCompanion(')
          ..write('id: $id, ')
          ..write('cotizacionId: $cotizacionId, ')
          ..write('materialId: $materialId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioHistorico: $precioHistorico')
          ..write(')'))
        .toString();
  }
}

class $CertificacionesChecklistTable extends CertificacionesChecklist
    with
        TableInfo<
          $CertificacionesChecklistTable,
          CertificacionesChecklistData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CertificacionesChecklistTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _instalacionIdMeta = const VerificationMeta(
    'instalacionId',
  );
  @override
  late final GeneratedColumn<int> instalacionId = GeneratedColumn<int>(
    'instalacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES instalaciones (id)',
    ),
  );
  static const VerificationMeta _nombreClienteMeta = const VerificationMeta(
    'nombreCliente',
  );
  @override
  late final GeneratedColumn<String> nombreCliente = GeneratedColumn<String>(
    'nombre_cliente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ciNitClienteMeta = const VerificationMeta(
    'ciNitCliente',
  );
  @override
  late final GeneratedColumn<String> ciNitCliente = GeneratedColumn<String>(
    'ci_nit_cliente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionInstalacionMeta =
      const VerificationMeta('direccionInstalacion');
  @override
  late final GeneratedColumn<String> direccionInstalacion =
      GeneratedColumn<String>(
        'direccion_instalacion',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('Cochabamba, Bolivia'),
      );
  static const VerificationMeta _visFijacionMeta = const VerificationMeta(
    'visFijacion',
  );
  @override
  late final GeneratedColumn<bool> visFijacion = GeneratedColumn<bool>(
    'vis_fijacion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vis_fijacion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _visCablesMeta = const VerificationMeta(
    'visCables',
  );
  @override
  late final GeneratedColumn<bool> visCables = GeneratedColumn<bool>(
    'vis_cables',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vis_cables" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _visProteccionMeta = const VerificationMeta(
    'visProteccion',
  );
  @override
  late final GeneratedColumn<bool> visProteccion = GeneratedColumn<bool>(
    'vis_proteccion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vis_proteccion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _visIdentificacionMeta = const VerificationMeta(
    'visIdentificacion',
  );
  @override
  late final GeneratedColumn<bool> visIdentificacion = GeneratedColumn<bool>(
    'vis_identificacion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vis_identificacion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _visDanosMeta = const VerificationMeta(
    'visDanos',
  );
  @override
  late final GeneratedColumn<bool> visDanos = GeneratedColumn<bool>(
    'vis_danos',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vis_danos" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tensionMedidaVMeta = const VerificationMeta(
    'tensionMedidaV',
  );
  @override
  late final GeneratedColumn<double> tensionMedidaV = GeneratedColumn<double>(
    'tension_medida_v',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resistenciaTierraOhmsMeta =
      const VerificationMeta('resistenciaTierraOhms');
  @override
  late final GeneratedColumn<double> resistenciaTierraOhms =
      GeneratedColumn<double>(
        'resistencia_tierra_ohms',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _elecContinuidadMeta = const VerificationMeta(
    'elecContinuidad',
  );
  @override
  late final GeneratedColumn<bool> elecContinuidad = GeneratedColumn<bool>(
    'elec_continuidad',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("elec_continuidad" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _funEncendidoMeta = const VerificationMeta(
    'funEncendido',
  );
  @override
  late final GeneratedColumn<bool> funEncendido = GeneratedColumn<bool>(
    'fun_encendido',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fun_encendido" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _funCorrienteMeta = const VerificationMeta(
    'funCorriente',
  );
  @override
  late final GeneratedColumn<bool> funCorriente = GeneratedColumn<bool>(
    'fun_corriente',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fun_corriente" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _funTemperaturaMeta = const VerificationMeta(
    'funTemperatura',
  );
  @override
  late final GeneratedColumn<bool> funTemperatura = GeneratedColumn<bool>(
    'fun_temperatura',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fun_temperatura" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _funEmergenciaMeta = const VerificationMeta(
    'funEmergencia',
  );
  @override
  late final GeneratedColumn<bool> funEmergencia = GeneratedColumn<bool>(
    'fun_emergencia',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fun_emergencia" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _docFotoMeta = const VerificationMeta(
    'docFoto',
  );
  @override
  late final GeneratedColumn<bool> docFoto = GeneratedColumn<bool>(
    'doc_foto',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("doc_foto" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _docDiagramaMeta = const VerificationMeta(
    'docDiagrama',
  );
  @override
  late final GeneratedColumn<bool> docDiagrama = GeneratedColumn<bool>(
    'doc_diagrama',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("doc_diagrama" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _docCertificadoTierraMeta =
      const VerificationMeta('docCertificadoTierra');
  @override
  late final GeneratedColumn<bool> docCertificadoTierra = GeneratedColumn<bool>(
    'doc_certificado_tierra',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("doc_certificado_tierra" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _docManualMeta = const VerificationMeta(
    'docManual',
  );
  @override
  late final GeneratedColumn<bool> docManual = GeneratedColumn<bool>(
    'doc_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("doc_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isCompletadoMeta = const VerificationMeta(
    'isCompletado',
  );
  @override
  late final GeneratedColumn<bool> isCompletado = GeneratedColumn<bool>(
    'is_completado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaRegistroMeta = const VerificationMeta(
    'fechaRegistro',
  );
  @override
  late final GeneratedColumn<DateTime> fechaRegistro =
      GeneratedColumn<DateTime>(
        'fecha_registro',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    instalacionId,
    nombreCliente,
    ciNitCliente,
    direccionInstalacion,
    visFijacion,
    visCables,
    visProteccion,
    visIdentificacion,
    visDanos,
    tensionMedidaV,
    resistenciaTierraOhms,
    elecContinuidad,
    funEncendido,
    funCorriente,
    funTemperatura,
    funEmergencia,
    docFoto,
    docDiagrama,
    docCertificadoTierra,
    docManual,
    isCompletado,
    fechaRegistro,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'certificaciones_checklist';
  @override
  VerificationContext validateIntegrity(
    Insertable<CertificacionesChecklistData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('instalacion_id')) {
      context.handle(
        _instalacionIdMeta,
        instalacionId.isAcceptableOrUnknown(
          data['instalacion_id']!,
          _instalacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instalacionIdMeta);
    }
    if (data.containsKey('nombre_cliente')) {
      context.handle(
        _nombreClienteMeta,
        nombreCliente.isAcceptableOrUnknown(
          data['nombre_cliente']!,
          _nombreClienteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreClienteMeta);
    }
    if (data.containsKey('ci_nit_cliente')) {
      context.handle(
        _ciNitClienteMeta,
        ciNitCliente.isAcceptableOrUnknown(
          data['ci_nit_cliente']!,
          _ciNitClienteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ciNitClienteMeta);
    }
    if (data.containsKey('direccion_instalacion')) {
      context.handle(
        _direccionInstalacionMeta,
        direccionInstalacion.isAcceptableOrUnknown(
          data['direccion_instalacion']!,
          _direccionInstalacionMeta,
        ),
      );
    }
    if (data.containsKey('vis_fijacion')) {
      context.handle(
        _visFijacionMeta,
        visFijacion.isAcceptableOrUnknown(
          data['vis_fijacion']!,
          _visFijacionMeta,
        ),
      );
    }
    if (data.containsKey('vis_cables')) {
      context.handle(
        _visCablesMeta,
        visCables.isAcceptableOrUnknown(data['vis_cables']!, _visCablesMeta),
      );
    }
    if (data.containsKey('vis_proteccion')) {
      context.handle(
        _visProteccionMeta,
        visProteccion.isAcceptableOrUnknown(
          data['vis_proteccion']!,
          _visProteccionMeta,
        ),
      );
    }
    if (data.containsKey('vis_identificacion')) {
      context.handle(
        _visIdentificacionMeta,
        visIdentificacion.isAcceptableOrUnknown(
          data['vis_identificacion']!,
          _visIdentificacionMeta,
        ),
      );
    }
    if (data.containsKey('vis_danos')) {
      context.handle(
        _visDanosMeta,
        visDanos.isAcceptableOrUnknown(data['vis_danos']!, _visDanosMeta),
      );
    }
    if (data.containsKey('tension_medida_v')) {
      context.handle(
        _tensionMedidaVMeta,
        tensionMedidaV.isAcceptableOrUnknown(
          data['tension_medida_v']!,
          _tensionMedidaVMeta,
        ),
      );
    }
    if (data.containsKey('resistencia_tierra_ohms')) {
      context.handle(
        _resistenciaTierraOhmsMeta,
        resistenciaTierraOhms.isAcceptableOrUnknown(
          data['resistencia_tierra_ohms']!,
          _resistenciaTierraOhmsMeta,
        ),
      );
    }
    if (data.containsKey('elec_continuidad')) {
      context.handle(
        _elecContinuidadMeta,
        elecContinuidad.isAcceptableOrUnknown(
          data['elec_continuidad']!,
          _elecContinuidadMeta,
        ),
      );
    }
    if (data.containsKey('fun_encendido')) {
      context.handle(
        _funEncendidoMeta,
        funEncendido.isAcceptableOrUnknown(
          data['fun_encendido']!,
          _funEncendidoMeta,
        ),
      );
    }
    if (data.containsKey('fun_corriente')) {
      context.handle(
        _funCorrienteMeta,
        funCorriente.isAcceptableOrUnknown(
          data['fun_corriente']!,
          _funCorrienteMeta,
        ),
      );
    }
    if (data.containsKey('fun_temperatura')) {
      context.handle(
        _funTemperaturaMeta,
        funTemperatura.isAcceptableOrUnknown(
          data['fun_temperatura']!,
          _funTemperaturaMeta,
        ),
      );
    }
    if (data.containsKey('fun_emergencia')) {
      context.handle(
        _funEmergenciaMeta,
        funEmergencia.isAcceptableOrUnknown(
          data['fun_emergencia']!,
          _funEmergenciaMeta,
        ),
      );
    }
    if (data.containsKey('doc_foto')) {
      context.handle(
        _docFotoMeta,
        docFoto.isAcceptableOrUnknown(data['doc_foto']!, _docFotoMeta),
      );
    }
    if (data.containsKey('doc_diagrama')) {
      context.handle(
        _docDiagramaMeta,
        docDiagrama.isAcceptableOrUnknown(
          data['doc_diagrama']!,
          _docDiagramaMeta,
        ),
      );
    }
    if (data.containsKey('doc_certificado_tierra')) {
      context.handle(
        _docCertificadoTierraMeta,
        docCertificadoTierra.isAcceptableOrUnknown(
          data['doc_certificado_tierra']!,
          _docCertificadoTierraMeta,
        ),
      );
    }
    if (data.containsKey('doc_manual')) {
      context.handle(
        _docManualMeta,
        docManual.isAcceptableOrUnknown(data['doc_manual']!, _docManualMeta),
      );
    }
    if (data.containsKey('is_completado')) {
      context.handle(
        _isCompletadoMeta,
        isCompletado.isAcceptableOrUnknown(
          data['is_completado']!,
          _isCompletadoMeta,
        ),
      );
    }
    if (data.containsKey('fecha_registro')) {
      context.handle(
        _fechaRegistroMeta,
        fechaRegistro.isAcceptableOrUnknown(
          data['fecha_registro']!,
          _fechaRegistroMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaRegistroMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CertificacionesChecklistData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CertificacionesChecklistData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      instalacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}instalacion_id'],
      )!,
      nombreCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_cliente'],
      )!,
      ciNitCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ci_nit_cliente'],
      )!,
      direccionInstalacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion_instalacion'],
      )!,
      visFijacion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vis_fijacion'],
      )!,
      visCables: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vis_cables'],
      )!,
      visProteccion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vis_proteccion'],
      )!,
      visIdentificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vis_identificacion'],
      )!,
      visDanos: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vis_danos'],
      )!,
      tensionMedidaV: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tension_medida_v'],
      ),
      resistenciaTierraOhms: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}resistencia_tierra_ohms'],
      ),
      elecContinuidad: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}elec_continuidad'],
      )!,
      funEncendido: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fun_encendido'],
      )!,
      funCorriente: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fun_corriente'],
      )!,
      funTemperatura: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fun_temperatura'],
      )!,
      funEmergencia: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fun_emergencia'],
      )!,
      docFoto: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}doc_foto'],
      )!,
      docDiagrama: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}doc_diagrama'],
      )!,
      docCertificadoTierra: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}doc_certificado_tierra'],
      )!,
      docManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}doc_manual'],
      )!,
      isCompletado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completado'],
      )!,
      fechaRegistro: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_registro'],
      )!,
    );
  }

  @override
  $CertificacionesChecklistTable createAlias(String alias) {
    return $CertificacionesChecklistTable(attachedDatabase, alias);
  }
}

class CertificacionesChecklistData extends DataClass
    implements Insertable<CertificacionesChecklistData> {
  final int id;
  final int instalacionId;
  final String nombreCliente;
  final String ciNitCliente;
  final String direccionInstalacion;
  final bool visFijacion;
  final bool visCables;
  final bool visProteccion;
  final bool visIdentificacion;
  final bool visDanos;
  final double? tensionMedidaV;
  final double? resistenciaTierraOhms;
  final bool elecContinuidad;
  final bool funEncendido;
  final bool funCorriente;
  final bool funTemperatura;
  final bool funEmergencia;
  final bool docFoto;
  final bool docDiagrama;
  final bool docCertificadoTierra;
  final bool docManual;
  final bool isCompletado;
  final DateTime fechaRegistro;
  const CertificacionesChecklistData({
    required this.id,
    required this.instalacionId,
    required this.nombreCliente,
    required this.ciNitCliente,
    required this.direccionInstalacion,
    required this.visFijacion,
    required this.visCables,
    required this.visProteccion,
    required this.visIdentificacion,
    required this.visDanos,
    this.tensionMedidaV,
    this.resistenciaTierraOhms,
    required this.elecContinuidad,
    required this.funEncendido,
    required this.funCorriente,
    required this.funTemperatura,
    required this.funEmergencia,
    required this.docFoto,
    required this.docDiagrama,
    required this.docCertificadoTierra,
    required this.docManual,
    required this.isCompletado,
    required this.fechaRegistro,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['instalacion_id'] = Variable<int>(instalacionId);
    map['nombre_cliente'] = Variable<String>(nombreCliente);
    map['ci_nit_cliente'] = Variable<String>(ciNitCliente);
    map['direccion_instalacion'] = Variable<String>(direccionInstalacion);
    map['vis_fijacion'] = Variable<bool>(visFijacion);
    map['vis_cables'] = Variable<bool>(visCables);
    map['vis_proteccion'] = Variable<bool>(visProteccion);
    map['vis_identificacion'] = Variable<bool>(visIdentificacion);
    map['vis_danos'] = Variable<bool>(visDanos);
    if (!nullToAbsent || tensionMedidaV != null) {
      map['tension_medida_v'] = Variable<double>(tensionMedidaV);
    }
    if (!nullToAbsent || resistenciaTierraOhms != null) {
      map['resistencia_tierra_ohms'] = Variable<double>(resistenciaTierraOhms);
    }
    map['elec_continuidad'] = Variable<bool>(elecContinuidad);
    map['fun_encendido'] = Variable<bool>(funEncendido);
    map['fun_corriente'] = Variable<bool>(funCorriente);
    map['fun_temperatura'] = Variable<bool>(funTemperatura);
    map['fun_emergencia'] = Variable<bool>(funEmergencia);
    map['doc_foto'] = Variable<bool>(docFoto);
    map['doc_diagrama'] = Variable<bool>(docDiagrama);
    map['doc_certificado_tierra'] = Variable<bool>(docCertificadoTierra);
    map['doc_manual'] = Variable<bool>(docManual);
    map['is_completado'] = Variable<bool>(isCompletado);
    map['fecha_registro'] = Variable<DateTime>(fechaRegistro);
    return map;
  }

  CertificacionesChecklistCompanion toCompanion(bool nullToAbsent) {
    return CertificacionesChecklistCompanion(
      id: Value(id),
      instalacionId: Value(instalacionId),
      nombreCliente: Value(nombreCliente),
      ciNitCliente: Value(ciNitCliente),
      direccionInstalacion: Value(direccionInstalacion),
      visFijacion: Value(visFijacion),
      visCables: Value(visCables),
      visProteccion: Value(visProteccion),
      visIdentificacion: Value(visIdentificacion),
      visDanos: Value(visDanos),
      tensionMedidaV: tensionMedidaV == null && nullToAbsent
          ? const Value.absent()
          : Value(tensionMedidaV),
      resistenciaTierraOhms: resistenciaTierraOhms == null && nullToAbsent
          ? const Value.absent()
          : Value(resistenciaTierraOhms),
      elecContinuidad: Value(elecContinuidad),
      funEncendido: Value(funEncendido),
      funCorriente: Value(funCorriente),
      funTemperatura: Value(funTemperatura),
      funEmergencia: Value(funEmergencia),
      docFoto: Value(docFoto),
      docDiagrama: Value(docDiagrama),
      docCertificadoTierra: Value(docCertificadoTierra),
      docManual: Value(docManual),
      isCompletado: Value(isCompletado),
      fechaRegistro: Value(fechaRegistro),
    );
  }

  factory CertificacionesChecklistData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CertificacionesChecklistData(
      id: serializer.fromJson<int>(json['id']),
      instalacionId: serializer.fromJson<int>(json['instalacionId']),
      nombreCliente: serializer.fromJson<String>(json['nombreCliente']),
      ciNitCliente: serializer.fromJson<String>(json['ciNitCliente']),
      direccionInstalacion: serializer.fromJson<String>(
        json['direccionInstalacion'],
      ),
      visFijacion: serializer.fromJson<bool>(json['visFijacion']),
      visCables: serializer.fromJson<bool>(json['visCables']),
      visProteccion: serializer.fromJson<bool>(json['visProteccion']),
      visIdentificacion: serializer.fromJson<bool>(json['visIdentificacion']),
      visDanos: serializer.fromJson<bool>(json['visDanos']),
      tensionMedidaV: serializer.fromJson<double?>(json['tensionMedidaV']),
      resistenciaTierraOhms: serializer.fromJson<double?>(
        json['resistenciaTierraOhms'],
      ),
      elecContinuidad: serializer.fromJson<bool>(json['elecContinuidad']),
      funEncendido: serializer.fromJson<bool>(json['funEncendido']),
      funCorriente: serializer.fromJson<bool>(json['funCorriente']),
      funTemperatura: serializer.fromJson<bool>(json['funTemperatura']),
      funEmergencia: serializer.fromJson<bool>(json['funEmergencia']),
      docFoto: serializer.fromJson<bool>(json['docFoto']),
      docDiagrama: serializer.fromJson<bool>(json['docDiagrama']),
      docCertificadoTierra: serializer.fromJson<bool>(
        json['docCertificadoTierra'],
      ),
      docManual: serializer.fromJson<bool>(json['docManual']),
      isCompletado: serializer.fromJson<bool>(json['isCompletado']),
      fechaRegistro: serializer.fromJson<DateTime>(json['fechaRegistro']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'instalacionId': serializer.toJson<int>(instalacionId),
      'nombreCliente': serializer.toJson<String>(nombreCliente),
      'ciNitCliente': serializer.toJson<String>(ciNitCliente),
      'direccionInstalacion': serializer.toJson<String>(direccionInstalacion),
      'visFijacion': serializer.toJson<bool>(visFijacion),
      'visCables': serializer.toJson<bool>(visCables),
      'visProteccion': serializer.toJson<bool>(visProteccion),
      'visIdentificacion': serializer.toJson<bool>(visIdentificacion),
      'visDanos': serializer.toJson<bool>(visDanos),
      'tensionMedidaV': serializer.toJson<double?>(tensionMedidaV),
      'resistenciaTierraOhms': serializer.toJson<double?>(
        resistenciaTierraOhms,
      ),
      'elecContinuidad': serializer.toJson<bool>(elecContinuidad),
      'funEncendido': serializer.toJson<bool>(funEncendido),
      'funCorriente': serializer.toJson<bool>(funCorriente),
      'funTemperatura': serializer.toJson<bool>(funTemperatura),
      'funEmergencia': serializer.toJson<bool>(funEmergencia),
      'docFoto': serializer.toJson<bool>(docFoto),
      'docDiagrama': serializer.toJson<bool>(docDiagrama),
      'docCertificadoTierra': serializer.toJson<bool>(docCertificadoTierra),
      'docManual': serializer.toJson<bool>(docManual),
      'isCompletado': serializer.toJson<bool>(isCompletado),
      'fechaRegistro': serializer.toJson<DateTime>(fechaRegistro),
    };
  }

  CertificacionesChecklistData copyWith({
    int? id,
    int? instalacionId,
    String? nombreCliente,
    String? ciNitCliente,
    String? direccionInstalacion,
    bool? visFijacion,
    bool? visCables,
    bool? visProteccion,
    bool? visIdentificacion,
    bool? visDanos,
    Value<double?> tensionMedidaV = const Value.absent(),
    Value<double?> resistenciaTierraOhms = const Value.absent(),
    bool? elecContinuidad,
    bool? funEncendido,
    bool? funCorriente,
    bool? funTemperatura,
    bool? funEmergencia,
    bool? docFoto,
    bool? docDiagrama,
    bool? docCertificadoTierra,
    bool? docManual,
    bool? isCompletado,
    DateTime? fechaRegistro,
  }) => CertificacionesChecklistData(
    id: id ?? this.id,
    instalacionId: instalacionId ?? this.instalacionId,
    nombreCliente: nombreCliente ?? this.nombreCliente,
    ciNitCliente: ciNitCliente ?? this.ciNitCliente,
    direccionInstalacion: direccionInstalacion ?? this.direccionInstalacion,
    visFijacion: visFijacion ?? this.visFijacion,
    visCables: visCables ?? this.visCables,
    visProteccion: visProteccion ?? this.visProteccion,
    visIdentificacion: visIdentificacion ?? this.visIdentificacion,
    visDanos: visDanos ?? this.visDanos,
    tensionMedidaV: tensionMedidaV.present
        ? tensionMedidaV.value
        : this.tensionMedidaV,
    resistenciaTierraOhms: resistenciaTierraOhms.present
        ? resistenciaTierraOhms.value
        : this.resistenciaTierraOhms,
    elecContinuidad: elecContinuidad ?? this.elecContinuidad,
    funEncendido: funEncendido ?? this.funEncendido,
    funCorriente: funCorriente ?? this.funCorriente,
    funTemperatura: funTemperatura ?? this.funTemperatura,
    funEmergencia: funEmergencia ?? this.funEmergencia,
    docFoto: docFoto ?? this.docFoto,
    docDiagrama: docDiagrama ?? this.docDiagrama,
    docCertificadoTierra: docCertificadoTierra ?? this.docCertificadoTierra,
    docManual: docManual ?? this.docManual,
    isCompletado: isCompletado ?? this.isCompletado,
    fechaRegistro: fechaRegistro ?? this.fechaRegistro,
  );
  CertificacionesChecklistData copyWithCompanion(
    CertificacionesChecklistCompanion data,
  ) {
    return CertificacionesChecklistData(
      id: data.id.present ? data.id.value : this.id,
      instalacionId: data.instalacionId.present
          ? data.instalacionId.value
          : this.instalacionId,
      nombreCliente: data.nombreCliente.present
          ? data.nombreCliente.value
          : this.nombreCliente,
      ciNitCliente: data.ciNitCliente.present
          ? data.ciNitCliente.value
          : this.ciNitCliente,
      direccionInstalacion: data.direccionInstalacion.present
          ? data.direccionInstalacion.value
          : this.direccionInstalacion,
      visFijacion: data.visFijacion.present
          ? data.visFijacion.value
          : this.visFijacion,
      visCables: data.visCables.present ? data.visCables.value : this.visCables,
      visProteccion: data.visProteccion.present
          ? data.visProteccion.value
          : this.visProteccion,
      visIdentificacion: data.visIdentificacion.present
          ? data.visIdentificacion.value
          : this.visIdentificacion,
      visDanos: data.visDanos.present ? data.visDanos.value : this.visDanos,
      tensionMedidaV: data.tensionMedidaV.present
          ? data.tensionMedidaV.value
          : this.tensionMedidaV,
      resistenciaTierraOhms: data.resistenciaTierraOhms.present
          ? data.resistenciaTierraOhms.value
          : this.resistenciaTierraOhms,
      elecContinuidad: data.elecContinuidad.present
          ? data.elecContinuidad.value
          : this.elecContinuidad,
      funEncendido: data.funEncendido.present
          ? data.funEncendido.value
          : this.funEncendido,
      funCorriente: data.funCorriente.present
          ? data.funCorriente.value
          : this.funCorriente,
      funTemperatura: data.funTemperatura.present
          ? data.funTemperatura.value
          : this.funTemperatura,
      funEmergencia: data.funEmergencia.present
          ? data.funEmergencia.value
          : this.funEmergencia,
      docFoto: data.docFoto.present ? data.docFoto.value : this.docFoto,
      docDiagrama: data.docDiagrama.present
          ? data.docDiagrama.value
          : this.docDiagrama,
      docCertificadoTierra: data.docCertificadoTierra.present
          ? data.docCertificadoTierra.value
          : this.docCertificadoTierra,
      docManual: data.docManual.present ? data.docManual.value : this.docManual,
      isCompletado: data.isCompletado.present
          ? data.isCompletado.value
          : this.isCompletado,
      fechaRegistro: data.fechaRegistro.present
          ? data.fechaRegistro.value
          : this.fechaRegistro,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CertificacionesChecklistData(')
          ..write('id: $id, ')
          ..write('instalacionId: $instalacionId, ')
          ..write('nombreCliente: $nombreCliente, ')
          ..write('ciNitCliente: $ciNitCliente, ')
          ..write('direccionInstalacion: $direccionInstalacion, ')
          ..write('visFijacion: $visFijacion, ')
          ..write('visCables: $visCables, ')
          ..write('visProteccion: $visProteccion, ')
          ..write('visIdentificacion: $visIdentificacion, ')
          ..write('visDanos: $visDanos, ')
          ..write('tensionMedidaV: $tensionMedidaV, ')
          ..write('resistenciaTierraOhms: $resistenciaTierraOhms, ')
          ..write('elecContinuidad: $elecContinuidad, ')
          ..write('funEncendido: $funEncendido, ')
          ..write('funCorriente: $funCorriente, ')
          ..write('funTemperatura: $funTemperatura, ')
          ..write('funEmergencia: $funEmergencia, ')
          ..write('docFoto: $docFoto, ')
          ..write('docDiagrama: $docDiagrama, ')
          ..write('docCertificadoTierra: $docCertificadoTierra, ')
          ..write('docManual: $docManual, ')
          ..write('isCompletado: $isCompletado, ')
          ..write('fechaRegistro: $fechaRegistro')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    instalacionId,
    nombreCliente,
    ciNitCliente,
    direccionInstalacion,
    visFijacion,
    visCables,
    visProteccion,
    visIdentificacion,
    visDanos,
    tensionMedidaV,
    resistenciaTierraOhms,
    elecContinuidad,
    funEncendido,
    funCorriente,
    funTemperatura,
    funEmergencia,
    docFoto,
    docDiagrama,
    docCertificadoTierra,
    docManual,
    isCompletado,
    fechaRegistro,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CertificacionesChecklistData &&
          other.id == this.id &&
          other.instalacionId == this.instalacionId &&
          other.nombreCliente == this.nombreCliente &&
          other.ciNitCliente == this.ciNitCliente &&
          other.direccionInstalacion == this.direccionInstalacion &&
          other.visFijacion == this.visFijacion &&
          other.visCables == this.visCables &&
          other.visProteccion == this.visProteccion &&
          other.visIdentificacion == this.visIdentificacion &&
          other.visDanos == this.visDanos &&
          other.tensionMedidaV == this.tensionMedidaV &&
          other.resistenciaTierraOhms == this.resistenciaTierraOhms &&
          other.elecContinuidad == this.elecContinuidad &&
          other.funEncendido == this.funEncendido &&
          other.funCorriente == this.funCorriente &&
          other.funTemperatura == this.funTemperatura &&
          other.funEmergencia == this.funEmergencia &&
          other.docFoto == this.docFoto &&
          other.docDiagrama == this.docDiagrama &&
          other.docCertificadoTierra == this.docCertificadoTierra &&
          other.docManual == this.docManual &&
          other.isCompletado == this.isCompletado &&
          other.fechaRegistro == this.fechaRegistro);
}

class CertificacionesChecklistCompanion
    extends UpdateCompanion<CertificacionesChecklistData> {
  final Value<int> id;
  final Value<int> instalacionId;
  final Value<String> nombreCliente;
  final Value<String> ciNitCliente;
  final Value<String> direccionInstalacion;
  final Value<bool> visFijacion;
  final Value<bool> visCables;
  final Value<bool> visProteccion;
  final Value<bool> visIdentificacion;
  final Value<bool> visDanos;
  final Value<double?> tensionMedidaV;
  final Value<double?> resistenciaTierraOhms;
  final Value<bool> elecContinuidad;
  final Value<bool> funEncendido;
  final Value<bool> funCorriente;
  final Value<bool> funTemperatura;
  final Value<bool> funEmergencia;
  final Value<bool> docFoto;
  final Value<bool> docDiagrama;
  final Value<bool> docCertificadoTierra;
  final Value<bool> docManual;
  final Value<bool> isCompletado;
  final Value<DateTime> fechaRegistro;
  const CertificacionesChecklistCompanion({
    this.id = const Value.absent(),
    this.instalacionId = const Value.absent(),
    this.nombreCliente = const Value.absent(),
    this.ciNitCliente = const Value.absent(),
    this.direccionInstalacion = const Value.absent(),
    this.visFijacion = const Value.absent(),
    this.visCables = const Value.absent(),
    this.visProteccion = const Value.absent(),
    this.visIdentificacion = const Value.absent(),
    this.visDanos = const Value.absent(),
    this.tensionMedidaV = const Value.absent(),
    this.resistenciaTierraOhms = const Value.absent(),
    this.elecContinuidad = const Value.absent(),
    this.funEncendido = const Value.absent(),
    this.funCorriente = const Value.absent(),
    this.funTemperatura = const Value.absent(),
    this.funEmergencia = const Value.absent(),
    this.docFoto = const Value.absent(),
    this.docDiagrama = const Value.absent(),
    this.docCertificadoTierra = const Value.absent(),
    this.docManual = const Value.absent(),
    this.isCompletado = const Value.absent(),
    this.fechaRegistro = const Value.absent(),
  });
  CertificacionesChecklistCompanion.insert({
    this.id = const Value.absent(),
    required int instalacionId,
    required String nombreCliente,
    required String ciNitCliente,
    this.direccionInstalacion = const Value.absent(),
    this.visFijacion = const Value.absent(),
    this.visCables = const Value.absent(),
    this.visProteccion = const Value.absent(),
    this.visIdentificacion = const Value.absent(),
    this.visDanos = const Value.absent(),
    this.tensionMedidaV = const Value.absent(),
    this.resistenciaTierraOhms = const Value.absent(),
    this.elecContinuidad = const Value.absent(),
    this.funEncendido = const Value.absent(),
    this.funCorriente = const Value.absent(),
    this.funTemperatura = const Value.absent(),
    this.funEmergencia = const Value.absent(),
    this.docFoto = const Value.absent(),
    this.docDiagrama = const Value.absent(),
    this.docCertificadoTierra = const Value.absent(),
    this.docManual = const Value.absent(),
    this.isCompletado = const Value.absent(),
    required DateTime fechaRegistro,
  }) : instalacionId = Value(instalacionId),
       nombreCliente = Value(nombreCliente),
       ciNitCliente = Value(ciNitCliente),
       fechaRegistro = Value(fechaRegistro);
  static Insertable<CertificacionesChecklistData> custom({
    Expression<int>? id,
    Expression<int>? instalacionId,
    Expression<String>? nombreCliente,
    Expression<String>? ciNitCliente,
    Expression<String>? direccionInstalacion,
    Expression<bool>? visFijacion,
    Expression<bool>? visCables,
    Expression<bool>? visProteccion,
    Expression<bool>? visIdentificacion,
    Expression<bool>? visDanos,
    Expression<double>? tensionMedidaV,
    Expression<double>? resistenciaTierraOhms,
    Expression<bool>? elecContinuidad,
    Expression<bool>? funEncendido,
    Expression<bool>? funCorriente,
    Expression<bool>? funTemperatura,
    Expression<bool>? funEmergencia,
    Expression<bool>? docFoto,
    Expression<bool>? docDiagrama,
    Expression<bool>? docCertificadoTierra,
    Expression<bool>? docManual,
    Expression<bool>? isCompletado,
    Expression<DateTime>? fechaRegistro,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (instalacionId != null) 'instalacion_id': instalacionId,
      if (nombreCliente != null) 'nombre_cliente': nombreCliente,
      if (ciNitCliente != null) 'ci_nit_cliente': ciNitCliente,
      if (direccionInstalacion != null)
        'direccion_instalacion': direccionInstalacion,
      if (visFijacion != null) 'vis_fijacion': visFijacion,
      if (visCables != null) 'vis_cables': visCables,
      if (visProteccion != null) 'vis_proteccion': visProteccion,
      if (visIdentificacion != null) 'vis_identificacion': visIdentificacion,
      if (visDanos != null) 'vis_danos': visDanos,
      if (tensionMedidaV != null) 'tension_medida_v': tensionMedidaV,
      if (resistenciaTierraOhms != null)
        'resistencia_tierra_ohms': resistenciaTierraOhms,
      if (elecContinuidad != null) 'elec_continuidad': elecContinuidad,
      if (funEncendido != null) 'fun_encendido': funEncendido,
      if (funCorriente != null) 'fun_corriente': funCorriente,
      if (funTemperatura != null) 'fun_temperatura': funTemperatura,
      if (funEmergencia != null) 'fun_emergencia': funEmergencia,
      if (docFoto != null) 'doc_foto': docFoto,
      if (docDiagrama != null) 'doc_diagrama': docDiagrama,
      if (docCertificadoTierra != null)
        'doc_certificado_tierra': docCertificadoTierra,
      if (docManual != null) 'doc_manual': docManual,
      if (isCompletado != null) 'is_completado': isCompletado,
      if (fechaRegistro != null) 'fecha_registro': fechaRegistro,
    });
  }

  CertificacionesChecklistCompanion copyWith({
    Value<int>? id,
    Value<int>? instalacionId,
    Value<String>? nombreCliente,
    Value<String>? ciNitCliente,
    Value<String>? direccionInstalacion,
    Value<bool>? visFijacion,
    Value<bool>? visCables,
    Value<bool>? visProteccion,
    Value<bool>? visIdentificacion,
    Value<bool>? visDanos,
    Value<double?>? tensionMedidaV,
    Value<double?>? resistenciaTierraOhms,
    Value<bool>? elecContinuidad,
    Value<bool>? funEncendido,
    Value<bool>? funCorriente,
    Value<bool>? funTemperatura,
    Value<bool>? funEmergencia,
    Value<bool>? docFoto,
    Value<bool>? docDiagrama,
    Value<bool>? docCertificadoTierra,
    Value<bool>? docManual,
    Value<bool>? isCompletado,
    Value<DateTime>? fechaRegistro,
  }) {
    return CertificacionesChecklistCompanion(
      id: id ?? this.id,
      instalacionId: instalacionId ?? this.instalacionId,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      ciNitCliente: ciNitCliente ?? this.ciNitCliente,
      direccionInstalacion: direccionInstalacion ?? this.direccionInstalacion,
      visFijacion: visFijacion ?? this.visFijacion,
      visCables: visCables ?? this.visCables,
      visProteccion: visProteccion ?? this.visProteccion,
      visIdentificacion: visIdentificacion ?? this.visIdentificacion,
      visDanos: visDanos ?? this.visDanos,
      tensionMedidaV: tensionMedidaV ?? this.tensionMedidaV,
      resistenciaTierraOhms:
          resistenciaTierraOhms ?? this.resistenciaTierraOhms,
      elecContinuidad: elecContinuidad ?? this.elecContinuidad,
      funEncendido: funEncendido ?? this.funEncendido,
      funCorriente: funCorriente ?? this.funCorriente,
      funTemperatura: funTemperatura ?? this.funTemperatura,
      funEmergencia: funEmergencia ?? this.funEmergencia,
      docFoto: docFoto ?? this.docFoto,
      docDiagrama: docDiagrama ?? this.docDiagrama,
      docCertificadoTierra: docCertificadoTierra ?? this.docCertificadoTierra,
      docManual: docManual ?? this.docManual,
      isCompletado: isCompletado ?? this.isCompletado,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (instalacionId.present) {
      map['instalacion_id'] = Variable<int>(instalacionId.value);
    }
    if (nombreCliente.present) {
      map['nombre_cliente'] = Variable<String>(nombreCliente.value);
    }
    if (ciNitCliente.present) {
      map['ci_nit_cliente'] = Variable<String>(ciNitCliente.value);
    }
    if (direccionInstalacion.present) {
      map['direccion_instalacion'] = Variable<String>(
        direccionInstalacion.value,
      );
    }
    if (visFijacion.present) {
      map['vis_fijacion'] = Variable<bool>(visFijacion.value);
    }
    if (visCables.present) {
      map['vis_cables'] = Variable<bool>(visCables.value);
    }
    if (visProteccion.present) {
      map['vis_proteccion'] = Variable<bool>(visProteccion.value);
    }
    if (visIdentificacion.present) {
      map['vis_identificacion'] = Variable<bool>(visIdentificacion.value);
    }
    if (visDanos.present) {
      map['vis_danos'] = Variable<bool>(visDanos.value);
    }
    if (tensionMedidaV.present) {
      map['tension_medida_v'] = Variable<double>(tensionMedidaV.value);
    }
    if (resistenciaTierraOhms.present) {
      map['resistencia_tierra_ohms'] = Variable<double>(
        resistenciaTierraOhms.value,
      );
    }
    if (elecContinuidad.present) {
      map['elec_continuidad'] = Variable<bool>(elecContinuidad.value);
    }
    if (funEncendido.present) {
      map['fun_encendido'] = Variable<bool>(funEncendido.value);
    }
    if (funCorriente.present) {
      map['fun_corriente'] = Variable<bool>(funCorriente.value);
    }
    if (funTemperatura.present) {
      map['fun_temperatura'] = Variable<bool>(funTemperatura.value);
    }
    if (funEmergencia.present) {
      map['fun_emergencia'] = Variable<bool>(funEmergencia.value);
    }
    if (docFoto.present) {
      map['doc_foto'] = Variable<bool>(docFoto.value);
    }
    if (docDiagrama.present) {
      map['doc_diagrama'] = Variable<bool>(docDiagrama.value);
    }
    if (docCertificadoTierra.present) {
      map['doc_certificado_tierra'] = Variable<bool>(
        docCertificadoTierra.value,
      );
    }
    if (docManual.present) {
      map['doc_manual'] = Variable<bool>(docManual.value);
    }
    if (isCompletado.present) {
      map['is_completado'] = Variable<bool>(isCompletado.value);
    }
    if (fechaRegistro.present) {
      map['fecha_registro'] = Variable<DateTime>(fechaRegistro.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CertificacionesChecklistCompanion(')
          ..write('id: $id, ')
          ..write('instalacionId: $instalacionId, ')
          ..write('nombreCliente: $nombreCliente, ')
          ..write('ciNitCliente: $ciNitCliente, ')
          ..write('direccionInstalacion: $direccionInstalacion, ')
          ..write('visFijacion: $visFijacion, ')
          ..write('visCables: $visCables, ')
          ..write('visProteccion: $visProteccion, ')
          ..write('visIdentificacion: $visIdentificacion, ')
          ..write('visDanos: $visDanos, ')
          ..write('tensionMedidaV: $tensionMedidaV, ')
          ..write('resistenciaTierraOhms: $resistenciaTierraOhms, ')
          ..write('elecContinuidad: $elecContinuidad, ')
          ..write('funEncendido: $funEncendido, ')
          ..write('funCorriente: $funCorriente, ')
          ..write('funTemperatura: $funTemperatura, ')
          ..write('funEmergencia: $funEmergencia, ')
          ..write('docFoto: $docFoto, ')
          ..write('docDiagrama: $docDiagrama, ')
          ..write('docCertificadoTierra: $docCertificadoTierra, ')
          ..write('docManual: $docManual, ')
          ..write('isCompletado: $isCompletado, ')
          ..write('fechaRegistro: $fechaRegistro')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InstalacionesTable instalaciones = $InstalacionesTable(this);
  late final $DimensionamientosTable dimensionamientos =
      $DimensionamientosTable(this);
  late final $CatalogoMaterialesTable catalogoMateriales =
      $CatalogoMaterialesTable(this);
  late final $CotizacionesTable cotizaciones = $CotizacionesTable(this);
  late final $CotizacionItemsTable cotizacionItems = $CotizacionItemsTable(
    this,
  );
  late final $CertificacionesChecklistTable certificacionesChecklist =
      $CertificacionesChecklistTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    instalaciones,
    dimensionamientos,
    catalogoMateriales,
    cotizaciones,
    cotizacionItems,
    certificacionesChecklist,
  ];
}

typedef $$InstalacionesTableCreateCompanionBuilder =
    InstalacionesCompanion Function({
      Value<int> id,
      required String titulo,
      required DateTime fechaCreacion,
      required String estado,
    });
typedef $$InstalacionesTableUpdateCompanionBuilder =
    InstalacionesCompanion Function({
      Value<int> id,
      Value<String> titulo,
      Value<DateTime> fechaCreacion,
      Value<String> estado,
    });

final class $$InstalacionesTableReferences
    extends BaseReferences<_$AppDatabase, $InstalacionesTable, Instalacione> {
  $$InstalacionesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DimensionamientosTable, List<Dimensionamiento>>
  _dimensionamientosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dimensionamientos,
        aliasName: $_aliasNameGenerator(
          db.instalaciones.id,
          db.dimensionamientos.instalacionId,
        ),
      );

  $$DimensionamientosTableProcessedTableManager get dimensionamientosRefs {
    final manager = $$DimensionamientosTableTableManager(
      $_db,
      $_db.dimensionamientos,
    ).filter((f) => f.instalacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dimensionamientosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CotizacionesTable, List<Cotizacione>>
  _cotizacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cotizaciones,
    aliasName: $_aliasNameGenerator(
      db.instalaciones.id,
      db.cotizaciones.instalacionId,
    ),
  );

  $$CotizacionesTableProcessedTableManager get cotizacionesRefs {
    final manager = $$CotizacionesTableTableManager(
      $_db,
      $_db.cotizaciones,
    ).filter((f) => f.instalacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cotizacionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CertificacionesChecklistTable,
    List<CertificacionesChecklistData>
  >
  _certificacionesChecklistRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.certificacionesChecklist,
        aliasName: $_aliasNameGenerator(
          db.instalaciones.id,
          db.certificacionesChecklist.instalacionId,
        ),
      );

  $$CertificacionesChecklistTableProcessedTableManager
  get certificacionesChecklistRefs {
    final manager = $$CertificacionesChecklistTableTableManager(
      $_db,
      $_db.certificacionesChecklist,
    ).filter((f) => f.instalacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _certificacionesChecklistRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InstalacionesTableFilterComposer
    extends Composer<_$AppDatabase, $InstalacionesTable> {
  $$InstalacionesTableFilterComposer({
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

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dimensionamientosRefs(
    Expression<bool> Function($$DimensionamientosTableFilterComposer f) f,
  ) {
    final $$DimensionamientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dimensionamientos,
      getReferencedColumn: (t) => t.instalacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionamientosTableFilterComposer(
            $db: $db,
            $table: $db.dimensionamientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cotizacionesRefs(
    Expression<bool> Function($$CotizacionesTableFilterComposer f) f,
  ) {
    final $$CotizacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizaciones,
      getReferencedColumn: (t) => t.instalacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionesTableFilterComposer(
            $db: $db,
            $table: $db.cotizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> certificacionesChecklistRefs(
    Expression<bool> Function($$CertificacionesChecklistTableFilterComposer f)
    f,
  ) {
    final $$CertificacionesChecklistTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.certificacionesChecklist,
          getReferencedColumn: (t) => t.instalacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CertificacionesChecklistTableFilterComposer(
                $db: $db,
                $table: $db.certificacionesChecklist,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InstalacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $InstalacionesTable> {
  $$InstalacionesTableOrderingComposer({
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

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstalacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstalacionesTable> {
  $$InstalacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  Expression<T> dimensionamientosRefs<T extends Object>(
    Expression<T> Function($$DimensionamientosTableAnnotationComposer a) f,
  ) {
    final $$DimensionamientosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dimensionamientos,
          getReferencedColumn: (t) => t.instalacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DimensionamientosTableAnnotationComposer(
                $db: $db,
                $table: $db.dimensionamientos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> cotizacionesRefs<T extends Object>(
    Expression<T> Function($$CotizacionesTableAnnotationComposer a) f,
  ) {
    final $$CotizacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizaciones,
      getReferencedColumn: (t) => t.instalacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.cotizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> certificacionesChecklistRefs<T extends Object>(
    Expression<T> Function($$CertificacionesChecklistTableAnnotationComposer a)
    f,
  ) {
    final $$CertificacionesChecklistTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.certificacionesChecklist,
          getReferencedColumn: (t) => t.instalacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CertificacionesChecklistTableAnnotationComposer(
                $db: $db,
                $table: $db.certificacionesChecklist,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InstalacionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstalacionesTable,
          Instalacione,
          $$InstalacionesTableFilterComposer,
          $$InstalacionesTableOrderingComposer,
          $$InstalacionesTableAnnotationComposer,
          $$InstalacionesTableCreateCompanionBuilder,
          $$InstalacionesTableUpdateCompanionBuilder,
          (Instalacione, $$InstalacionesTableReferences),
          Instalacione,
          PrefetchHooks Function({
            bool dimensionamientosRefs,
            bool cotizacionesRefs,
            bool certificacionesChecklistRefs,
          })
        > {
  $$InstalacionesTableTableManager(_$AppDatabase db, $InstalacionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstalacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstalacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstalacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => InstalacionesCompanion(
                id: id,
                titulo: titulo,
                fechaCreacion: fechaCreacion,
                estado: estado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titulo,
                required DateTime fechaCreacion,
                required String estado,
              }) => InstalacionesCompanion.insert(
                id: id,
                titulo: titulo,
                fechaCreacion: fechaCreacion,
                estado: estado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InstalacionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                dimensionamientosRefs = false,
                cotizacionesRefs = false,
                certificacionesChecklistRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dimensionamientosRefs) db.dimensionamientos,
                    if (cotizacionesRefs) db.cotizaciones,
                    if (certificacionesChecklistRefs)
                      db.certificacionesChecklist,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dimensionamientosRefs)
                        await $_getPrefetchedData<
                          Instalacione,
                          $InstalacionesTable,
                          Dimensionamiento
                        >(
                          currentTable: table,
                          referencedTable: $$InstalacionesTableReferences
                              ._dimensionamientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InstalacionesTableReferences(
                                db,
                                table,
                                p0,
                              ).dimensionamientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.instalacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cotizacionesRefs)
                        await $_getPrefetchedData<
                          Instalacione,
                          $InstalacionesTable,
                          Cotizacione
                        >(
                          currentTable: table,
                          referencedTable: $$InstalacionesTableReferences
                              ._cotizacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InstalacionesTableReferences(
                                db,
                                table,
                                p0,
                              ).cotizacionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.instalacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (certificacionesChecklistRefs)
                        await $_getPrefetchedData<
                          Instalacione,
                          $InstalacionesTable,
                          CertificacionesChecklistData
                        >(
                          currentTable: table,
                          referencedTable: $$InstalacionesTableReferences
                              ._certificacionesChecklistRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InstalacionesTableReferences(
                                db,
                                table,
                                p0,
                              ).certificacionesChecklistRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.instalacionId == item.id,
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

typedef $$InstalacionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstalacionesTable,
      Instalacione,
      $$InstalacionesTableFilterComposer,
      $$InstalacionesTableOrderingComposer,
      $$InstalacionesTableAnnotationComposer,
      $$InstalacionesTableCreateCompanionBuilder,
      $$InstalacionesTableUpdateCompanionBuilder,
      (Instalacione, $$InstalacionesTableReferences),
      Instalacione,
      PrefetchHooks Function({
        bool dimensionamientosRefs,
        bool cotizacionesRefs,
        bool certificacionesChecklistRefs,
      })
    >;
typedef $$DimensionamientosTableCreateCompanionBuilder =
    DimensionamientosCompanion Function({
      Value<int> id,
      required int instalacionId,
      required String tipoRed,
      required double potenciaKw,
      required double distanciaMetros,
      required double corrienteCalculadaA,
      required double caidaTensionPorcentaje,
      required String calibreCableAwg,
    });
typedef $$DimensionamientosTableUpdateCompanionBuilder =
    DimensionamientosCompanion Function({
      Value<int> id,
      Value<int> instalacionId,
      Value<String> tipoRed,
      Value<double> potenciaKw,
      Value<double> distanciaMetros,
      Value<double> corrienteCalculadaA,
      Value<double> caidaTensionPorcentaje,
      Value<String> calibreCableAwg,
    });

final class $$DimensionamientosTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DimensionamientosTable,
          Dimensionamiento
        > {
  $$DimensionamientosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InstalacionesTable _instalacionIdTable(_$AppDatabase db) =>
      db.instalaciones.createAlias(
        $_aliasNameGenerator(
          db.dimensionamientos.instalacionId,
          db.instalaciones.id,
        ),
      );

  $$InstalacionesTableProcessedTableManager get instalacionId {
    final $_column = $_itemColumn<int>('instalacion_id')!;

    final manager = $$InstalacionesTableTableManager(
      $_db,
      $_db.instalaciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_instalacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DimensionamientosTableFilterComposer
    extends Composer<_$AppDatabase, $DimensionamientosTable> {
  $$DimensionamientosTableFilterComposer({
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

  ColumnFilters<String> get tipoRed => $composableBuilder(
    column: $table.tipoRed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get potenciaKw => $composableBuilder(
    column: $table.potenciaKw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get corrienteCalculadaA => $composableBuilder(
    column: $table.corrienteCalculadaA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caidaTensionPorcentaje => $composableBuilder(
    column: $table.caidaTensionPorcentaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calibreCableAwg => $composableBuilder(
    column: $table.calibreCableAwg,
    builder: (column) => ColumnFilters(column),
  );

  $$InstalacionesTableFilterComposer get instalacionId {
    final $$InstalacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableFilterComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DimensionamientosTableOrderingComposer
    extends Composer<_$AppDatabase, $DimensionamientosTable> {
  $$DimensionamientosTableOrderingComposer({
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

  ColumnOrderings<String> get tipoRed => $composableBuilder(
    column: $table.tipoRed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get potenciaKw => $composableBuilder(
    column: $table.potenciaKw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get corrienteCalculadaA => $composableBuilder(
    column: $table.corrienteCalculadaA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caidaTensionPorcentaje => $composableBuilder(
    column: $table.caidaTensionPorcentaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calibreCableAwg => $composableBuilder(
    column: $table.calibreCableAwg,
    builder: (column) => ColumnOrderings(column),
  );

  $$InstalacionesTableOrderingComposer get instalacionId {
    final $$InstalacionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableOrderingComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DimensionamientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DimensionamientosTable> {
  $$DimensionamientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoRed =>
      $composableBuilder(column: $table.tipoRed, builder: (column) => column);

  GeneratedColumn<double> get potenciaKw => $composableBuilder(
    column: $table.potenciaKw,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => column,
  );

  GeneratedColumn<double> get corrienteCalculadaA => $composableBuilder(
    column: $table.corrienteCalculadaA,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caidaTensionPorcentaje => $composableBuilder(
    column: $table.caidaTensionPorcentaje,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calibreCableAwg => $composableBuilder(
    column: $table.calibreCableAwg,
    builder: (column) => column,
  );

  $$InstalacionesTableAnnotationComposer get instalacionId {
    final $$InstalacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DimensionamientosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DimensionamientosTable,
          Dimensionamiento,
          $$DimensionamientosTableFilterComposer,
          $$DimensionamientosTableOrderingComposer,
          $$DimensionamientosTableAnnotationComposer,
          $$DimensionamientosTableCreateCompanionBuilder,
          $$DimensionamientosTableUpdateCompanionBuilder,
          (Dimensionamiento, $$DimensionamientosTableReferences),
          Dimensionamiento,
          PrefetchHooks Function({bool instalacionId})
        > {
  $$DimensionamientosTableTableManager(
    _$AppDatabase db,
    $DimensionamientosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DimensionamientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DimensionamientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DimensionamientosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> instalacionId = const Value.absent(),
                Value<String> tipoRed = const Value.absent(),
                Value<double> potenciaKw = const Value.absent(),
                Value<double> distanciaMetros = const Value.absent(),
                Value<double> corrienteCalculadaA = const Value.absent(),
                Value<double> caidaTensionPorcentaje = const Value.absent(),
                Value<String> calibreCableAwg = const Value.absent(),
              }) => DimensionamientosCompanion(
                id: id,
                instalacionId: instalacionId,
                tipoRed: tipoRed,
                potenciaKw: potenciaKw,
                distanciaMetros: distanciaMetros,
                corrienteCalculadaA: corrienteCalculadaA,
                caidaTensionPorcentaje: caidaTensionPorcentaje,
                calibreCableAwg: calibreCableAwg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int instalacionId,
                required String tipoRed,
                required double potenciaKw,
                required double distanciaMetros,
                required double corrienteCalculadaA,
                required double caidaTensionPorcentaje,
                required String calibreCableAwg,
              }) => DimensionamientosCompanion.insert(
                id: id,
                instalacionId: instalacionId,
                tipoRed: tipoRed,
                potenciaKw: potenciaKw,
                distanciaMetros: distanciaMetros,
                corrienteCalculadaA: corrienteCalculadaA,
                caidaTensionPorcentaje: caidaTensionPorcentaje,
                calibreCableAwg: calibreCableAwg,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DimensionamientosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({instalacionId = false}) {
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
                    if (instalacionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.instalacionId,
                                referencedTable:
                                    $$DimensionamientosTableReferences
                                        ._instalacionIdTable(db),
                                referencedColumn:
                                    $$DimensionamientosTableReferences
                                        ._instalacionIdTable(db)
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

typedef $$DimensionamientosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DimensionamientosTable,
      Dimensionamiento,
      $$DimensionamientosTableFilterComposer,
      $$DimensionamientosTableOrderingComposer,
      $$DimensionamientosTableAnnotationComposer,
      $$DimensionamientosTableCreateCompanionBuilder,
      $$DimensionamientosTableUpdateCompanionBuilder,
      (Dimensionamiento, $$DimensionamientosTableReferences),
      Dimensionamiento,
      PrefetchHooks Function({bool instalacionId})
    >;
typedef $$CatalogoMaterialesTableCreateCompanionBuilder =
    CatalogoMaterialesCompanion Function({
      Value<int> id,
      required String categoria,
      required String nombre,
      required double precioUnitario,
      required String unidadMedida,
    });
typedef $$CatalogoMaterialesTableUpdateCompanionBuilder =
    CatalogoMaterialesCompanion Function({
      Value<int> id,
      Value<String> categoria,
      Value<String> nombre,
      Value<double> precioUnitario,
      Value<String> unidadMedida,
    });

final class $$CatalogoMaterialesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CatalogoMaterialesTable,
          CatalogoMateriale
        > {
  $$CatalogoMaterialesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CotizacionItemsTable, List<CotizacionItem>>
  _cotizacionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cotizacionItems,
    aliasName: $_aliasNameGenerator(
      db.catalogoMateriales.id,
      db.cotizacionItems.materialId,
    ),
  );

  $$CotizacionItemsTableProcessedTableManager get cotizacionItemsRefs {
    final manager = $$CotizacionItemsTableTableManager(
      $_db,
      $_db.cotizacionItems,
    ).filter((f) => f.materialId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cotizacionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatalogoMaterialesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoMaterialesTable> {
  $$CatalogoMaterialesTableFilterComposer({
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

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidadMedida => $composableBuilder(
    column: $table.unidadMedida,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cotizacionItemsRefs(
    Expression<bool> Function($$CotizacionItemsTableFilterComposer f) f,
  ) {
    final $$CotizacionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizacionItems,
      getReferencedColumn: (t) => t.materialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionItemsTableFilterComposer(
            $db: $db,
            $table: $db.cotizacionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoMaterialesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoMaterialesTable> {
  $$CatalogoMaterialesTableOrderingComposer({
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

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidadMedida => $composableBuilder(
    column: $table.unidadMedida,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoMaterialesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoMaterialesTable> {
  $$CatalogoMaterialesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unidadMedida => $composableBuilder(
    column: $table.unidadMedida,
    builder: (column) => column,
  );

  Expression<T> cotizacionItemsRefs<T extends Object>(
    Expression<T> Function($$CotizacionItemsTableAnnotationComposer a) f,
  ) {
    final $$CotizacionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizacionItems,
      getReferencedColumn: (t) => t.materialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cotizacionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoMaterialesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoMaterialesTable,
          CatalogoMateriale,
          $$CatalogoMaterialesTableFilterComposer,
          $$CatalogoMaterialesTableOrderingComposer,
          $$CatalogoMaterialesTableAnnotationComposer,
          $$CatalogoMaterialesTableCreateCompanionBuilder,
          $$CatalogoMaterialesTableUpdateCompanionBuilder,
          (CatalogoMateriale, $$CatalogoMaterialesTableReferences),
          CatalogoMateriale,
          PrefetchHooks Function({bool cotizacionItemsRefs})
        > {
  $$CatalogoMaterialesTableTableManager(
    _$AppDatabase db,
    $CatalogoMaterialesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoMaterialesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoMaterialesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoMaterialesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<String> unidadMedida = const Value.absent(),
              }) => CatalogoMaterialesCompanion(
                id: id,
                categoria: categoria,
                nombre: nombre,
                precioUnitario: precioUnitario,
                unidadMedida: unidadMedida,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoria,
                required String nombre,
                required double precioUnitario,
                required String unidadMedida,
              }) => CatalogoMaterialesCompanion.insert(
                id: id,
                categoria: categoria,
                nombre: nombre,
                precioUnitario: precioUnitario,
                unidadMedida: unidadMedida,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatalogoMaterialesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cotizacionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cotizacionItemsRefs) db.cotizacionItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cotizacionItemsRefs)
                    await $_getPrefetchedData<
                      CatalogoMateriale,
                      $CatalogoMaterialesTable,
                      CotizacionItem
                    >(
                      currentTable: table,
                      referencedTable: $$CatalogoMaterialesTableReferences
                          ._cotizacionItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CatalogoMaterialesTableReferences(
                            db,
                            table,
                            p0,
                          ).cotizacionItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.materialId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CatalogoMaterialesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoMaterialesTable,
      CatalogoMateriale,
      $$CatalogoMaterialesTableFilterComposer,
      $$CatalogoMaterialesTableOrderingComposer,
      $$CatalogoMaterialesTableAnnotationComposer,
      $$CatalogoMaterialesTableCreateCompanionBuilder,
      $$CatalogoMaterialesTableUpdateCompanionBuilder,
      (CatalogoMateriale, $$CatalogoMaterialesTableReferences),
      CatalogoMateriale,
      PrefetchHooks Function({bool cotizacionItemsRefs})
    >;
typedef $$CotizacionesTableCreateCompanionBuilder =
    CotizacionesCompanion Function({
      Value<int> id,
      required int instalacionId,
      required String nivelComplejidad,
      required double totalMateriales,
      required double totalManoObra,
      required double granTotal,
      required DateTime fechaValidez,
    });
typedef $$CotizacionesTableUpdateCompanionBuilder =
    CotizacionesCompanion Function({
      Value<int> id,
      Value<int> instalacionId,
      Value<String> nivelComplejidad,
      Value<double> totalMateriales,
      Value<double> totalManoObra,
      Value<double> granTotal,
      Value<DateTime> fechaValidez,
    });

final class $$CotizacionesTableReferences
    extends BaseReferences<_$AppDatabase, $CotizacionesTable, Cotizacione> {
  $$CotizacionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InstalacionesTable _instalacionIdTable(_$AppDatabase db) =>
      db.instalaciones.createAlias(
        $_aliasNameGenerator(
          db.cotizaciones.instalacionId,
          db.instalaciones.id,
        ),
      );

  $$InstalacionesTableProcessedTableManager get instalacionId {
    final $_column = $_itemColumn<int>('instalacion_id')!;

    final manager = $$InstalacionesTableTableManager(
      $_db,
      $_db.instalaciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_instalacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CotizacionItemsTable, List<CotizacionItem>>
  _cotizacionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cotizacionItems,
    aliasName: $_aliasNameGenerator(
      db.cotizaciones.id,
      db.cotizacionItems.cotizacionId,
    ),
  );

  $$CotizacionItemsTableProcessedTableManager get cotizacionItemsRefs {
    final manager = $$CotizacionItemsTableTableManager(
      $_db,
      $_db.cotizacionItems,
    ).filter((f) => f.cotizacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cotizacionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CotizacionesTableFilterComposer
    extends Composer<_$AppDatabase, $CotizacionesTable> {
  $$CotizacionesTableFilterComposer({
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

  ColumnFilters<String> get nivelComplejidad => $composableBuilder(
    column: $table.nivelComplejidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalMateriales => $composableBuilder(
    column: $table.totalMateriales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalManoObra => $composableBuilder(
    column: $table.totalManoObra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get granTotal => $composableBuilder(
    column: $table.granTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaValidez => $composableBuilder(
    column: $table.fechaValidez,
    builder: (column) => ColumnFilters(column),
  );

  $$InstalacionesTableFilterComposer get instalacionId {
    final $$InstalacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableFilterComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cotizacionItemsRefs(
    Expression<bool> Function($$CotizacionItemsTableFilterComposer f) f,
  ) {
    final $$CotizacionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizacionItems,
      getReferencedColumn: (t) => t.cotizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionItemsTableFilterComposer(
            $db: $db,
            $table: $db.cotizacionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CotizacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $CotizacionesTable> {
  $$CotizacionesTableOrderingComposer({
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

  ColumnOrderings<String> get nivelComplejidad => $composableBuilder(
    column: $table.nivelComplejidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalMateriales => $composableBuilder(
    column: $table.totalMateriales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalManoObra => $composableBuilder(
    column: $table.totalManoObra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get granTotal => $composableBuilder(
    column: $table.granTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaValidez => $composableBuilder(
    column: $table.fechaValidez,
    builder: (column) => ColumnOrderings(column),
  );

  $$InstalacionesTableOrderingComposer get instalacionId {
    final $$InstalacionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableOrderingComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CotizacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CotizacionesTable> {
  $$CotizacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nivelComplejidad => $composableBuilder(
    column: $table.nivelComplejidad,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalMateriales => $composableBuilder(
    column: $table.totalMateriales,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalManoObra => $composableBuilder(
    column: $table.totalManoObra,
    builder: (column) => column,
  );

  GeneratedColumn<double> get granTotal =>
      $composableBuilder(column: $table.granTotal, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaValidez => $composableBuilder(
    column: $table.fechaValidez,
    builder: (column) => column,
  );

  $$InstalacionesTableAnnotationComposer get instalacionId {
    final $$InstalacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cotizacionItemsRefs<T extends Object>(
    Expression<T> Function($$CotizacionItemsTableAnnotationComposer a) f,
  ) {
    final $$CotizacionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizacionItems,
      getReferencedColumn: (t) => t.cotizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cotizacionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CotizacionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CotizacionesTable,
          Cotizacione,
          $$CotizacionesTableFilterComposer,
          $$CotizacionesTableOrderingComposer,
          $$CotizacionesTableAnnotationComposer,
          $$CotizacionesTableCreateCompanionBuilder,
          $$CotizacionesTableUpdateCompanionBuilder,
          (Cotizacione, $$CotizacionesTableReferences),
          Cotizacione,
          PrefetchHooks Function({bool instalacionId, bool cotizacionItemsRefs})
        > {
  $$CotizacionesTableTableManager(_$AppDatabase db, $CotizacionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CotizacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CotizacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CotizacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> instalacionId = const Value.absent(),
                Value<String> nivelComplejidad = const Value.absent(),
                Value<double> totalMateriales = const Value.absent(),
                Value<double> totalManoObra = const Value.absent(),
                Value<double> granTotal = const Value.absent(),
                Value<DateTime> fechaValidez = const Value.absent(),
              }) => CotizacionesCompanion(
                id: id,
                instalacionId: instalacionId,
                nivelComplejidad: nivelComplejidad,
                totalMateriales: totalMateriales,
                totalManoObra: totalManoObra,
                granTotal: granTotal,
                fechaValidez: fechaValidez,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int instalacionId,
                required String nivelComplejidad,
                required double totalMateriales,
                required double totalManoObra,
                required double granTotal,
                required DateTime fechaValidez,
              }) => CotizacionesCompanion.insert(
                id: id,
                instalacionId: instalacionId,
                nivelComplejidad: nivelComplejidad,
                totalMateriales: totalMateriales,
                totalManoObra: totalManoObra,
                granTotal: granTotal,
                fechaValidez: fechaValidez,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CotizacionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({instalacionId = false, cotizacionItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cotizacionItemsRefs) db.cotizacionItems,
                  ],
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
                        if (instalacionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.instalacionId,
                                    referencedTable:
                                        $$CotizacionesTableReferences
                                            ._instalacionIdTable(db),
                                    referencedColumn:
                                        $$CotizacionesTableReferences
                                            ._instalacionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cotizacionItemsRefs)
                        await $_getPrefetchedData<
                          Cotizacione,
                          $CotizacionesTable,
                          CotizacionItem
                        >(
                          currentTable: table,
                          referencedTable: $$CotizacionesTableReferences
                              ._cotizacionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CotizacionesTableReferences(
                                db,
                                table,
                                p0,
                              ).cotizacionItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cotizacionId == item.id,
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

typedef $$CotizacionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CotizacionesTable,
      Cotizacione,
      $$CotizacionesTableFilterComposer,
      $$CotizacionesTableOrderingComposer,
      $$CotizacionesTableAnnotationComposer,
      $$CotizacionesTableCreateCompanionBuilder,
      $$CotizacionesTableUpdateCompanionBuilder,
      (Cotizacione, $$CotizacionesTableReferences),
      Cotizacione,
      PrefetchHooks Function({bool instalacionId, bool cotizacionItemsRefs})
    >;
typedef $$CotizacionItemsTableCreateCompanionBuilder =
    CotizacionItemsCompanion Function({
      Value<int> id,
      required int cotizacionId,
      required int materialId,
      required double cantidad,
      required double precioHistorico,
    });
typedef $$CotizacionItemsTableUpdateCompanionBuilder =
    CotizacionItemsCompanion Function({
      Value<int> id,
      Value<int> cotizacionId,
      Value<int> materialId,
      Value<double> cantidad,
      Value<double> precioHistorico,
    });

final class $$CotizacionItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CotizacionItemsTable, CotizacionItem> {
  $$CotizacionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CotizacionesTable _cotizacionIdTable(_$AppDatabase db) =>
      db.cotizaciones.createAlias(
        $_aliasNameGenerator(
          db.cotizacionItems.cotizacionId,
          db.cotizaciones.id,
        ),
      );

  $$CotizacionesTableProcessedTableManager get cotizacionId {
    final $_column = $_itemColumn<int>('cotizacion_id')!;

    final manager = $$CotizacionesTableTableManager(
      $_db,
      $_db.cotizaciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cotizacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CatalogoMaterialesTable _materialIdTable(_$AppDatabase db) =>
      db.catalogoMateriales.createAlias(
        $_aliasNameGenerator(
          db.cotizacionItems.materialId,
          db.catalogoMateriales.id,
        ),
      );

  $$CatalogoMaterialesTableProcessedTableManager get materialId {
    final $_column = $_itemColumn<int>('material_id')!;

    final manager = $$CatalogoMaterialesTableTableManager(
      $_db,
      $_db.catalogoMateriales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CotizacionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CotizacionItemsTable> {
  $$CotizacionItemsTableFilterComposer({
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

  ColumnFilters<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioHistorico => $composableBuilder(
    column: $table.precioHistorico,
    builder: (column) => ColumnFilters(column),
  );

  $$CotizacionesTableFilterComposer get cotizacionId {
    final $$CotizacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cotizacionId,
      referencedTable: $db.cotizaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionesTableFilterComposer(
            $db: $db,
            $table: $db.cotizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoMaterialesTableFilterComposer get materialId {
    final $$CatalogoMaterialesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.catalogoMateriales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoMaterialesTableFilterComposer(
            $db: $db,
            $table: $db.catalogoMateriales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CotizacionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CotizacionItemsTable> {
  $$CotizacionItemsTableOrderingComposer({
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

  ColumnOrderings<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioHistorico => $composableBuilder(
    column: $table.precioHistorico,
    builder: (column) => ColumnOrderings(column),
  );

  $$CotizacionesTableOrderingComposer get cotizacionId {
    final $$CotizacionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cotizacionId,
      referencedTable: $db.cotizaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionesTableOrderingComposer(
            $db: $db,
            $table: $db.cotizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoMaterialesTableOrderingComposer get materialId {
    final $$CatalogoMaterialesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.catalogoMateriales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoMaterialesTableOrderingComposer(
            $db: $db,
            $table: $db.catalogoMateriales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CotizacionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CotizacionItemsTable> {
  $$CotizacionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioHistorico => $composableBuilder(
    column: $table.precioHistorico,
    builder: (column) => column,
  );

  $$CotizacionesTableAnnotationComposer get cotizacionId {
    final $$CotizacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cotizacionId,
      referencedTable: $db.cotizaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.cotizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoMaterialesTableAnnotationComposer get materialId {
    final $$CatalogoMaterialesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.materialId,
          referencedTable: $db.catalogoMateriales,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CatalogoMaterialesTableAnnotationComposer(
                $db: $db,
                $table: $db.catalogoMateriales,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CotizacionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CotizacionItemsTable,
          CotizacionItem,
          $$CotizacionItemsTableFilterComposer,
          $$CotizacionItemsTableOrderingComposer,
          $$CotizacionItemsTableAnnotationComposer,
          $$CotizacionItemsTableCreateCompanionBuilder,
          $$CotizacionItemsTableUpdateCompanionBuilder,
          (CotizacionItem, $$CotizacionItemsTableReferences),
          CotizacionItem,
          PrefetchHooks Function({bool cotizacionId, bool materialId})
        > {
  $$CotizacionItemsTableTableManager(
    _$AppDatabase db,
    $CotizacionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CotizacionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CotizacionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CotizacionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cotizacionId = const Value.absent(),
                Value<int> materialId = const Value.absent(),
                Value<double> cantidad = const Value.absent(),
                Value<double> precioHistorico = const Value.absent(),
              }) => CotizacionItemsCompanion(
                id: id,
                cotizacionId: cotizacionId,
                materialId: materialId,
                cantidad: cantidad,
                precioHistorico: precioHistorico,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cotizacionId,
                required int materialId,
                required double cantidad,
                required double precioHistorico,
              }) => CotizacionItemsCompanion.insert(
                id: id,
                cotizacionId: cotizacionId,
                materialId: materialId,
                cantidad: cantidad,
                precioHistorico: precioHistorico,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CotizacionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cotizacionId = false, materialId = false}) {
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
                    if (cotizacionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cotizacionId,
                                referencedTable:
                                    $$CotizacionItemsTableReferences
                                        ._cotizacionIdTable(db),
                                referencedColumn:
                                    $$CotizacionItemsTableReferences
                                        ._cotizacionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (materialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.materialId,
                                referencedTable:
                                    $$CotizacionItemsTableReferences
                                        ._materialIdTable(db),
                                referencedColumn:
                                    $$CotizacionItemsTableReferences
                                        ._materialIdTable(db)
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

typedef $$CotizacionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CotizacionItemsTable,
      CotizacionItem,
      $$CotizacionItemsTableFilterComposer,
      $$CotizacionItemsTableOrderingComposer,
      $$CotizacionItemsTableAnnotationComposer,
      $$CotizacionItemsTableCreateCompanionBuilder,
      $$CotizacionItemsTableUpdateCompanionBuilder,
      (CotizacionItem, $$CotizacionItemsTableReferences),
      CotizacionItem,
      PrefetchHooks Function({bool cotizacionId, bool materialId})
    >;
typedef $$CertificacionesChecklistTableCreateCompanionBuilder =
    CertificacionesChecklistCompanion Function({
      Value<int> id,
      required int instalacionId,
      required String nombreCliente,
      required String ciNitCliente,
      Value<String> direccionInstalacion,
      Value<bool> visFijacion,
      Value<bool> visCables,
      Value<bool> visProteccion,
      Value<bool> visIdentificacion,
      Value<bool> visDanos,
      Value<double?> tensionMedidaV,
      Value<double?> resistenciaTierraOhms,
      Value<bool> elecContinuidad,
      Value<bool> funEncendido,
      Value<bool> funCorriente,
      Value<bool> funTemperatura,
      Value<bool> funEmergencia,
      Value<bool> docFoto,
      Value<bool> docDiagrama,
      Value<bool> docCertificadoTierra,
      Value<bool> docManual,
      Value<bool> isCompletado,
      required DateTime fechaRegistro,
    });
typedef $$CertificacionesChecklistTableUpdateCompanionBuilder =
    CertificacionesChecklistCompanion Function({
      Value<int> id,
      Value<int> instalacionId,
      Value<String> nombreCliente,
      Value<String> ciNitCliente,
      Value<String> direccionInstalacion,
      Value<bool> visFijacion,
      Value<bool> visCables,
      Value<bool> visProteccion,
      Value<bool> visIdentificacion,
      Value<bool> visDanos,
      Value<double?> tensionMedidaV,
      Value<double?> resistenciaTierraOhms,
      Value<bool> elecContinuidad,
      Value<bool> funEncendido,
      Value<bool> funCorriente,
      Value<bool> funTemperatura,
      Value<bool> funEmergencia,
      Value<bool> docFoto,
      Value<bool> docDiagrama,
      Value<bool> docCertificadoTierra,
      Value<bool> docManual,
      Value<bool> isCompletado,
      Value<DateTime> fechaRegistro,
    });

final class $$CertificacionesChecklistTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CertificacionesChecklistTable,
          CertificacionesChecklistData
        > {
  $$CertificacionesChecklistTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InstalacionesTable _instalacionIdTable(_$AppDatabase db) =>
      db.instalaciones.createAlias(
        $_aliasNameGenerator(
          db.certificacionesChecklist.instalacionId,
          db.instalaciones.id,
        ),
      );

  $$InstalacionesTableProcessedTableManager get instalacionId {
    final $_column = $_itemColumn<int>('instalacion_id')!;

    final manager = $$InstalacionesTableTableManager(
      $_db,
      $_db.instalaciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_instalacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CertificacionesChecklistTableFilterComposer
    extends Composer<_$AppDatabase, $CertificacionesChecklistTable> {
  $$CertificacionesChecklistTableFilterComposer({
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

  ColumnFilters<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciNitCliente => $composableBuilder(
    column: $table.ciNitCliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccionInstalacion => $composableBuilder(
    column: $table.direccionInstalacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visFijacion => $composableBuilder(
    column: $table.visFijacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visCables => $composableBuilder(
    column: $table.visCables,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visProteccion => $composableBuilder(
    column: $table.visProteccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visIdentificacion => $composableBuilder(
    column: $table.visIdentificacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visDanos => $composableBuilder(
    column: $table.visDanos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tensionMedidaV => $composableBuilder(
    column: $table.tensionMedidaV,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get resistenciaTierraOhms => $composableBuilder(
    column: $table.resistenciaTierraOhms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get elecContinuidad => $composableBuilder(
    column: $table.elecContinuidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get funEncendido => $composableBuilder(
    column: $table.funEncendido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get funCorriente => $composableBuilder(
    column: $table.funCorriente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get funTemperatura => $composableBuilder(
    column: $table.funTemperatura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get funEmergencia => $composableBuilder(
    column: $table.funEmergencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get docFoto => $composableBuilder(
    column: $table.docFoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get docDiagrama => $composableBuilder(
    column: $table.docDiagrama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get docCertificadoTierra => $composableBuilder(
    column: $table.docCertificadoTierra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get docManual => $composableBuilder(
    column: $table.docManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompletado => $composableBuilder(
    column: $table.isCompletado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnFilters(column),
  );

  $$InstalacionesTableFilterComposer get instalacionId {
    final $$InstalacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableFilterComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CertificacionesChecklistTableOrderingComposer
    extends Composer<_$AppDatabase, $CertificacionesChecklistTable> {
  $$CertificacionesChecklistTableOrderingComposer({
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

  ColumnOrderings<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciNitCliente => $composableBuilder(
    column: $table.ciNitCliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccionInstalacion => $composableBuilder(
    column: $table.direccionInstalacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visFijacion => $composableBuilder(
    column: $table.visFijacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visCables => $composableBuilder(
    column: $table.visCables,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visProteccion => $composableBuilder(
    column: $table.visProteccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visIdentificacion => $composableBuilder(
    column: $table.visIdentificacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visDanos => $composableBuilder(
    column: $table.visDanos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tensionMedidaV => $composableBuilder(
    column: $table.tensionMedidaV,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get resistenciaTierraOhms => $composableBuilder(
    column: $table.resistenciaTierraOhms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get elecContinuidad => $composableBuilder(
    column: $table.elecContinuidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get funEncendido => $composableBuilder(
    column: $table.funEncendido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get funCorriente => $composableBuilder(
    column: $table.funCorriente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get funTemperatura => $composableBuilder(
    column: $table.funTemperatura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get funEmergencia => $composableBuilder(
    column: $table.funEmergencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get docFoto => $composableBuilder(
    column: $table.docFoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get docDiagrama => $composableBuilder(
    column: $table.docDiagrama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get docCertificadoTierra => $composableBuilder(
    column: $table.docCertificadoTierra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get docManual => $composableBuilder(
    column: $table.docManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompletado => $composableBuilder(
    column: $table.isCompletado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnOrderings(column),
  );

  $$InstalacionesTableOrderingComposer get instalacionId {
    final $$InstalacionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableOrderingComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CertificacionesChecklistTableAnnotationComposer
    extends Composer<_$AppDatabase, $CertificacionesChecklistTable> {
  $$CertificacionesChecklistTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ciNitCliente => $composableBuilder(
    column: $table.ciNitCliente,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direccionInstalacion => $composableBuilder(
    column: $table.direccionInstalacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get visFijacion => $composableBuilder(
    column: $table.visFijacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get visCables =>
      $composableBuilder(column: $table.visCables, builder: (column) => column);

  GeneratedColumn<bool> get visProteccion => $composableBuilder(
    column: $table.visProteccion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get visIdentificacion => $composableBuilder(
    column: $table.visIdentificacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get visDanos =>
      $composableBuilder(column: $table.visDanos, builder: (column) => column);

  GeneratedColumn<double> get tensionMedidaV => $composableBuilder(
    column: $table.tensionMedidaV,
    builder: (column) => column,
  );

  GeneratedColumn<double> get resistenciaTierraOhms => $composableBuilder(
    column: $table.resistenciaTierraOhms,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get elecContinuidad => $composableBuilder(
    column: $table.elecContinuidad,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get funEncendido => $composableBuilder(
    column: $table.funEncendido,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get funCorriente => $composableBuilder(
    column: $table.funCorriente,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get funTemperatura => $composableBuilder(
    column: $table.funTemperatura,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get funEmergencia => $composableBuilder(
    column: $table.funEmergencia,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get docFoto =>
      $composableBuilder(column: $table.docFoto, builder: (column) => column);

  GeneratedColumn<bool> get docDiagrama => $composableBuilder(
    column: $table.docDiagrama,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get docCertificadoTierra => $composableBuilder(
    column: $table.docCertificadoTierra,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get docManual =>
      $composableBuilder(column: $table.docManual, builder: (column) => column);

  GeneratedColumn<bool> get isCompletado => $composableBuilder(
    column: $table.isCompletado,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => column,
  );

  $$InstalacionesTableAnnotationComposer get instalacionId {
    final $$InstalacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.instalacionId,
      referencedTable: $db.instalaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstalacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.instalaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CertificacionesChecklistTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CertificacionesChecklistTable,
          CertificacionesChecklistData,
          $$CertificacionesChecklistTableFilterComposer,
          $$CertificacionesChecklistTableOrderingComposer,
          $$CertificacionesChecklistTableAnnotationComposer,
          $$CertificacionesChecklistTableCreateCompanionBuilder,
          $$CertificacionesChecklistTableUpdateCompanionBuilder,
          (
            CertificacionesChecklistData,
            $$CertificacionesChecklistTableReferences,
          ),
          CertificacionesChecklistData,
          PrefetchHooks Function({bool instalacionId})
        > {
  $$CertificacionesChecklistTableTableManager(
    _$AppDatabase db,
    $CertificacionesChecklistTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CertificacionesChecklistTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CertificacionesChecklistTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CertificacionesChecklistTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> instalacionId = const Value.absent(),
                Value<String> nombreCliente = const Value.absent(),
                Value<String> ciNitCliente = const Value.absent(),
                Value<String> direccionInstalacion = const Value.absent(),
                Value<bool> visFijacion = const Value.absent(),
                Value<bool> visCables = const Value.absent(),
                Value<bool> visProteccion = const Value.absent(),
                Value<bool> visIdentificacion = const Value.absent(),
                Value<bool> visDanos = const Value.absent(),
                Value<double?> tensionMedidaV = const Value.absent(),
                Value<double?> resistenciaTierraOhms = const Value.absent(),
                Value<bool> elecContinuidad = const Value.absent(),
                Value<bool> funEncendido = const Value.absent(),
                Value<bool> funCorriente = const Value.absent(),
                Value<bool> funTemperatura = const Value.absent(),
                Value<bool> funEmergencia = const Value.absent(),
                Value<bool> docFoto = const Value.absent(),
                Value<bool> docDiagrama = const Value.absent(),
                Value<bool> docCertificadoTierra = const Value.absent(),
                Value<bool> docManual = const Value.absent(),
                Value<bool> isCompletado = const Value.absent(),
                Value<DateTime> fechaRegistro = const Value.absent(),
              }) => CertificacionesChecklistCompanion(
                id: id,
                instalacionId: instalacionId,
                nombreCliente: nombreCliente,
                ciNitCliente: ciNitCliente,
                direccionInstalacion: direccionInstalacion,
                visFijacion: visFijacion,
                visCables: visCables,
                visProteccion: visProteccion,
                visIdentificacion: visIdentificacion,
                visDanos: visDanos,
                tensionMedidaV: tensionMedidaV,
                resistenciaTierraOhms: resistenciaTierraOhms,
                elecContinuidad: elecContinuidad,
                funEncendido: funEncendido,
                funCorriente: funCorriente,
                funTemperatura: funTemperatura,
                funEmergencia: funEmergencia,
                docFoto: docFoto,
                docDiagrama: docDiagrama,
                docCertificadoTierra: docCertificadoTierra,
                docManual: docManual,
                isCompletado: isCompletado,
                fechaRegistro: fechaRegistro,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int instalacionId,
                required String nombreCliente,
                required String ciNitCliente,
                Value<String> direccionInstalacion = const Value.absent(),
                Value<bool> visFijacion = const Value.absent(),
                Value<bool> visCables = const Value.absent(),
                Value<bool> visProteccion = const Value.absent(),
                Value<bool> visIdentificacion = const Value.absent(),
                Value<bool> visDanos = const Value.absent(),
                Value<double?> tensionMedidaV = const Value.absent(),
                Value<double?> resistenciaTierraOhms = const Value.absent(),
                Value<bool> elecContinuidad = const Value.absent(),
                Value<bool> funEncendido = const Value.absent(),
                Value<bool> funCorriente = const Value.absent(),
                Value<bool> funTemperatura = const Value.absent(),
                Value<bool> funEmergencia = const Value.absent(),
                Value<bool> docFoto = const Value.absent(),
                Value<bool> docDiagrama = const Value.absent(),
                Value<bool> docCertificadoTierra = const Value.absent(),
                Value<bool> docManual = const Value.absent(),
                Value<bool> isCompletado = const Value.absent(),
                required DateTime fechaRegistro,
              }) => CertificacionesChecklistCompanion.insert(
                id: id,
                instalacionId: instalacionId,
                nombreCliente: nombreCliente,
                ciNitCliente: ciNitCliente,
                direccionInstalacion: direccionInstalacion,
                visFijacion: visFijacion,
                visCables: visCables,
                visProteccion: visProteccion,
                visIdentificacion: visIdentificacion,
                visDanos: visDanos,
                tensionMedidaV: tensionMedidaV,
                resistenciaTierraOhms: resistenciaTierraOhms,
                elecContinuidad: elecContinuidad,
                funEncendido: funEncendido,
                funCorriente: funCorriente,
                funTemperatura: funTemperatura,
                funEmergencia: funEmergencia,
                docFoto: docFoto,
                docDiagrama: docDiagrama,
                docCertificadoTierra: docCertificadoTierra,
                docManual: docManual,
                isCompletado: isCompletado,
                fechaRegistro: fechaRegistro,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CertificacionesChecklistTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({instalacionId = false}) {
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
                    if (instalacionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.instalacionId,
                                referencedTable:
                                    $$CertificacionesChecklistTableReferences
                                        ._instalacionIdTable(db),
                                referencedColumn:
                                    $$CertificacionesChecklistTableReferences
                                        ._instalacionIdTable(db)
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

typedef $$CertificacionesChecklistTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CertificacionesChecklistTable,
      CertificacionesChecklistData,
      $$CertificacionesChecklistTableFilterComposer,
      $$CertificacionesChecklistTableOrderingComposer,
      $$CertificacionesChecklistTableAnnotationComposer,
      $$CertificacionesChecklistTableCreateCompanionBuilder,
      $$CertificacionesChecklistTableUpdateCompanionBuilder,
      (CertificacionesChecklistData, $$CertificacionesChecklistTableReferences),
      CertificacionesChecklistData,
      PrefetchHooks Function({bool instalacionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InstalacionesTableTableManager get instalaciones =>
      $$InstalacionesTableTableManager(_db, _db.instalaciones);
  $$DimensionamientosTableTableManager get dimensionamientos =>
      $$DimensionamientosTableTableManager(_db, _db.dimensionamientos);
  $$CatalogoMaterialesTableTableManager get catalogoMateriales =>
      $$CatalogoMaterialesTableTableManager(_db, _db.catalogoMateriales);
  $$CotizacionesTableTableManager get cotizaciones =>
      $$CotizacionesTableTableManager(_db, _db.cotizaciones);
  $$CotizacionItemsTableTableManager get cotizacionItems =>
      $$CotizacionItemsTableTableManager(_db, _db.cotizacionItems);
  $$CertificacionesChecklistTableTableManager get certificacionesChecklist =>
      $$CertificacionesChecklistTableTableManager(
        _db,
        _db.certificacionesChecklist,
      );
}
