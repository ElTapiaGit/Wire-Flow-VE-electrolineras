import 'dart:math';

class CalculatorResult {
  final double corrienteA;
  final int disyuntorA;
  final double seccionCableMm2;
  final String calibreAwg;
  final double caidaTensionPct;
  final String etiqueta; // identifidor tipo de calculo

  CalculatorResult({
    required this.corrienteA,
    required this.disyuntorA,
    required this.seccionCableMm2,
    required this.calibreAwg,
    required this.caidaTensionPct,
    required this.etiqueta,
  });

  bool get isCaidaCritica => caidaTensionPct > 4.0;
}

class CalculationResponse {
  final CalculatorResult recommended; 
  final CalculatorResult flexible;    

  CalculationResponse({required this.recommended, required this.flexible});
}

class CalculatorEngine {
  static const double resistividadCobre = 0.0172;
  // tabla oficial basada en Norma Boliviana NB 777 (y NEC)
  // Conductores de cobre aislados con PVC (70 ºC)
  static const List<Map<String, dynamic>> tablaNB777 = [
    {'awg': '16',  'mm2': 1.31,  'amp': 10.0},
    {'awg': '14',  'mm2': 2.08,  'amp': 15.0},
    {'awg': '12',  'mm2': 3.31,  'amp': 20.0},
    {'awg': '10',  'mm2': 5.26,  'amp': 30.0},
    {'awg': '8',   'mm2': 8.36,  'amp': 40.0},
    {'awg': '6',   'mm2': 13.28, 'amp': 55.0},
    {'awg': '4',   'mm2': 21.15, 'amp': 70.0},
    {'awg': '2',   'mm2': 33.62, 'amp': 95.0},
    {'awg': '1',   'mm2': 42.37, 'amp': 110.0},
    {'awg': '1/0', 'mm2': 53.90, 'amp': 150.0},
  ];

  // estandar Internacional (IEC/NEC)
  static const List<Map<String, dynamic>> tablaInternacional = [
    {'awg': '16', 'mm2': 1.5,  'ampMono': 17.5, 'ampTri': 15.5},
    {'awg': '14', 'mm2': 2.5,  'ampMono': 24.0, 'ampTri': 21.0},
    {'awg': '12', 'mm2': 4.0,  'ampMono': 32.0, 'ampTri': 28.0},
    {'awg': '10', 'mm2': 6.0,  'ampMono': 41.0, 'ampTri': 36.0},
    {'awg': '8',  'mm2': 10.0, 'ampMono': 57.0, 'ampTri': 50.0},
    {'awg': '6',  'mm2': 16.0, 'ampMono': 76.0, 'ampTri': 68.0},
    {'awg': '4',  'mm2': 25.0, 'ampMono': 96.0, 'ampTri': 86.0}, 
    {'awg': '2',  'mm2': 35.0, 'ampMono': 119.0, 'ampTri': 107.0},
  ];
  // valores de termomagneticos (DIN) comerciales en bolivia
  static const List<int> _disyuntoresComerciales = [16, 20, 25, 32, 40, 50, 63, 80, 100, 125];

  // METODO PRINCIPAL DE ENTRADA
  static CalculationResponse calcularTodo({
    required double potenciaKw,
    required double distanciaM,
    required int tipoRed,
    required double voltaje,
    required bool usarNormaNacional,
  }) {
    // Calculo estricto conforme a normativa (Seguridad Máxima)
    final strict = _ejecutarAlgoritmo(
      potenciaKw: potenciaKw,
      distanciaM: distanciaM,
      tipoRed: tipoRed,
      voltaje: voltaje,
      usarNormaNacional: usarNormaNacional,
      tolerancia: 0.5,
      etiqueta: 'RECOMENDADO (Seguridad Máxima)',
    );

    // Calculo flexible conforme a optimización comercial
    final flexible = _ejecutarAlgoritmo(
      potenciaKw: potenciaKw,
      distanciaM: distanciaM,
      tipoRed: tipoRed,
      voltaje: voltaje,
      usarNormaNacional: usarNormaNacional,
      tolerancia: 2.5,
      etiqueta: 'ALTERNATIVO (Optimizado)',
    );

    return CalculationResponse(recommended: strict, flexible: flexible);
  }

