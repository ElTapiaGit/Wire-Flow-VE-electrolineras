import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; 
import '../../core/database/app_database.dart'; 

class PdfService {
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
            _buildCheckItem('Resistencia de puesta a tierra: ${registro.resistenciaTierraOhms ?? 'N/A'} Ω', registro.resistenciaTierraOhms != null),
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
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Certificado_${registro.nombreCliente.replaceAll(' ', '_')}.pdf',
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