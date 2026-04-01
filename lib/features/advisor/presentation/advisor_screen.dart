import 'package:flutter/material.dart';

class AdvisorScreen extends StatefulWidget {
  const AdvisorScreen({super.key});

  @override
  State<AdvisorScreen> createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  // ESTADO DEL FORMULARIO
  int _ubicacionIndex = 0;
  int _redIndex = 0;
  int _kmIndex = 1; 
  int _tiempoIndex = 0;

  // LOGICA DEL ASESOR
  Map<String, dynamic> _getRecommendation() {
    if (_ubicacionIndex == 2) {
      return {
        'tipo': 'Cargador Portátil (Ocasional)',
        'potencia': '1.4 kW a 3.7 kW',
        'tiempo': 'Carga lenta (8-15 km de autonomía por hora)',
        'inversion': 'Baja (Viene con el vehículo o < Bs 2.000)',
        'descripcion': 'Se conecta a tomas convencionales. Ideal para emergencias, pero requiere un circuito exclusivo de 16A si se usará a diario.',
        'icon': Icons.electrical_services,
        'color': Theme.of(context).colorScheme.outline,
        'suggestedPowerKw': 3.7, 
      };
    }

    if (_ubicacionIndex == 1 && _tiempoIndex == 2) {
      return {
        'tipo': 'Cargador Off-Board (DC)',
        'potencia': '30 kW a 150+ kW',
        'tiempo': 'Carga en minutos (< 1 hora)',
        'inversion': '\$80.000 - \$150.000+ USD',
        'descripcion': 'Alimenta directamente la batería en corriente continua (CC), saltándose el límite del vehículo. Requiere media tensión.',
        'icon': Icons.ev_station,
        'color': Theme.of(context).colorScheme.error,
        'suggestedPowerKw': 50.0, 
      };
    }

    if (_ubicacionIndex == 1) {
      return {
        'tipo': 'Tótem / Estación Semi-rápida (AC)',
        'potencia': '7.4 kW a 22 kW',
        'tiempo': '2 a 8 horas',
        'inversion': '\$8.000 - \$15.000 USD',
        'descripcion': 'Soporta uso intensivo (IP54/IK10). Ideal para supermercados, hoteles y empresas. Integra pagos y múltiples mangueras.',
        'icon': Icons.business,
        'color': Theme.of(context).colorScheme.tertiaryContainer,
      };
    }

    if (_ubicacionIndex == 0 && _redIndex == 1 && (_kmIndex > 0 || _tiempoIndex == 1)) {
      return {
        'tipo': 'Wallbox Residencial Trifásico',
        'potencia': '11 kW a 22 kW',
        'tiempo': 'Carga completa en 2 a 4 horas',
        'inversion': '\$2.000 - \$8.000 USD',
        'descripcion': 'Aprovecha la red trifásica para tiempos mínimos. IMPORTANTE: El vehículo debe tener un On-Board Charger (OBC) de 11kW o 22kW para aprovecharlo.',
        'icon': Icons.home,
        'color': Theme.of(context).colorScheme.primaryContainer,
      };
    }

    return {
      'tipo': 'Wallbox Residencial Monofásico',
      'potencia': '7.4 kW',
      'tiempo': 'Carga completa en 6 a 10 horas',
      'inversion': 'Bs 4.500 - 6.000',
      'descripcion': 'La solución ideal y más común. Carga el vehículo al 100% durante la noche de forma segura y económica.',
      'icon': Icons.home,
      'color': Theme.of(context).colorScheme.secondaryContainer,
    };
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
              panEnabled: true, // permite mover la imagen
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0, // zoom maximo de 4x
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recomendacion = _getRecommendation();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24.0), 
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
                          
