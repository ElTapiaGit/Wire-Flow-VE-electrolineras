import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; 
import '../../core/database/app_database.dart'; 

class PdfService {
  static Future<void> generarCotizacionComercialPdf({
    required BuildContext context,
    required String calibreAwg,
    required double distanciaM,
    required double precioMetroCable,
    required double costoTotalCable,
    required double costoProtecciones,
    required Map<String, double> desgloseProtecciones,
    required double costoManoObra,
    required double subtotalMateriales,
    required double totalEstimado,
    required double ahorroMensualVsGasolina,
    required double ahorroAnualVsGasolina,
  }) async {
    final pdf = pw.Document();
    final fechaFormat = DateFormat('dd/MM/yyyy');
    final fechaStr = fechaFormat.format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        build: (pw.Context ctx) {
          return [
            _buildCotizacionHeader(fechaStr),
            pw.SizedBox(height: 12),

            // Banner Título
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                'PRESUPUESTO DE INSTALACIÓN — ESTACIÓN DE CARGA VE',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 10),

            // Resumen Técnico del Circuito
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ESPECIFICACIÓN TÉCNICA DEL CIRCUITO', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                      pw.SizedBox(height: 2),
                      pw.Text('Tendido desde tablero/acometida: ${distanciaM.toStringAsFixed(1)} metros', style: const pw.TextStyle(fontSize: 8.5)),
                      pw.Text('Conductor seleccionado: Cobre AWG $calibreAwg (PVC 70°C)', style: const pw.TextStyle(fontSize: 8.5)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('NORMA TÉCNICA APLICADA', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                      pw.SizedBox(height: 2),
                      pw.Text('NB 777 / IEC 61851-1 / NEC 625', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Protección Bipolar Curva C + RCD Tipo A', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.blue900)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // Tabla 1: Materiales Eléctricos y Canalización
            pw.Text('1. MATERIALES ELÉCTRICOS Y PROTECCIONES', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.SizedBox(height: 4),
            _buildTablaMateriales(
              calibreAwg: calibreAwg,
              distanciaM: distanciaM,
              precioMetroCable: precioMetroCable,
              costoTotalCable: costoTotalCable,
              desgloseProtecciones: desgloseProtecciones,
              subtotalMateriales: subtotalMateriales,
            ),
            pw.SizedBox(height: 10),

            // Partida 2: Mano de Obra
            pw.Text('2. SERVICIOS PROFESIONALES Y MANO DE OBRA', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.SizedBox(height: 4),
            _buildTablaManoObra(costoManoObra),
            pw.SizedBox(height: 10),

            // Resumen Económico
            _buildResumenEconomico(subtotalMateriales, costoManoObra, totalEstimado),
            pw.SizedBox(height: 10),

            // Bloque ROI
            _buildBloqueRoi(ahorroMensualVsGasolina, ahorroAnualVsGasolina, totalEstimado),
            pw.SizedBox(height: 14),

            // Pie de página corporativo (Términos, Garantía y Nota Técnica)
            _buildPiePaginaCorporativo(),
          ];
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Cotizacion_Instalacion_VE_${fechaStr.replaceAll('/', '-')}.pdf',
    );
  }

  static pw.Widget _buildCotizacionHeader(String fecha) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('WIRE FLOW VE', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Text('Ingeniería e Instalaciones de Electromovilidad en Bolivia', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Fecha de Emisión: $fecha', style: const pw.TextStyle(fontSize: 8.5)),
            pw.Text('Validez de la Oferta: 15 días calendario', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTablaMateriales({
    required String calibreAwg,
    required double distanciaM,
    required double precioMetroCable,
    required double costoTotalCable,
    required Map<String, double> desgloseProtecciones,
    required double subtotalMateriales,
  }) {
    final List<pw.TableRow> rows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Descripción del Material', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Cant.', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('P. Unit (Bs)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
          pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Total (Bs)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
        ],
      ),
      // Fila Conductor
      pw.TableRow(
        children: [
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Conductor de Cobre AWG $calibreAwg (PVC 70°C)', style: const pw.TextStyle(fontSize: 8))),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${distanciaM.toStringAsFixed(0)} m', style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(precioMetroCable.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(costoTotalCable.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
        ],
      ),
    ];

    // Filas Componentes Protecciones
    desgloseProtecciones.forEach((nombre, precio) {
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(nombre, style: const pw.TextStyle(fontSize: 8))),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('1 pza', style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(precio.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(precio.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
          ],
        ),
      );
    });

    // Fila Subtotal
    rows.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey100),
        children: [
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('SUBTOTAL MATERIALES Y PROTECCIONES', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: const pw.TextStyle(fontSize: 8))),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: const pw.TextStyle(fontSize: 8))),
          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Bs ${subtotalMateriales.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900), textAlign: pw.TextAlign.right)),
        ],
      ),
    );

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(5),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
      },
      children: rows,
    );
  }

  static pw.Widget _buildTablaManoObra(double costoManoObra) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(5),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Descripción del Servicio Técnico', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Cant.', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('P. Unit (Bs)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
            pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Total (Bs)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Instalación Especializada de Cargador VE', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Montaje y fijación mecánica de tablero IP65 y Wallbox, tendido y entubado de canalización, conexionado de protecciones DIN, pruebas de continuidad de conductores, medición de resistencia de puesta a tierra y calibración operativa.', style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('1 Serv', style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(costoManoObra.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(costoManoObra.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildResumenEconomico(double subtotalMateriales, double costoManoObra, double totalEstimado) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Subtotal Materiales: Bs ${subtotalMateriales.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8.5)),
              pw.Text('Mano de Obra Calificada: Bs ${costoManoObra.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8.5)),
            ],
          ),
          pw.Row(
            children: [
              pw.Text('TOTAL PRESUPUESTADO: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
              pw.Text('Bs ${totalEstimado.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBloqueRoi(double ahorroMensual, double ahorroAnual, double totalPresupuesto) {
    final double mesesRetorno = ahorroMensual > 0 ? (totalPresupuesto / ahorroMensual) : 0;
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.green700),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('BENEFICIO ECONÓMICO Y RETORNO DE INVERSIÓN (ROI EN BOLIVIA)', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
          pw.SizedBox(height: 3),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Ahorro estimado mensual vs. Gasolina: Bs ${ahorroMensual.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8)),
              pw.Text('Ahorro estimado anual (15,000 km): Bs ${ahorroAnual.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'La recarga eléctrica domiciliaria en Bolivia permite un costo operativo hasta 5.8 veces menor que la gasolina. Su inversión en la instalación se amortiza en aproximadamente ${mesesRetorno > 0 ? mesesRetorno.toStringAsFixed(1) : '--'} meses de uso.',
            style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPiePaginaCorporativo() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'CONDICIONES COMERCIALES Y GARANTÍA TÉCNICA',
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 4,
                height: 4,
                margin: const pw.EdgeInsets.only(top: 3, right: 6),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blue900,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.Expanded(
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800),
                    children: [
                      pw.TextSpan(text: 'Términos de validez: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      const pw.TextSpan(text: 'Oferta formal válida por 15 días calendario a partir de su emisión.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 4,
                height: 4,
                margin: const pw.EdgeInsets.only(top: 3, right: 6),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blue900,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.Expanded(
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800),
                    children: [
                      pw.TextSpan(text: 'Garantía de instalación: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      const pw.TextSpan(text: 'Garantía de 1 año calendario sobre la mano de obra calificada y conexionado eléctrico.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 4,
                height: 4,
                margin: const pw.EdgeInsets.only(top: 3, right: 6),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blue900,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.Expanded(
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800),
                    children: [
                      pw.TextSpan(text: 'Nota de ingeniería: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      const pw.TextSpan(text: 'Montaje ejecutado bajo directrices técnicas de la Norma Boliviana NB 777 y estándar internacional IEC 61851-1.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> generarCertificado(
    CertificacionesChecklistData registro, {
    String esquemaTierra = 'TN-S',
    String distribuidora = 'ELFEC',
    String? nombreTecnico,
    String? registroSib,
    bool medicionTierraExterna = false,
  }) async {
    final pdf = pw.Document();

    // Formateador de fecha
    final fechaFormat = DateFormat('dd/MM/yyyy HH:mm');
    final fechaStr = fechaFormat.format(registro.fechaRegistro);

    // Formateo de datos del técnico responsable
    final String textoTecnico = (nombreTecnico != null && nombreTecnico.trim().isNotEmpty)
        ? 'Técnico Responsable: ${nombreTecnico.trim()}${(registroSib != null && registroSib.trim().isNotEmpty) ? ' • Matrícula/SIB: ${registroSib.trim()}' : ''}'
        : 'Técnico Responsable: Instalador Especialista en Electromovilidad${(registroSib != null && registroSib.trim().isNotEmpty) ? ' • Matrícula/SIB: ${registroSib.trim()}' : ''}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        build: (pw.Context context) {
          final bool isTierraPropia = !medicionTierraExterna && registro.resistenciaTierraOhms != null;
          final String valorTierra = registro.resistenciaTierraOhms != null
              ? (registro.resistenciaTierraOhms! == registro.resistenciaTierraOhms!.roundToDouble()
                  ? registro.resistenciaTierraOhms!.toInt().toString()
                  : registro.resistenciaTierraOhms!.toString())
              : '0';

          final String textoPAT;
          final bool checkPAT;

          if (medicionTierraExterna) {
            textoPAT = 'Resistencia de puesta a tierra: Delegada a especialista técnico (Pendiente de verificación con telurómetro)';
            checkPAT = true;
          } else if (isTierraPropia) {
            textoPAT = 'Resistencia de puesta a tierra: $valorTierra Ohms (Conforme NB 777 <= 25 Ohms)';
            checkPAT = true;
          } else {
            textoPAT = 'Resistencia de puesta a tierra: No registrada';
            checkPAT = false;
          }

          return [
            _buildHeader(fechaStr),
            pw.SizedBox(height: 14),
            _buildDatosCliente(
              registro,
              esquemaTierra: esquemaTierra,
              distribuidora: distribuidora,
              textoTecnico: textoTecnico,
            ),
            pw.SizedBox(height: 16),
            
            // TITULO DEL REPORTE
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                'ACTA DE PUESTA EN MARCHA Y CERTIFICACIÓN TÉCNICA (AETN 479/2021)',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 12),

            // 1. INSPECCION VISUAL Y MONTAJE
            _buildSeccionTitulo('1. Inspección Visual y Montaje Físico (AETN Nº 479/2021)'),
            _buildCheckItem('Fijación sólida y altura reglamentaria (0.60 m a 1.30 m s.n.p.t.)', registro.visFijacion),
            _buildCheckItem('Envolvente con grado de protección adecuado (Mínimo IP54 intemperie / IP44 interior)', registro.visDanos),
            _buildCheckItem('Canalización continua en ducto rígido/reforzado (sin cables en contacto con suelo)', registro.visCables),
            _buildCheckItem('Tablero exclusivo rotulado y disyuntor termomagnético Curva C', registro.visIdentificacion),
            _buildCheckItem('Protección contra sobretensiones transitorias (DPS / SPD Clase II conectado a PAT)', registro.visProteccion),
            pw.SizedBox(height: 10),

            // 2. PRUEBAS ELECTRICAS
            _buildSeccionTitulo('2. Pruebas Eléctricas y Seguridad de Personas (NB 777)'),
            _buildCheckItem('Interruptor Diferencial exclusivo Tipo A 30mA instalado (prohibido Tipo AC)', registro.visProteccion),
            _buildCheckItem('Tensión nominal medida en el punto: ${registro.tensionMedidaV != null ? '${registro.tensionMedidaV!.toStringAsFixed(1)} V' : 'N/A'} (180V - 460V)', registro.tensionMedidaV != null),
            _buildCheckItem(textoPAT, checkPAT),
            _buildCheckItem('Continuidad verificada en conductores activos y barra equipotencial de tierra', registro.elecContinuidad),
            pw.SizedBox(height: 10),

            // 3. PRUEBAS FINALES
            _buildSeccionTitulo('3. Pruebas Funcionales y Puesta en Marcha con EV'),
            _buildCheckItem('Encendido de Wallbox y comprobación de secuencia de control sin errores', registro.funEncendido),
            _buildCheckItem('Verificación de corriente real de carga mediante pinza amperimétrica', registro.funCorriente),
            _buildCheckItem('Control térmico operativo en bornes tras prueba de carga continua (<= 60°C)', registro.funTemperatura),
            _buildCheckItem('Mecanismo de parada de emergencia verificado y operativo (si aplica)', registro.funEmergencia),
            pw.SizedBox(height: 10),

            // 4. DOCUMENTACION
            _buildSeccionTitulo('4. Documentación y Protocolo de Entrega'),
            _buildCheckItem('Registro fotográfico de la estación de carga y tablero secundario', registro.docFoto),
            _buildCheckItem('Diagrama unifilar del circuito terminal dedicado', registro.docDiagrama),
            _buildCheckItem('Constancia o certificado de medición de resistencia de puesta a tierra (PAT)', registro.docCertificadoTierra),
            _buildCheckItem('Manual del fabricante y recomendaciones operativas entregadas al usuario', registro.docManual),
            
            pw.SizedBox(height: 16),
            
            // DECLARACION LEGAL Y GARANTIA (Sin bloque de firmas requerido)
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('DECLARACIÓN DE CUMPLIMIENTO TÉCNICO Y GARANTÍA', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Se certifica que la estación de recarga de vehículos eléctricos descrita en la presente acta ha sido instalada y probada cumpliendo los preceptos de seguridad técnica de la Norma Boliviana NB 777, la Resolución Regulatoria AETN Nº 479/2021 y el estándar internacional IEC 61851-1. Garantía de 1 año calendario sobre la mano de obra calificada.',
                    style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800),
                    textAlign: pw.TextAlign.justify,
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    // Compartir mediante el diálogo nativo (WhatsApp, Correo, Almacenamiento)
    final cleanClientName = registro.nombreCliente.replaceAll(RegExp(r'[^\w\-]'), '_');
    final cleanFecha = fechaStr.replaceAll('/', '-').replaceAll(':', '-').replaceAll(' ', '_');
    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Acta_Certificacion_${cleanClientName}_$cleanFecha.pdf',
    );
  }

  static pw.Widget _buildHeader(String fecha) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('WIRE FLOW VE', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Text('Ingeniería y Electromovilidad Bolivia', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.Text('Resolución Regulatoria AETN Nº 479/2021 — Norma NB 777', style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Fecha: $fecha', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('Bolivia', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildDatosCliente(
    CertificacionesChecklistData registro, {
    required String esquemaTierra,
    required String distribuidora,
    required String textoTecnico,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('DATOS DEL CLIENTE, SUMINISTRO Y TÉCNICO RESPONSABLE', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: registro.isCompletado ? PdfColors.green100 : PdfColors.orange100,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  border: pw.Border.all(color: registro.isCompletado ? PdfColors.green800 : PdfColors.orange800, width: 0.5),
                ),
                child: pw.Text(
                  registro.isCompletado ? 'CERTIFICADO CONFORME' : 'BORRADOR PENDIENTE',
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    fontWeight: pw.FontWeight.bold,
                    color: registro.isCompletado ? PdfColors.green900 : PdfColors.orange900,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            children: [
              pw.Expanded(child: pw.Text('Cliente: ${registro.nombreCliente}', style: const pw.TextStyle(fontSize: 8.5))),
              pw.Expanded(child: pw.Text('CI / NIT: ${registro.ciNitCliente.isEmpty ? 'N/A' : registro.ciNitCliente}', style: const pw.TextStyle(fontSize: 8.5))),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            children: [
              pw.Expanded(child: pw.Text('Ubicación: ${registro.direccionInstalacion}', style: const pw.TextStyle(fontSize: 8.5))),
              pw.Expanded(child: pw.Text('Distribuidora: $distribuidora', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold))),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            children: [
              pw.Expanded(child: pw.Text('Esquema de Tierra (PAT): $esquemaTierra (NB 777)', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold))),
              pw.Expanded(child: pw.Text(textoTecnico, style: const pw.TextStyle(fontSize: 8))),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSeccionTitulo(String titulo) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(titulo, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
    );
  }

  static pw.Widget _buildCheckItem(String texto, bool isChecked) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6, left: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 12,
            height: 12,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1),
              color: isChecked ? PdfColors.blue900 : PdfColors.white,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(texto, style: const pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

}