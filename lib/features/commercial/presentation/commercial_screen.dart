import 'package:flutter/material.dart';
import 'package:wireflow_ve/core/constants/app_constants.dart';
import 'package:wireflow_ve/core/services/pdf_service.dart';

class CommercialScreen extends StatefulWidget {
  const CommercialScreen({super.key});

  @override
  State<CommercialScreen> createState() => _CommercialScreenState();
}

class _CommercialScreenState extends State<CommercialScreen> {
  int _currentTabIndex = 0;
  
  // ENTRADAS DEL VEHICULO Y CARGADOR 
  final TextEditingController _batteryController = TextEditingController(text: '60');
  final TextEditingController _chargerPowerController = TextEditingController(text: '7.4'); 
  
  // PRECIOS UNITARIOS
  double _precioKwh = AppConstants.tarifaElectricaKwh;
  double _precioGnv = AppConstants.tarifaGnvM3;
  double _precioGasolina = AppConstants.tarifaGasolinaLitro;

  // ESTADO: PESTAÑA 2 (PRESUPUESTO)
  String _calibreSeleccionado = '8';
  bool _isProteccionesExpanded = false;
  bool _isGeneratingPdf = false;
  
  // Controladores para que el tecnico edite todo a su gusto
  final TextEditingController _metrosController = TextEditingController(text: '15');
  late final TextEditingController _precioMetroController;
  final TextEditingController _proteccionesController = TextEditingController(text: '675.00');
  final TextEditingController _manoObraController = TextEditingController(text: AppConstants.precioBaseManoObra.toStringAsFixed(2));

  // Controladores de componentes individuales de protecciones (Precios mercado Bolivia)
  final TextEditingController _gabineteCtrl = TextEditingController(text: '80.00');
  final TextEditingController _mcbCtrl = TextEditingController(text: '45.00');
  final TextEditingController _rcdCtrl = TextEditingController(text: '240.00');
  final TextEditingController _spdCtrl = TextEditingController(text: '140.00');
  final TextEditingController _ovpCtrl = TextEditingController(text: '85.00');
  final TextEditingController _patCtrl = TextEditingController(text: '85.00');
  
  @override
  void initState() {
    super.initState();
    _precioMetroController = TextEditingController(
      text: AppConstants.preciosSugeridosCable[_calibreSeleccionado]!.toStringAsFixed(2)
    );
  }

  @override
  void dispose() {
    _batteryController.dispose();
    _chargerPowerController.dispose();
    _metrosController.dispose();
    _precioMetroController.dispose();
    _proteccionesController.dispose();
    _manoObraController.dispose();
    _gabineteCtrl.dispose();
    _mcbCtrl.dispose();
    _rcdCtrl.dispose();
    _spdCtrl.dispose();
    _ovpCtrl.dispose();
    _patCtrl.dispose();
    super.dispose();
  }

  void _recalcularTotalProtecciones() {
    final double g = double.tryParse(_gabineteCtrl.text.trim().replaceAll(',', '.')) ?? 0;
    final double m = double.tryParse(_mcbCtrl.text.trim().replaceAll(',', '.')) ?? 0;
    final double r = double.tryParse(_rcdCtrl.text.trim().replaceAll(',', '.')) ?? 0;
    final double s = double.tryParse(_spdCtrl.text.trim().replaceAll(',', '.')) ?? 0;
    final double o = double.tryParse(_ovpCtrl.text.trim().replaceAll(',', '.')) ?? 0;
    final double p = double.tryParse(_patCtrl.text.trim().replaceAll(',', '.')) ?? 0;
    final double total = g + m + r + s + o + p;
    _proteccionesController.text = total.toStringAsFixed(2);
    setState(() {});
  }

  void _restaurarPreciosSugeridosProtecciones() {
    _gabineteCtrl.text = '80.00';
    _mcbCtrl.text = '45.00';
    _rcdCtrl.text = '240.00';
    _spdCtrl.text = '140.00';
    _ovpCtrl.text = '85.00';
    _patCtrl.text = '85.00';
    _recalcularTotalProtecciones();
  }

