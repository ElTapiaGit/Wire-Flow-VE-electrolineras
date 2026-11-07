import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';

class ChecklistProvider extends ChangeNotifier {
  final AppDatabase _db;

  // Claves para persistencia de credenciales del técnico
  static const String keyNombreTecnico = 'cfg_nombre_tecnico';
  static const String keyRegistroSib = 'cfg_registro_sib';

  // ESTADO DEL FORMULARIO
  int? currentInstalacionId; //para edit
  // INSPECCION VISUAL Y MONTAJE (AETN 479/2021)
  bool visFijacion = false;
  bool visCables = false;
  bool visProteccion = false;
  bool visIdentificacion = false;
  bool visDanos = false;

  // PRUEBAS ELECTRICAS
  final tensionController = TextEditingController();
  final tierraController = TextEditingController();
  bool elecContinuidad = false;
  bool medicionTierraExterna = false;

  // METADATOS NORMATIVOS DE RED Y DISTRIBUIDORA
  String esquemaTierra = 'TN-S'; // 'TN-S' o 'TT'
  String distribuidora = 'ELFEC'; // 'ELFEC', 'DELAPAZ', 'CRE', 'ENDE', 'OTRO'
  String tecnicoResponsable = '';
  String matriculaProfesional = '';

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
    cargarDatosTecnicoPersistidos();
  }

  Future<void> cargarDatosTecnicoPersistidos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final t = prefs.getString(keyNombreTecnico);
      final s = prefs.getString(keyRegistroSib);
      if (t != null && t.trim().isNotEmpty) {
        tecnicoResponsable = t.trim();
      }
      if (s != null && s.trim().isNotEmpty) {
        matriculaProfesional = s.trim();
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> guardarDatosTecnicoPersistidos(String nombre, String matricula) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      tecnicoResponsable = nombre.trim();
      matriculaProfesional = matricula.trim();
      await prefs.setString(keyNombreTecnico, tecnicoResponsable);
      await prefs.setString(keyRegistroSib, matriculaProfesional);
      notifyListeners();
    } catch (_) {}
  }

  @override
  void dispose() {
    tensionController.dispose();
    tierraController.dispose();
    super.dispose();
  }

  void refresh() => notifyListeners();

  void setEsquemaTierra(String val) {
    esquemaTierra = val;
    notifyListeners();
  }

  void setDistribuidora(String val) {
    distribuidora = val;
    notifyListeners();
  }

  void setMedicionTierraExterna(bool val) {
    medicionTierraExterna = val;
    notifyListeners();
  }

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
    medicionTierraExterna = registro.resistenciaTierraOhms == null && registro.docCertificadoTierra;

    notifyListeners(); // aviso de los cambios en pantalla
  }

  // Validador global: permite certificar con medición in situ (<= 25 Ohms) o mediante especialista externo con certificado adjunto
  bool get isChecklistComplete {
    // 1. Tensión operativa: sanitizar y verificar rango 180V - 460V
    final tensionStr = tensionController.text.trim().replaceAll(',', '.');
    final tension = double.tryParse(tensionStr);
    final bool tensionOk = tension != null &&
        tension >= AppConstants.tensionMinimaOperativaV &&
        tension <= AppConstants.tensionMaximaOperativaV;

    // 2. Resistencia de puesta a tierra:
    // Si es delegada a especialista externo, se valida mediante el certificado PAT adjunto (docCertificado)
    // Si es medición propia in situ, requiere valor numérico > 0 y <= 25.0 Ohms
    bool tierraOk = false;
    if (medicionTierraExterna) {
      tierraOk = docCertificado;
    } else {
      final tierraStr = tierraController.text.trim().replaceAll(',', '.');
      final tierra = double.tryParse(tierraStr);
      tierraOk = tierra != null &&
          tierra > 0.0 &&
          tierra <= AppConstants.resistenciaTierraMaximaOhms;
    }

    final bool visualOk = visFijacion && visCables && visProteccion && visIdentificacion && visDanos;
    final bool electricasOk = tensionOk && tierraOk && elecContinuidad;
    final bool finalesOk = funEncendido && funCorriente && funTemperatura && funEmergencia;
    final bool docsOk = docFoto && docDiagrama && docCertificado && docManual;
    
    return visualOk && electricasOk && finalesOk && docsOk;
  }

  // Métricas para la barra de avance de cumplimiento normativo
  int get totalItemsRequeridos => 16;

  int get itemsCompletadosCount {
    int count = 0;
    if (visFijacion) count++;
    if (visCables) count++;
    if (visProteccion) count++;
    if (visIdentificacion) count++;
    if (visDanos) count++;

    final tensionStr = tensionController.text.trim().replaceAll(',', '.');
    final tension = double.tryParse(tensionStr);
    if (tension != null &&
        tension >= AppConstants.tensionMinimaOperativaV &&
        tension <= AppConstants.tensionMaximaOperativaV) {
      count++;
    }

    if (medicionTierraExterna) {
      if (docCertificado) count++;
    } else {
      final tierraStr = tierraController.text.trim().replaceAll(',', '.');
      final tierra = double.tryParse(tierraStr);
      if (tierra != null &&
          tierra > 0.0 &&
          tierra <= AppConstants.resistenciaTierraMaximaOhms) {
        count++;
      }
    }

    if (elecContinuidad) count++;
    if (funEncendido) count++;
    if (funCorriente) count++;
    if (funTemperatura) count++;
    if (funEmergencia) count++;
    if (docFoto) count++;
    if (docDiagrama) count++;
    if (docCertificado) count++;
    if (docManual) count++;
    return count;
  }

  double get progresoPorcentaje => totalItemsRequeridos > 0 ? (itemsCompletadosCount / totalItemsRequeridos) : 0.0;

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

      // Persistir datos del técnico si se ingresaron
      if (tecnicoResponsable.trim().isNotEmpty || matriculaProfesional.trim().isNotEmpty) {
        await guardarDatosTecnicoPersistidos(tecnicoResponsable, matriculaProfesional);
      }

      await _limpiarFormulario();
      
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> _limpiarFormulario() async {
    currentInstalacionId = null;
    nombreClienteGuardado = '';
    ciNitClienteGuardado = '';
    direccionGuardada = '';
    esquemaTierra = 'TN-S';
    distribuidora = 'ELFEC';
    medicionTierraExterna = false;

    // Mantenemos o recargamos los datos del técnico persistidos para no obligar a reescribirlos
    try {
      final prefs = await SharedPreferences.getInstance();
      tecnicoResponsable = prefs.getString(keyNombreTecnico) ?? tecnicoResponsable;
      matriculaProfesional = prefs.getString(keyRegistroSib) ?? matriculaProfesional;
    } catch (_) {}

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