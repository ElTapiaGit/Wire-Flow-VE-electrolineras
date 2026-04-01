import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart'; 

class DashboardProvider extends ChangeNotifier {
  final AppDatabase _db;

  // Estados
  List<CertificacionesChecklistData> _historial = [];
  bool _isLoading = true;
  String? _error;

  // Getters para que la UI los lea
  List<CertificacionesChecklistData> get historial => _historial;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Inyección de dependencias: Recibe la base de datos al crearse
  DashboardProvider(this._db) {
    cargarHistorial(); // Carga los datos automáticamente al iniciar
  }

  // onsultar a SQLite
  Future<void> cargarHistorial() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); 

    try {
      _historial = await _db.obtenerHistorialCertificaciones();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
}