import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/checklist_provider.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  void _generarPDF(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.construction, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Generación de PDF en desarrollo...')),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _mostrarDialogoGuardar(BuildContext context, ChecklistProvider provider) {
    final nombreController = TextEditingController();
    final ciController = TextEditingController();
    final direccionController = TextEditingController();
    final isReady = provider.isChecklistComplete;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Row(
            children: [
              Icon(isReady ? Icons.verified : Icons.save, color: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isReady ? 'Certificar Entrega' : 'Guardar Registro', 
                  style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary)
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReady 
                    ? 'La instalación cumple con todas las normativas. Ingresa los datos del cliente.'
                    : 'Faltan datos o pruebas. El registro se guardará como pendiente en tu Historial.',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nombreController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Cliente / Empresa *', 
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), 
                    border: OutlineInputBorder(), isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: direccionController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Dirección de Instalación *', 
                    prefixIcon: Icon(Icons.location_on, size: 18), 
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), 
                    border: OutlineInputBorder(), isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ciController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'C.I. / NIT (Opcional)', 
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), 
                    border: OutlineInputBorder(), isDense: true
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            ),
            ElevatedButton(
              onPressed: provider.isSaving ? null : () async {
                if (nombreController.text.isEmpty || direccionController.text.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text('Nombre y Dirección son obligatorios para el certificado.'), backgroundColor: Theme.of(context).colorScheme.error)
                );
                return;
              }

                // logica del Provider
                await provider.guardarRegistroFinal(
                nombreCliente: nombreController.text.trim(), 
                ciNitCliente: ciController.text.trim(),
                direccion: direccionController.text.trim(),
              );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isReady ? 'Certificado guardado correctamente.' : '💾 Registro guardado en BD como pendiente.'), 
                      backgroundColor: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                    )
                  );
                  Navigator.pop(context); 
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary, 
                foregroundColor: isReady ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: provider.isSaving 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider globalmente en la pantalla
    final provider = context.watch<ChecklistProvider>();
    final isReady = provider.isChecklistComplete;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContextSection(context),
                    const SizedBox(height: 24),
                    _buildVisualInspectionTile(context, provider),
                    const SizedBox(height: 16),
                    _buildElectricalTestsTile(context, provider),
                    const SizedBox(height: 16),
                    _buildFinalTestsTile(context, provider),
                    const SizedBox(height: 16),
                    _buildDocumentationTile(context, provider),
                    const SizedBox(height: 32),
                    _buildActionButtons(context, provider, isReady),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ChecklistProvider provider, bool isReady) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _mostrarDialogoGuardar(context, provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: isReady ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onPrimaryContainer,
              elevation: isReady ? 8 : 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            icon: Icon(isReady ? Icons.verified : Icons.save),
            label: Text(
              isReady ? 'CERTIFICAR INSTALACIÓN' : 'GUARDAR REGISTRO PENDIENTE', 
              style: const TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0)
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => _generarPDF(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PREVISUALIZAR ACTA (PDF)', style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.5))),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary, size: 20), onPressed: () => Navigator.pop(context)),
          const SizedBox(width: 8),
          Text('Certificación y Entrega', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }

  Widget _buildContextSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PROTOCOLO ELECTROMOVILIDAD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text('Puesta en Marcha', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 8),
          Text('Registra la instalación. Si sales de esta pantalla, tu borrador se guardará automáticamente.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // INSPECCION VISUAL 
  Widget _buildVisualInspectionTile(BuildContext context, ChecklistProvider p) {
    return _buildCustomExpansionTile(
      context,
      title: '1. Inspección Visual', icon: Icons.visibility, initiallyExpanded: true,
      children: [
        _buildCheckboxItem(context, value: p.visFijacion, title: 'Fijación firme del Wallbox', subtitle: 'Verificar que todos los tornillos de anclaje estén firmes.', onChanged: (v) { p.visFijacion = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.visCables, title: 'Cables organizados', subtitle: 'Ruta continua, sin empalmes sueltos/aprentes.', onChanged: (v) { p.visCables = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.visProteccion, title: 'Protección mecánica', subtitle: 'Conductores en ductos, cajas de paso o bandejas adecuadas.', onChanged: (v) { p.visProteccion = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.visIdentificacion, title: 'Identificación', subtitle: 'Tablero claramente etiquetado con su disyuntor exclusivo.', onChanged: (v) { p.visIdentificacion = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.visDanos, title: 'Ausencia de daños', subtitle: 'Equipos y cables sin daños físicos visibles.', onChanged: (v) { p.visDanos = v ?? false; p.refresh(); }),
      ],
    );
  }

  // PRUEBAS ELECTRICAS 
  Widget _buildElectricalTestsTile(BuildContext context, ChecklistProvider p) {
    double ohms = double.tryParse(p.tierraController.text) ?? 0.0;
    bool isError = ohms > 10.0 && p.tierraController.text.isNotEmpty;
    bool isSuccess = ohms > 0.0 && ohms <= 10.0;

    return _buildCustomExpansionTile(
      context,
      title: '2. Pruebas Eléctricas', icon: Icons.electrical_services,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSimpleInput(context, 'Tensión en el punto (Multímetro)', p.tensionController, 'V', 'Ej: 230'),
              Padding(
                padding: EdgeInsets.only(left: 14, top: 4, bottom: 16), 
                child: Text('Tensión nominal al ±10%.', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))
              ),
              
              Text('RESISTENCIA PUESTA A TIERRA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              TextField(
                controller: p.tierraController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: isError ? Theme.of(context).colorScheme.error : (isSuccess ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurface)),
                decoration: InputDecoration(
                  hintText: 'Ej: 5.4',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)), filled: true, fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                  border: UnderlineInputBorder(borderSide: BorderSide(color: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.outlineVariant, width: 2)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.outlineVariant, width: 2)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary, width: 2)),
                  suffixIcon: isError 
                      ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.warning, color: Theme.of(context).colorScheme.error, size: 20), Text('Peligroso (>25Ω)', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error))])
                      : (isSuccess ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary) : const SizedBox.shrink()),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 14, top: 8, bottom: 16), 
                child: Text('Ideal < 10 Ω. Aceptable doméstico ≤ 25 Ω. Dejar en blanco si un tercero validará con telurómetro.', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic))
              ),
              _buildCheckboxItem(context, value: p.elecContinuidad, title: 'Continuidad', subtitle: 'Fase, Neutro y Tierra medidos.', onChanged: (v) { p.elecContinuidad = v ?? false; p.refresh(); }),
            ],
          ),
        ),
      ],
    );
  }

  // PRUEBAS FINALES 
  Widget _buildFinalTestsTile(BuildContext context, ChecklistProvider p) {
    return _buildCustomExpansionTile(
      context,
      title: '3. Pruebas Finales', icon: Icons.power_settings_new,
      children: [
        _buildCheckboxItem(context, value: p.funEncendido, title: 'Encendido Wallbox', subtitle: 'Verificar LEDs / pantalla activa sin errores.', onChanged: (v) { p.funEncendido = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.funCorriente, title: 'Corriente real de carga', subtitle: 'Conectar EV y verificar corriente con pinza.', onChanged: (v) { p.funCorriente = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.funTemperatura, title: 'Temperatura de cables', subtitle: 'Sin calentamiento (>60°C) excesivo en bornes tras 30 mins.', onChanged: (v) { p.funTemperatura = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.funEmergencia, title: 'Parada de emergencia', subtitle: 'Botón de parada probado y efectivo (Si aplica).', onChanged: (v) { p.funEmergencia = v ?? false; p.refresh(); }),
      ],
    );
  }

  // DOCUMENTACIOPN FINAL 
  Widget _buildDocumentationTile(BuildContext context, ChecklistProvider p) {
    return _buildCustomExpansionTile( 
      context,
      title: '4. Documentación y Entrega', icon: Icons.folder_special,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDocButton(context, text: 'Registro fotográfico (Equipo y Tablero)', isCompleted: p.docFoto, onTap: () { p.docFoto = !p.docFoto; p.refresh(); }),
              const SizedBox(height: 8),
              _buildDocButton(context, text: 'Diagrama unifilar del circuito', isCompleted: p.docDiagrama, onTap: () { p.docDiagrama = !p.docDiagrama; p.refresh(); }),
              const SizedBox(height: 8),
              _buildDocButton(context, text: 'Certificado de medición de puesta a tierra', isCompleted: p.docCertificado, onTap: () { p.docCertificado = !p.docCertificado; p.refresh(); }),
              const SizedBox(height: 8),
              _buildDocButton(context, text: 'Manual de equipo entregado al cliente', isCompleted: p.docManual, onTap: () { p.docManual = !p.docManual; p.refresh(); }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
          child: Text('Nota: Orientar al cliente sobre uso y mantenimiento preventivo tras firmar.', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.secondary, fontStyle: FontStyle.italic)),
        )
      ],
    );
  }

  Widget _buildCheckboxItem(BuildContext context, {required bool value, required String title, required String subtitle, required ValueChanged<bool?> onChanged}) {
    return CheckboxListTile(
      value: value, onChanged: onChanged, activeColor: Theme.of(context).colorScheme.primary, checkColor: Theme.of(context).colorScheme.onPrimary,
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      controlAffinity: ListTileControlAffinity.leading, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), dense: true,
    );
  }

  Widget _buildSimpleInput(BuildContext context, String label, TextEditingController controller, String suffix, String hint) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, border: Border(left: BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: TextField(
                  controller: controller, 
                  keyboardType: TextInputType.numberWithOptions(decimal: true), 
                  style: TextStyle(
                    fontFamily: 'Space Grotesk', 
                    fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface
                  ), 
                  decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)), 
                  border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero)),
              ),
              Text(suffix, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDocButton(BuildContext context, {
    required String text, required bool isCompleted, required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCompleted ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1) : Theme.of(context).colorScheme.surfaceContainerLowest, 
          borderRadius: BorderRadius.circular(4), 
          border: Border.all(color: isCompleted ? Theme.of(context).colorScheme.secondary : Colors.transparent)
        ),
        child: Row(
          children: [
            Icon(isCompleted ? Icons.check_circle : Icons.circle_outlined, color: isCompleted ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isCompleted ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurface))),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomExpansionTile(BuildContext context, {
    required String title, required IconData icon, 
    bool initiallyExpanded = false, required List<Widget> children
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow, 
        borderRadius: BorderRadius.circular(8)
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded, 
          iconColor: Theme.of(context).colorScheme.primary, 
          collapsedIconColor: Theme.of(context).colorScheme.outlineVariant,
          title: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary), 
              const SizedBox(width: 16),
              Flexible(child: Text(title, style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold))),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}