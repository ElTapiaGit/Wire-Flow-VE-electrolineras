import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../../core/database/app_database.dart'; 
import '../../../core/services/pdf_service.dart'; 

class PantallaDetalleRegistro extends StatelessWidget {
  final CertificacionesChecklistData registro;
  
  const PantallaDetalleRegistro({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    final bool isCertificado = registro.isCompletado;
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
                        fechaFormat.format(registro.fechaRegistro),
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(registro.nombreCliente, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(child: Text(registro.direccionInstalacion, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant))),
                    ],
                  ),
                  if (registro.ciNitCliente.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.badge, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('CI/NIT: ${registro.ciNitCliente}', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
            
            _buildDataRow(context, 'Tensión Medida', registro.tensionMedidaV != null ? '${registro.tensionMedidaV} V' : 'No registrada', Icons.electrical_services),
            const Divider(height: 1),
            _buildDataRow(context, 'Puesta a Tierra', registro.resistenciaTierraOhms != null ? '${registro.resistenciaTierraOhms} Ω' : 'No registrada', Icons.youtube_searched_for_sharp),
            const Divider(height: 1),
            _buildDataRow(context, 'Pruebas Operativas', registro.funEncendido && registro.funCorriente ? 'Aprobadas' : 'Incompletas', Icons.check_circle_outline),
          ],
        ),
      ),
      
      // BOTON FLOTANTE PARA GENERAR EL PDF
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () async {
              await PdfService.generarCertificado(registro);
            },
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            elevation: 4,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('GENERAR ACTA EN PDF', style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ),
        ),
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