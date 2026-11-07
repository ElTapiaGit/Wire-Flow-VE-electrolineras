import 'dart:math';
import 'package:flutter/material.dart';
import '../domain/advisor_models.dart';

class AdvisorScreen extends StatefulWidget {
  const AdvisorScreen({super.key});

  @override
  State<AdvisorScreen> createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  // SELECCIÓN DE VEHÍCULO (Inicia en null = Modo Personalizado / Manual)
  VehiculoPreset? _vehiculoSeleccionado;

  // CONTROLADORES DE TEXTO (Inician completamente vacíos para entrada libre)
  late final TextEditingController _bateriaController;
  late final TextEditingController _obcController;

  // CONECTOR NATIVO Y PROPIEDADES
  String _conectorSeleccionado = 'GB/T';
  bool _esTrifasicoAC = false;

  // SUMINISTRO ELÉCTRICO Y PERFIL DE USO
  // 0: Monofásica (220V), 1: Delta 220V (Fase-Fase), 2: Trifásica (380V)
  int _redIndex = 0;
  int _kmIndex = 1; // 0: < 50 km, 1: 50 - 150 km, 2: > 150 km / Flotas
  int _tiempoIndex = 0; // 0: Nocturna (8-12h), 1: En Trabajo (4-8h), 2: En Tránsito (< 1h)

  // CARRUSEL DE RECOMENDACIONES
  late PageController _pageController;
  int _currentCardIndex = 0;

  final List<String> _conectoresDisponibles = ['GB/T', 'Tipo 2', 'Tipo 1', 'Schuko', 'NACS'];

  @override
  void initState() {
    super.initState();
    _bateriaController = TextEditingController();
    _obcController = TextEditingController();
    _pageController = PageController(viewportFraction: 0.92);

    _bateriaController.addListener(_onInputChanged);
    _obcController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _bateriaController.removeListener(_onInputChanged);
    _obcController.removeListener(_onInputChanged);
    _bateriaController.dispose();
    _obcController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    setState(() {});
  }

  void _onVehiculoDropdownChanged(VehiculoPreset? preset) {
    setState(() {
      _vehiculoSeleccionado = preset;
      if (preset != null) {
        _bateriaController.text = preset.bateriaKwh.toString();
        _obcController.text = preset.obcMaxKw.toString();
        _esTrifasicoAC = preset.esTrifasicoAC;

        if (preset.conectorNativo.contains('GB/T')) {
          _conectorSeleccionado = 'GB/T';
        } else if (preset.conectorNativo.contains('Tipo 2')) {
          _conectorSeleccionado = 'Tipo 2';
        } else if (preset.conectorNativo.contains('Tipo 1')) {
          _conectorSeleccionado = 'Tipo 1';
        } else if (preset.conectorNativo.contains('Schuko')) {
          _conectorSeleccionado = 'Schuko';
        }
      } else {
        // Modo Personalizado: limpiar campos para entrada libre
        _bateriaController.clear();
        _obcController.clear();
        _esTrifasicoAC = false;
      }
    });
  }

  int get _tipoRedCalculator {
    // CalculatorScreen usa: 0 -> Monofásica, 1 -> Trifásica, 2 -> Delta
    if (_redIndex == 0) return 0; // Monofásica
    if (_redIndex == 1) return 2; // Delta 220V
    return 1; // Trifásica 380V
  }

