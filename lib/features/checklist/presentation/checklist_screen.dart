import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/checklist_provider.dart';
import '../../../core/services/pdf_service.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  void _generarPDF(BuildContext context, ChecklistProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    String tecnico = provider.tecnicoResponsable.trim();
    String matricula = provider.matriculaProfesional.trim();
    if (tecnico.isEmpty) {
      tecnico = prefs.getString('cfg_nombre_tecnico')?.trim() ?? '';
    }
    if (matricula.isEmpty) {
      matricula = prefs.getString('cfg_registro_sib')?.trim() ?? '';
    }

    // Si no tenemos un nombre de cliente temporal (porque es un checklist vacío nuevo),
    // le asignamos valores genéricos solo para que el PDF no explote al generar la vista previa.
    final registroTemporal = provider.crearRegistroTemporal(
      nombreCliente: provider.nombreClienteGuardado.isNotEmpty ? provider.nombreClienteGuardado : 'Previsualización Borrador',
      ciNitCliente: provider.ciNitClienteGuardado,
      direccion: provider.direccionGuardada.isNotEmpty ? provider.direccionGuardada : 'Dirección pendiente',
    );

    // Llamamos al servicio para compartir el PDF con metadatos normativos
    await PdfService.generarCertificado(
      registroTemporal,
      esquemaTierra: provider.esquemaTierra,
      distribuidora: provider.distribuidora,
      nombreTecnico: tecnico.isNotEmpty ? tecnico : 'Instalador Especialista en Electromovilidad',
      registroSib: matricula.isNotEmpty ? matricula : null,
      medicionTierraExterna: provider.medicionTierraExterna,
    );
  }

  void _mostrarDialogoGuardar(BuildContext context, ChecklistProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _DialogoGuardarRegistro(
        provider: provider,
        parentContext: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider globalmente en la pantalla
    final provider = context.watch<ChecklistProvider>();
    final isReady = provider.isChecklistComplete;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                      const SizedBox(height: 16),
                      _buildProgressCard(context, provider),
                      const SizedBox(height: 20),
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
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, ChecklistProvider provider) {
    final completados = provider.itemsCompletadosCount;
    final total = provider.totalItemsRequeridos;
    final double progreso = provider.progresoPorcentaje;
    final int porcentaje = (progreso * 100).toInt();
    final bool isReady = provider.isChecklistComplete;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isReady
            ? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.25)
            : Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isReady
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isReady ? Icons.verified : Icons.rule,
                    color: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AVANCE DE CONFORMIDAD NORMATIVA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Text(
                '$porcentaje%',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
              valueColor: AlwaysStoppedAnimation<Color>(
                isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completados de $total requisitos normativos completados ($porcentaje%)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
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
            onPressed: () => _generarPDF(context, provider),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('COMPARTIR ACTA (PDF)', style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
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
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PROTOCOLO ELECTROMOVILIDAD — AETN Nº 479/2021', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text('Puesta en Marcha', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text('Valida la instalación eléctrica y mecánica. Para emitir el certificado final, todos los puntos y la medición de tierra son obligatorios.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // INSPECCION VISUAL Y MONTAJE
  Widget _buildVisualInspectionTile(BuildContext context, ChecklistProvider p) {
    return _buildCustomExpansionTile(
      context,
      title: '1. Inspección Visual y Montaje (AETN 479/2021)', icon: Icons.visibility, initiallyExpanded: true,
      children: [
        _buildCheckboxItem(
          context,
          value: p.visFijacion,
          title: 'Fijación firme y altura reglamentaria',
          subtitle: 'Anclaje sólido y altura de conector/tótem entre 0.60 m y 1.30 m s.n.p.t. (AETN Art. 14).',
          onChanged: (v) { p.visFijacion = v ?? false; p.refresh(); },
        ),
        _buildCheckboxItem(
          context,
          value: p.visDanos,
          title: 'Envolvente y grado de protección (IP / IK)',
          subtitle: 'Sin daños; envolvente mínima IP54 para intemperie o IP44 interior protegido (IK08).',
          onChanged: (v) { p.visDanos = v ?? false; p.refresh(); },
        ),
        _buildCheckboxItem(
          context,
          value: p.visCables,
          title: 'Canalización y recorrido de cables',
          subtitle: 'Ruta continua protegida en ducto rígido/reforzado; sin cables en contacto con suelo.',
          onChanged: (v) { p.visCables = v ?? false; p.refresh(); },
        ),
        _buildCheckboxItem(
          context,
          value: p.visProteccion,
          title: 'Protección de personas: RCD Tipo A 30mA',
          subtitle: 'Interruptor diferencial exclusivo Tipo A de 30mA con corte omnipolar (no Tipo AC).',
          onChanged: (v) { p.visProteccion = v ?? false; p.refresh(); },
        ),
        _buildCheckboxItem(
          context,
          value: p.visIdentificacion,
          title: 'Protección atmosférica y rotulado (SPD Clase II)',
          subtitle: 'Tablero rotulado con disyuntor Curva C y protector de sobretensión SPD Clase II a tierra.',
          onChanged: (v) { p.visIdentificacion = v ?? false; p.refresh(); },
        ),
      ],
    );
  }

  // PRUEBAS ELECTRICAS 
  Widget _buildElectricalTestsTile(BuildContext context, ChecklistProvider p) {
    // 1. Tensión reactiva
    final tensionTexto = p.tensionController.text.trim().replaceAll(',', '.');
    final double? parsedTension = double.tryParse(tensionTexto);
    final bool hasTension = tensionTexto.isNotEmpty;
    final bool isTensionSuccess = hasTension && parsedTension != null && parsedTension >= AppConstants.tensionMinimaOperativaV && parsedTension <= AppConstants.tensionMaximaOperativaV;
    final bool isTensionError = hasTension && !isTensionSuccess;

    Color colorTensionEstado = Theme.of(context).colorScheme.onSurface;
    Color colorTensionBorde = Theme.of(context).colorScheme.outlineVariant;
    Color colorTensionFocus = Theme.of(context).colorScheme.primary;

    if (isTensionError) {
      colorTensionEstado = Theme.of(context).colorScheme.error;
      colorTensionBorde = Theme.of(context).colorScheme.error;
      colorTensionFocus = Theme.of(context).colorScheme.error;
    } else if (isTensionSuccess) {
      colorTensionEstado = Theme.of(context).colorScheme.secondary;
      colorTensionBorde = Theme.of(context).colorScheme.secondary;
      colorTensionFocus = Theme.of(context).colorScheme.secondary;
    }

    Widget? suffixTensionWidget;
    if (isTensionError) {
      suffixTensionWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Theme.of(context).colorScheme.error, size: 20),
          Text(
            'Fuera de rango',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error),
          ),
        ],
      );
    } else if (isTensionSuccess) {
      suffixTensionWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary, size: 20),
          Text(
            'Conforme',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      );
    }

    // 2. Resistencia de Puesta a Tierra (Obligatoria para certificar)
    final tierraTexto = p.tierraController.text.trim().replaceAll(',', '.');
    final double? parsedOhms = double.tryParse(tierraTexto);
    final bool hasTierra = tierraTexto.isNotEmpty;

    final bool isSuccess = hasTierra && parsedOhms != null && parsedOhms > 0.0 && parsedOhms <= AppConstants.resistenciaTierraOptimaOhms;
    final bool isAceptable = hasTierra && parsedOhms != null && parsedOhms > AppConstants.resistenciaTierraOptimaOhms && parsedOhms <= AppConstants.resistenciaTierraMaximaOhms;
    final bool isError = hasTierra && (parsedOhms == null || parsedOhms <= 0.0 || parsedOhms > AppConstants.resistenciaTierraMaximaOhms);

    Color colorEstado = Theme.of(context).colorScheme.onSurface;
    Color colorBorde = Theme.of(context).colorScheme.outlineVariant;
    Color colorFocus = Theme.of(context).colorScheme.primary;

    if (isError) {
      colorEstado = Theme.of(context).colorScheme.error;
      colorBorde = Theme.of(context).colorScheme.error;
      colorFocus = Theme.of(context).colorScheme.error;
    } else if (isSuccess) {
      colorEstado = Theme.of(context).colorScheme.secondary;
      colorBorde = Theme.of(context).colorScheme.secondary;
      colorFocus = Theme.of(context).colorScheme.secondary;
    } else if (isAceptable) {
      colorEstado = Theme.of(context).colorScheme.tertiaryContainer;
      colorBorde = Theme.of(context).colorScheme.tertiaryContainer;
      colorFocus = Theme.of(context).colorScheme.tertiaryContainer;
    }

    Widget? suffixWidget;
    if (isError) {
      suffixWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Theme.of(context).colorScheme.error, size: 20),
          Text(
            (parsedOhms != null && parsedOhms <= 0.0) ? 'Inválido (≤0Ω)' : 'Peligroso (>25Ω)',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error),
          ),
        ],
      );
    } else if (isSuccess) {
      suffixWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary, size: 20),
          Text(
            'Óptimo (≤10Ω)',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      );
    } else if (isAceptable) {
      suffixWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Theme.of(context).colorScheme.tertiaryContainer, size: 20),
          Text(
            'Aceptable (≤25Ω)',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiaryContainer),
          ),
        ],
      );
    }

    return _buildCustomExpansionTile(
      context,
      title: '2. Pruebas Eléctricas y PAT (NB 777)', icon: Icons.electrical_services,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ESQUEMA DE CONEXIÓN A TIERRA (AETN Nº 479/2021)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'TN-S (Red Dedicada)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      selected: p.esquemaTierra == 'TN-S',
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: p.esquemaTierra == 'TN-S'
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (val) {
                        if (val) p.setEsquemaTierra('TN-S');
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'TT (Jabalina Local)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      selected: p.esquemaTierra == 'TT',
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: p.esquemaTierra == 'TT'
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (val) {
                        if (val) p.setEsquemaTierra('TT');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text('TENSIÓN DE RED OPERATIVA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              TextField(
                controller: p.tensionController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: colorTensionEstado),
                decoration: InputDecoration(
                  hintText: 'Ej: 220',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                  suffixText: 'V',
                  suffixStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                  border: UnderlineInputBorder(borderSide: BorderSide(color: colorTensionBorde, width: 2)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorTensionBorde, width: 2)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorTensionFocus, width: 2)),
                  suffixIcon: suffixTensionWidget,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4, bottom: 16),
                child: Text('Tensión nominal requerida entre 180V y 460V (Monofásica 220V, Delta 220V, Trifásica 380V).', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
              
              Text('RESISTENCIA PUESTA A TIERRA (OBLIGATORIA)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              TextField(
                controller: p.tierraController,
                enabled: !p.medicionTierraExterna,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: colorEstado),
                decoration: InputDecoration(
                  hintText: p.medicionTierraExterna ? 'Delegada a externo' : 'Ej: 5.4',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)), 
                  suffixText: p.medicionTierraExterna ? null : 'Ω',
                  suffixStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  filled: true, 
                  fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                  border: UnderlineInputBorder(borderSide: BorderSide(color: colorBorde, width: 2)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorBorde, width: 2)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorFocus, width: 2)),
                  disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1)),
                  suffixIcon: p.medicionTierraExterna ? null : suffixWidget,
                ),
              ),
              CheckboxListTile(
                title: const Text(
                  'Medición delegada a especialista técnico (Constancia PAT adjunta)',
                  style: TextStyle(fontSize: 12),
                ),
                value: p.medicionTierraExterna,
                onChanged: (val) => p.setMedicionTierraExterna(val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4, bottom: 16), 
                child: Text(
                  p.medicionTierraExterna
                      ? 'Medición de PAT delegada a especialista técnico. Requiere marcar la constancia PAT en la sección de Documentación.'
                      : 'Requisito obligatorio ≤ 25 Ω (NB 777) para emitir el certificado final (Ideal < 10 Ω). Si se omite, solo se guardará como borrador.',
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
                ),
              ),
              _buildCheckboxItem(
                context,
                value: p.elecContinuidad,
                title: 'Continuidad y equipotencialidad',
                subtitle: 'Fase, Neutro y Tierra medidos con continuidad efectiva a la barra equipotencial.',
                onChanged: (v) { p.elecContinuidad = v ?? false; p.refresh(); },
              ),
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
      title: '3. Pruebas Finales y Operación con EV', icon: Icons.power_settings_new,
      children: [
        _buildCheckboxItem(context, value: p.funEncendido, title: 'Encendido Wallbox', subtitle: 'Verificar LEDs / pantalla activa sin errores de comunicación.', onChanged: (v) { p.funEncendido = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.funCorriente, title: 'Corriente real de carga', subtitle: 'Conectar EV y verificar corriente real con pinza amperimétrica.', onChanged: (v) { p.funCorriente = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.funTemperatura, title: 'Control térmico en bornes', subtitle: 'Sin calentamiento excesivo (≤ 60°C) en bornes tras prueba de carga continua.', onChanged: (v) { p.funTemperatura = v ?? false; p.refresh(); }),
        _buildCheckboxItem(context, value: p.funEmergencia, title: 'Parada de emergencia', subtitle: 'Pulsador de parada probado y efectivo (si aplica).', onChanged: (v) { p.funEmergencia = v ?? false; p.refresh(); }),
      ],
    );
  }

  // DOCUMENTACION FINAL 
  Widget _buildDocumentationTile(BuildContext context, ChecklistProvider p) {
    return _buildCustomExpansionTile( 
      context,
      title: '4. Documentación y Entrega Técnica', icon: Icons.folder_special,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDocButton(context, text: 'Registro fotográfico (Equipo, Tablero y PAT)', isCompleted: p.docFoto, onTap: () { p.docFoto = !p.docFoto; p.refresh(); }),
              const SizedBox(height: 8),
              _buildDocButton(context, text: 'Diagrama unifilar del circuito terminal dedicado', isCompleted: p.docDiagrama, onTap: () { p.docDiagrama = !p.docDiagrama; p.refresh(); }),
              const SizedBox(height: 8),
              _buildDocButton(context, text: 'Constancia o certificado de medición de puesta a tierra (PAT)', isCompleted: p.docCertificado, onTap: () { p.docCertificado = !p.docCertificado; p.refresh(); }),
              const SizedBox(height: 8),
              _buildDocButton(context, text: 'Manual de usuario y mantenimiento entregado al cliente', isCompleted: p.docManual, onTap: () { p.docManual = !p.docManual; p.refresh(); }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
          child: Text('Nota: Orientar al cliente sobre uso seguro, protocolos de desconexión y mantenimiento preventivo.', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.secondary, fontStyle: FontStyle.italic)),
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

class _DialogoGuardarRegistro extends StatefulWidget {
  final ChecklistProvider provider;
  final BuildContext parentContext;

  const _DialogoGuardarRegistro({
    required this.provider,
    required this.parentContext,
  });

  @override
  State<_DialogoGuardarRegistro> createState() => _DialogoGuardarRegistroState();
}

class _DialogoGuardarRegistroState extends State<_DialogoGuardarRegistro> {
  late final TextEditingController _nombreController;
  late final TextEditingController _ciController;
  late final TextEditingController _direccionController;
  late final TextEditingController _tecnicoController;
  late final TextEditingController _matriculaController;
  late String _distribuidoraSeleccionada;
  late String _esquemaSeleccionado;

  final List<String> _distribuidorasDisponibles = ['ELFEC', 'DELAPAZ', 'CRE', 'ENDE', 'OTRO'];
  final List<String> _esquemasDisponibles = ['TN-S', 'TT'];

  @override
  void initState() {
    super.initState();
    final isEditing = widget.provider.currentInstalacionId != null;
    _nombreController = TextEditingController(text: isEditing ? widget.provider.nombreClienteGuardado : '');
    _ciController = TextEditingController(text: isEditing ? widget.provider.ciNitClienteGuardado : '');
    _direccionController = TextEditingController(text: isEditing ? widget.provider.direccionGuardada : '');
    _tecnicoController = TextEditingController(text: widget.provider.tecnicoResponsable);
    _matriculaController = TextEditingController(text: widget.provider.matriculaProfesional);
    _distribuidoraSeleccionada = widget.provider.distribuidora;
    _esquemaSeleccionado = widget.provider.esquemaTierra;

    _cargarDatosTecnicoPersistidos();
  }

  Future<void> _cargarDatosTecnicoPersistidos() async {
    final prefs = await SharedPreferences.getInstance();
    final nombreGuardado = prefs.getString('cfg_nombre_tecnico');
    final sibGuardado = prefs.getString('cfg_registro_sib');

    if (mounted) {
      if (_tecnicoController.text.trim().isEmpty && nombreGuardado != null && nombreGuardado.trim().isNotEmpty) {
        setState(() {
          _tecnicoController.text = nombreGuardado.trim();
        });
      }
      if (_matriculaController.text.trim().isEmpty && sibGuardado != null && sibGuardado.trim().isNotEmpty) {
        setState(() {
          _matriculaController.text = sibGuardado.trim();
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ciController.dispose();
    _direccionController.dispose();
    _tecnicoController.dispose();
    _matriculaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final isEditing = provider.currentInstalacionId != null;
    final isReady = provider.isChecklistComplete;

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Row(
        children: [
          Icon(isReady ? Icons.verified : Icons.save, color: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isReady ? 'Certificar Entrega (AETN 479)' : (isEditing ? 'Actualizar Borrador' : 'Guardar Borrador'), 
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
                ? 'La instalación cumple con la Resolución AETN Nº 479/2021 y NB 777. Completa los datos para el acta formal.'
                : 'Faltan datos o mediciones de puesta a tierra. El registro se guardará como borrador pendiente.',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nombre del Cliente / Empresa *', 
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), 
                border: const OutlineInputBorder(), 
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _direccionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Dirección de Instalación *', 
                prefixIcon: const Icon(Icons.location_on, size: 18), 
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), 
                border: const OutlineInputBorder(), 
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ciController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'C.I. / NIT (Opcional)', 
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), 
                border: const OutlineInputBorder(), 
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            // Distribuidora eléctrica
            DropdownButtonFormField<String>(
              value: _distribuidoraSeleccionada,
              decoration: InputDecoration(
                labelText: 'Empresa Distribuidora Eléctrica',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              items: _distribuidorasDisponibles.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _distribuidoraSeleccionada = val);
              },
            ),
            const SizedBox(height: 12),

            // Esquema de Tierra
            DropdownButtonFormField<String>(
              value: _esquemaSeleccionado,
              decoration: InputDecoration(
                labelText: 'Esquema de Tierra (PAT)',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              items: _esquemasDisponibles.map((e) => DropdownMenuItem(value: e, child: Text(e == 'TN-S' ? 'TN-S (Neutro y Tierra separados)' : 'TT (Tierra local y RCD)'))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _esquemaSeleccionado = val);
              },
            ),
            const SizedBox(height: 12),

            // Técnico responsable
            TextField(
              controller: _tecnicoController,
              decoration: InputDecoration(
                labelText: 'Nombre del Técnico / Empresa Instaladora (Opcional)',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            // Matrícula profesional
            TextField(
              controller: _matriculaController,
              decoration: InputDecoration(
                labelText: 'Matrícula Profesional / Registro SIB (Opcional)',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
        ),
        ElevatedButton(
          onPressed: provider.isSaving ? null : () async {
            if (_nombreController.text.trim().isEmpty || _direccionController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Nombre y Dirección son obligatorios para el certificado.'), 
                  backgroundColor: Theme.of(context).colorScheme.error,
                )
              );
              return;
            }

            // Sincronizamos y persistimos datos del instalador en SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            final tecnicoStr = _tecnicoController.text.trim();
            final matriculaStr = _matriculaController.text.trim();
            if (tecnicoStr.isNotEmpty) {
              await prefs.setString('cfg_nombre_tecnico', tecnicoStr);
            }
            if (matriculaStr.isNotEmpty) {
              await prefs.setString('cfg_registro_sib', matriculaStr);
            }

            // Sincronizamos metadatos normativos en el Provider
            widget.provider.distribuidora = _distribuidoraSeleccionada;
            widget.provider.esquemaTierra = _esquemaSeleccionado;
            widget.provider.tecnicoResponsable = tecnicoStr;
            widget.provider.matriculaProfesional = matriculaStr;

            await provider.guardarRegistroFinal(
              nombreCliente: _nombreController.text.trim(), 
              ciNitCliente: _ciController.text.trim(),
              direccion: _direccionController.text.trim(),
            );

            if (context.mounted) {
              Navigator.pop(context); 
              ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                SnackBar(
                  content: Text(isReady ? 'Certificado emitido y guardado correctamente.' : '💾 Registro guardado en BD como borrador.'), 
                  backgroundColor: isReady ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                )
              );
              Navigator.pop(widget.parentContext); 
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
}
