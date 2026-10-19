# Validacion de evidencia del Laboratorio 1

## Alcance y estado

Se contrastaron las instrucciones del Laboratorio 9, `docs/documento_explicacion.md`, `Laboratorio_1_completo.Rmd` y las 26 paginas de `Laboratorio_1_Series_de_Tiempo_Grupo6-1.pdf`.

Esta es una validacion documental y del procedimiento, no una reproduccion numerica. El archivo `Base_Migracion_2009-2026jun.xlsx` no esta disponible en el repositorio. No se reconstruiran series ni intervalos leyendo posiciones de pixeles de los graficos. El Laboratorio 1 original se conserva sin modificaciones.

## Cifras cotejadas

| Insumo | Fuente en el PDF | Resultado del cotejo | Pendiente |
| --- | --- | --- | --- |
| Cobertura ene-2009 a jun-2026 y 161,036 registros | pp. 2 y 6 | Coincide con la explicacion; son registros agregados, no viajeros individuales | Confirmar cobertura por serie en el Excel |
| Caida general de 73.0% | pp. 4 y 25 | Coincide; el Rmd redondea a un decimal | Recalcular totales de 2019 y 2020 |
| Cinco modelos de la serie general, MAE y RMSE | p. 12 | Las diez cifras coinciden con la tabla de la explicacion | Reproducir predicciones y errores |
| Ganadores de las siete series, MAE y RMSE | pp. 16, 18, 20, 22, 24 y 25 | Coinciden con la explicacion; empate maritimo solo confirmado a dos decimales | Verificar precision completa y fechas de prueba |
| Siete series por cuatro indicadores | p. 25 | Las 28 celdas coinciden, incluido N/D para Guatemala | Recalcular con las mismas ventanas |
| Pico de 2019 y recuperacion de 2022 | Grafico anual, p. 3 | 4.7 y 4.3 millones son aproximaciones visuales, no totales exactos publicados | Calcular totales y porcentaje de recuperacion |
| Total parcial de 2026 | Grafico anual, p. 3 | La cifra aproximada no sustituye el calculo | Sumar enero-junio y comparar semestres equivalentes |
| Meses pico y valle | Descomposiciones, pp. 11 a 23 | Hay patrones visibles, pero no una tabla mensual precisa | Extraer los 12 componentes estacionales por serie |
| Paises, vias y fronteras principales | pp. 4 a 6 | El orden descrito coincide con los graficos | Calcular volumen y participacion antes de publicar porcentajes |

Los cinco modelos generales publicados ordenados por RMSE son Prophet (107,976.80), ARIMA (121,487.80), Holt-Winters (169,332.70), ETS (210,431.50) y Seasonal Naive (253,203.40). El ganador publicado es Prophet, con MAE de 97,589.88. Ser el mejor de los candidatos no garantiza un error bajo ni cobertura adecuada del intervalo.

## Discrepancias e interpretaciones

