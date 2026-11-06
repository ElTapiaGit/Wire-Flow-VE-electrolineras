// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../domain/calculator_engine.dart'; 

class CalculatorScreen extends StatefulWidget { 
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  CalculationResponse? _resultado;
  bool _isCalculating = false;

  int _selectedNetworkIndex = 0; 
  double _voltajeMono = 220.0;
  double _voltajeTri = 400.0;
  double _voltajeDelta = 230.0;
  bool _usarNormaNacional = false; 

  final TextEditingController _potenciaController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();

  @override
  void dispose() {
    _potenciaController.dispose();
    _distanciaController.dispose();
    super.dispose();
  }

  void _mostrarConfiguracionNorma() { 
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
              title: Row(
                children: [
                  Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                  SizedBox(width: 8),
                  Text('Configuración', style: TextStyle(fontFamily: 'Space Grotesk', color: Theme.of(context).colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selecciona la normativa base para el cálculo de conductores:', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  RadioListTile<bool>(
                    title: const Text('Internacional (IEC/NEC)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Flexible. Separa ampacidad mono/trifásica.', style: TextStyle(fontSize: 11)),
                    value: false,
                    groupValue: _usarNormaNacional,
                    activeColor: Theme.of(context).colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (bool? value) {
                      setStateDialog(() => _usarNormaNacional = value!);
                      setState(() => _usarNormaNacional = value!);
                    },
                  ),
                  RadioListTile<bool>(
                    title: const Text('Norma Nacional (NB 777)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Exigente. Unifica ductos hasta 3 conductores.', style: TextStyle(fontSize: 11)),
                    value: true,
                    groupValue: _usarNormaNacional,
                    activeColor: Theme.of(context).colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (bool? value) {
                      setStateDialog(() => _usarNormaNacional = value!);
                      setState(() => _usarNormaNacional = value!);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (_resultado != null) _ejecutarCalculo(); 
                  },
                  child: Text('Aplicar', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _mostrarDialogoEdicionVoltaje() {
    final monoCtrl = TextEditingController(text: _voltajeMono.toInt().toString());
    final triCtrl = TextEditingController(text: _voltajeTri.toInt().toString());
    final deltaCtrl = TextEditingController(text: _voltajeDelta.toInt().toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Text('Editar Voltajes (V)', style: TextStyle(fontFamily: 'Space Grotesk', color: Theme.of(context).colorScheme.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: monoCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Monofásica (V)', labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: triCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Trifásica (V)', labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: deltaCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Delta (2 Fases sin neutro) (V)', labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                monoCtrl.dispose();
                triCtrl.dispose();
                deltaCtrl.dispose();
                Navigator.pop(context);
              },
              child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _voltajeMono = double.tryParse(monoCtrl.text.replaceAll(',', '.')) ?? _voltajeMono;
                  _voltajeTri = double.tryParse(triCtrl.text.replaceAll(',', '.')) ?? _voltajeTri;
                  _voltajeDelta = double.tryParse(deltaCtrl.text.replaceAll(',', '.')) ?? _voltajeDelta;
                });
                monoCtrl.dispose();
                triCtrl.dispose();
                deltaCtrl.dispose();
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

  void _mostrarInfoNormativa() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: Row(
          children: [
            Icon(Icons.gavel, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(_usarNormaNacional ? 'Normativa (NB 777)' : 'Normativa (IEC/NEC)', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Factor de Carga Continua (125%)', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 4),
              Text('Un EV carga ininterrumpidamente por >3 horas. Para evitar que el calor acumulado dispare las protecciones, la norma exige sobredimensionar la corriente nominal en un 25% para elegir el disyuntor.', 
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)
              ),
              SizedBox(height: 16),
              Text('Coordinación Térmica', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 4),
              Text('El cable SIEMPRE debe soportar más amperaje que el disyuntor. Si la carga obliga a subir el disyuntor al siguiente valor comercial, el cable también debe subir de calibre para no derretirse antes de que el disyuntor salte.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  void _mostrarTablaAmpacidad() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        title: Row(
          children: [
            Icon(Icons.table_chart, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Expanded(child: Text(_usarNormaNacional ? 'Tabla 15 - NB 777' : 'Tabla IEC/NEC (70°C)', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary))),
          ],
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _usarNormaNacional ? _buildTablaNacional() : _buildTablaInternacional(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
        ],
      ),
    );
  }

  void _mostrarInfoProtecciones(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: Row(
          children: [
            Icon(Icons.shield, color: Theme.of(context).colorScheme.tertiaryContainer),
            SizedBox(width: 8),
            Text('Secuencia en Cascada', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Este orden profesional protege los componentes más sensibles y costosos del tablero:', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: 16),
              Text('1. SPD (Sobretensión):', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              Text('Va primero para absorber y derivar rayos a tierra antes de que la energía fría los interruptores de abajo.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: 8),
              Text('2. MCB (Termomagnético):', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              Text('Se coloca antes del diferencial para protegerlo (al igual que al cableado) de cortocircuitos directos o sobrecargas prolongadas.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: 8),
              Text('3. DR/RCD (Diferencial):', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              Text('Es muy sensible y costoso (Especialmente Tipo A o B). Al estar aguas abajo del MCB, trabaja de forma segura protegiendo vidas.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: 8),
              Text('4. OVP/UVP (Tensión de Recup.):', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              Text('Filtra el suministro final garantizando que variaciones de la red eléctrica no dañen la placa interna del cargador.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido', style: TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Tabla NB 777
  Widget _buildTablaNacional() {
    return DataTable(
      columnSpacing: 16,
      headingRowHeight: 40,
      dataRowMinHeight: 32,
      dataRowMaxHeight: 32,
      headingTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
      dataTextStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
      columns: const [
        DataColumn(label: Text('AWG')),
        DataColumn(label: Text('mm²')),
        DataColumn(label: Text('En Ducto (A)')),
      ],
      rows: CalculatorEngine.tablaNB777.map((cable) {
        return DataRow(cells: [
          DataCell(Text(cable['awg'], style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(cable['mm2'].toString())),
          DataCell(Text('${cable['amp']} A', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
        ]);
      }).toList(),
    );
  }

  // Tabla Internacional
  Widget _buildTablaInternacional() {
    return DataTable(
      columnSpacing: 16,
      headingRowHeight: 40,
      dataRowMinHeight: 32,
      dataRowMaxHeight: 32,
      headingTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
      dataTextStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
      columns: const [
        DataColumn(label: Text('AWG')),
        DataColumn(label: Text('mm²')),
        DataColumn(label: Text('1-Fase')),
        DataColumn(label: Text('3-Fases')),
      ],
      rows: CalculatorEngine.tablaInternacional.map((cable) {
        return DataRow(cells: [
          DataCell(Text(cable['awg'], style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(cable['mm2'].toString())),
          DataCell(Text('${cable['ampMono']} A')),
          DataCell(Text('${cable['ampTri']} A')),
        ]);
      }).toList(),
    );
  }

  void _ejecutarCalculo() async {
    final potenciaTexto = _potenciaController.text.trim().replaceAll(',', '.');
    final distanciaTexto = _distanciaController.text.trim().replaceAll(',', '.');

    if (potenciaTexto.isEmpty || distanciaTexto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Por favor ingresa la potencia del cargador y la distancia del tablero.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final double? potencia = double.tryParse(potenciaTexto);
    final double? distancia = double.tryParse(distanciaTexto);

    if (potencia == null || distancia == null || potencia <= 0 || distancia <= 0) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Valores inválidos: La potencia (kW) y la distancia (m) deben ser números mayores a cero.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (potencia > 22.0) {
      FocusScope.of(context).unfocus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'POTENCIA FUERA DE RANGO:\nLos cargadores mayores a 22 kW son de Corriente Continua (DC - Nivel 3). Requieren diseño de subestación.',
                  style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return; 
    }

    if (distancia > 100.0) {
      FocusScope.of(context).unfocus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'DISTANCIA FUERA DE RANGO RESIDENCIAL: La distancia máxima recomendada entre el medidor de la acometida y la estación de carga es de 100 metros. Verifique el recorrido.',
                  style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return; 
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isCalculating = true;
      _resultado = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    
    double voltajeAplicado = _voltajeMono;
    if (_selectedNetworkIndex == 1) voltajeAplicado = _voltajeTri;
    if (_selectedNetworkIndex == 2) voltajeAplicado = _voltajeDelta;

    try {
      final resultadoCalculo = CalculatorEngine.calcularTodo(
        potenciaKw: potencia,
        distanciaM: distancia,
        tipoRed: _selectedNetworkIndex,
        voltaje: voltajeAplicado,
        usarNormaNacional: _usarNormaNacional, 
      );

      setState(() {
        _resultado = resultadoCalculo; 
        _isCalculating = false;
      });

    } catch (e) {
      setState(() {
        _isCalculating = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.toString().replaceAll('Exception: ', ''),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputSection(),
                    const SizedBox(height: 32),
                    _buildResultsSection(),
                  ],
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
              'Calculadora Técnica',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.outline),
            onPressed: _mostrarConfiguracionNorma,
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CONFIGURACIÓN DE RED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.outline, size: 20),
                onPressed: _mostrarDialogoEdicionVoltaje,
                tooltip: 'Editar Voltajes',
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNetworkSelector(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField('POTENCIA DEL CARGADOR', '7.4', 'kW', _potenciaController)),
              const SizedBox(width: 24),
              Expanded(child: _buildTextField('DISTANCIA DEL TABLERO', '25', 'm', _distanciaController)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isCalculating ? null : _ejecutarCalculo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                disabledBackgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: _isCalculating ? 0 : 8,
                shadowColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
              ),
              icon: _isCalculating 
                ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary))
                : const Icon(Icons.calculate),
              label: Text(
                _isCalculating ? 'CALCULANDO...' : 'CALCULAR DIMENSIONAMIENTO', 
                style: const TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.2)
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNetworkSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          _buildNetworkOption(0, 'Monofásica\n${_voltajeMono.toInt()}V'),
          _buildNetworkOption(1, 'Trifásica\n${_voltajeTri.toInt()}V'),
          _buildNetworkOption(2, 'Delta\n${_voltajeDelta.toInt()}V'),
        ],
      ),
    );
  }

  Widget _buildNetworkOption(int index, String title) {
    final isSelected = _selectedNetworkIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedNetworkIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, String suffix, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            suffixText: suffix,
            suffixStyle: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
            border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 2)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 2)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Cálculo de Ingeniería', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            InkWell(
              onTap: _mostrarInfoNormativa,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(_usarNormaNacional ? 'NB 777' : 'IEC/NEC', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (_resultado == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.electric_meter, color: Theme.of(context).colorScheme.outline, size: 48),
                SizedBox(height: 16),
                Text('Esperando datos...', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline)),
                Text('Ingresa la configuración y presiona calcular.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          )
        else
          Builder(
            builder: (context) {
              final strict = _resultado!.recommended;
              final flex = _resultado!.flexible;
              // verificacion de diferenica
              final bool calibresDistintos = strict.seccionCableMm2 != flex.seccionCableMm2;

              return Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final int columns = constraints.maxWidth < 600 ? 1 : 2;
                      final double ratio = columns == 1 ? 3.5 : 1.2;

                      return GridView.count(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: ratio,
                        children: [
                          _buildResultCard(
                            title: 'Corriente (A)', 
                            mainValue: flex.corrienteA.toStringAsFixed(2), 
                            subValue: 'Nominal', 
                            icon: Icons.electric_bolt, 
                            accentColor: Theme.of(context).colorScheme.primary,
                            extraContent: Text('Diseño (+25%): ${(flex.corrienteA * 1.25).toStringAsFixed(1)} A', 
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                          ),
                          _buildResultCard(
                            title: 'Calibre Cobre Sugerido', 
                            mainValue: flex.seccionCableMm2.toStringAsFixed(2), 
                            subValue: 'mm² / ${flex.calibreAwg} AWG', 
                            icon: Icons.settings_input_component, 
                            accentColor: Theme.of(context).colorScheme.secondary,
                            extraContent: calibresDistintos 
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Recomendado', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, letterSpacing: 0.5)),
                                    Text('${strict.seccionCableMm2} mm² / ${strict.calibreAwg} AWG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary)),
                                  ],
                                )
                              : null,
                          ),
                          _buildWarningCard(strict, flex), // aceptar ambos
                        ],
                      );
                    }
                  ),
                  if (strict.isCaidaCritica) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Theme.of(context).colorScheme.error),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ADVERTENCIA: CAÍDA DE TENSIÓN CRÍTICA (${strict.caidaTensionPct.toStringAsFixed(2)}%)',
                                  style: TextStyle(
                                    fontFamily: 'Space Grotesk',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'La caída de tensión supera el 4.0% admisible por norma técnica (NB 777 / IEC) incluso empleando el conductor de máxima capacidad comercial (${strict.calibreAwg} AWG / ${strict.seccionCableMm2} mm²). Se recomienda reducir la distancia del circuito o evaluar una alimentación en red trifásica.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _mostrarTablaAmpacidad,
                      icon: Icon(Icons.table_chart, color: Theme.of(context).colorScheme.secondary),
                      label: Text('VER TABLA DE AMPACIDAD (${_usarNormaNacional ? 'NB 777' : 'IEC/NEC'})', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildProtectionsTimelineCard(strict, flex), 
                ],
              );
            }
          ),
      ],
    );
  }

  Widget _buildResultCard({
    required String title, 
    required String mainValue, 
    required String subValue, 
    required IconData icon, 
    required Color accentColor,
    Widget? extraContent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, 
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: accentColor, size: 20),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween, 
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 4.0, 
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      mainValue,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subValue,
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant,),
                    ),
                  ],
                ),
                if (extraContent != null) 
                  extraContent,
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWarningCard(CalculatorResult strict, CalculatorResult flex) {
    final bool isCritico = strict.isCaidaCritica;
    final Color cardColor = isCritico ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary;
    // VERIFICACION DE DIFERENCIA PARA LA CAIDA DE TENSION
    final bool caidasDistintas = strict.caidaTensionPct != flex.caidaTensionPct;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: cardColor.withValues(alpha: 0.3), width: 1),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: cardColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('CAÍDA DE TENSIÓN (%)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant))),
              Icon(isCritico ? Icons.warning : Icons.check_circle, color: cardColor, size: 20),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 4.0,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      flex.caidaTensionPct.toStringAsFixed(2), 
                      style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: cardColor)
                    ),
                    const SizedBox(width: 2),
                    Text(
                      isCritico ? '% Crítico' : '% Óptimo', 
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isCritico ? 'AUMENTAR SECCIÓN' : 'DENTRO DE NORMA', 
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: cardColor, letterSpacing: 0.5)
                    ),
                    if (caidasDistintas)
                      Text(
                        'Rec: ${strict.caidaTensionPct.toStringAsFixed(2)}%', 
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary)
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProtectionsTimelineCard(CalculatorResult strict, CalculatorResult flex) {
    final String tipoPolos = _selectedNetworkIndex == 1 ? 'Tetrapolar' : 'Bipolar';

    Widget buildProteccionTexto(String suffix, {bool isMcb = false}) {
      final String mcbLabel = isMcb ? ' (Curva C)' : '';
      if (strict.disyuntorA == flex.disyuntorA) {
        return Text('$tipoPolos ${flex.disyuntorA}A$mcbLabel$suffix', 
            style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary));
      } else {
        final String mcbDualTag = isMcb ? ' (Curva C)' : '';
        return RichText(
          text: TextSpan(
            style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary),
            children: [
              TextSpan(text: '$tipoPolos ${flex.disyuntorA}A$mcbDualTag  •  '),
              TextSpan(
                text: '$tipoPolos ${strict.disyuntorA}A$mcbDualTag (Rec)', 
                style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w900) 
              ),
              if (suffix.isNotEmpty) TextSpan(text: suffix),
            ],
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: Theme.of(context).colorScheme.tertiaryContainer, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.shield, color: Theme.of(context).colorScheme.tertiaryContainer, size: 20),
                  SizedBox(width: 8),
                  Text('INSTALACIÓN EN TABLERO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
              // Botón de información añadido a la derecha
              IconButton(
                icon: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.outline, size: 20),
                onPressed: () => _mostrarInfoProtecciones(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildProtectionStep(
            step: '1',
            title: 'Protector de Sobretensión (SPD)',
            subtitle: 'Deriva picos masivos (rayos) a tierra inmediatamente.',
            specWidget: Text('Clase II • 275V • 20kA',
              style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 11.0),
            child: SizedBox(height: 20, child: VerticalDivider(color: Theme.of(context).colorScheme.outlineVariant, thickness: 2)),
          ),
          _buildProtectionStep(
            step: '2',
            title: 'Termomagnético (MCB)',
            subtitle: 'Protege la línea y equipos aguas abajo de cortocircuitos.',
            specWidget: buildProteccionTexto('', isMcb: true),
          ),
          Padding(
            padding: EdgeInsets.only(left: 11.0),
            child: SizedBox(height: 20, child: VerticalDivider(color: Theme.of(context).colorScheme.outlineVariant, thickness: 2)),
          ),
          _buildProtectionStep(
            step: '3',
            title: 'Diferencial (DR / RCD)',
            subtitle: 'Protección humana súper sensible. Protegida por el MCB.',
            specWidget: buildProteccionTexto('  •  30mA  •  Tipo A/B'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 11.0),
            child: SizedBox(height: 20, child: VerticalDivider(color: Theme.of(context).colorScheme.outlineVariant, thickness: 2)),
          ),
          _buildProtectionStep(
            step: '4',
            title: 'Relé de Tensión (OVP/UVP)',
            subtitle: 'Corta si el voltaje sube o baja de rangos seguros de operación.',
            specWidget: Text('$tipoPolos ${flex.disyuntorA}A  •  Monitoreo',
            style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)),
          ),
        ],
      ),
    );
  }

  Widget _buildProtectionStep({required String step, required String title, required String subtitle, required Widget specWidget}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiaryContainer, shape: BoxShape.circle),
          child: Text(step, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onTertiaryContainer)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: specWidget,
              ),
            ],
          ),
        ),
      ],
    );
  }
}