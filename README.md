# Laboratorio 9: Visualización Estática (Grupo 6)

CC3084 – Data Science · Universidad del Valle de Guatemala · Semestre II 2026

Repositorio de la entrega de **avance** (jueves 15 de octubre de 2026): documento de explicación de las decisiones de diseño de la infografía sobre el flujo migratorio y el turismo en Guatemala (2009–2026).

## Contenido

- `docs/documento_explicacion.md`: texto del documento de explicación.
- `docs/documento_explicacion.pdf`: versión PDF para entregar (agréguenla aquí al exportarla).
- `docs/enlaces.md`: enlaces del documento de trabajo y del repositorio.
- `docs/validacion_evidencia.md`: cotejo de resultados y limitaciones del análisis original.
- `scripts/preparar_series.R`: preparación reproducible de las siete series mensuales.
- `tests/test_preparar_series.R`: pruebas con datos sintéticos, sin información restringida.

## Preparación reproducible

Ejecutar desde la raíz del repositorio con R. Instalar una vez las dependencias:

```r
install.packages(c("readxl", "janitor"))
```

Colocar el Excel académico en una ubicación local no pública. La ruta se pasa como argumento, sin modificar el Laboratorio 1:

```bash
Rscript scripts/preparar_series.R "/ruta/local/Base_Migracion_2009-2026jun.xlsx"
```

El directorio de salida predeterminado es `salidas/`, excluido de Git. Se puede indicar otro como segundo argumento, pero debe mantenerse fuera del historial y de ubicaciones públicas. Contiene:

- `series_preparadas.rds`: series completas, tablas mensuales, objetos `ts` de entrenamiento y prueba, cobertura, huecos y procedencia (archivo, MD5, filas y opciones).
- `cobertura.csv`: fechas y tamaños de cada serie y su división cronológica 70/30.
- `meses_imputados.csv`: meses completados con cero, si se autorizaron explícitamente.
- `sesion_R.txt`: versiones de R y paquetes para documentar la ejecución.

El script suma la cantidad `viajero`, no el número de filas. Exige columnas válidas, categorías presentes, conteos no negativos, ausencia de duplicados exactos y al menos 24 meses de entrenamiento por serie. Los nombres de columnas del Excel se normalizan con `janitor::clean_names()`, igual que en el laboratorio original.

Los meses internos sin registros detienen la ejecución. Solo después de revisar la fuente, se puede reproducir la imputación a cero del laboratorio original mediante:

```bash
Rscript scripts/preparar_series.R "/ruta/local/Base_Migracion_2009-2026jun.xlsx" salidas --completar-ceros
```

Esta opción registra qué meses fueron imputados; no extiende las series antes de su primer registro ni después del último. Las ventanas de cada segmento se conservan por separado, como en el original. No se consideran equivalentes ni se igualan artificialmente.

Verificación sin el Excel ni paquetes externos:

```bash
Rscript tests/test_preparar_series.R
Rscript scripts/preparar_series.R --help
```

Este paso prepara los datos para los cálculos y gráficos posteriores; todavía no calcula KPIs, entrena modelos ni diseña la infografía. Las pruebas sintéticas no demuestran que las cifras del Excel coincidan con las del PDF.

## Notas

- Los datos se comparten con fines estrictamente académicos: no subirlos a este repositorio ni publicarlo abiertamente.
- Agreguen al profesor y a los auxiliares como colaboradores.
- Cada integrante hace sus commits con su propio usuario, para que el historial muestre los aportes.
