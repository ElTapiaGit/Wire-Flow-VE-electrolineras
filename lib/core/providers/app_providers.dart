import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

// Proveedor global de la Base de Datos (para no instanciarla a cada rato)
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Proveedor del ID de la Instalacion Activa (Nulo si no has seleccionado ninguna)
final activeInstalacionIdProvider = StateProvider<int?>((ref) => null);

// Proveedor del Nombre de la Instalacion Activa (Para mostrarlo en la UI)
final activeInstalacionNombreProvider = StateProvider<String?>((ref) => null);