| Tema | Evidencia | Tratamiento para el Laboratorio 9 |
| --- | --- | --- |
| Fuerza de tendencia no es tasa de crecimiento | Rmd lineas 856-862: cociente de varianzas, sin pendiente ni signo | No declarar a Guatemala como la de mayor crecimiento por su 0.928. Calcular crecimiento en un periodo comun y documentar la medida |
| Pandemia en Guatemala | Rmd lineas 900-913 atribuye una caida a Guatemala; PDF p. 25 publica N/D porque el indicador usa solo entrenamiento | Conservar N/D en la tabla original. El Salvador tiene la mayor caida publicada entre las seis series restantes: -74.9% |
| Cobertura de Guatemala | PDF p. 15 da fin de entrenamiento en sep-2018; p. 16 muestra pandemia en prueba | No confundir fin de entrenamiento con fin de la serie. Verificar fechas completas en los datos |
| Comparabilidad temporal | Rmd lineas 325-365 divide cada serie 70/30 por separado; lineas 851-871 calcula indicadores sobre entrenamiento | Rotular ventanas distintas. No interpretar las diferencias como un ranking sobre un periodo comun |
| Recuperacion pospandemia | PDF p. 26 la infiere de fuerza de tendencia; entrenamiento general termina en mar-2021 | Medir recuperacion con observaciones posteriores, no con fuerza de tendencia de entrenamiento |
| Ventaja de Prophet | PDF p. 12 usa una expresion exagerada frente a ARIMA y atribuye el resultado al manejo de la pandemia | Comunicar los errores, sin afirmar que el mecanismo causal esta demostrado. El ajuste no usa observaciones futuras del test |
| Volatilidad maritima | PDF p. 26 dice casi el doble; CV 0.868 frente a 0.548 de El Salvador | Es aproximadamente 58% mayor; preferir mostrar los CV |
| Seasonal Naive | Rmd linea 523 usa un pronostico fijo de longitud h | Repite el ultimo ciclo anual del entrenamiento durante todo el horizonte; no se actualiza con datos reales de prueba |
| Contexto migratorio | PDF p. 2 advierte cambio de categoria entre 2022 y 2023 y uso academico; p. 4 incluye Guatemala | No equiparar total migratorio con turistas extranjeros ni atribuir cambios a demanda sin revisar definiciones. Verificar el alcance del cambio antes de asumir que el total es inmune |
| Hipotesis de cruceros y eventos de calendario | PDF p. 26 usa una explicacion tentativa sobre cruceros | Presentar contexto como hipotesis o coincidencia, no causalidad demostrada |

## Reproduccion y pronostico

- El Rmd fija `setwd("D:/Data Science/Lab-Series-de-Tiempo")` (linea 37). El nuevo script recibira una ruta local de entrada, sin depender de esa maquina ni incluir datos restringidos en Git.
- La agregacion mensual suma `viajero`, no cuenta filas. `crear_train_test()` completa meses ausentes con cero (lineas 336-339). Se revisaran los huecos antes de repetir esa decision: ausencia de registro no demuestra flujo nulo.
- La seleccion global ordena por RMSE (linea 577). MAE se mostrara como metrica complementaria sobre el mismo test de cada serie.
- Los AIC/BIC de ARIMA transformado y ETS en escala original no se compararan directamente. No sustituyen el desempeno fuera de muestra.
- Prophet usa estacionalidad anual, sin semanal ni diaria (lineas 532-534). El script genera fechas futuras y toma las ultimas h predicciones; se verificara su correspondencia exacta con las fechas de prueba.
- `predict()` de Prophet normalmente produce `yhat_lower` y `yhat_upper`, con nivel predeterminado de 80%. El Rmd solo utiliza `yhat` y no devuelve esos limites (lineas 537-538 y 602-617). Falta conservar y visualizar el intervalo, no necesariamente implementar otro metodo.
- El nuevo resultado debe distinguir observaciones, prediccion y limites. Se fijara una semilla para la simulacion de incertidumbre y se documentara cualquier diferencia respecto de los errores publicados.
- La visualizacion obligatoria corresponde al conjunto de prueba, no a un modelo reentrenado con todos los datos. Un eventual pronostico posterior a junio de 2026 seria un producto adicional distinto.
- No se fabricaran intervalos con MAE/RMSE ni se truncaran valores negativos silenciosamente. Las predicciones imposibles de modelos no ganadores no se ocultaran en sus metricas.

## Condiciones para continuar

1. Preparar el script reproducible manteniendo separado el analisis original.
2. Disponer del Excel local o de agregaciones mensuales suficientes para las siete series, con cobertura y procedencia documentadas.
3. Recalcular KPIs, calendario y crecimiento; conservar por separado resultados publicados y reproducidos si difieren.
4. Generar los graficos individuales y el pronostico con intervalo, verificando fechas, unidades y errores.

Este paso no incluye diseno ni composicion de la infografia. El tamano A3 frente a 11x17 pulgadas sigue pendiente de confirmacion con el profesor. Tampoco se modifica el historial ni se acredita trabajo a otros integrantes.
