# Laboratorio 9 – Documento de explicación (Grupo 6)

CC3084 – Data Science · UVG · Semestre II 2026 · 15 de octubre de 2026

## 1. Propósito y narrativa

La infografía responde una sola pregunta: qué enseñan 17 años de datos migratorios sobre el turismo en Guatemala y qué debemos anticipar. Está dirigida a un directivo de INGUAT que no es estadístico ni técnico, así que cada concepto del Laboratorio 1 (ADF, AIC/BIC, Box-Cox) se traduce a una idea de negocio: hay un calendario que se repite, hubo un golpe en 2020 y algunos modelos anticipan mejor que otros.

**Titular propuesto:** Del golpe a la recuperación: lo que 17 años de llegadas dicen sobre el turismo en Guatemala (2009–2026)

**Subtítulo propuesto:** Una caída de 73% en 2020, un rebote en 2022 y un calendario que se repite: qué esperar y dónde actuar.

El hilo conductor avanza en cuatro preguntas:

1. ¿Qué pasó? Cifras clave y línea temporal 2009–2026.
2. ¿Cuándo y por dónde llegan los viajeros? Estacionalidad y comparación entre series.
3. ¿Qué podemos anticipar? Desempeño de los modelos y proyección con intervalo.
4. ¿Qué hacemos? Recomendaciones para INGUAT.

## 2. Orden de los bloques y trayectoria visual

Los bloques siguen el orden en que un directivo haría sus preguntas: qué pasó, cuándo y por dónde, qué viene y qué hacer. Se va de lo general a lo específico y del pasado a la acción. La lectura sigue un patrón en Z, y los elementos que sostienen la historia (KPIs, línea temporal y proyección) llevan el mayor peso visual.

| Zona | Contenido | Razón del lugar |
| --- | --- | --- |
| Arriba | Titular, subtítulo y 3–4 KPIs | Es donde empieza la lectura; las cifras grandes son el gancho |
| Franja ancha | Línea temporal 2009–2026 con anotaciones | Una serie de 17 años necesita todo el ancho para que se vea su forma |
| Dos columnas | Estacionalidad (izquierda) y cuadrante comparativo (derecha) | Ambos responden «cuándo» y «cuál serie»; se leen en paralelo |
| Dos columnas | Comparación de modelos (izquierda) y proyección (derecha) | Primero se justifica el modelo y después se muestra su resultado |
| Abajo | Recomendaciones para INGUAT y ficha técnica | La conclusión cierra el recorrido; la ficha va en tipografía pequeña |

**Lienzo.** La rúbrica pide un PNG de mínimo 1200×2400 px y un PDF «A3 vertical, 11×17 pulgadas», pero esas medidas no coinciden (A3 mide 297×420 mm; 11×17 in mide 279×432 mm). Proponemos diseñar en proporción 11×17 a 3300×5100 px, que supera el mínimo del PNG, y confirmar con el profesor qué tamaño de papel prevalece.

## 3. Selección de gráficos por bloque

Cada gráfico se eligió por el tipo de dato que representa, no por estética.

| Bloque | Visualización | Tipo de dato | Por qué esta elección |
| --- | --- | --- | --- |
| 1. KPIs | 3–4 tarjetas con cifra grande | Valores únicos agregados | Un número aislado se lee en segundos y abre la historia |
| 2. Panorama histórico | Línea mensual 2009–2026 con anotaciones directas | Serie temporal continua | La línea muestra continuidad, tendencia y ciclos; las anotaciones explican 2020 y 2022 sin leyenda |
| 3. Estacionalidad | Barras del componente estacional por mes, con los picos rotulados | Valores cíclicos por categoría (mes) | Compara los 12 meses en una misma escala y destaca el mes pico con el color de acento |
| 3. Cuadrante comparativo | Tabla visual (mapa de calor) de 7 series × 4 indicadores | Varias medidas de distinta naturaleza por serie | Se lee por fila (una serie) y por columna (un indicador); se resalta la serie que responde cada pregunta |
| 4. Modelos | Barras horizontales ordenadas por error (MAE y RMSE) | Una medida de error por modelo | Las barras parten de cero y comparan magnitudes; el ganador va en acento y el resto en gris |
| 4. Proyección | Línea observada + línea estimada con abanico del 80%, rotulado «Estimación» | Serie temporal con incertidumbre | La banda muestra que el pronóstico es un rango y no un punto |
| 5. Recomendaciones | Lista numerada corta, cada una con su evidencia | Texto | Es el único bloque donde un gráfico no aporta información |

