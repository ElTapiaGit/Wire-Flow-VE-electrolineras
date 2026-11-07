class VehiculoPreset {
  final String marca;
  final String modelo;
  final double bateriaKwh;
  final double obcMaxKw; // Límite del cargador interno en corriente alterna
  final String conectorNativo; // 'GB/T', 'Tipo 2', 'Tipo 1', 'Schuko'
  final bool esTrifasicoAC;

  const VehiculoPreset({
    required this.marca,
    required this.modelo,
    required this.bateriaKwh,
    required this.obcMaxKw,
    required this.conectorNativo,
    this.esTrifasicoAC = false,
  });

  String get nombreCompleto => '$marca $modelo';
  String get nombre => nombreCompleto;
}

/// Catálogo de vehículos eléctricos presentes y verificados en el mercado boliviano
const List<VehiculoPreset> catalogoVehiculosBolivia = [
  // BYD
  VehiculoPreset(
    marca: 'BYD',
    modelo: 'Dolphin Mini / Seagull',
    bateriaKwh: 38.0,
    obcMaxKw: 6.6,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),
  VehiculoPreset(
    marca: 'BYD',
    modelo: 'Dolphin',
    bateriaKwh: 44.9,
    obcMaxKw: 7.0,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),
  VehiculoPreset(
    marca: 'BYD',
    modelo: 'Yuan Plus',
    bateriaKwh: 60.5,
    obcMaxKw: 7.0,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),
  VehiculoPreset(
    marca: 'BYD',
    modelo: 'Song Plus DM-i / EV',
    bateriaKwh: 18.3,
    obcMaxKw: 3.3,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),
  VehiculoPreset(
    marca: 'BYD',
    modelo: 'Han EV / Tang EV',
    bateriaKwh: 85.4,
    obcMaxKw: 7.0,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),

  // Toyota
  VehiculoPreset(
    marca: 'Toyota',
    modelo: 'bZ4X',
    bateriaKwh: 71.4,
    obcMaxKw: 6.6,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),
  VehiculoPreset(
    marca: 'Toyota',
    modelo: 'bZ3 Sedán',
    bateriaKwh: 49.9,
    obcMaxKw: 7.0,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),

  // Quantum Motors
  VehiculoPreset(
    marca: 'Quantum Motors',
    modelo: 'E2 / E3 / E4',
    bateriaKwh: 12.0,
    obcMaxKw: 3.3,
    conectorNativo: 'Schuko / Tipo 1',
    esTrifasicoAC: false,
  ),

  // Changan
  VehiculoPreset(
    marca: 'Changan',
    modelo: 'Lumin',
    bateriaKwh: 28.0,
    obcMaxKw: 3.3,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),

  // Dongfeng
  VehiculoPreset(
    marca: 'Dongfeng',
    modelo: 'Nano Box',
    bateriaKwh: 27.2,
    obcMaxKw: 3.3,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),

  // JAC
  VehiculoPreset(
    marca: 'JAC',
    modelo: 'e-JS1',
    bateriaKwh: 31.4,
    obcMaxKw: 6.6,
    conectorNativo: 'GB/T',
    esTrifasicoAC: false,
  ),

  // Tesla / Euro EV (Trifásico)
  VehiculoPreset(
    marca: 'Tesla',
    modelo: 'Model 3 / Y (Euro Trifásico)',
    bateriaKwh: 75.0,
    obcMaxKw: 11.0,
    conectorNativo: 'Tipo 2',
    esTrifasicoAC: true,
  ),
];

class CatalogoVehiculosBolivia {
  static List<VehiculoPreset> get vehiculos => catalogoVehiculosBolivia;
}

/// Representa una opción técnica viable generada para el carrusel comparativo
class OpcionCargador {
  final String nivel; // 'BÁSICA / ECONÓMICA', 'ESTÁNDAR / CONFORT', 'AVANZADA / TRIFÁSICA'
  final String titulo;
  final double potenciaKw;
  final String tipoHardware; // 'Portátil Reforzado', 'Wallbox Fijo', etc.
  final String rangoInversionBs;
  final double horasRecarga;
  final String kmPorHoraTexto;
  final String requerimientoElectrico;
  final String? avisoTecnico;
  final bool requiereAdaptadorGbt;

  const OpcionCargador({
    required this.nivel,
    required this.titulo,
    required this.potenciaKw,
    required this.tipoHardware,
    required this.rangoInversionBs,
    required this.horasRecarga,
    required this.kmPorHoraTexto,
    required this.requerimientoElectrico,
    this.avisoTecnico,
    this.requiereAdaptadorGbt = false,
  });
}
