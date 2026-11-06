# AUDITORÍA TÉCNICA Y DE DISEÑO UI/UX — MÓDULO COMERCIAL (PRESUPUESTO Y COMPARATIVA)

**Fecha de Auditoría:** Noviembre 2026  
**Roles:** Diseñador de Producto UI/UX Senior & Arquitecto de Software Móvil Flutter  
**Proyecto:** WireFlow VE (Bolivia)  
**Módulos Auditados:**  
* `lib/features/commercial/presentation/commercial_screen.dart`
* `lib/core/constants/app_constants.dart`
* `lib/core/services/pdf_service.dart`
* `lib/core/database/app_database.dart` (Modelos `Cotizaciones`, `CotizacionItems`, `CatalogoMateriales`)

---

## 1. RESUMEN EJECUTIVO Y DIAGNÓSTICO DE ARQUITECTURA

El módulo comercial de **WireFlow VE** fue concebido como el puente entre el dimensionamiento técnico de ingeniería y el cierre de venta para el instalador de cargadores de vehículos eléctricos. Consta de dos vistas principales distribuidas en pestañas:
1. **Pestaña "Comparativa" (Retorno de Inversión / Ahorro):** Compara el costo operativo por kilómetro de un vehículo eléctrico frente a alternativas tradicionales (Gasolina y GNV) en el contexto boliviano.
2. **Pestaña "Presupuesto" (Cotizador de Obra):** Permite calcular los costos de materiales (cable, tablero de protecciones) y mano de obra para emitir un presupuesto económico.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        FLUJO ACTUAL DEL MÓDULO                         │
└────────────────────────────────────────────────────────────────────────┘

  [Dashboard / Home]
          │
          ▼ Navigator.pushNamed('/commercial')  (Sin parámetros)
  ┌──────────────────────────────────────────────────────────────────────┐
  │ CommercialScreen (StatefulWidget Monolítico - 730 líneas)           │
  │   ├── Estado local efímero (Sin Provider, sin Drift, sin SharedPreferences)
  │   ├── Tarifas hardcodeadas en memoria (se pierden al salir)         │
  │   └── Tableros y cables desacoplados de la Calculadora Técnica       │
  └───────────────────┬───────────────────────────────┬──────────────────┘
                      │                               │
        Pestaña 1     ▼                 Pestaña 2     ▼
  ┌───────────────────────────────┐   ┌──────────────────────────────────┐
  │        COMPARATIVA            │   │           PRESUPUESTO            │
  │ • Batería (kWh) & Potencia kW │   │ • Cable AWG (Dropdown)           │
  │ • Autonomía teórica (km)      │   │ • Distancia (m) y Precio/m (Bs)  │
  │ • Comparativa EV vs GNV vs Gas│   │ • Protecciones fijas (450 Bs)    │
  │ • Ahorro Anual (Fijo 15k km)  │   │ • Mano de obra fija (800 Bs)     │
  │ • Modal edición de tarifas    │   │ • Desglose y Total Estimado      │
  └───────────────────────────────┘   └────────────────┬─────────────────┘
                                                       │
                                  Botón "GENERAR PDF"  ▼
                                      ┌──────────────────────────────────┐
                                      │ SnackBar: "Próximamente"         │
                                      │ (PdfService NO lo implementa)    │
                                      └──────────────────────────────────┘
