import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import 'detalle_registro_screen.dart';

class PantallaHistorialCompleto extends StatefulWidget {
  const PantallaHistorialCompleto({super.key});

  @override
  State<PantallaHistorialCompleto> createState() => _PantallaHistorialCompletoState();
}

class _PantallaHistorialCompletoState extends State<PantallaHistorialCompleto> {
  String _searchQuery = '';
  String _filterStatus = 'Todos'; // 'Todos', 'Certificados', 'Borradores'
  int _itemsToShow = 15; 

  void _cargarMas() {
    setState(() {
      _itemsToShow += 15; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Historial de Instalaciones', style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BARRA DE BUSQUEDA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _itemsToShow = 15;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar cliente o dirección...',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.outline),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // FILTROS RAPIDOS (CHIPS)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: ['Todos', 'Certificados', 'Borradores'].map((status) {
                final isSelected = _filterStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(status, style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                      color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant
                    )),
                    selected: isSelected,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                    showCheckmark: false,
                    side: BorderSide(color: isSelected ? Colors.transparent : Theme.of(context).colorScheme.outlineVariant),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _filterStatus = status;
                          _itemsToShow = 15; 
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 1),

          // LISTA FILTRADA Y PAGINADA
          Expanded(
            child: Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                final historialRaw = provider.historial;
                
                if (historialRaw.isEmpty) {
                  return Center(child: Text('No hay registros guardados.', style: TextStyle(color: Theme.of(context).colorScheme.outline)));
                }

                // filtrado en memoria
                final historialFiltrado = historialRaw.where((registro) {
                  // Filtro por texto
                  final matchText = registro.nombreCliente.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                    registro.direccionInstalacion.toLowerCase().contains(_searchQuery.toLowerCase());
                  
                  // Filtro por estado
                  bool matchStatus = true;
                  if (_filterStatus == 'Certificados') matchStatus = registro.isCompletado;
                  if (_filterStatus == 'Borradores') matchStatus = !registro.isCompletado;

                  return matchText && matchStatus;
                }).toList();

                if (historialFiltrado.isEmpty) {
                  return Center(child: Text('Ningún registro coincide con tu búsqueda.', style: TextStyle(color: Theme.of(context).colorScheme.outline)));
                }

                // paginacion
                final limit = historialFiltrado.length > _itemsToShow ? _itemsToShow : historialFiltrado.length;
                final bool hasMore = historialFiltrado.length > _itemsToShow;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: hasMore ? limit + 1 : limit, 
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    
                    if (index == limit) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TextButton.icon(
                          onPressed: _cargarMas,
                          icon: Icon(Icons.expand_more, color: Theme.of(context).colorScheme.secondary),
                          label: Text('Cargar más registros', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
                        ),
                      );
                    }

                    final registro = historialFiltrado[index];
                    final fecha = '${registro.fechaRegistro.day.toString().padLeft(2, '0')}/${registro.fechaRegistro.month.toString().padLeft(2, '0')}/${registro.fechaRegistro.year}';
                    
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PantallaDetalleRegistro(registro: registro),));
                        },
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
                              Icon(registro.isCompletado ? Icons.verified : Icons.pending_actions, color: registro.isCompletado ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(registro.nombreCliente, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface), overflow: TextOverflow.ellipsis)),
                                        Text(fecha, style: TextStyle(fontSize: 10, fontFamily: 'Space Grotesk', color: Theme.of(context).colorScheme.outline)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(registro.direccionInstalacion, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}