  List<OpcionCargador> _generarOpciones() {
    final double? batIngresada = double.tryParse(_bateriaController.text.trim().replaceAll(',', '.'));
    final double? obcIngresado = double.tryParse(_obcController.text.trim().replaceAll(',', '.'));

    final double batCalc = (batIngresada != null && batIngresada > 0) ? batIngresada : 40.0;
    final double obcVal = (obcIngresado != null && obcIngresado > 0) ? obcIngresado : 7.0;
    final bool esTrifasicoAuto = _vehiculoSeleccionado?.esTrifasicoAC ?? _esTrifasicoAC;
    final bool esGbt = _conectorSeleccionado.contains('GB/T');

    final List<OpcionCargador> opciones = [];

    // ----------------------------------------------------
    // OPCIÓN 1: BÁSICA / ECONÓMICA (Cargador Portátil Reforzado)
    // ----------------------------------------------------
    final double potPortatil = min(3.3, obcVal);
    final double horasPortatil = batCalc / (potPortatil > 0 ? potPortatil : 2.3);

    opciones.add(
      OpcionCargador(
        nivel: 'BÁSICA / ECONÓMICA',
        titulo: 'Cargador Portátil Reforzado',
        potenciaKw: potPortatil,
        tipoHardware: 'Portátil Modo 2 (${potPortatil.toStringAsFixed(1)} kW)',
        rangoInversionBs: 'Bs 1.200 - Bs 1.800',
        horasRecarga: horasPortatil,
        kmPorHoraTexto: '~15 a 22 km/h',
        requerimientoElectrico: 'Circuito estándar de 16A con toma industrial CEE azul o Schuko reforzado. No exige aumento de potencia.',
        avisoTecnico: null,
        requiereAdaptadorGbt: esGbt && _conectorSeleccionado != 'Schuko',
      ),
    );

    // ----------------------------------------------------
    // OPCIÓN 2: ESTÁNDAR / CONFORT (Wallbox Residencial Dedicado 7.4 kW)
    // ----------------------------------------------------
    final double potWallbox = 7.4;
    final double horasWallbox = batCalc / min(potWallbox, obcVal);

    String? alertaWallbox;
    if (_redIndex == 0 || _redIndex == 1) {
      alertaWallbox = 'Demanda de 32A continuos: Asegurar disyuntor general en medidor ≥ 40A para evitar disparos por sobrecarga con otros artefactos.';
    }

    opciones.add(
      OpcionCargador(
        nivel: 'ESTÁNDAR / CONFORT',
        titulo: _redIndex == 1 ? 'Wallbox Red Delta (7.4 kW)' : 'Wallbox Residencial (7.4 kW)',
        potenciaKw: potWallbox,
        tipoHardware: 'Wallbox Fijo de Pared (Modo 3 - 32A)',
        rangoInversionBs: 'Bs 4.200 - Bs 5.800',
        horasRecarga: horasWallbox,
        kmPorHoraTexto: '~45 a 50 km/h',
        requerimientoElectrico: 'Circuito exclusivo con disyuntor Bipolar de 40A, diferencial Tipo A (30mA) y cable de 6 mm².',
        avisoTecnico: alertaWallbox,
        requiereAdaptadorGbt: esGbt,
      ),
    );

    // ----------------------------------------------------
    // OPCIÓN 3: AVANZADA / TRIFÁSICA (Wallbox Trifásico 11 kW - 22 kW)
    // Solo disponible si la red es Trifásica (380V)
    // ----------------------------------------------------
    if (_redIndex == 2) {
      final double horasTrifasico = esTrifasicoAuto ? (batCalc / 11.0) : (batCalc / min(7.4, obcVal));

      String? avisoOBC;
      if (!esTrifasicoAuto || obcVal <= 7.4) {
        avisoOBC = 'Nota de compatibilidad: Su vehículo tiene cargador interno monofásico. Operará en este equipo limitado a ${obcVal.toStringAsFixed(1)} kW en una sola fase, dejando las demás inactivas.';
      }

      opciones.add(
        OpcionCargador(
          nivel: 'AVANZADA / TRIFÁSICA',
          titulo: 'Wallbox Trifásico (11 - 22 kW)',
          potenciaKw: 11.0,
          tipoHardware: 'Wallbox Trifásico Modo 3 (380V)',
          rangoInversionBs: 'Bs 7.500 - Bs 12.000',
          horasRecarga: horasTrifasico,
          kmPorHoraTexto: esTrifasicoAuto ? '~70 a 75 km/h' : '~45 a 50 km/h (Limitado a 1F por auto)',
          requerimientoElectrico: 'Circuito trifásico tetrapolar dedicado con diferencial Tipo A tetrapolar y descargador SPD Clase II.',
          avisoTecnico: avisoOBC,
          requiereAdaptadorGbt: esGbt,
        ),
      );
    }

    return opciones;
  }

