import 'package:flutter_test/flutter_test.dart';
import 'package:wireflow_ve/features/advisor/domain/advisor_models.dart';

void main() {
  group('AdvisorModels y Catálogo Boliviano', () {
    test('1. Catálogo contiene presets verificados del mercado boliviano', () {
      final vehiculos = CatalogoVehiculosBolivia.vehiculos;
      expect(vehiculos.length, greaterThanOrEqualTo(10));

      // BYD Dolphin Mini
      final bydMini = vehiculos.firstWhere((v) => v.modelo.contains('Dolphin Mini'));
      expect(bydMini.marca, 'BYD');
      expect(bydMini.bateriaKwh, 38.0);
      expect(bydMini.obcMaxKw, 6.6);
      expect(bydMini.conectorNativo, 'GB/T');
      expect(bydMini.esTrifasicoAC, isFalse);
      expect(bydMini.nombreCompleto, 'BYD Dolphin Mini / Seagull');

      // Quantum Motors
      final quantum = vehiculos.firstWhere((v) => v.marca == 'Quantum Motors');
      expect(quantum.bateriaKwh, 12.0);
      expect(quantum.obcMaxKw, 3.3);
      expect(quantum.esTrifasicoAC, isFalse);

      // Toyota bZ4X
      final toyota = vehiculos.firstWhere((v) => v.modelo == 'bZ4X');
      expect(toyota.marca, 'Toyota');
      expect(toyota.bateriaKwh, 71.4);
      expect(toyota.obcMaxKw, 6.6);

      // Changan Lumin
      final changan = vehiculos.firstWhere((v) => v.modelo == 'Lumin');
      expect(changan.bateriaKwh, 28.0);
      expect(changan.obcMaxKw, 3.3);
    });

    test('2. Vehículos trifásicos soportan bandera esTrifasicoAC == true', () {
      final vehiculos = CatalogoVehiculosBolivia.vehiculos;
      final trifasico = vehiculos.firstWhere((v) => v.esTrifasicoAC);
      expect(trifasico.obcMaxKw, greaterThanOrEqualTo(11.0));
      expect(trifasico.conectorNativo, 'Tipo 2');
    });

    test('3. Modelo OpcionCargador transporta datos de interoperabilidad, alertas y costos', () {
      final opcion = OpcionCargador(
        nivel: 'ESTÁNDAR / CONFORT',
        titulo: 'Wallbox Residencial (7.4 kW)',
        potenciaKw: 7.4,
        tipoHardware: 'Wallbox Fijo de Pared (Modo 3)',
        rangoInversionBs: 'Bs 4.200 - Bs 5.800',
        horasRecarga: 5.5,
        kmPorHoraTexto: '~45 a 50 km/h',
        requerimientoElectrico: 'Circuito exclusivo con disyuntor Bipolar de 40A',
        avisoTecnico: 'Demanda de 32A continuos',
        requiereAdaptadorGbt: true,
      );

      expect(opcion.potenciaKw, 7.4);
      expect(opcion.horasRecarga, 5.5);
      expect(opcion.requiereAdaptadorGbt, isTrue);
      expect(opcion.rangoInversionBs, contains('Bs'));
      expect(opcion.avisoTecnico, isNotNull);
    });
  });
}
