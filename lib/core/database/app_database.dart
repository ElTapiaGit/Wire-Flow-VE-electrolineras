import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 1. Tabla Instalaciones (La tabla nucleo)
class Instalaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text()(); // Ej: "Instalación Casa Perez"
  DateTimeColumn get fechaCreacion => dateTime()();
  TextColumn get estado => text()(); // "Pendiente", "Cotizada", "Instalada", "Certificada"
}

// 2. Tabla Dimensionamientos (Modulo Tecnico)
class Dimensionamientos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get instalacionId => integer().references(Instalaciones, #id)();
  TextColumn get tipoRed => text()();
  RealColumn get potenciaKw => real()();
  RealColumn get distanciaMetros => real()();
  RealColumn get corrienteCalculadaA => real()();
  RealColumn get caidaTensionPorcentaje => real()();
  TextColumn get calibreCableAwg => text()();
}

// 3. Tabla Catalogo_Materiales (Maestro de Precios)
class CatalogoMateriales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoria => text()();
  TextColumn get nombre => text()();
  RealColumn get precioUnitario => real()();
  TextColumn get unidadMedida => text()();
}

// 4. Tabla Cotizaciones (Modulo Comercial - Cabecera)
class Cotizaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get instalacionId => integer().references(Instalaciones, #id)();
  TextColumn get nivelComplejidad => text()();
  RealColumn get totalMateriales => real()();
  RealColumn get totalManoObra => real()();
  RealColumn get granTotal => real()();
  DateTimeColumn get fechaValidez => dateTime()();
}

