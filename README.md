# ⚡ Wiire Flow VE - Herramienta Técnica para Electrolineras

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)

**Wiire Flow VE** es una aplicación móvil diseñada específicamente para ingenieros y técnicos instaladores de estaciones de carga para vehículos eléctricos (VE). Permite dimensionar conductores, calcular protecciones en cascada, realizar cotizaciones y generar actas de certificación en PDF, todo funcionando de manera 100% local (Offline-first).

---

## 🚀 Características Principales

### 🧮 1. Motor de Cálculo Técnico
* **Dimensionamiento de Conductores:** Calcula la sección óptima del cableado considerando una sobrecarga continua del 125% para VE.
* **Doble Normativa:** Soporte integrado para la Norma Boliviana **NB 777** y estándares internacionales **(IEC/NEC)**.
* **Caída de Tensión:** Cálculo automatizado de la pérdida de voltaje según la distancia del tablero principal al cargador.
* **Protecciones en Cascada:** Sugerencia del orden y calibre correcto para tableros eléctricos (SPD, MCB, RCD Tipo A/B, OVP/UVP).

### 📋 2. Puesta en Marcha y Certificación (Checklist)
* Protocolo estructurado de inspección visual, pruebas eléctricas (continuidad y resistencia de puesta a tierra) y pruebas funcionales.
* **Generación de PDF:** Creación nativa de Actas de Entrega y Certificación listas para ser firmadas por el técnico y el cliente, con opción de compartir por WhatsApp o correo.

### 💼 3. Módulo Comercial (Cotizador)
* Estimación de costos basada en precios unitarios.
* Cálculo automático de margen de ganancias y Retorno de Inversión (ROI) para el cliente final.

### 🔒 4. Privacidad y Almacenamiento Local
* Toda la información de clientes, instalaciones y catálogos de precios se guarda estrictamente en la memoria del dispositivo (SQLite). No requiere conexión a internet ni expone datos sensibles en la nube.

---

## 🛠️ Stack Tecnológico y Arquitectura

* **Framework:** Flutter (Material 3 Design).
* **Gestión de Estado:** `provider` para inyección de dependencias y reactividad.
* **Base de Datos Local:** `drift` (ORM reactivo sobre SQLite).
* **Generación de Documentos:** `pdf` y `printing` para la creación y previsualización de reportes A4.
* **UI/UX:** Soporte dinámico para Modo Claro (Alto contraste para trabajo en exteriores bajo el sol) y Modo Oscuro.

---

## 📸 Capturas de Pantalla

| Dashboard Principal | Calculadora Técnica | Checklist de Certificación | Acta PDF Generada |
| :---: | :---: | :---: | :---: |
| <img src="assets/images/screenshot1.png" width="200"/> | <img src="assets/images/screenshot2.jpg" width="200"/> | <img src="assets/images/screenshot3.jpg" width="200"/> | <img src="assets/images/screenshot4.jpg" width="200"/> |

---

## ⚙️ Instalación y Compilación

Para clonar y correr este proyecto localmente, necesitas tener instalado [Flutter SDK](https://docs.flutter.dev/get-started/install).

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/ElTapiaGit/wireflow_ve.git](https://github.com/ElTapiaGit/Wire-Flow-VE-electrolineras.git)