  static CalculatorResult _ejecutarAlgoritmo({
    required double potenciaKw,
    required double distanciaM,
    required int tipoRed, // 0: Monofasica, 1: Trifasica, 2: Delta (Fase-Fase)
    required double voltaje,
    required bool usarNormaNacional,
    required double tolerancia,
    required String etiqueta,
  }) {
    // Corriente Nominal
    // En Delta (tipoRed == 2) la conexion es entre 2 fases vivas a tension de linea (V_LL): I = P / V
    double corriente = (tipoRed == 1) 
        ? (potenciaKw * 1000) / (voltaje * sqrt(3))
        : (potenciaKw * 1000) / voltaje;

    // Disyuntor (estrictamente >= 125% de carga continua segun NB 777 / NEC 625 con margen de tolerancia)
    double corrienteSeguridad = corriente * 1.25;
    int disyuntor = _seleccionarDisyuntorComercial(corrienteSeguridad, tolerancia);

    // seleccion: ampacidad debe ser mayor o igual al disyuntor
    int indexConductor = -1; 
    List<Map<String, dynamic>> tablaActiva = usarNormaNacional ? tablaNB777 : tablaInternacional;
    
    for (int i = 0; i < tablaActiva.length; i++) {
      double ampacidadCable = usarNormaNacional
        ? tablaActiva[i]['amp'] 
        : (tipoRed == 1 ? tablaActiva[i]['ampTri'] : tablaActiva[i]['ampMono']);

      if (ampacidadCable >= disyuntor) {
        indexConductor = i;
        break; 
      }
    }

    if (indexConductor == -1) {
      throw Exception('La corriente de diseño ($disyuntor A) excede la capacidad del cable más grueso disponible. Requiere estudio de ingeniería.');
    }

    var conductor = tablaActiva[indexConductor];
    // Caida de Tension
    double caidaPct = _calcularCaidaTension(tipoRed, voltaje, distanciaM, corriente, conductor['mm2']);

    // Bucle de correccion por caida de tension: aumenta la seccion mientras sea > 4.0% hasta agotar la tabla
    while (caidaPct > 4.0 && indexConductor < tablaActiva.length - 1) {
      indexConductor++;
      conductor = tablaActiva[indexConductor];
      caidaPct = _calcularCaidaTension(tipoRed, voltaje, distanciaM, corriente, conductor['mm2']);
    }

    // No lanzamos excepcion si caidaPct supera 4.0% al agotar la tabla;
    // devolvemos el resultado para que la interfaz alerte visualmente via isCaidaCritica.
    return CalculatorResult(
      corrienteA: corriente,
      disyuntorA: disyuntor,
      seccionCableMm2: conductor['mm2'],
      calibreAwg: conductor['awg'],
      caidaTensionPct: caidaPct,
      etiqueta: etiqueta,
    );
  }

  static double _calcularCaidaTension(int tipoRed, double voltaje, double distancia, double corriente, double seccion) {
    double vDrop = (tipoRed == 1)
        ? (sqrt(3) * resistividadCobre * distancia * corriente) / seccion
        : (2 * resistividadCobre * distancia * corriente) / seccion;

    return (vDrop / voltaje) * 100;
  }

  static int _seleccionarDisyuntorComercial(double corrienteReq, double tolerancia) {
    for (int valor in _disyuntoresComerciales) {
      if ((valor + tolerancia) >= corrienteReq) {
        return valor;
      }
    }
    throw Exception(
      'La corriente de diseño calculada (${corrienteReq.toStringAsFixed(1)} A) supera el catálogo comercial estándar (máx. 125 A). Se requiere diseño de subestación.',
    );
  }
}