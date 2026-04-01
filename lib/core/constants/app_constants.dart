class AppConstants {
  // Precios referenciales
  static const double precioCableAwg1_0PorMetro = 145.00;// 14500 Bs / 100m
  static const double precioCableAwg1PorMetro = 115.00;  // 11500 Bs / 100m
  static const double precioCableAwg2PorMetro = 88.50;   // 8850 Bs / 100m
  static const double precioCableAwg4PorMetro = 55.00;   // 5500 Bs / 100 
  static const double precioCableAwg6PorMetro = 42.88; // 4288 Bs / 100m
  static const double precioCableAwg8PorMetro = 25.46; // 2546 Bs / 100m
  static const double precioCableAwg10PorMetro = 15.68; // 1568 Bs / 100m
  static const double precioCableAwg12PorMetro = 10.50;  // 1050 Bs / 100m
  static const double precioCableAwg14PorMetro = 6.80;   // Estimado ~ 680 Bs / 100m
  static const double precioCableAwg16PorMetro = 4.50;   // Estimado ~ 450 Bs / 100m
  static const double precioJabalina = 120.00;
  static const double precioBaseProtecciones = 450.00;
  static const double precioBaseManoObra = 800.00;

  // MAPA UNIFICADO PARA EL COTIZADOR
  static const Map<String, double> preciosSugeridosCable = {
    '16': precioCableAwg16PorMetro,
    '14': precioCableAwg14PorMetro,
    '12': precioCableAwg12PorMetro,
    '10': precioCableAwg10PorMetro,
    '8': precioCableAwg8PorMetro,
    '6': precioCableAwg6PorMetro,
    '4': precioCableAwg4PorMetro,
    '2': precioCableAwg2PorMetro,
    '1': precioCableAwg1PorMetro,
    '1/0': precioCableAwg1_0PorMetro
  };

  // TARIFAS ENERGETICAS (Bolivia)
  static const double tarifaElectricaKwh = 0.80; // Bs / kWh
  static const double tarifaGnvM3 = 2.73;        // Bs / m3
  static const double tarifaGasolinaLitro = 6.96; // Bs / Litro

  // RENDIMIENTOS PROMEDIO 
  static const double consumoEvKwhPorKm = 0.15;     // 15 kWh / 100km
  static const double consumoGasolinaKmPorL = 10.0; // 10 km por Litro
  static const double consumoGnvKmPorM3 = 12.0;     // 12 km por m3
  
}