  void _mostrarImagenCompleta(BuildContext context, String imagePath, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(title, style: const TextStyle(fontFamily: 'Space Grotesk', color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opciones = _generarOpciones();

    // Ajustar índice actual del carrusel si cambia la longitud de opciones
    if (_currentCardIndex >= opciones.length) {
      _currentCardIndex = max(0, opciones.length - 1);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isTablet = constraints.maxWidth >= 600;
              final double targetViewport = isTablet ? 0.70 : 0.92;

              if (_pageController.viewportFraction != targetViewport) {
                final initialPage = _pageController.hasClients
                    ? (_pageController.page?.round() ?? _currentCardIndex)
                    : _currentCardIndex;
                _pageController.dispose();
                _pageController = PageController(viewportFraction: targetViewport, initialPage: initialPage);
              }

              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildContextSection(),
                                    const SizedBox(height: 24),

                                    // 1. SELECCIÓN DE VEHÍCULO
                                    Text(
                                      '1. VEHÍCULO ELÉCTRICO',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildVehicleSelectorCard(),
                                    const SizedBox(height: 24),

                                    // 2. SUMINISTRO ELÉCTRICO Y PERFIL DE USO
                                    Text(
                                      '2. RED ELÉCTRICA Y USO',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    _buildChoiceGroup(
                                      'Suministro Eléctrico en Inmueble',
                                      ['Monofásica (220V)', 'Delta 220V (Fase-Fase)', 'Trifásica (380V)'],
                                      _redIndex,
                                      (val) {
                                        setState(() {
                                          _redIndex = val;
                                          _currentCardIndex = 0;
                                          if (_pageController.hasClients) {
                                            _pageController.jumpToPage(0);
                                          }
                                        });
                                      },
                                    ),
                                    _buildChoiceGroup(
                                      'Kilometraje Diario Estimado',
                                      ['< 50 km', '50 - 150 km', '> 150 km / Flotas'],
                                      _kmIndex,
                                      (val) => setState(() => _kmIndex = val),
                                    ),
                                    _buildChoiceGroup(
                                      'Tiempo Objetivo de Carga',
                                      ['Nocturna (8-12h)', 'En Trabajo (4-8h)', 'En Tránsito (< 1h)'],
                                      _tiempoIndex,
                                      (val) => setState(() => _tiempoIndex = val),
                                    ),

                                    const SizedBox(height: 28),

                                    // 3. ENCABEZADO DEL CARRUSEL COMPARATIVO
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ALTERNATIVAS DE HARDWARE',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${opciones.length} Opciones Viables',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Desliza horizontalmente para comparar potencias, requerimientos y costos estimados.',
                                      style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.outline),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // 4. CARRUSEL INTERACTIVO DE TARJETAS
                              _buildCarousel(opciones),
                              const SizedBox(height: 12),
                              _buildCarouselDots(opciones.length),

                              const SizedBox(height: 32),

                              // 5. GUÍA VISUAL DE CONECTORES
                              _buildConnectorsGuide(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // HEADER Y CONTEXTO
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.5)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Text(
                'Asesor de Cargadores VE',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECCIÓN TÉCNICA Y COMPARATIVA',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          Text(
            'Asesor de Hardware',
            style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Configura el vehículo y evalúa las opciones de carga compatibles con el suministro del inmueble en Bolivia.',
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _mostrarModalSeleccionVehiculo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (sheetContext, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado del modal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar Vehículo',
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Modelos verificados en Bolivia o configuración manual',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 16),

                // Lista scrollable de opciones
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    children: [
                      // Primer ítem destacado: Personalizado / Ingreso Manual
                      Container(
                        decoration: BoxDecoration(
                          color: _vehiculoSeleccionado == null
                              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
                              : Theme.of(context).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _vehiculoSeleccionado == null
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            width: _vehiculoSeleccionado == null ? 1.5 : 0.8,
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.tune,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          title: const Text(
                            'Personalizado / Ingreso Manual',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                          ),
                          subtitle: const Text(
                            'Configurar batería, límite OBC y puerto manualmente',
                            style: TextStyle(fontSize: 11.5),
                          ),
                          trailing: _vehiculoSeleccionado == null
                              ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                              : null,
                          onTap: () {
                            Navigator.pop(modalContext);
                            _onVehiculoDropdownChanged(null);
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Divisor con etiqueta de sección
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                        child: Text(
                          'Catálogo de Marcas en Bolivia',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),

                      // Lista scrollable con catalogoVehiculosBolivia
                      ...catalogoVehiculosBolivia.map((v) {
                        final bool isCurrent = _vehiculoSeleccionado == v;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.directions_car,
                                color: isCurrent
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              '${v.marca} ${v.modelo}',
                              style: TextStyle(
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                fontSize: 13.5,
                              ),
                            ),
                            subtitle: Text(
                              '${v.bateriaKwh} kWh • OBC ${v.obcMaxKw} kW • Conector ${v.conectorNativo}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: isCurrent
                                ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                                : null,
                            onTap: () {
                              Navigator.pop(modalContext);
                              _onVehiculoDropdownChanged(v);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // SELECTOR DE VEHÍCULO Y MODO MANUAL
  Widget _buildVehicleSelectorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car, color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Catálogo de Vehículos (Opcional)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Selector táctil interactivo estilo Material 3
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _mostrarModalSeleccionVehiculo(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(
                      _vehiculoSeleccionado == null ? Icons.tune : Icons.directions_car,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _vehiculoSeleccionado?.nombreCompleto ?? 'Personalizado / Ingreso Manual',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.outline),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campos editables de batería y límite OBC
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Batería (kWh)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _bateriaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 15, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Ej: 38.0',
                        suffixText: 'kWh',
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Límite OBC (kW)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _obcController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 15, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Ej: 6.6',
                        suffixText: 'kW',
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Selector de conector nativo del vehículo
          Text('Conector del Vehículo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _conectoresDisponibles.map((conector) {
              final isSelected = _conectorSeleccionado == conector;
              return ChoiceChip(
                label: Text(conector, style: TextStyle(fontSize: 11.5, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.onSecondaryContainer : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                showCheckmark: false,
                side: BorderSide(
                  color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.outlineVariant,
                  width: isSelected ? 1.5 : 1.0,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                onSelected: (val) {
                  if (val) setState(() => _conectorSeleccionado = conector);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // GRUPOS DE PREGUNTAS (ChoiceChips)
  Widget _buildChoiceGroup(String title, List<String> options, int selectedIndex, ValueChanged<int> onSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(options.length, (index) {
              final isSelected = selectedIndex == index;
              return ChoiceChip(
                label: Text(options[index], style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) onSelected(index);
                },
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                showCheckmark: false,
                side: BorderSide(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
                  width: isSelected ? 1.5 : 1.0,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ],
      ),
    );
  }

  // CARRUSEL COMPARATIVO DE HARDWARE
  Widget _buildCarousel(List<OpcionCargador> opciones) {
    return SizedBox(
      height: 440,
      child: PageView.builder(
        controller: _pageController,
        itemCount: opciones.length,
        onPageChanged: (index) {
          setState(() {
            _currentCardIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final opcion = opciones[index];
          return _buildCarouselCard(opcion);
        },
      ),
    );
  }

  Widget _buildCarouselDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isSelected = _currentCardIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isSelected ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildCarouselCard(OpcionCargador opcion) {
    Color badgeColor;
    Color onBadgeColor;
    Color borderAccent;

    if (opcion.nivel.contains('BÁSICA')) {
      badgeColor = Theme.of(context).colorScheme.primaryContainer;
      onBadgeColor = Theme.of(context).colorScheme.onPrimaryContainer;
      borderAccent = Theme.of(context).colorScheme.primary;
    } else if (opcion.nivel.contains('ESTÁNDAR')) {
      badgeColor = Theme.of(context).colorScheme.secondaryContainer;
      onBadgeColor = Theme.of(context).colorScheme.onSecondaryContainer;
      borderAccent = Theme.of(context).colorScheme.secondary;
    } else {
      badgeColor = Theme.of(context).colorScheme.tertiaryContainer;
      onBadgeColor = Theme.of(context).colorScheme.onTertiaryContainer;
      borderAccent = Theme.of(context).colorScheme.tertiaryContainer;
    }

    final double? batIngresada = double.tryParse(_bateriaController.text.trim().replaceAll(',', '.'));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderAccent.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nivel y Potencia
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opcion.nivel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: onBadgeColor,
                  ),
                ),
              ),
              Text(
                '${opcion.potenciaKw.toStringAsFixed(1)} kW',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: borderAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            opcion.titulo,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            opcion.tipoHardware,
            style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.outline),
          ),

          const Divider(height: 16),

          // BLOQUE 1: Fila de 2 columnas al 50% (Tiempo y Velocidad)
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  Icons.timer_outlined,
                  'Tiempo de Carga',
                  '~${opcion.horasRecarga.toStringAsFixed(1)} h',
                  borderAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricItem(
                  Icons.speed,
                  'Velocidad',
                  opcion.kmPorHoraTexto,
                  borderAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // BLOQUE 2: Barra de Inversión Estimada a lo ancho
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderAccent.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.payments_outlined, size: 16, color: borderAccent),
                    const SizedBox(width: 6),
                    Text(
                      'Inversión Estimada',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(
                  opcion.rangoInversionBs,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Requerimiento Eléctrico
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.bolt, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    opcion.requerimientoElectrico,
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.3),
                  ),
                ),
              ],
            ),
          ),

          // Alerta preventiva (Acometida u OBC)
          if (opcion.avisoTecnico != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.6)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      opcion.avisoTecnico!,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Alerta de adaptador GB/T
          if (opcion.requiereAdaptadorGbt) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.cable, size: 14, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Requiere adaptador Tipo 2 a GB/T si el Wallbox incluye manguera europea.',
                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          // BOTONES CTA (INTEROPERABILIDAD)
          Row(
            children: [
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/calculator',
                        arguments: {
                          'potenciaKw': opcion.potenciaKw,
                          'tipoRed': _tipoRedCalculator,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.calculate, size: 18),
                    label: Text(
                      'DIMENSIONAR (${opcion.potenciaKw.toStringAsFixed(1)} kW)',
                      style: const TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/commercial',
                        arguments: {
                          'potenciaKw': opcion.potenciaKw,
                          'bateriaKwh': batIngresada ?? 40.0,
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: const Text(
                      'COTIZAR',
                      style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  // GUÍA VISUAL DE CONECTORES
  Widget _buildConnectorsGuide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'GUÍA RÁPIDA DE CONECTORES (AC)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Toca la imagen para ampliar y ver los pines del puerto.',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.secondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 230,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildConnectorCard(
                name: 'GB/T (AC)',
                region: 'China (Dominante en Bolivia)',
                description: 'Estándar oficial chino dominante en Bolivia (BYD, Quantum, Dongfeng, JAC, Changan). Admite monofásica y trifásica.',
                imagePath: 'assets/images/GBT-AC.webp',
              ),
              _buildConnectorCard(
                name: 'Tipo 2 (Mennekes)',
                region: 'Europa / Internacional',
                description: 'Estándar IEC 62196. Frecuente en Wallboxes europeos comerciales. Requiere adaptador para autos con conector chino.',
                imagePath: 'assets/images/tipo-2-mennekes.webp',
              ),
              _buildConnectorCard(
                name: 'Tipo 1 (J1772)',
                region: 'Norteamérica / Japón',
                description: 'Estándar monofásico (hasta 7.4 kW). Común en autos usados importados de EE.UU. (Nissan Leaf).',
                imagePath: 'assets/images/tipo-1-J1772-norteamerica.webp',
              ),
              _buildConnectorCard(
                name: 'NACS (Tesla)',
                region: 'Norteamérica',
                description: 'Conector propietario de Tesla. En Bolivia requiere adaptador Tipo 2 o GB/T para estaciones locales.',
                imagePath: 'assets/images/NACS-tesla.webp',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorCard({required String name, required String region, required String description, required String imagePath}) {
    return Container(
      width: 230,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _mostrarImagenCompleta(context, imagePath, name),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: imagePath,
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(name, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          Text(region, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(fontSize: 10.5, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.3),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