                          // PREGUNTAS AL CLIENTE 
                          Text('PERFIL DE USO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 16),
                          _buildChoiceGroup('1. Ubicación', ['Residencial', 'Comercial / Público', 'Emergencia / Viaje'], _ubicacionIndex, (val) => setState(() => _ubicacionIndex = val)),
                          _buildChoiceGroup('2. Red Disponible', ['Monofásica (220V)', 'Trifásica (380V)'], _redIndex, (val) => setState(() => _redIndex = val)),
                          _buildChoiceGroup('3. Kilometraje Diario', ['< 50 km', '50 - 150 km', '> 150 km / Flotas'], _kmIndex, (val) => setState(() => _kmIndex = val)),
                          _buildChoiceGroup('4. Tiempo de Carga', ['Nocturna (8-12h)', 'En Trabajo (4-8h)', 'En Tránsito (< 1h)'], _tiempoIndex, (val) => setState(() => _tiempoIndex = val)),
                          
                          const SizedBox(height: 32),

                          // RESULTADO Y RECOMENDACION 
                          Text('RECOMENDACIÓN DEL SISTEMA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 16),
                          _buildRecommendationCard(recomendacion),
                          const SizedBox(height: 24),

                          // ADVERTENCIA TECNICA 
                          _buildTechnicalWarning(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),

                    // GUIA DE CONECTORES 
                    _buildConnectorsGuide(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // GUIA VISUAL DE CONECTORES
  Widget _buildConnectorsGuide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('GUÍA RÁPIDA DE CONECTORES (AC)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('Toca la imagen para ampliar y ver detalles del puerto.', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.secondary, fontStyle: FontStyle.italic)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240, 
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildConnectorCard(
                name: 'Tipo 2 (Mennekes)',
                region: 'Europa / Resto del Mundo',
                description: 'El estándar más común hoy en día. Soporta carga trifásica (hasta 22kW). Usado por marcas europeas.',
                imagePath: 'assets/images/tipo-2-mennekes.webp',
              ),
              _buildConnectorCard(
                name: 'GB/T (AC)',
                region: 'China',
                description: 'Estándar asiático creciente en Latinoamérica por importaciones (BYD, Changan, etc.). Solo monofásico.',
                imagePath: 'assets/images/GBT-AC.webp',
              ),
              _buildConnectorCard(
                name: 'Tipo 1 (J1772)',
                region: 'Norteamérica / Japón',
                description: 'Estándar antiguo, limitado a carga monofásica (7.4kW). Común en autos usados importados (Nissan Leaf).',
                imagePath: 'assets/images/tipo-1-J1772-norteamerica.webp',
              ),
              _buildConnectorCard(
                name: 'NACS (Tesla)',
                region: 'Norteamérica',
                description: 'Conector propietario de Tesla. En el mercado europeo/latino, Tesla a menudo envía autos con puerto Tipo 2.',
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
      width: 240, 
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AREA DE LA IMAGEN CLICKEABLE CON ZOOM
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
                  child: Hero( // animacion fluida al abrir
                    tag: imagePath,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(name, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          Text(region, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.3),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.5))),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary, size: 20), onPressed: () => Navigator.pop(context)),
          const SizedBox(width: 8),
          Text('Asesor de Hardware', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }

  Widget _buildContextSection() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SELECCIÓN DE CARGADOR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text('Perfil del Cliente', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 8),
          Text('Responde estas 4 preguntas con el cliente para sugerirle el cargador ideal según las normas.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildChoiceGroup(String title, List<String> options, int selectedIndex, ValueChanged<int> onSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 12),
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
                labelStyle: TextStyle(color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurfaceVariant),
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

  Widget _buildRecommendationCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: data['color'], width: 6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: data['color'].withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Icon(data['icon'], color: data['color'], size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['potencia'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: data['color'])),
                    Text(data['tipo'], style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface, height: 1.1)),
                  ],
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
          _buildInfoRow(Icons.timer, 'Tiempo estimado:', data['tiempo']),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.payments, 'Inversión aprox:', data['inversion']),
          const SizedBox(height: 16),
          Text(data['descripcion'], style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
              children: [
                TextSpan(text: '$label ', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicalWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.secondary, size: 18),
              SizedBox(width: 8),
              Text('TIP PARA EL TÉCNICO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
            ],
          ),
          SizedBox(height: 12),
          Text('El límite del On-Board Charger (OBC)', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 4),
          Text(
            'Recuerda explicarle al cliente que el cargador On-Board (interno del auto) limita la velocidad en Corriente Alterna (CA). Por ejemplo, si el vehículo tiene un OBC de 11 kW, aunque le instales un Wallbox de 22 kW, el auto solo cargará a 11 kW máximo.',
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}