// 5. Tabla Cotizacion_Items (Modulo Comercial - Detalle)
class CotizacionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cotizacionId => integer().references(Cotizaciones, #id)();
  IntColumn get materialId => integer().references(CatalogoMateriales, #id)();
  RealColumn get cantidad => real()();
  RealColumn get precioHistorico => real()(); 
}

// 6. REFACTORIZADO: Tabla Certificaciones_Checklist (Modulo Puesta en Marcha)
class CertificacionesChecklist extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get instalacionId => integer().references(Instalaciones, #id)();
  
  // Datos del Cliente
  TextColumn get nombreCliente => text()();
  TextColumn get ciNitCliente => text()();
  TextColumn get direccionInstalacion => text().withDefault(const Constant('Cochabamba, Bolivia'))();
  
  // Inspección Visual
  BoolColumn get visFijacion => boolean().withDefault(const Constant(false))();
  BoolColumn get visCables => boolean().withDefault(const Constant(false))();
  BoolColumn get visProteccion => boolean().withDefault(const Constant(false))();
  BoolColumn get visIdentificacion => boolean().withDefault(const Constant(false))();
  BoolColumn get visDanos => boolean().withDefault(const Constant(false))();

  // Pruebas Electricas
  RealColumn get tensionMedidaV => real().nullable()();
  RealColumn get resistenciaTierraOhms => real().nullable()(); 
  BoolColumn get elecContinuidad => boolean().withDefault(const Constant(false))();

  // Pruebas Finales
  BoolColumn get funEncendido => boolean().withDefault(const Constant(false))();
  BoolColumn get funCorriente => boolean().withDefault(const Constant(false))();
  BoolColumn get funTemperatura => boolean().withDefault(const Constant(false))();
  BoolColumn get funEmergencia => boolean().withDefault(const Constant(false))();

  // Documentacion Final
  BoolColumn get docFoto => boolean().withDefault(const Constant(false))();
  BoolColumn get docDiagrama => boolean().withDefault(const Constant(false))();
  BoolColumn get docCertificadoTierra => boolean().withDefault(const Constant(false))();
  BoolColumn get docManual => boolean().withDefault(const Constant(false))();

  // Estado del certificado
  BoolColumn get isCompletado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get fechaRegistro => dateTime()();
}

// ---------------------------------------------------------
// Configuración principal de la Base de Datos
// ---------------------------------------------------------
@DriftDatabase(tables: [
  Instalaciones,
  Dimensionamientos,
  CatalogoMateriales,
  Cotizaciones,
  CotizacionItems,
  CertificacionesChecklist,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; 

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // Creacion inicial completa para instalaciones nuevas
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Migracion no destructiva que preserva el 100% de datos existentes
      if (from < 2) {
        // Validamos si la tabla certificaciones_checklist ya existia para no afectarla
        final tableCheck = await customSelect(
          "SELECT count(*) as c FROM sqlite_master WHERE type='table' AND name='certificaciones_checklist'",
        ).getSingle();
        
        if (tableCheck.read<int>('c') == 0) {
          await m.createTable(certificacionesChecklist);
        }
      }
    },
    beforeOpen: (details) async {
      // Habilitar claves foraneas en tiempo de ejecucion para integridad referencial
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  ); 

  // METODOS DE LA BASE DE DATOS 
  Future<int> crearInstalacion(String titulo) {
    return into(instalaciones).insert(
      InstalacionesCompanion.insert(
        titulo: titulo,
        fechaCreacion: DateTime.now(),
        estado: 'Pendiente',
      ),
    );
  }

  // Obtener todos los proyectos activos
  Future<List<Instalacione>> obtenerProyectosActivos() {
    return (select(instalaciones)
          ..where((tbl) => tbl.estado.isNotIn(['Certificada'])) 
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .get();
  }

  // Guardar o Actualizar el Dimensionamiento (Calculadora)
  Future<void> upsertDimensionamiento(DimensionamientosCompanion dim) async {
    await (delete(dimensionamientos)
          ..where((t) => t.instalacionId.equals(dim.instalacionId.value)))
        .go();
    await into(dimensionamientos).insert(dim);
  }

  // Obtener el calculo tecnico previo del cliente activo
  Future<Dimensionamiento?> obtenerDimensionamiento(int instalacionId) {
    return (select(dimensionamientos)
          ..where((t) => t.instalacionId.equals(instalacionId)))
        .getSingleOrNull();
  }

  // Guardar o Actualizar la Cotizacion
  Future<void> upsertCotizacion(CotizacionesCompanion cot) async {
    await (delete(cotizaciones)
          ..where((t) => t.instalacionId.equals(cot.instalacionId.value)))
        .go();
    await into(cotizaciones).insert(cot);
  }

  // METODOS PARA EL CHECKLIST 

  // Guardar o Actualizar el Checklist de Certificacion
  Future<void> upsertCertificacionChecklist(CertificacionesChecklistCompanion cert) async {
    await transaction(() async {
      // 1. Consultamos si ya existe un registro para esta instalacion
      final existente = await (select(certificacionesChecklist)
            ..where((t) => t.instalacionId.equals(cert.instalacionId.value)))
          .getSingleOrNull();

      if (existente != null) {
        // 2. Si existe: actualizamos las columnas sin alterar la clave primaria (id)
        await (update(certificacionesChecklist)
              ..where((t) => t.instalacionId.equals(cert.instalacionId.value)))
            .write(cert);
      } else {
        // 3. Si no existe: insertamos el nuevo registro
        await into(certificacionesChecklist).insert(cert);
      }

      // 4. Actualizamos el estado general de la instalacion a "Certificada" si corresponde
      if (cert.isCompletado.value) {
        await (update(instalaciones)
              ..where((t) => t.id.equals(cert.instalacionId.value)))
            .write(const InstalacionesCompanion(estado: Value('Certificada')));
      }
    });
  }

  // Obtener todos los certificados (util para el Dashboard "Actividad Reciente")
  Future<List<CertificacionesChecklistData>> obtenerHistorialCertificaciones() {
    return (select(certificacionesChecklist)
          ..orderBy([(t) => OrderingTerm.desc(t.fechaRegistro)]))
        .get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ev_tech_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}