**Por qué MAE y RMSE y no AIC/BIC.** Dentro de cada serie, MAE y RMSE se calculan sobre el mismo conjunto de prueba para los cinco modelos, así que son comparables. El script solo reporta AIC y BIC para ARIMA y ETS; no son métricas de error sobre prueba y no se usarán para ordenar algoritmos. Además, cuando ARIMA usa Box-Cox y ETS usa la escala original, sus AIC/BIC reportados no deben compararse directamente sin un tratamiento consistente de la transformación. MAE es el error absoluto promedio en viajeros por mes; RMSE penaliza más los errores grandes. El ganador del script se selecciona por menor RMSE.

**Fechas de contexto.** La infografía anotará los meses de pico y valle tomados de la descomposición estacional de cada serie y, cuando coincidan, las fechas de contexto (por ejemplo Semana Santa, bono 14 en julio y aguinaldo en diciembre). Estas coincidencias no demuestran causalidad. Semana Santa cambia de fecha entre marzo y abril; un patrón mensual no permite atribuirle por sí solo un efecto específico.

## 4. Paleta de colores

La paleta usa dos colores temáticos, un neutro y un solo acento, con un esquema monocromático (azul petróleo y sus tintes) más un acento complementario (naranja). Los colores se eligieron por el significado de lo que representan, no por decoración.

| Rol | Color propuesto | Se usa para | Razón |
| --- | --- | --- | --- |
| Principal | Azul petróleo `#0F5C6E` | Datos observados, títulos, barras base | El azul transmite estabilidad y confianza, adecuado para una institución; coincide con el informe del Laboratorio 1 y con la identidad de la UVG |
| Secundario | Gris azulado `#5B6B7A` | Contexto, modelos no ganadores, rejillas y texto de apoyo | Un gris retrocede visualmente y deja protagonismo al resto |
| Neutro | Blanco cálido `#FAFAF8` (fondo) y casi negro `#1F2933` (texto) | Fondo y texto | Contraste alto y lectura cómoda en pantalla |
| Acento | Naranja `#E8710A` | La caída de 2020, el mes pico, el modelo ganador y la proyección | Es complementario al azul, así que salta a la vista; azul y naranja se distinguen incluso con daltonismo |

**Reglas de uso.** El acento aparece solo donde el lector debe mirar y nunca más de una vez por gráfico. La proyección se distingue además con línea punteada y el rótulo «Estimación», para no depender solo del color. El naranja tiene un contraste moderado sobre fondo blanco, por eso se reserva para marcas y cifras grandes, y el texto pequeño va siempre en azul oscuro o casi negro.

**Qué cambia respecto al Laboratorio 1.** Allí cada serie o modelo tenía un color distinto (esquema tipo arcoíris). En la infografía esos colores se reemplazan por la lógica gris + acento.

Los valores hexadecimales son una propuesta y se confirman con el archivo final. La elección se apoya en tres ideas de la teoría del color. Primero, la rueda de color y la armonía complementaria: el azul y el naranja están en lados opuestos y dan el máximo contraste con solo dos tonos. Segundo, el esquema monocromático: un solo tono (azul petróleo) en distintas intensidades da cohesión a todos los datos observados. Tercero, el significado asociado al color: los tonos fríos transmiten calma y confianza, y el cálido llama la atención, por eso el naranja queda reservado a lo que exige atención. Además, el color nunca es la única señal, para que la lectura funcione con daltonismo y en blanco y negro.

## 5. Tipografía, contraste y legibilidad

La infografía se difunde en pantalla, así que la legibilidad pesa más que el estilo. Se usa una sola familia sans-serif (por ejemplo Inter o Source Sans) en tres pesos: regular, semibold y bold. Una familia única evita el ruido visual y deja que el tamaño y el peso marquen la jerarquía.

| Elemento | Tamaño propuesto (lienzo de 1200 px de ancho) | Peso |
| --- | --- | --- |
| Titular | 64–72 px | Bold |
| Cifras de KPIs | 96–120 px | Bold, en azul petróleo o acento |
| Encabezados de bloque | 36 px | Semibold |
| Cuerpo y recomendaciones | 22 px o más | Regular |
| Etiquetas de gráficos | 20 px o más | Regular |
| Ficha técnica y créditos | 18 px o más | Regular |

