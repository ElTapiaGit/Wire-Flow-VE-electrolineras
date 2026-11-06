import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../../core/database/app_database.dart'; 
import '../../../core/services/pdf_service.dart'; 
import 'package:provider/provider.dart';
import '../../checklist/providers/checklist_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';

class PantallaDetalleRegistro extends StatelessWidget {
  final CertificacionesChecklistData registro;
  
  const PantallaDetalleRegistro({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    // REACTIVIDAD: Escuchamos el historial global
    final dashboardProvider = context.watch<DashboardProvider>();
    // Buscamos la version mas reciente de este registro en específico por su clave de instalacion
    final registroActualizado = dashboardProvider.historial.firstWhere(
      (r) => r.instalacionId == registro.instalacionId,
      orElse: () => registro, // Si por alguna razón no lo encuentra, usa el viejo
    );
    final bool isCertificado = registroActualizado.isCompletado;
    final fechaFormat = DateFormat('dd MMM yyyy - HH:mm');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Detalle de Instalación', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TARJETA DE ESTADO Y CLIENTE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCertificado 
                              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)
                              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isCertificado ? 'CERTIFICADO' : 'BORRADOR PENDIENTE',
                          style: TextStyle(
                            fontSize: 10, 
                            fontWeight: FontWeight.bold, 
                            color: isCertificado ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary
                          ),
                        ),
                      ),
                      Text(
                        fechaFormat.format(registroActualizado.fechaRegistro),
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(registroActualizado.nombreCliente, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(child: Text(registroActualizado.direccionInstalacion, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant))),
                    ],
                  ),
                  if (registroActualizado.ciNitCliente.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.badge, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('CI/NIT: ${registroActualizado.ciNitCliente}', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 24),

            // RESUMEN TECNICO
            Text('DATOS TÉCNICOS REGISTRADOS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 12),
            
            _buildDataRow(context, 'Tensión Medida', registroActualizado.tensionMedidaV != null ? '${registroActualizado.tensionMedidaV} V' : 'No registrada', Icons.electrical_services),
            const Divider(height: 1),
            _buildDataRow(context, 'Puesta a Tierra', registroActualizado.resistenciaTierraOhms != null ? '${registroActualizado.resistenciaTierraOhms} Ω' : 'No registrada', Icons.sensors),
            const Divider(height: 1),
            _buildDataRow(context, 'Pruebas Operativas', registroActualizado.funEncendido && registroActualizado.funCorriente ? 'Aprobadas' : 'Incompletas', Icons.check_circle_outline),
          ],
        ),
      ),
      
      // BOTONES FLOTANTE PARA GENERAR EL PDF
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Si ES BORRADOR: Botón principal de Editar
              if (!isCertificado) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      context.read<ChecklistProvider>().cargadorBorrador(registroActualizado);
                      
                      await Navigator.pushNamed(context, '/checklist');
                      // obligamos al historial a recargar la base de datos
                      if (context.mounted) {
                        context.read<DashboardProvider>().cargarHistorial();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.edit_document),
                    label: const Text('CONTINUAR EDITANDO', style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // boton de pdf
              SizedBox(
                width: double.infinity,
                height: 52,
                child: isCertificado 
                  ? ElevatedButton.icon(
                      onPressed: () async => await PdfService.generarCertificado(registroActualizado),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.surface, // Texto oscuro o claro según el tema
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('GENERAR ACTA EN PDF', style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    )
                  : OutlinedButton.icon(
                      onPressed: () async => await PdfService.generarCertificado(registroActualizado),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PREVISUALIZAR BORRADOR', style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold)),
                    ),
              ),

              // candado de seguridad
              if (isCertificado) ...[
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 14, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(width: 6),
                    Text('Registro certificado. No se puede modificar.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline)),
                  ],
                )
              ]
            ],
          ),
        )
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}