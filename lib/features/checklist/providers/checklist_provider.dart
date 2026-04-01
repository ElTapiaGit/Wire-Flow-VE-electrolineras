import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';

class ChecklistProvider extends ChangeNotifier {
  final AppDatabase _db;

  // ESTADO DEL FORMULARIO
  // INSPECCION VISUAL
  bool visFijacion = false;
  bool visCables = false;
  bool visProteccion = false;
  bool visIdentificacion = false;
  bool visDanos = false;

  // PRUEBAS ELECTRICAS
  final tensionController = TextEditingController();
  final tierraController = TextEditingController();
  bool elecContinuidad = false;

  // PRUEBAS FINALES
  bool funEncendido = false;
  bool funCorriente = false;
  bool funTemperatura = false;
  bool funEmergencia = false;

  // DOCUMENTACION FINAL
  bool docFoto = false;
  bool docDiagrama = false;
  bool docCertificado = false;
  bool docManual = false;

  // Estado de carga al guardar
  bool isSaving = false;

  ChecklistProvider(this._db) {
    tensionController.addListener(notifyListeners);
    tierraController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    tensionController.dispose();
    tierraController.dispose();
    super.dispose();
  }

  void refresh() => notifyListeners();

  // Validador global estricto
  bool get isChecklistComplete {
    double tierra = double.tryParse(tierraController.text) ?? 999.0;
    bool tierraOk = (tierra == 0) ? true : (tierra <= 25.0);
    bool tensionOk = tensionController.text.isNotEmpty;

    bool visualOk = visFijacion && visCables && visProteccion && visIdentificacion && visDanos;
    bool electricasOk = tensionOk && tierraOk && elecContinuidad;
    bool finalesOk = funEncendido && funCorriente && funTemperatura && funEmergencia;
    bool docsOk = docFoto && docDiagrama && docCertificado && docManual;
    
    return visualOk && electricasOk && finalesOk && docsOk;
  }

  // Logica base de datos
  Future<void> guardarRegistroFinal({required String nombreCliente, String? ciNitCliente, required String direccion}) async {
    isSaving = true;
    notifyListeners();

    try {
      final isReady = isChecklistComplete;
      
      // Instalacion Padre con nombre del cliente
      final instalacionId = await _db.crearInstalacion('Certificación: $nombreCliente');

      // Preparamos el Companion
      final nuevoCertificado = CertificacionesChecklistCompanion.insert(
        instalacionId: instalacionId,
        nombreCliente: nombreCliente,
        ciNitCliente: ciNitCliente ?? '',
        direccionInstalacion: drift.Value(direccion),
        
        visFijacion: drift.Value(visFijacion),
        visCables: drift.Value(visCables),
        visProteccion: drift.Value(visProteccion),
        visIdentificacion: drift.Value(visIdentificacion),
        visDanos: drift.Value(visDanos),
        elecContinuidad: drift.Value(elecContinuidad),
        funEncendido: drift.Value(funEncendido),
        funCorriente: drift.Value(funCorriente),
        funTemperatura: drift.Value(funTemperatura),
        funEmergencia: drift.Value(funEmergencia),
        docFoto: drift.Value(docFoto),
        docDiagrama: drift.Value(docDiagrama),
        docCertificadoTierra: drift.Value(docCertificado),
        docManual: drift.Value(docManual),
        
        tensionMedidaV: drift.Value(double.tryParse(tensionController.text)),
        resistenciaTierraOhms: drift.Value(double.tryParse(tierraController.text)),
        
        isCompletado: drift.Value(isReady),
        fechaRegistro: DateTime.now(),
      );

      await _db.upsertCertificacionChecklist(nuevoCertificado);
      _limpiarFormulario();
      
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  void _limpiarFormulario() {
    visFijacion = false; visCables = false; visProteccion = false; 
    visIdentificacion = false; visDanos = false; elecContinuidad = false;
    funEncendido = false; funCorriente = false; funTemperatura = false; 
    funEmergencia = false; docFoto = false; docDiagrama = false; 
    docCertificado = false; docManual = false;
    tensionController.clear();
    tierraController.clear();
  }
}