El texto normal mantiene una relación de contraste de al menos 4.5:1 con su fondo, que es el mínimo de accesibilidad WCAG nivel AA. Nunca se coloca texto sobre las áreas de datos ni sobre el color de acento sin comprobar el contraste. Las etiquetas van directamente sobre los puntos clave, no en leyendas alejadas.

Los tamaños son una propuesta y se verifican al exportar la versión final, también en pantalla pequeña.

## 6. Jerarquía visual y eliminación de elementos decorativos

La jerarquía se construye con tamaño, peso y color, en este orden de importancia: (1) titular y KPIs, (2) línea temporal y proyección, (3) estacionalidad y cuadrante, (4) comparación de modelos, (5) recomendaciones y ficha técnica. El ojo debe poder reconstruir la historia leyendo solo lo más grande.

Todo elemento que no aporta información se eliminó, siguiendo la idea de maximizar la proporción de «tinta de datos» (Tufte):

- Sin efectos 3D, sombras ni degradados.
- Sin marcos alrededor de los gráficos; el espacio en blanco separa los bloques.
- Rejillas muy tenues o ausentes, y valores impresos en las marcas clave en lugar de ejes densos.
- Leyendas reemplazadas por etiquetas directas.
- Sin fondos saturados ni imágenes de adorno.

Las barras parten siempre de cero, porque su longitud representa el valor. Se usa agrupación por proximidad y alineación a una cuadrícula común para que cada bloque se lea como una unidad. Estas decisiones se apoyan en cuatro principios. La razón datos-tinta de Tufte: se elimina lo que no informa. Los atributos preatentivos: tamaño, color y posición se perciben antes de leer, así que el acento y el tamaño guían la mirada. Las leyes de la Gestalt (proximidad, similitud y alineación): agrupan cada bloque como unidad. La jerarquía de precisión perceptual de Cleveland y McGill: la posición y la longitud se leen con más exactitud que el área o el color, por lo que se prefieren líneas y barras a círculos o gráficos 3D.

## 7. Fidelidad de los datos

La fuente analítica es el Laboratorio 1 (Grupo 6, 26 de julio de 2026): una base de 161,036 registros agregados que cubre de enero de 2009 a junio de 2026, a partir de la cual se construyeron 7 series mensuales. El número de registros no equivale al número de viajeros. Las tablas siguientes se cotejaron con el PDF del laboratorio, pero aún no se han reproducido sus cálculos: falta el archivo Excel de entrada. La trazabilidad y las discrepancias con el Rmd están documentadas en `docs/validacion_evidencia.md`.

### KPIs propuestos

| KPI | Cifra | Origen en el Laboratorio 1 | Estado |
| --- | --- | --- | --- |
| Pico anual prepandemia (2019) | ≈ 4.7 millones de viajeros | Barras anuales del EDA | Leído del gráfico; calcular el valor exacto con el script |
| Caída 2019→2020 (serie general) | −73.0% | Tabla de indicadores, PDF p. 25 | Reportado y redondeado a un decimal; pendiente de reproducir |
| Recuperación en 2022 | ≈ 4.3 millones de viajeros (≈ 92% del pico de 2019) | Barras anuales del EDA | Leído del gráfico; calcular el valor exacto con el script |
| Error medio del mejor modelo (serie general) | 97,590 viajeros por mes (Prophet, MAE) | Comparación de modelos, PDF p. 12 | Reportado con dos decimales (97,589.88); pendiente de reproducir |

### Comparación de modelos en la serie general

| Modelo | MAE (viajeros/mes) | RMSE (viajeros/mes) |
| --- | --- | --- |
| Prophet (ganador) | 97,589.88 | 107,976.80 |
| ARIMA(2,1,1)(1,0,1)[12] | 102,566.16 | 121,487.80 |
| Holt-Winters | 150,681.72 | 169,332.70 |
| ETS(A,N,A) | 193,116.55 | 210,431.50 |
| Seasonal Naive | 235,730.91 | 253,203.40 |

### Mejor modelo por serie

