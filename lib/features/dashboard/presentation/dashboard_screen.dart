import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../providers/dashboard_provider.dart';
import 'detalle_registro_screen.dart';
import 'historial_completo_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(context), 
                    const SizedBox(height: 24),
                    _buildGridCards(context),
                    const SizedBox(height: 32),
                    
                    // SECCION DINAMICA CONECTADA AL PROVIDER
                    _buildRecentActivity(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarInfoLegal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
              SizedBox(width: 8),
              Text('Acerca de la App', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            ],
          ), 
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¿Cómo funciona el almacenamiento?', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text(
                  'Por seguridad y privacidad, toda la información de tus instalaciones y clientes se guarda de forma LOCAL en la memoria de este dispositivo.\n\n'
                  '⚠️ IMPORTANTE: Si desinstalas la aplicación o borras sus datos desde la configuración de Android/iOS, toda la información se perderá permanentemente.',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Text('Aviso Legal', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text(
                  'Esta herramienta está diseñada como apoyo para instaladores profesionales. Los cálculos y sugerencias normativas (NB 777 / IEC) deben ser verificados por un ingeniero eléctrico certificado. El desarrollador no asume responsabilidad por instalaciones defectuosas.',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                // Boton para calificar/sugerir en Play Store
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.jhones.wireflow_ve');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.star_rate_rounded),
                    label: const Text('DEJAR SUGERENCIA EN PLAY STORE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Entendido', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 26, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface),
                    children: [
                      TextSpan(text: 'WIRE FLOW\n'),
                      TextSpan(text: 'VE ', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      TextSpan(text: 'ELECTROLINERA', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bolt, color: Theme.of(context).colorScheme.secondary, size: 36),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // BOTON DE INFORMACION
          InkWell(
            onTap: () => _mostrarInfoLegal(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Acerca de la app y Privacidad',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCards(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActionCard(
          context,
          title: 'Calculadora Técnica',
          subtitle: 'Dimensionamiento de conductores.',
          icon: Icons.calculate,
          accentColor: Theme.of(context).colorScheme.primaryContainer,
          onAccentColor: Theme.of(context).colorScheme.onPrimaryContainer,
          onTap: () => Navigator.pushNamed(context, '/calculator'),
        ),
        _buildActionCard(
          context,
          title: 'Cotizador y ROI',
          subtitle: 'Análisis comercial y retorno.',
          icon: Icons.analytics,
          accentColor: Theme.of(context).colorScheme.secondaryContainer,
          onAccentColor: Theme.of(context).colorScheme.onSecondaryContainer,
          onTap: () => Navigator.pushNamed(context, '/commercial'),
        ),
        _buildActionCard(
          context,
          title: 'Checklist Certificación',
          subtitle: 'Validación y puesta en marcha.',
          icon: Icons.fact_check,
          accentColor: Theme.of(context).colorScheme.tertiaryContainer,
          onAccentColor: Theme.of(context).colorScheme.onTertiaryContainer,
          onTap: () async {
            await Navigator.pushNamed(context, '/checklist');
            if (context.mounted) {
              context.read<DashboardProvider>().cargarHistorial();
            }
          },
        ),
        _buildActionCard(
          context,
          title: 'Asesor de Cargador',
          subtitle: 'Selección de hardware.',
          icon: Icons.account_tree,
          accentColor: Theme.of(context).colorScheme.primaryContainer,
          onAccentColor: Theme.of(context).colorScheme.onPrimaryContainer,
          onTap: () => Navigator.pushNamed(context, '/advisor'),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context,{
    required String title, required String subtitle, 
    required IconData icon, required Color accentColor, 
    required Color onAccentColor, required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: accentColor),
                ),
                Icon(Icons.north_east, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface), maxLines: 2),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            )
          ],
        ),
      ),
    );
  }

  // UI REACTIVA CON PROVIDER 
  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ACTIVIDAD RECIENTE',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.outline),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaHistorialCompleto()),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Ver Todo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Consumer<DashboardProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.outlineVariant),
              ));
            }

            if (provider.error != null) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('Error al cargar datos: ${provider.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              );
            }

            final historial = provider.historial;
            if (historial.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.inbox, color: Theme.of(context).colorScheme.outlineVariant, size: 32),
                    SizedBox(height: 8),
                    Text('Aún no hay instalaciones registradas.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historial.length > 10 ? 10 : historial.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final registro = historial[index];
                final fecha = '${registro.fechaRegistro.day.toString().padLeft(2, '0')}/${registro.fechaRegistro.month.toString().padLeft(2, '0')}/${registro.fechaRegistro.year}';
                
                return _buildActivityTile(
                  context,
                  title: registro.nombreCliente,
                  subtitle: registro.direccionInstalacion,
                  status: registro.isCompletado ? 'Certificado' : 'Borrador',
                  time: fecha,
                  icon: registro.isCompletado ? Icons.verified : Icons.pending_actions,
                  iconColor: registro.isCompletado ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaDetalleRegistro(registro: registro),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityTile(BuildContext context,{
    required String title, required String subtitle, 
    required String status, required String time, 
    required IconData icon, required Color iconColor, 
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3))
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(title, 
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface), 
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Text(time, style: TextStyle(fontSize: 13, fontFamily: 'Space Grotesk', color: Theme.of(context).colorScheme.outline)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, 
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant), 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: iconColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}