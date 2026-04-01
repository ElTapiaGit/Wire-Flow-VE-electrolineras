import 'package:flutter/material.dart';
import 'package:wireflow_ve/core/constants/app_constants.dart';

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
  
  // Controladores para que el tecnico edite todo a su gusto
  final TextEditingController _metrosController = TextEditingController(text: '15');
  late final TextEditingController _precioMetroController;
  final TextEditingController _proteccionesController = TextEditingController(text: AppConstants.precioBaseProtecciones.toStringAsFixed(2));
  final TextEditingController _manoObraController = TextEditingController(text: AppConstants.precioBaseManoObra.toStringAsFixed(2));
  
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
    super.dispose();
  }

  void _mostrarDialogoEdicion() {
    final kwhCtrl = TextEditingController(text: _precioKwh.toStringAsFixed(2));
    final gnvCtrl = TextEditingController(text: _precioGnv.toStringAsFixed(2));
    final gasCtrl = TextEditingController(text: _precioGasolina.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Text('Precios Unitarios', style: TextStyle(fontFamily: 'Space Grotesk', color: Theme.of(context).colorScheme.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: kwhCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Electricidad (Bs / kWh)', labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: gasCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Gasolina (Bs / Litro)', labelStyle: TextStyle(color: Color(0xFFFF1744))),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: gnvCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'GNV (Bs / m³)', labelStyle: TextStyle(color: Color(0xFFFFD600))),
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
                setState(() {
                  _precioKwh = double.tryParse(kwhCtrl.text) ?? _precioKwh;
                  _precioGnv = double.tryParse(gnvCtrl.text) ?? _precioGnv;
                  _precioGasolina = double.tryParse(gasCtrl.text) ?? _precioGasolina;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer, foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer),
              child: const Text('Guardar'),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildModuleHeaderAndTabs(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 100.0),
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

  Widget _buildModuleHeaderAndTabs() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comercial', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          Text('COTIZADOR Y RETORNO DE INVERSIÓN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(child: _buildTabButton('Comparativa', 0)),
                Expanded(child: _buildTabButton('Presupuesto', 1)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isActive = _currentTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    // 1. Lectura de variables
    final double bateriaKwh = double.tryParse(_batteryController.text) ?? 0.0;
    final double potenciaCargadorKw = double.tryParse(_chargerPowerController.text) ?? 7.4;

    // 2. CAlculos de Capacidad (Tanque Lleno)
    final double tiempoCargaHoras = potenciaCargadorKw > 0 ? bateriaKwh / potenciaCargadorKw : 0.0;
    final double autonomiaKm = bateriaKwh / AppConstants.consumoEvKwhPorKm;

    // 3. CAlculos de Costo para recorrer ESA autonomia
    final double costoTanqueEv = bateriaKwh * _precioKwh;
    
    final double litrosGasolinaNecesarios = autonomiaKm / AppConstants.consumoGasolinaKmPorL;
    final double costoTanqueGasolina = litrosGasolinaNecesarios * _precioGasolina;

    final double m3GnvNecesarios = autonomiaKm / AppConstants.consumoGnvKmPorM3;
    final double costoTanqueGnv = m3GnvNecesarios * _precioGnv;

    // 4. Ahorro Anual (Proyección a 15,000 km)
    final double ahorroAnual = (15000 / AppConstants.consumoGasolinaKmPorL * _precioGasolina) - (15000 * AppConstants.consumoEvKwhPorKm * _precioKwh);

    // Referencia para la barra de progreso (El mas caro es el 100%)
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
                            SizedBox(width: 4),
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
                            SizedBox(width: 4),
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
              Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tiempo de carga (0-100%)', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Text('~${tiempoCargaHoras.toStringAsFixed(1)} horas', style:  TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Autonomía estimada', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Text('${autonomiaKm.toInt()} km', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
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
                        Expanded(child: Text('Costo para recorrer ${autonomiaKm.toInt()} km', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))),
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
              
              _buildProgressRow('Carga EV Completa', 'Bs ${costoTanqueEv.toStringAsFixed(2)}', Icons.battery_charging_full, Theme.of(context).colorScheme.secondary, maxCost > 0 ? costoTanqueEv / maxCost : 0),
              const SizedBox(height: 16),
              _buildProgressRow('Equivalente en GNV', 'Bs ${costoTanqueGnv.toStringAsFixed(2)}', Icons.gas_meter, const Color(0xFFFFD600), maxCost > 0 ? costoTanqueGnv / maxCost : 0),
              const SizedBox(height: 16),
              _buildProgressRow('Equivalente en Gasolina', 'Bs ${costoTanqueGasolina.toStringAsFixed(2)}', Icons.local_gas_station, const Color(0xFFFF1744), maxCost > 0 ? costoTanqueGasolina / maxCost : 0),
              
              Padding(padding: EdgeInsets.symmetric(vertical: 24.0), child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
              
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.savings, color: Theme.of(context).colorScheme.secondary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AHORRO ESTIMADO ANUAL (15,000 km)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        Text('Bs ${ahorroAnual.toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(String title, String cost, IconData icon, Color color, double percentage) {
    final safePct = percentage > 1.0 ? 1.0 : (percentage < 0 ? 0.0 : percentage);
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
    // Lectura en tiempo real de los campos editables
    double metros = double.tryParse(_metrosController.text) ?? 0;
    double precioPorMetro = double.tryParse(_precioMetroController.text) ?? 0;
    double protecciones = double.tryParse(_proteccionesController.text) ?? 0;
    double manoObra = double.tryParse(_manoObraController.text) ?? 0;

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
              
              Text('Tablero y Protecciones', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 8),
              _buildInputEditable('Costo total de protecciones (Bs)', _proteccionesController),
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
        
        //const SizedBox(height: 24),
        
        /*/ BOTON EXPORTAR 
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generando PDF... (Próximamente)'), backgroundColor: AppColors.secondaryContainer));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('GENERAR PDF PARA CLIENTE', style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ),
        )*/
      ],
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