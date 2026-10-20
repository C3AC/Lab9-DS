# Resultados de los insumos

## Fuente y procedimiento

Resultados calculados localmente con `Base_Migracion_2009-2026jun.xlsx`, `scripts/preparar_series.R` y `scripts/calcular_insumos.R`. La base contiene 161,036 filas, sin duplicados exactos ni valores faltantes en las columnas requeridas. Hay 51,272 valores fraccionarios en `Viajero`: se conservaron sin redondear. Su significado debe confirmarse con el proveedor de la base; los valores siguientes describen la suma de esa variable, no personas individuales verificadas.

Se reprodujo expresamente la imputacion de meses internos ausentes a cero del Lab 1 con `--completar-ceros`. Se imputaron 5 meses de El Salvador, 5 de Estados Unidos y 27 de Via Maritima. Los dos primeros segmentos carecen de registros de abril a agosto de 2020. Via Maritima tambien tiene huecos fuera de la pandemia. La lista completa queda en `salidas/meses_imputados.csv`, fuera de Git. Las demas series no tienen huecos internos.

Guatemala cubre enero de 2009 a diciembre de 2022 (168 meses); su entrenamiento termina en septiembre de 2018. Las otras seis series cubren enero de 2009 a junio de 2026 (210 meses), con entrenamiento hasta marzo de 2021. No se extiende Guatemala hasta 2026 con ceros.

## KPIs calculados

Los totales se muestran redondeados a dos decimales para documentar las fracciones del archivo; los calculos conservan toda la precision. En la infografia se podran expresar en millones, aclarando la unidad y la fuente academica.

| Indicador general | Resultado |
| --- | --- |
| Total 2019 | 4,691,820.20 |
| Total 2020 | 1,266,340.14 |
| Variacion 2019 a 2020 | -73.0096% |
| Total 2022 | 4,316,164.40 |
| Nivel de 2022 respecto a 2019 | 91.9934% |

El primer semestre de 2026 suma aproximadamente 1.683 millones, frente a 1.740 millones en el mismo semestre de 2025 y 2.252 millones en el de 2019. No es un total anual ni un pronostico. El MAE de Prophet sigue siendo un valor publicado, no reproducido en este paso: aun no se entrenaron modelos.

## Crecimiento comparable

Medida adicional al laboratorio original: CAGR = `(total_2019 / total_2009)^(1/10) - 1`. Compara anos completos y un periodo comun prepandemia; no mide recuperacion posterior ni demuestra crecimiento monotono mes a mes.

| Serie | CAGR 2009-2019 | Crecimiento acumulado |
| --- | --- | --- |
| El Salvador | 12.0810% | 212.8389% |
| Via Terrestre | 11.9013% | 207.8591% |
| Guatemala | 10.3594% | 167.9743% |
| General | 8.7454% | 131.2636% |
| Via Aerea | 4.7193% | 58.5866% |
| Estados Unidos | 4.6758% | 57.9287% |
| Via Maritima | 3.3907% | 39.5768% |

El Salvador tiene el mayor crecimiento porcentual con esta definicion. Paises y vias son cortes superpuestos del mismo total, no categorias que puedan sumarse entre si.

## Calendario estacional

Se usa la descomposicion aditiva `decompose()` del Lab 1. Los meses corresponden al maximo y minimo del componente estacional, no necesariamente al record observado de toda la serie. Coinciden en ambas ventanas calculadas: entrenamiento original y periodo comun 2009-2019.

| Serie | Mes pico | Mes valle |
| --- | --- | --- |
| General | Diciembre | Septiembre |
| El Salvador | Diciembre | Septiembre |
| Guatemala | Diciembre | Febrero |
| Estados Unidos | Julio | Septiembre |
| Via Aerea | Diciembre | Septiembre |
| Via Terrestre | Diciembre | Septiembre |
| Via Maritima | Diciembre | Junio |

Julio y diciembre permiten anotar vacaciones, bono 14 y aguinaldo como contexto, sin afirmar causalidad ni asumir que el calendario laboral guatemalteco explica por si solo los viajes de residentes de otros paises. Semana Santa es movil y requiere analizar sus fechas concretas.

## Reproduccion y ventanas

Las fuerzas estacional y de tendencia, los CV y las caidas disponibles del entrenamiento original coinciden con el PDF al redondear a tres decimales y un decimal, respectivamente. Guatemala conserva N/D en la caida original porque su entrenamiento termina antes de 2019. No se actualiza silenciosamente esa celda usando prueba.

El ranking depende de la ventana. En el entrenamiento original, Guatemala es la mas estacional (0.793). En el periodo comun prepandemia 2009-2019, Estados Unidos tiene la mayor fuerza estacional (0.918), seguido de Via Aerea (0.879). Via Maritima tiene el mayor CV en ambas ventanas (0.868 y 0.790, respectivamente). El Salvador tiene la mayor caida publicada entre las seis series con 2019 y 2020 completos en entrenamiento (-74.9%). Las caidas de segmentos con meses imputados dependen de esa decision.

Para el cuadrante se debe indicar expresamente si se muestran indicadores originales o indicadores de ventana comun. La respuesta a crecimiento usa CAGR, no fuerza de tendencia. Los resultados de entrenamiento no prueban recuperacion pospandemia ni precision futura. El cambio de clasificacion de viajeros advertido en el PDF sigue siendo una limitacion al interpretar el total despues de 2022.

Los artefactos detallados, la huella MD5 de la entrada y las sesiones de R se conservan en `salidas/`, excluida de Git. No se generaron graficos, pronosticos ni diseno de infografia en este paso. Uso estrictamente academico; no publicar la base ni los resultados abiertamente sin consulta previa.