| Serie | Mejor modelo | MAE | RMSE |
| --- | --- | --- | --- |
| General | Prophet | 97,589.88 | 107,976.80 |
| El Salvador | Prophet | 53,252.87 | 56,540.06 |
| Guatemala | Seasonal Naive | 56,259.91 | 69,513.09 |
| Estados Unidos | Holt-Winters | 23,097.58 | 25,168.66 |
| Vía Aérea | Holt-Winters | 26,342.67 | 31,317.38 |
| Vía Terrestre | Prophet | 54,308.76 | 71,306.26 |
| Vía Marítima | ARIMA y Seasonal Naive (empate) | 858.37 | 1,731.93 |

### Cuadrante comparativo

| Serie | Fuerza estacional | Fuerza de tendencia | Volatilidad (CV) | Caída 2019→2020 |
| --- | --- | --- | --- | --- |
| Guatemala | 0.793 | 0.928 | 0.359 | N/D |
| Estados Unidos | 0.703 | 0.712 | 0.396 | −73.7% |
| Vía Marítima | 0.614 | 0.196 | 0.868 | −67.9% |
| Vía Aérea | 0.558 | 0.809 | 0.330 | −72.3% |
| General | 0.472 | 0.826 | 0.430 | −73.0% |
| Vía Terrestre | 0.387 | 0.818 | 0.517 | −73.6% |
| El Salvador | 0.318 | 0.763 | 0.548 | −74.9% |

Según los indicadores publicados, Guatemala tiene la mayor fuerza estacional (0.793) y fuerza de tendencia (0.928); Vía Marítima tiene la mayor volatilidad relativa (CV 0.868); El Salvador presenta la mayor caída 2019→2020 (−74.9%) entre las seis series con ese indicador disponible. Son comparaciones descriptivas de las ventanas de entrenamiento originales, no de un periodo común. **La pregunta de mayor crecimiento sigue pendiente:** la fuerza de tendencia mide cuánto domina ese componente frente al residuo, no su dirección ni su tasa de crecimiento. Se calculará una medida explícita de crecimiento sobre un periodo común y se distinguirá de los indicadores originales.

### Cuidados para que los gráficos no mientan

- **2026 está incompleto.** La barra anual de 2026 (≈ 1.68 millones) cubre solo enero a junio. Se rotulará «ene–jun 2026» o se comparará con el mismo semestre de otros años.
- **Guatemala no es comparable en todo.** Su entrenamiento termina en septiembre de 2018, antes de la pandemia, así que su caída es N/D en la tabla original y sus indicadores de entrenamiento no incluyen 2020. Esto no significa que la serie completa termine en 2018: el gráfico de prueba incluye la pandemia. Se comprobará la cobertura completa al cargar el Excel. La pregunta «más golpeada» se responde por ahora solo entre las seis series con caída publicada, y así se rotula.
- **Las caídas son parecidas.** Las series comparables cayeron entre −72% y −75%, salvo Vía Marítima (−67.9%). El Salvador (−74.9%) apenas supera a las demás, por lo que no se presentará como una diferencia dramática.
- **El error depende de la escala.** El MAE de Vía Marítima (858) y el de la serie general (97,590) no se pueden poner en un mismo gráfico sin normalizar. Dentro de cada serie sí son comparables; entre series se usará el error relativo a la media mensual, que se calcula con el script.
- **«Casi el doble» no es exacto.** El Laboratorio 1 dice que la volatilidad de Vía Marítima (0.868) es casi el doble que la siguiente, pero El Salvador tiene 0.548, y 0.868 es alrededor de 58% más. Se mostrará el valor, no esa frase.
- **La fuerza de tendencia no mide la recuperación.** Se calculó sobre la ventana de entrenamiento (termina en marzo de 2021 en casi todas las series y en septiembre de 2018 en Guatemala). Por eso no se usa para afirmar qué serie se recuperó mejor.
- **El error del ganador es relevante.** Un MAE de 97,590 sobre niveles mensuales típicos de 250 mil a 400 mil no es pequeño; por eso la proyección se muestra con su abanico y el rótulo «Estimación».
- **El intervalo no fue presentado ni conservado.** El Rmd llama a `predict()` de Prophet, que normalmente devuelve `yhat_lower` y `yhat_upper` con nivel de 80% por defecto, pero solo extrae `yhat` para el gráfico y las métricas. Se reproducirá la predicción sobre las fechas exactas de prueba, se conservarán los límites y se rotulará «Estimación: intervalo de predicción del 80%». No se fabricará la banda a partir del MAE o RMSE.
- **Valores imposibles.** El PDF muestra predicciones negativas de ARIMA para Vía Aérea y Estados Unidos. El gráfico del ganador no necesita incluir esas líneas, pero sus errores sí permanecen en la comparación de modelos. No se recortarán predicciones ni límites a cero silenciosamente, pues eso modificaría el resultado o su interpretación.
- **Lo que el Laboratorio 1 solo supone.** La explicación de que Vía Marítima cayó menos «por los cruceros» es una hipótesis («probablemente»); no se afirmará como hecho. La categoría «tipo de viajero» cambió de criterio entre 2022 y 2023, así que no se usa para tendencias, y el país «Guatemala» agrupa registros fronterizos e intrarregionales, no turistas extranjeros.

