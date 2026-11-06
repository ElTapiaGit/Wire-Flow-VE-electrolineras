import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';

class ChecklistProvider extends ChangeNotifier {
  final AppDatabase _db;

  // ESTADO DEL FORMULARIO
  int? currentInstalacionId; //para edit
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

  // --- VARIABLES DE MEMORIA DE CLIENTE ---
  String nombreClienteGuardado = '';
  String ciNitClienteGuardado = '';
  String direccionGuardada = '';

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

  // Iniciar un nuevo checklist limpio para evitar contaminacion de clientes anteriores
  void iniciarNuevoChecklist() {
    _limpiarFormulario();
    notifyListeners();
  }

  // METODO edit datos de borrador
  void cargadorBorrador(CertificacionesChecklistData registro) {
    currentInstalacionId = registro.instalacionId;

    // Cargamos los datos del cliente
    nombreClienteGuardado = registro.nombreCliente;
    ciNitClienteGuardado = registro.ciNitCliente;
    direccionGuardada = registro.direccionInstalacion;

    visFijacion = registro.visFijacion;
    visCables = registro.visCables;
    visProteccion = registro.visProteccion;
    visIdentificacion = registro.visIdentificacion;
    visDanos = registro.visDanos;

    elecContinuidad = registro.elecContinuidad;
    funEncendido = registro.funEncendido;
    funCorriente = registro.funCorriente;
    funTemperatura = registro.funTemperatura;
    funEmergencia = registro.funEmergencia;

    docFoto = registro.docFoto;
    docDiagrama = registro.docDiagrama;
    docCertificado = registro.docCertificadoTierra;
    docManual = registro.docManual;

    tensionController.text = registro.tensionMedidaV != null ? registro.tensionMedidaV.toString() : '';
    tierraController.text = registro.resistenciaTierraOhms != null ? registro.resistenciaTierraOhms.toString() : '';

    notifyListeners(); // aviso de los cambios en pantalla
  }

  // Validador global estricto
  bool get isChecklistComplete {
    // 1. Tensión operativa: sanitizar y verificar rango 180V - 460V
    final tensionStr = tensionController.text.trim().replaceAll(',', '.');
    final tension = double.tryParse(tensionStr);
    final bool tensionOk = tension != null && tension >= 180.0 && tension <= 460.0;

    // 2. Resistencia de puesta a tierra: si contiene texto debe ser estrictamente > 0.0 y <= 25.0
    final tierraStr = tierraController.text.trim().replaceAll(',', '.');
    bool tierraOk = true; 
    if (tierraStr.isNotEmpty) {
      final tierra = double.tryParse(tierraStr);
      tierraOk = tierra != null && tierra > 0.0 && tierra <= 25.0;
    }

    final bool visualOk = visFijacion && visCables && visProteccion && visIdentificacion && visDanos;
    final bool electricasOk = tensionOk && tierraOk && elecContinuidad;
    final bool finalesOk = funEncendido && funCorriente && funTemperatura && funEmergencia;
    final bool docsOk = docFoto && docDiagrama && docCertificado && docManual;
    
    return visualOk && electricasOk && finalesOk && docsOk;
  }

  // Logica base de datos
  Future<void> guardarRegistroFinal({required String nombreCliente, String? ciNitCliente, required String direccion}) async {
    isSaving = true;
    notifyListeners();

    try {
      final isReady = isChecklistComplete;
      
      // Instalacion Padre con nombre del cliente
      int idToUse;
      if (currentInstalacionId != null) {
        idToUse = currentInstalacionId!; // Actualizamos el borrador existente
      } else {
        idToUse = await _db.crearInstalacion('Certificación: $nombreCliente'); // Creamos uno nuevo
      }

      final tensionStr = tensionController.text.trim().replaceAll(',', '.');
      final tierraStr = tierraController.text.trim().replaceAll(',', '.');

      // Preparamos el Companion
      final nuevoCertificado = CertificacionesChecklistCompanion.insert(
        instalacionId: idToUse,
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
        
        tensionMedidaV: drift.Value(double.tryParse(tensionStr)),
        resistenciaTierraOhms: drift.Value(double.tryParse(tierraStr)),
        
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
    currentInstalacionId = null;
    nombreClienteGuardado = '';
    ciNitClienteGuardado = '';
    direccionGuardada = '';

    visFijacion = false; visCables = false; visProteccion = false; 
    visIdentificacion = false; visDanos = false; elecContinuidad = false;
    funEncendido = false; funCorriente = false; funTemperatura = false; 
    funEmergencia = false; docFoto = false; docDiagrama = false; 
    docCertificado = false; docManual = false;
    tensionController.clear();
    tierraController.clear();
  }

  CertificacionesChecklistData crearRegistroTemporal({required String nombreCliente, required String ciNitCliente, required String direccion}) {
    final tensionStr = tensionController.text.trim().replaceAll(',', '.');
    final tierraStr = tierraController.text.trim().replaceAll(',', '.');

    return CertificacionesChecklistData(
      id: currentInstalacionId ?? 0, 
      instalacionId: currentInstalacionId ?? 0, 
      nombreCliente: nombreCliente, 
      ciNitCliente: ciNitCliente, 
      direccionInstalacion: direccion, 
      visFijacion: visFijacion, 
      visCables: visCables, 
      visProteccion: visProteccion, 
      visIdentificacion: visIdentificacion, 
      visDanos: visDanos, 
      tensionMedidaV: double.tryParse(tensionStr), 
      resistenciaTierraOhms: double.tryParse(tierraStr), 
      elecContinuidad: elecContinuidad, 
      funEncendido: funEncendido, 
      funCorriente: funCorriente, 
      funTemperatura: funTemperatura, 
      funEmergencia: funEmergencia, 
      docFoto: docFoto, 
      docDiagrama: docDiagrama, 
      docCertificadoTierra: docCertificado, 
      docManual: docManual, 
      isCompletado: isChecklistComplete, 
      fechaRegistro: DateTime.now()
    );
  }
}