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
            pw.SizedBox(height: 16),

            // Términos y Firmas
            _buildTerminosYFirmas(),
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

  static pw.Widget _buildTerminosYFirmas() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Términos Comerciales: Oferta válida por 15 días calendario a partir de su emisión. Garantía de 1 año sobre la instalación eléctrica y mano de obra. Todo el montaje cumple las directrices técnicas de la Norma Boliviana NB 777 e IEC 61851-1.',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
          textAlign: pw.TextAlign.justify,
        ),
        pw.SizedBox(height: 28),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Column(
              children: [
                pw.Container(width: 150, height: 0.8, color: PdfColors.black),
                pw.SizedBox(height: 3),
                pw.Text('Firma del Técnico Instalador', style: const pw.TextStyle(fontSize: 8)),
                pw.Text('WireFlow VE — Certificación', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
              ],
            ),
            pw.Column(
              children: [
                pw.Container(width: 150, height: 0.8, color: PdfColors.black),
                pw.SizedBox(height: 3),
                pw.Text('Aceptación y Conformidad (Cliente)', style: const pw.TextStyle(fontSize: 8)),
                pw.Text('Aprobación de Presupuesto', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Future<void> generarCertificado(CertificacionesChecklistData registro) async {
    final pdf = pw.Document();

    // Formateador de fecha
    final fechaFormat = DateFormat('dd/MM/yyyy HH:mm');
    final fechaStr = fechaFormat.format(registro.fechaRegistro);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            _buildHeader(fechaStr),
            pw.SizedBox(height: 20),
            _buildDatosCliente(registro),
            pw.SizedBox(height: 24),
            
            // TITULO DEL REPORTE
            pw.Text('ACTA DE PUESTA EN MARCHA Y CERTIFICACIÓN', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Divider(thickness: 2, color: PdfColors.blue900),
            pw.SizedBox(height: 16),

            // 1. INSPECCION VISUAL
            _buildSeccionTitulo('1. Inspección Visual'),
            _buildCheckItem('Fijación firme del Wallbox y accesorios', registro.visFijacion),
            _buildCheckItem('Ruta de cables continua y organizada', registro.visCables),
            _buildCheckItem('Protección mecánica (ductos, bandejas)', registro.visProteccion),
            _buildCheckItem('Identificación de tableros y disyuntores', registro.visIdentificacion),
            _buildCheckItem('Ausencia de daños físicos en el equipo', registro.visDanos),
            pw.SizedBox(height: 16),

            // 2. PRUEBAS ELECTRICAS
            _buildSeccionTitulo('2. Pruebas Eléctricas'),
            _buildCheckItem('Tensión medida en el punto: ${registro.tensionMedidaV ?? 'N/A'} V', registro.tensionMedidaV != null),
            _buildCheckItem('Resistencia de puesta a tierra: ${registro.resistenciaTierraOhms != null ? '${registro.resistenciaTierraOhms} Ohms' : 'N/A'}', registro.resistenciaTierraOhms != null),
            _buildCheckItem('Continuidad verificada (Fase, Neutro, Tierra)', registro.elecContinuidad),
            pw.SizedBox(height: 16),

            // 3. PRUEBAS FINALES
            _buildSeccionTitulo('3. Pruebas Finales y Operación'),
            _buildCheckItem('Encendido del Wallbox sin errores', registro.funEncendido),
            _buildCheckItem('Verificación de corriente real de carga', registro.funCorriente),
            _buildCheckItem('Temperatura operativa en parámetros normales', registro.funTemperatura),
            _buildCheckItem('Prueba de parada de emergencia (si aplica)', registro.funEmergencia),
            pw.SizedBox(height: 16),

            // 4. DOCUMENTACION
            _buildSeccionTitulo('4. Documentación Entregada'),
            _buildCheckItem('Registro fotográfico de la instalación', registro.docFoto),
            _buildCheckItem('Diagrama unifilar del circuito', registro.docDiagrama),
            _buildCheckItem('Certificado de medición de PAT', registro.docCertificadoTierra),
            _buildCheckItem('Manuales del equipo entregados al usuario', registro.docManual),
            
            pw.SizedBox(height: 40),
            
            // DECLARACION Y FIRMAS
            pw.Text(
              'Por medio de la presente acta, se certifica que la estación de carga para vehículo eléctrico ha sido instalada y probada cumpliendo con los estándares técnicos vigentes. El cliente declara conformidad con el trabajo realizado y recibe las instrucciones de uso operativo.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 60),
            _buildFirmas(),
          ];
        },
      ),
    );

    // Lanzar la vista previa 
    final cleanClientName = registro.nombreCliente.replaceAll(RegExp(r'[^\w\-]'), '_');
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Certificado_$cleanClientName.pdf',
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
            pw.Text('WIIRE FLOW VE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Text('Ingeniería y Electromovilidad', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Fecha: $fecha', style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Bolivia', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildDatosCliente(CertificacionesChecklistData registro) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('DATOS DEL CLIENTE E INSTALACIÓN', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(child: pw.Text('Cliente: ${registro.nombreCliente}', style: const pw.TextStyle(fontSize: 11))),
              pw.Expanded(child: pw.Text('CI / NIT: ${registro.ciNitCliente.isEmpty ? 'N/A' : registro.ciNitCliente}', style: const pw.TextStyle(fontSize: 11))),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text('Ubicación: ${registro.direccionInstalacion}', style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 4),
          pw.Text('Estado: ${registro.isCompletado ? 'Certificado Exitoso' : 'Registro Pendiente'}', 
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: registro.isCompletado ? PdfColors.green700 : PdfColors.orange700)),
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

  static pw.Widget _buildFirmas() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Column(
          children: [
            pw.Container(width: 150, height: 1, color: PdfColors.black),
            pw.SizedBox(height: 4),
            pw.Text('Firma del Técnico Instalador', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          children: [
            pw.Container(width: 150, height: 1, color: PdfColors.black),
            pw.SizedBox(height: 4),
            pw.Text('Firma de Conformidad (Cliente)', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }
}