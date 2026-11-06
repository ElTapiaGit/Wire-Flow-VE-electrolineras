import 'package:flutter_test/flutter_test.dart';
import 'package:wireflow_ve/features/calculator/domain/calculator_engine.dart';

void main() {
  group('CalculatorEngine - Pruebas Unitarias de Ingeniería Eléctrica', () {
    test('1. Respuesta dual: 7.4 kW a 220V y 25m arroja flexible (40A, 6mm², ~2.19%) y recomendado (50A, 10mm², ~1.31%)', () {
      // 7.4 kW a 220V Monofásica, 25 metros, IEC
      final response = CalculatorEngine.calcularTodo(
        potenciaKw: 7.4,
        distanciaM: 25.0,
        tipoRed: 0, // Monofásica
        voltaje: 220.0,
        usarNormaNacional: false,
      );

      final flex = response.flexible;
      final strict = response.recommended;

      // Corriente nominal: I = 7400 / 220 = 33.64 A
      expect(flex.corrienteA, closeTo(33.64, 0.05));
      expect(strict.corrienteA, closeTo(33.64, 0.05));

      // Flexible (tolerancia 2.5): 40A, 6.0 mm² (10 AWG), caída ~2.19%
      expect(flex.disyuntorA, equals(40));
      expect(flex.calibreAwg, equals('10'));
      expect(flex.seccionCableMm2, equals(6.0));
      expect(flex.caidaTensionPct, closeTo(2.19, 0.02));

      // Recomendado (tolerancia 0.5): 50A, 10.0 mm² (8 AWG), caída ~1.31%
      expect(strict.disyuntorA, equals(50));
      expect(strict.calibreAwg, equals('8'));
      expect(strict.seccionCableMm2, equals(10.0));
      expect(strict.caidaTensionPct, closeTo(1.31, 0.02));
    });

    test('2. Carga trifásica (11 kW a 400V) calcula corriente con sqrt(3) y dimensiona protecciones tetrapolares', () {
      // 11 kW a 400V Trifásica (tipoRed == 1), 20 metros, IEC
      final response = CalculatorEngine.calcularTodo(
        potenciaKw: 11.0,
        distanciaM: 20.0,
        tipoRed: 1, // Trifásica
        voltaje: 400.0,
        usarNormaNacional: false,
      );

      final flex = response.flexible;
      final strict = response.recommended;

      // I = 11000 / (400 * sqrt(3)) = 15.877 A
      expect(flex.corrienteA, closeTo(15.88, 0.05));
      // I_diseño = 15.877 * 1.25 = 19.846 A -> Disyuntor 20A en flex y strict
      expect(flex.disyuntorA, equals(20));
      expect(strict.disyuntorA, equals(20));
      expect(flex.seccionCableMm2, equals(2.5));
    });

    test('3. Carga en red Delta a 230V opera entre 2 fases vivas sin sqrt(3)', () {
      // 7.4 kW a 230V Delta (tipoRed == 2), 25 metros, IEC
      final response = CalculatorEngine.calcularTodo(
        potenciaKw: 7.4,
        distanciaM: 25.0,
        tipoRed: 2, // Delta
        voltaje: 230.0,
        usarNormaNacional: false,
      );

      final flex = response.flexible;

      // I = 7400 / 230 = 32.17 A
      expect(flex.corrienteA, closeTo(32.17, 0.05));
      // I_diseño = 40.217A -> con tolerancia 2.5 selecciona 40A
      expect(flex.disyuntorA, equals(40));
      expect(flex.calibreAwg, equals('10'));
      expect(flex.seccionCableMm2, equals(6.0));
      expect(flex.caidaTensionPct, closeTo(2.01, 0.02));
    });

    test('4. Distancia extendida marca bandera de caída crítica (isCaidaCritica) sin abortar ejecución', () {
      // 7.4 kW a 230V Monofásica con 500 metros de distancia
      final response = CalculatorEngine.calcularTodo(
        potenciaKw: 7.4,
        distanciaM: 500.0,
        tipoRed: 0,
        voltaje: 230.0,
        usarNormaNacional: true,
      );

      final result = response.recommended;

      // Debe haber subido hasta el conductor de mayor sección en NB 777 (1/0 AWG - 53.90 mm²)
      expect(result.calibreAwg, equals('1/0'));
      expect(result.seccionCableMm2, equals(53.90));

      // La caída de tensión a 500m con 1/0 AWG supera el 4%
      expect(result.caidaTensionPct, greaterThan(4.0));

      // La bandera crítica debe ser verdadera para activar la alerta en la interfaz
      expect(result.isCaidaCritica, isTrue);
    });

    test('5. Disyuntor que supera 125A lanza excepción controlada con valor en amperios', () {
      // 60 kW a 230V monofásica generaría una corriente de diseño > 300A
      expect(
        () => CalculatorEngine.calcularTodo(
          potenciaKw: 60.0,
          distanciaM: 10.0,
          tipoRed: 0,
          voltaje: 230.0,
          usarNormaNacional: true,
        ),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('supera el catálogo comercial estándar') &&
            e.toString().contains('125 A'))),
      );
    });
  });
}

