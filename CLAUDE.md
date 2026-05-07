# Rugby Score - Contexto del Proyecto

## Que es esta app
App Flutter de resultados de rugby en vivo, desplegada como version web via Vercel.
El dueno del proyecto no es programador. Todas las explicaciones deben ser claras y sin jerga innecesaria.

## Stack tecnologico
- Frontend: Flutter (Dart), version web
- Backend: Desplegado en Vercel (tecnologia exacta a confirmar)
- Scraper: Python, carpeta urba_scraper/ (separado del frontend)
- Deploy: Vercel (web)

## Estado actual
- Trae resultados de rugby en vivo
- El backend existe pero su estado es incierto (puede tener fallas)
- El diseno esta en progreso, hay pantallas por terminar y mejorar
- A veces falla la carga de datos en vivo

## Estructura del proyecto
rugby_app/
├── lib/
│   ├── config/       <- Configuracion general
│   ├── data/         <- Fuentes de datos y APIs
│   ├── models/       <- Estructuras de datos
│   ├── pages/        <- Pantallas de la app
│   ├── services/     <- Logica de negocio
│   └── widgets/      <- Componentes visuales reutilizables
├── web/              <- Archivos para version web
└── urba_scraper/     <- Scraper Python (no mezclar con Flutter)

## Reglas que siempre aplican
- Las paginas nunca llaman APIs directamente, siempre via services/
- Los models solo tienen datos, sin logica
- Los widgets reciben datos, no los buscan
- Nunca escribir API keys o tokens directamente en el codigo
- Antes de un cambio grande, explicar en simple que se va a hacer y por que

## Skills disponibles
- rugby-app-guardian: arquitectura, seguridad y debugging
- brand-guidelines: colores, tipografia y estilo visual
- frontend-design: como crear pantallas bien disenadas
- skill-creator: para crear o mejorar skills

## Paleta de colores
- Verde primario: #1B5E20
- Verde acento: #4CAF50
- Negro fondo: #0A0A0A
- Negro tarjetas: #1A1A1A
- Blanco texto: #FFFFFF
- Gris secundario: #9E9E9E

## Prioridades actuales
1. Estabilizar el backend (a veces falla la carga de datos)
2. Terminar el diseno de pantallas pendientes
3. Mantener coherencia visual en toda la app