  Future<void> _generarPdfComercial() async {
    if (_isGeneratingPdf) return;

    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final double metros = double.tryParse(_metrosController.text.trim().replaceAll(',', '.')) ?? 0.0;
      final double precioPorMetro = double.tryParse(_precioMetroController.text.trim().replaceAll(',', '.')) ?? 0.0;
      final double protecciones = double.tryParse(_proteccionesController.text.trim().replaceAll(',', '.')) ?? 0.0;
      final double manoObra = double.tryParse(_manoObraController.text.trim().replaceAll(',', '.')) ?? 0.0;
      final double costoTotalCable = metros * precioPorMetro;
      final double subtotalMateriales = costoTotalCable + protecciones;
      final double granTotal = subtotalMateriales + manoObra;

      // Lectura del Ahorro Anual y Mensual vs Gasolina (Pestaña Comparativa)
      final double bateriaKwh = double.tryParse(_batteryController.text.trim().replaceAll(',', '.')) ?? 0.0;
      final double potenciaCargadorKw = double.tryParse(_chargerPowerController.text.trim().replaceAll(',', '.')) ?? 0.0;
      final bool esDatoValido = bateriaKwh > 0 && potenciaCargadorKw > 0;

      final double ahorroAnual = esDatoValido
          ? ((15000 / AppConstants.consumoGasolinaKmPorL * _precioGasolina) - (15000 * AppConstants.consumoEvKwhPorKm * _precioKwh))
          : 0.0;
      final double ahorroMensual = ahorroAnual > 0 ? ahorroAnual / 12 : 0.0;

      final desglose = <String, double>{
        'Gabinete estanco IP65': double.tryParse(_gabineteCtrl.text.trim().replaceAll(',', '.')) ?? 80.0,
        'Disyuntor Termomagnético Bipolar Curva C': double.tryParse(_mcbCtrl.text.trim().replaceAll(',', '.')) ?? 45.0,
        'Interruptor Diferencial Tipo A 30mA': double.tryParse(_rcdCtrl.text.trim().replaceAll(',', '.')) ?? 240.0,
        'Protector de Sobretensión SPD Clase II': double.tryParse(_spdCtrl.text.trim().replaceAll(',', '.')) ?? 140.0,
        'Relé de Monitoreo de Tensión OVP/UVP': double.tryParse(_ovpCtrl.text.trim().replaceAll(',', '.')) ?? 85.0,
        'Kit de Puesta a Tierra y Conexión': double.tryParse(_patCtrl.text.trim().replaceAll(',', '.')) ?? 85.0,
      };

      await PdfService.generarCotizacionComercialPdf(
        context: context,
        calibreAwg: _calibreSeleccionado,
        distanciaM: metros,
        precioMetroCable: precioPorMetro,
        costoTotalCable: costoTotalCable,
        costoProtecciones: protecciones,
        desgloseProtecciones: desglose,
        costoManoObra: manoObra,
        subtotalMateriales: subtotalMateriales,
        totalEstimado: granTotal,
        ahorroMensualVsGasolina: ahorroMensual,
        ahorroAnualVsGasolina: ahorroAnual,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar la cotización: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
        });
      }
    }
  }

  void _mostrarDialogoEdicion() {
    showDialog(
      context: context,
      builder: (context) => _DialogoEdicionTarifas(
        precioKwh: _precioKwh,
        precioGnv: _precioGnv,
        precioGasolina: _precioGasolina,
        onGuardar: (kwh, gnv, gas) {
          setState(() {
            _precioKwh = kwh;
            _precioGnv = gnv;
            _precioGasolina = gas;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabSelector(),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 4.0, bottom: 100.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentTabIndex == 0 
                        ? _buildAhorroTab() 
                        : _buildPresupuestoTab(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Módulo Comercial',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTabButton('Comparativa', 0)),
            Expanded(child: _buildTabButton('Presupuesto', 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isActive = _currentTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // PESTAÑA 1: CALCULADORA DE AHORRO 
  Widget _buildAhorroTab() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color gnvColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);

    // 1. Lectura de variables sanitizadas
    final double bateriaKwh = double.tryParse(_batteryController.text.trim().replaceAll(',', '.')) ?? 0.0;
    final double potenciaCargadorKw = double.tryParse(_chargerPowerController.text.trim().replaceAll(',', '.')) ?? 0.0;

    // Validación estricta para evitar divisiones por cero, valores negativos o infinitos
    final bool esDatoValido = bateriaKwh > 0 && potenciaCargadorKw > 0;

    // 2. Cálculos de Capacidad (Tanque Lleno)
    final double tiempoCargaHoras = esDatoValido ? bateriaKwh / potenciaCargadorKw : 0.0;
    final double autonomiaKm = esDatoValido ? bateriaKwh / AppConstants.consumoEvKwhPorKm : 0.0;

    // 3. Cálculos de Costo para recorrer ESA autonomía
    final double costoTanqueEv = esDatoValido ? bateriaKwh * _precioKwh : 0.0;
    
    final double litrosGasolinaNecesarios = esDatoValido ? autonomiaKm / AppConstants.consumoGasolinaKmPorL : 0.0;
    final double costoTanqueGasolina = esDatoValido ? litrosGasolinaNecesarios * _precioGasolina : 0.0;

    final double m3GnvNecesarios = esDatoValido ? autonomiaKm / AppConstants.consumoGnvKmPorM3 : 0.0;
    final double costoTanqueGnv = esDatoValido ? m3GnvNecesarios * _precioGnv : 0.0;

    // 4. Ahorro Anual y Mensual (Proyección a 15,000 km)
    final double ahorroAnual = esDatoValido
        ? ((15000 / AppConstants.consumoGasolinaKmPorL * _precioGasolina) - (15000 * AppConstants.consumoEvKwhPorKm * _precioKwh))
        : 0.0;
    final double ahorroMensualVsGasolina = ahorroAnual > 0 ? (ahorroAnual / 12) : 0.0;

    // 5. Total presupuestado desde la pestaña Presupuesto para cálculo de amortización
    final double metros = double.tryParse(_metrosController.text.trim().replaceAll(',', '.')) ?? 0.0;
    final double precioPorMetro = double.tryParse(_precioMetroController.text.trim().replaceAll(',', '.')) ?? 0.0;
    final double protecciones = double.tryParse(_proteccionesController.text.trim().replaceAll(',', '.')) ?? 0.0;
    final double manoObra = double.tryParse(_manoObraController.text.trim().replaceAll(',', '.')) ?? 0.0;
    final double totalEstimadoPresupuesto = (metros * precioPorMetro) + protecciones + manoObra;

    final double tiempoRetornoMeses = (ahorroMensualVsGasolina > 0 && totalEstimadoPresupuesto > 0)
        ? (totalEstimadoPresupuesto / ahorroMensualVsGasolina)
        : 0.0;

    // Referencia para la barra de progreso (El más caro es el 100%)
    final double maxCost = costoTanqueGasolina > costoTanqueGnv ? costoTanqueGasolina : costoTanqueGnv;

    return Column(
      key: const ValueKey('ahorro_tab'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DATOS DEL VEHÍCULO Y CARGADOR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  Icon(Icons.electric_car, color: Theme.of(context).colorScheme.primary, size: 24),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Batería del EV', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            const SizedBox(width: 4),
                            Icon(Icons.edit, size: 10, color: Theme.of(context).colorScheme.outline),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _batteryController,
                                keyboardType: TextInputType.number,
                                onChanged: (v) => setState(() {}),
                                style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                                decoration: InputDecoration(
                                  isDense: true, 
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('kWh', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 40, color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Potencia de Carga', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            const SizedBox(width: 4),
                            Icon(Icons.edit, size: 10, color: Theme.of(context).colorScheme.outline),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _chargerPowerController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onChanged: (v) => setState(() {}),
                                style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                                decoration: InputDecoration(
                                  isDense: true, 
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('kW', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tiempo de carga (0-100%)', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Text(esDatoValido ? '~${tiempoCargaHoras.toStringAsFixed(1)} horas' : '--', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Autonomía estimada', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Text(esDatoValido ? '${autonomiaKm.toInt()} km' : '--', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.compare_arrows, color: Theme.of(context).colorScheme.secondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(esDatoValido ? 'Costo para recorrer ${autonomiaKm.toInt()} km' : 'Costo para recorrer autonomía estimada', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.outline), 
                    onPressed: _mostrarDialogoEdicion,
                    tooltip: 'Editar Tarifas',
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildProgressRow(
                'Carga EV Completa',
                esDatoValido ? 'Bs ${costoTanqueEv.toStringAsFixed(2)}' : '--',
                Icons.battery_charging_full,
                Theme.of(context).colorScheme.secondary,
                (esDatoValido && maxCost > 0) ? costoTanqueEv / maxCost : 0,
              ),
              const SizedBox(height: 16),
              _buildProgressRow(
                'Equivalente en GNV',
                esDatoValido ? 'Bs ${costoTanqueGnv.toStringAsFixed(2)}' : '--',
                Icons.gas_meter,
                gnvColor,
                (esDatoValido && maxCost > 0) ? costoTanqueGnv / maxCost : 0,
              ),
              const SizedBox(height: 16),
              _buildProgressRow(
                'Equivalente en Gasolina',
                esDatoValido ? 'Bs ${costoTanqueGasolina.toStringAsFixed(2)}' : '--',
                Icons.local_gas_station,
                const Color(0xFFFF1744),
                (esDatoValido && maxCost > 0) ? costoTanqueGasolina / maxCost : 0,
              ),
              
              Padding(padding: const EdgeInsets.symmetric(vertical: 24.0), child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
              
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.savings, color: Theme.of(context).colorScheme.secondary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AHORRO ESTIMADO ANUAL (15,000 km)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        Text(esDatoValido ? 'Bs ${ahorroAnual.toStringAsFixed(2)}' : '--', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 16),

        // TARJETA DE RETORNO DE INVERSIÓN (PAYBACK / ROI)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Retorno de Inversión Estimado',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                (esDatoValido && tiempoRetornoMeses > 0)
                    ? 'Tu instalación se paga sola en ${tiempoRetornoMeses.toStringAsFixed(1)} meses'
                    : 'Tu instalación se paga sola en -- meses',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                (esDatoValido && tiempoRetornoMeses > 0)
                    ? 'Con un ahorro proyectado de Bs ${ahorroMensualVsGasolina.toStringAsFixed(2)} al mes frente a la gasolina, recuperas el costo total de la obra (Bs ${totalEstimadoPresupuesto.toStringAsFixed(2)}) en menos de ${tiempoRetornoMeses.ceil()} meses de uso continuo.'
                    : 'Ingresa la batería del vehículo y potencia de carga para proyectar la amortización en base al presupuesto actual de Bs ${totalEstimadoPresupuesto.toStringAsFixed(2)}.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(String title, String cost, IconData icon, Color color, double percentage) {
    final safePct = (percentage.isNaN || percentage.isInfinite) ? 0.0 : (percentage > 1.0 ? 1.0 : (percentage < 0 ? 0.0 : percentage));
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 4),
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            Text(cost, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.centerLeft,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * safePct,
                height: 12,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
              );
            }
          ),
        ),
      ],
    );
  }

  // PESTAÑA 2: PRESUPUESTO 
  Widget _buildPresupuestoTab() {
    // Lectura en tiempo real de los campos editables sanitizados con comas y puntos
    double metros = double.tryParse(_metrosController.text.trim().replaceAll(',', '.')) ?? 0;
    double precioPorMetro = double.tryParse(_precioMetroController.text.trim().replaceAll(',', '.')) ?? 0;
    double protecciones = double.tryParse(_proteccionesController.text.trim().replaceAll(',', '.')) ?? 0;
    double manoObra = double.tryParse(_manoObraController.text.trim().replaceAll(',', '.')) ?? 0;

    double costoTotalCable = metros * precioPorMetro;
    double subtotalMateriales = costoTotalCable + protecciones;
    double granTotal = subtotalMateriales + manoObra;

    return Column(
      key: const ValueKey('presupuesto_tab'),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('COSTOS DE MATERIALES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  Icon(Icons.inventory_2, color: Theme.of(context).colorScheme.primary, size: 24),
                ],
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cable (AWG)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 40,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(4), border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _calibreSeleccionado,
                        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
                        style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _calibreSeleccionado = newValue;
                              _precioMetroController.text = AppConstants.preciosSugeridosCable[newValue]!.toStringAsFixed(2);
                            });
                          }
                        },
                        items: AppConstants.preciosSugeridosCable.keys.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('AWG $value'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildInputEditable('Distancia (m)', _metrosController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInputEditable('Precio/Metro (Bs)', _precioMetroController)),
                ],
              ),
              
              Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tablero y Protecciones', 
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  InkWell(
                    onTap: () => setState(() => _isProteccionesExpanded = !_isProteccionesExpanded),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isProteccionesExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isProteccionesExpanded ? 'Ocultar desglose' : 'Desglosar componentes',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInputEditable('Costo total de protecciones (Bs)', _proteccionesController),
              if (_isProteccionesExpanded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'COMPONENTES NORMATIVOS SUGERIDOS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: _restaurarPreciosSugeridosProtecciones,
                            child: Text(
                              'Restaurar sugeridos',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFilaComponente('Gabinete / Tablero estanco IP65', _gabineteCtrl, 'Bs 80.00'),
                      _buildFilaComponente('Disyuntor Termomagnético Bipolar Curva C', _mcbCtrl, 'Bs 45.00'),
                      _buildFilaComponente('Interruptor Diferencial Tipo A 30mA', _rcdCtrl, 'Bs 240.00'),
                      _buildFilaComponente('Protector de Sobretensión SPD Clase II', _spdCtrl, 'Bs 140.00'),
                      _buildFilaComponente('Relé de Monitoreo de Tensión OVP/UVP', _ovpCtrl, 'Bs 85.00'),
                      _buildFilaComponente('Kit de Puesta a Tierra y Conexión', _patCtrl, 'Bs 85.00', isLast: true),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('MANO DE OBRA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  Icon(Icons.engineering, color: Theme.of(context).colorScheme.secondary, size: 24),
                ],
              ),
              const SizedBox(height: 16),
              Text('Instalación y Configuración', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 8),
              _buildInputEditable('Costo por servicio (Bs)', _manoObraController),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // TARJETA DE RESUMEN
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DESGLOSE DE COTIZACIÓN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              _buildResumenItem('Cable AWG $_calibreSeleccionado (${metros.toInt()} m)', costoTotalCable),
              const SizedBox(height: 8),
              _buildResumenItem('Protecciones (Tablero, Disyuntores)', protecciones),
              Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
              _buildResumenItem('Subtotal Materiales', subtotalMateriales, isBold: true),
              const SizedBox(height: 16),
              _buildResumenItem('Servicio de Instalación', manoObra),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('TOTAL ESTIMADO', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  Text('Bs ${granTotal.toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // BOTON EXPORTAR COTIZACION
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _isGeneratingPdf ? null : _generarPdfComercial,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            icon: _isGeneratingPdf
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : const Icon(Icons.picture_as_pdf),
            label: Text(
              _isGeneratingPdf ? 'GENERANDO PDF...' : 'GENERAR PDF PARA CLIENTE',
              style: const TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilaComponente(String title, TextEditingController controller, String sugerido, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Sugerido: $sugerido',
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 85,
            height: 38,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => _recalcularTotalProtecciones(),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget reutilizable para los campos de texto editables en el presupuesto
  Widget _buildInputEditable(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) => setState(() {}), 
          style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildResumenItem(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: isBold ? 14 : 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: isBold ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant))),
        Text('Bs ${value.toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: isBold ? 16 : 14, fontWeight: FontWeight.bold, color: isBold ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _DialogoEdicionTarifas extends StatefulWidget {
  final double precioKwh;
  final double precioGnv;
  final double precioGasolina;
  final void Function(double kwh, double gnv, double gas) onGuardar;

  const _DialogoEdicionTarifas({
    required this.precioKwh,
    required this.precioGnv,
    required this.precioGasolina,
    required this.onGuardar,
  });

  @override
  State<_DialogoEdicionTarifas> createState() => _DialogoEdicionTarifasState();
}

class _DialogoEdicionTarifasState extends State<_DialogoEdicionTarifas> {
  late final TextEditingController _kwhCtrl;
  late final TextEditingController _gnvCtrl;
  late final TextEditingController _gasCtrl;

  @override
  void initState() {
    super.initState();
    _kwhCtrl = TextEditingController(text: widget.precioKwh.toStringAsFixed(2));
    _gnvCtrl = TextEditingController(text: widget.precioGnv.toStringAsFixed(2));
    _gasCtrl = TextEditingController(text: widget.precioGasolina.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _kwhCtrl.dispose();
    _gnvCtrl.dispose();
    _gasCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color gnvColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text('Precios Unitarios', style: TextStyle(fontFamily: 'Space Grotesk', color: Theme.of(context).colorScheme.primary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _kwhCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Electricidad (Bs / kWh)', labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _gasCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Gasolina (Bs / Litro)', labelStyle: TextStyle(color: Color(0xFFFF1744))),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _gnvCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'GNV (Bs / m³)', labelStyle: TextStyle(color: gnvColor)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
        ),
        ElevatedButton(
          onPressed: () {
            final nuevoKwh = double.tryParse(_kwhCtrl.text.trim().replaceAll(',', '.')) ?? widget.precioKwh;
            final nuevoGnv = double.tryParse(_gnvCtrl.text.trim().replaceAll(',', '.')) ?? widget.precioGnv;
            final nuevoGas = double.tryParse(_gasCtrl.text.trim().replaceAll(',', '.')) ?? widget.precioGasolina;
            widget.onGuardar(nuevoKwh, nuevoGnv, nuevoGas);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer, 
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}