## 8. Recomendaciones estratégicas para INGUAT

Cada recomendación se deriva de un resultado del Laboratorio 1 y se mostrará en la infografía junto a su evidencia.

| # | Recomendación | Evidencia |
| --- | --- | --- |
| 1 | Planificar personal e infraestructura con un calendario mensual basado en la estacionalidad | Las series muestran un componente estacional en el entrenamiento (fuerza de 0.318 a 0.793); Seasonal Naive fue el mejor modelo para Guatemala en la prueba. En pronósticos de varios años, este método repite el último ciclo anual observado en entrenamiento, no utiliza los valores reales posteriores |
| 2 | Concentrar el monitoreo y la promoción en los puntos de mayor volumen | Tres países (El Salvador, Guatemala, Estados Unidos), dos regiones (América del Centro y del Norte), la vía terrestre y la aérea, y las fronteras La Aurora, Valle Nuevo y San Cristóbal concentran la mayoría de los registros |
| 3 | Mantener un modelo por segmento, reevaluarlo tras cada choque y monitorear errores y salidas persistentes del intervalo antes de revisar capacidad o campañas | Ningún modelo gana en todo: Prophet ganó en 3 de 7 series (General, El Salvador, Vía Terrestre), Holt-Winters en 2 (Estados Unidos, Vía Aérea), Seasonal Naive en Guatemala, y en Vía Marítima hubo empate a la precisión publicada entre ARIMA y Seasonal Naive. Un intervalo del 80% admite observaciones fuera de él; una salida aislada no prueba un cambio estructural |
| 4 | Tratar la Vía Marítima como una serie de vigilancia mensual y no confiar en proyecciones a largo plazo | Tiene la mayor volatilidad (CV 0.868), la menor fuerza de tendencia (0.196) y residuos autocorrelacionados en su ARIMA (Ljung-Box p ≈ 0.0000032) |
| 5 | Lanzar campañas dirigidas a los mercados principales en los meses de menor afluencia, para aplanar los picos | La estacionalidad es marcada y la demanda está concentrada en pocos mercados, lo que permite apuntar a segmentos concretos en meses concretos |

Las recomendaciones 1 y 5 se acompañarán en la infografía con los meses de pico y valle de la descomposición estacional.

## 9. Herramientas, historial y contribuciones

Los gráficos se generan por código para que las cifras sean reproducibles, partiendo del script del Laboratorio 1 (que usó R). La composición final de la infografía y este documento se trabajan en herramientas con historial de cambios. La infografía se compone en Canva.

**Requisitos de la rúbrica**

- [ ] Profesor y auxiliares agregados como colaboradores del documento y de la infografía
- [ ] Todos los integrantes con aportes visibles en el historial, tanto en el documento como en la infografía
- [ ] Script en R o Python y enlace al repositorio con el código versionado

**Entregables**

| Entregable | Fecha |
| --- | --- |
| Avance: documento de explicación en PDF | Jueves 15 de octubre de 2026 |
| Infografía en PNG (mínimo 1200×2400 px) y PDF de 1 página, más enlaces al documento, script y repositorio | Domingo 18 de octubre de 2026 |

## 10. Fuentes y créditos

- **Datos:** Base de Migración 2009–2026, INGUAT / Instituto Guatemalteco de Migración (IGM). Compartida con fines estrictamente académicos; la infografía no se publica en redes ni repositorios públicos sin consulta previa.
- **Análisis base:** Laboratorio 1 – Series de Tiempo, Grupo 6, 26 de julio de 2026. CC3084 Data Science, Universidad del Valle de Guatemala.
- **Autores:** Grupo 6

El Laboratorio 1 aclara que estos datos son solo para uso académico y no son cifras oficiales; la ficha técnica de la infografía lo indicará.