```

### Hallazgos Críticos de Arquitectura:
1. **Monolito de Presentación sin Capa de Dominio:** Toda la lógica de cálculo financiero y de presupuestación está incrustada directamente en los métodos de construcción de widgets (`_buildAhorroTab`, `_buildPresupuestoTab`). No existe un `CommercialCalculator` o `RoiEngine` en la capa de dominio.
2. **Tablas de Base de Datos Huerfanas:** `app_database.dart` ya cuenta con el diseño de tablas relacionales (`Cotizaciones`, `CotizacionItems` y `CatalogoMateriales`), pero `commercial_screen.dart` no consume ni persiste ningún registro en SQLite. Cada vez que el usuario cierra la pantalla, la cotización se desvanece.
3. **Desconexión Total con la Calculadora Técnica:** El instalador dimensiona un circuito en `CalculatorScreen` (obteniendo calibre, distancia y protecciones recomendadas), pero al abrir `CommercialScreen` debe volver a ingresar manualmente la distancia, buscar el calibre y adivinar el costo de las protecciones.
4. **Reporte PDF Comercial Inexistente:** El botón principal de llamada a la acción (*Call-to-Action*) `"GENERAR PDF PARA CLIENTE"` es un cascarón vacío que dispara un SnackBar informativo (`'Generación de cotización comercial en PDF (Próximamente).'`). `PdfService` únicamente tiene implementado el certificado de puesta en marcha.

---

## 2. MAPEO DETALLADO DE VARIABLES, FÓRMULAS MATEMÁTICAS Y TARIFAS

### 2.1. Parámetros Base y Constantes del Sistema (`AppConstants`)

| Parámetro | Valor por Defecto | Unidad | Justificación en el Mercado Boliviano |
|---|:---:|:---:|---|
| `tarifaElectricaKwh` | `0.80` | Bs / kWh | Tarifa domiciliaria de escalón intermedio promedio (DELAPAZ, CRE, ENDE DEORURO). |
| `tarifaGasolinaLitro` | `6.96` | Bs / Litro | Precio comercial de Gasolina Premium / Especial sin subvención plena. |
| `tarifaGnvM3` | `2.73` | Bs / m³ | Tarifa regulada para Gas Natural Vehicular (GNV). |
| `consumoEvKwhPorKm` | `0.15` | kWh / km | Rendimiento estándar de vehículos eléctricos urbanos ($15\,\text{kWh}/100\,\text{km}$, ej. BYD Dolphin, Renault Kwid E-Tech). |
| `consumoGasolinaKmPorL` | `10.0` | km / Litro | Rendimiento promedio urbano de vehículos compactos a gasolina ($10\,\text{L}/100\,\text{km}$). |
| `consumoGnvKmPorM3` | `12.0` | km / m³ | Rendimiento promedio vehicular a gas natural ($8.33\,\text{m}^3/100\,\text{km}$). |
| `precioBaseProtecciones` | `450.00` | Bs | Monto global asignado a disyuntor, diferencial y tablero. |
| `precioBaseManoObra` | `800.00` | Bs | Costo base referencial de instalación estándar domiciliaria. |

#### Precios de Cable de Cobre Sugeridos por Metro:
* 16 AWG: `4.50` Bs/m | 14 AWG: `6.80` Bs/m | 12 AWG: `10.50` Bs/m
* 10 AWG: `15.68` Bs/m | 8 AWG: `25.46` Bs/m | 6 AWG: `42.88` Bs/m
* 4 AWG: `55.00` Bs/m | 2 AWG: `88.50` Bs/m | 1 AWG: `115.00` Bs/m | 1/0 AWG: `145.00` Bs/m

---

### 2.2. Fórmulas de la Pestaña "Comparativa" (Análisis Energético)

1. **Tiempo de Recarga Completa (0 - 100%):**
   $$T_{\text{carga}} = \frac{\text{Batería (kWh)}}{P_{\text{cargador}} (\text{kW})}$$
   *Ejemplo: Para batería de $60\,\text{kWh}$ y cargador de $7.4\,\text{kW} \implies T = 60 / 7.4 \approx 8.1\,\text{horas}$.*

2. **Autonomía Estimada con Tanque Lleno:**
   $$D_{\text{autonomía}} = \frac{\text{Batería (kWh)}}{\text{Consumo}_{\text{EV}} (\text{kWh/km})} = \frac{60}{0.15} = 400\,\text{km}$$

3. **Costo de Recarga Eléctrica Completa:**
   $$C_{\text{EV}} = \text{Batería (kWh)} \times \text{Tarifa}_{\text{elec}} = 60 \times 0.80 = 48.00\,\text{Bs}$$
   *Costo unitario por km: $48.00 / 400 = 0.12\,\text{Bs/km}$.*

4. **Costo Equivalente en Gasolina:**
   $$L_{\text{gas}} = \frac{D_{\text{autonomía}}}{\text{Rend}_{\text{gas}}} = \frac{400}{10.0} = 40\,\text{litros}$$
   $$C_{\text{Gasolina}} = L_{\text{gas}} \times \text{Tarifa}_{\text{gas}} = 40 \times 6.96 = 278.40\,\text{Bs}$$
   *Costo unitario por km: $278.40 / 400 = 0.696\,\text{Bs/km}$ ($5.8\times$ más caro que el EV).*

5. **Costo Equivalente en GNV:**
   $$V_{\text{GNV}} = \frac{D_{\text{autonomía}}}{\text{Rend}_{\text{GNV}}} = \frac{400}{12.0} = 33.33\,\text{m}^3$$
   $$C_{\text{GNV}} = V_{\text{GNV}} \times \text{Tarifa}_{\text{GNV}} = 33.33 \times 2.73 = 91.00\,\text{Bs}$$
   *Costo unitario por km: $91.00 / 400 = 0.228\,\text{Bs/km}$ ($1.9\times$ más caro que el EV).*

6. **Proyección de Ahorro Anual (Kilometraje fijo a 15,000 km):**
   $$\text{Gasto Gasolina Anual} = \left(\frac{15000}{10.0}\right) \times 6.96 = 10,440.00\,\text{Bs}$$
   $$\text{Gasto Eléctrico Anual} = 15000 \times 0.15 \times 0.80 = 1,800.00\,\text{Bs}$$
   $$\text{Ahorro Anual Frente a Gasolina} = 10,440.00 - 1,800.00 = 8,640.00\,\text{Bs/año}$$

---

### 2.3. Fórmulas de la Pestaña "Presupuesto" (Cotizador de Instalación)

1. **Costo Total del Conductor:**
   $$\text{Costo Cable} = \text{Distancia (m)} \times \text{Precio por Metro (Bs/m)}$$
2. **Subtotal de Materiales:**
   $$\text{Subtotal Materiales} = \text{Costo Cable} + \text{Costo Protecciones}$$
3. **Gran Total Estimado:**
   $$\text{Gran Total} = \text{Subtotal Materiales} + \text{Mano de Obra}$$

---

## 3. CATÁLOGO DE PROBLEMAS DE USABILIDAD (UX) Y PUNTOS CIEGOS TÉCNICOS

### 3.1. Deficiencias Críticas de Usabilidad y Ergonomía Móvil

| ID | Pantalla / Componente | Descripción del Fallo de Experiencia (UX) | Impacto en el Usuario | Severidad |
|---|---|---|---|:---:|
| **UX-01** | Presupuesto (`_buildInputEditable`) | **Falta de sanitización de comas en parseo numérico:** Si el teclado del smartphone escribe `"15,5"` en lugar de `"15.5"`, `double.tryParse` falla silenciosamente retornando `0.0`. | El subtotal se va a cero sin advertencia, desconcertando al instalador. | **Alta** |
| **UX-02** | Pantalla global (`commercial_screen.dart`) | **Falta de `GestureDetector` con `unfocus()`:** Al pulsar fuera de los campos de texto, el teclado virtual permanece abierto tapando el botón de acción y las tarjetas de resumen. | Dificultad para revisar el Gran Total sin cerrar manualmente el teclado. | **Media** |
| **UX-03** | Comparativa (`_batteryController`) | **Campos de edición diminutos sin validación de límites:** Se permite escribir `"0"` o valores negativos, provocando divisiones por cero (`Infinity`) en tiempo de recarga y autonomía. | La interfaz renderiza números corruptos o barras de progreso en blanco. | **Media** |
| **UX-04** | Pestañas de Navegación | **Uso de un contenedor simulado en lugar de `TabBar` nativo:** No soporta deslizamiento lateral (*swipe gesture*) entre Comparativa y Presupuesto, limitando la fluidez táctil. | Pérdida de familiaridad con los estándares de Android Material 3. | **Baja** |

---

### 3.2. Puntos Ciegos Técnicos y Comerciales de Ingeniería

#### Punto Ciego 1: Desglose "Tablero y Protecciones" como Monto Global Fijo (450 Bs)
* **Realidad de Campo:** Un cargador de VE de $7.4\,\text{kW}$ o $11\,\text{kW}$ exige obligatoriamente por normativa internacional (IEC 61851-1 / NEC 625) los siguientes componentes:
  1. *Gabinete estanco o tablero IP65* con riel DIN (~120 a 180 Bs).
  2. *Interruptor Termomagnético bipolar o tetrapolar Curva C* (~65 a 120 Bs).
  3. *Interruptor Diferencial Superinmunizado o Tipo A de 30 mA* (~280 a 450 Bs).
  4. *Protector de Sobretensión Transitoria (SPD Clase II)* (~180 a 280 Bs).
  5. *Relé de protección de tensión OVP/UVP* (~150 a 220 Bs).
  6. *Puesta a tierra complementaria (Jabalina + conector)* (~120 Bs).
* **Vulnerabilidad Comercial:** El costo real de una protección completa certificada oscila entre **900 Bs y 1,350 Bs**. Asumir un monto global fijo de 450 Bs genera **subcotización grave**, provocando pérdidas al instalador o induciéndolo a omitir el diferencial Tipo A o el SPD para no salirse del presupuesto.

#### Punto Ciego 2: Desconexión Absoluta con la Calculadora Técnica
* En `CalculatorScreen`, el motor ya determinó:
  * Número de polos (2 para Monofásica/Delta, 4 para Trifásica).
  * Calibre comercial necesario (ej. 6 mm² / 10 AWG o 10 mm² / 8 AWG).
  * Distancia del circuito en metros.
* En `CommercialScreen`, el usuario inicia siempre con valores fijos (15 metros, AWG 8), obligándolo a recordar y tipear de nuevo. Esto rompe el principio de diseño de *"Reconocimiento antes que Recuerdo"* (Heurística de Nielsen).

#### Punto Ciego 3: Supuesto Inflexible de 15,000 km sin Cálculo de Retorno de Inversión (ROI / Payback)
* El ahorro anual está anclado en 15,000 km. Un conductor de taxi o servicio de transporte privado (Uber/Indrive) en Bolivia recorre más de $35,000\,\text{km/año}$, mientras que un usuario particular de oficina recorre apenas $8,000\,\text{km/año}$.
* **Oportunidad de Venta Perdida:** El cotizador no calcula el tiempo de amortización:
  $$\text{Tiempo de Retorno (Meses)} = \left(\frac{\text{Gran Total de la Instalación}}{\text{Ahorro Mensual del Cliente}}\right)$$
  Mostrar: *"Tu inversión de Bs 2,850 se paga sola en apenas 4.2 meses de ahorro de gasolina"* es el argumento de cierre más poderoso para el comprador de un auto eléctrico.

#### Punto Ciego 4: Botón de PDF Huérfano
* El técnico no tiene forma de compartir formalmente la cotización por WhatsApp o correo al cliente final. La promesa de valor del módulo comercial queda truncada al nivel de un borrador de pantalla.

---

## 4. PROPUESTA DE MEJORAS: PESTAÑA "PRESUPUESTO"

### 4.1. Precarga Inteligente desde la Calculadora Técnica
Implementar transferencia de estado o precarga mediante un DTO `PresupuestoInitialData`:
* Si el técnico calculó en la pantalla técnica $28\,\text{m}$ con cable `AWG 6` en red monofásica, la pestaña de presupuesto debe inicializarse automáticamente con:
  * Distancia: `28 m`.
  * Calibre: `AWG 6`.
  * Precio/m: `42.88 Bs/m`.
  * Disyuntor preconfigurado a `2xC40A`.

### 4.2. Desglose Modular de Protecciones y Materiales
Sustituir el campo único de 450 Bs por un selector expandible con switch o checklist de materiales típicos:

```
┌─────────────────────────────────────────────────────────────┐
│ TABLERO Y PROTECCIONES (Desglose Profesional)               │
├─────────────────────────────────────────────────────────────┤
│ [x] Gabinete IP65 8-12 Módulos                   Bs 150.00  │
│ [x] Disyuntor Termomagnético 2xC40A (Curva C)    Bs  85.00  │
│ [x] Diferencial 40A 30mA Tipo A (Normativo)      Bs 320.00  │
│ [x] Protector de Sobretensión SPD Clase II       Bs 220.00  │
│ [x] Relé de Tensión OVP/UVP 40A                  Bs 180.00  │
│ [ ] Kit Jabalina y Conexión Puesta a Tierra      Bs 120.00  │
├─────────────────────────────────────────────────────────────┤
│ Total Protecciones y Gabinete:                   Bs 955.00  │
└─────────────────────────────────────────────────────────────┘
```

### 4.3. Parámetro de Canalización y Obras Civiles
Añadir una partida opcional de canalización (tubería EMT / PVC Conduit de 1" o 3/4", abrazaderas y curvas):
* Costo referencial: `18.00 Bs/metro`.
* Multiplicado automáticamente por la distancia ingresada.

### 4.4. Persistencia en Base de Datos Local Drift
Conectar la pantalla con el método `upsertCotizacion` y `CotizacionItems` en `app_database.dart`, permitiendo:
* Guardar borradores asociados al cliente.
* Reabrir cotizaciones anteriores desde el historial del Dashboard.

---

## 5. PROPUESTA DE MEJORAS: PESTAÑA "COMPARATIVA" Y REPORTE PDF

### 5.1. Slider Dinámico de Kilometraje y Cálculo de Payback (ROI)
Incorporar un selector o campo dinámico para el kilometraje mensual/anual con perfiles predefinidos:
* **Uso Particular:** $10,000\,\text{km/año}$
* **Uso Mixto:** $18,000\,\text{km/año}$
* **Uso Intensivo / Flota:** $35,000\,\text{km/año}$

#### Indicador Visual de Amortización:
```
┌─────────────────────────────────────────────────────────────┐
│ RETORNO DE INVERSIÓN ESTIMADO (ROI)                        │
├─────────────────────────────────────────────────────────────┤
│ Costo de la Instalación:                 Bs 3,250.00        │
│ Ahorro Mensual vs Gasolina:              Bs   720.00        │
│                                                             │
│  [===================>         ] 4.5 MESES PARA RECUPERAR   │
│                                                             │
│ "En menos de 5 meses la instalación se amortiza por         │
│  completo gracias a la diferencia de combustible."          │
└─────────────────────────────────────────────────────────────┘
```

### 5.2. Persistencia de Tarifas Editadas
Almacenar las tarifas personalizadas en `SharedPreferences` para que el instalador de La Paz o Santa Cruz no tenga que reconfigurar la tarifa cada vez que abre la aplicación.

---

### 5.3. Especificación Formal del Reporte Comercial en PDF

El servicio [`lib/core/services/pdf_service.dart`](file:///c:/Users/Jhon/Desktop/proyectos/Flutter-projects/wireflow_ve/lib/core/services/pdf_service.dart) debe incorporar el método:
```dart
static Future<void> generarPresupuestoComercial({
  required CotizacionData cotizacion,
  required List<CotizacionItemData> items,
  required double ahorroAnualGasolina,
  required double tiempoRetornoMeses,
}) async
```

#### Estructura del Documento PDF Comercial:
1. **Encabezado Corporativo:**
   * Logo y nombre de la empresa instaladora (*WireFlow VE — Ingeniería y Electromovilidad*).
   * Número correlativo de cotización (`COT-2026-XXXX`).
   * Fecha de emisión y fecha de validez (ej. *Oferta válida por 15 días calendario*).
2. **Información del Cliente y Lugar de Instalación:**
   * Nombre del cliente, CI/NIT, teléfono y dirección del inmueble.
3. **Tabla de Desglose de Materiales:**
   * Ítems, descripción técnica (calibre AWG, metraje, modelo de disyuntor, diferencial Tipo A, gabinete).
   * Cantidades, precios unitarios (Bs) y subtotales.
4. **Tabla de Servicios Profesionales:**
   * Mano de obra certificada, tendido, conexionado, pruebas operativas y puesta en marcha.
5. **Resumen Financiero:**
   * Subtotal Materiales, Subtotal Mano de Obra y **Total Presupuestado (Bs)**.
6. **Sección Comercial de Retorno de Inversión (ROI):**
   * Gráfico comparativo de costos operativos (EV vs Gasolina vs GNV).
   * Ahorro mensual y anual proyectado.
   * Mensaje de amortización de la inversión.
7. **Términos de Garantía y Firmas:**
   * Garantía de instalación (ej. 1 año sobre mano de obra, garantía de fábrica sobre equipos).
   * Espacio para firma de aceptación del cliente y firma del técnico responsable.

---

## 6. CONCLUSIÓN Y HOJA DE RUTA RECOMENDADA

El módulo comercial de WireFlow VE posee una base matemática sólida y un diseño visual atractivo, pero actualmente sufre de **aislamiento de datos**, **omisión del reporte PDF** y **subdimensionamiento en los costos de tableros de protección**.

### Prioridades de Implementación Sugeridas:
1. **Fase 1 (Inmediata):** Sanitizar parseos de texto (`.replaceAll(',', '.')`), agregar `unfocus()` en pantalla y conectar la navegación para recibir datos calculados desde `CalculatorScreen`.
2. **Fase 2 (Presupuesto & Base de Datos):** Desglosar las protecciones en componentes individuales (gabinete, térmico, diferencial Tipo A, SPD) y conectar con las tablas `Cotizaciones` y `CotizacionItems` en SQLite/Drift.
3. **Fase 3 (Generación de PDF Comercial):** Implementar `generarPresupuestoComercial` en `PdfService` con vista previa e impresión directa en Android.
4. **Fase 4 (ROI Dinámico):** Incorporar selector de kilometraje anual con cálculo automático de meses de retorno de inversión.

