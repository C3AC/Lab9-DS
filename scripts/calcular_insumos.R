# Uses the local artifact from preparar_series.R; no model fitting or charts.
calcular_insumos <- function(preparadas) {
  anuales <- list()
  indicadores <- list()
  estacionales <- list()
  crecimiento <- list()
  for (nombre in names(preparadas$series)) {
    serie <- preparadas$series[[nombre]]
    mensual <- serie$mensual
    mensual$ano <- as.integer(format(mensual$fecha, "%Y"))
    anual <- aggregate(viajeros ~ ano, mensual, sum)
    anual$meses <- as.integer(table(mensual$ano)[as.character(anual$ano)])
    anual$imputados <- as.integer(tapply(mensual$imputado_cero, mensual$ano, sum)[as.character(anual$ano)])
    anual$serie <- nombre
    anuales[[nombre]] <- anual

    # Original training windows and a common pre-pandemic window stay separate.
    for (ventana in c("entrenamiento_original", "comun_2009_2019")) {
      df <- if (ventana == "entrenamiento_original") serie$train$df else
        mensual[mensual$fecha >= as.Date("2009-01-01") &
                  mensual$fecha <= as.Date("2019-12-01"), ]
      if (ventana == "comun_2009_2019" && nrow(df) != 132) {
        stop("No hay cobertura comun completa 2009-2019 en: ", nombre)
      }
      x <- ts(df$viajeros, start = c(as.integer(format(df$fecha[1], "%Y")),
                                    as.integer(format(df$fecha[1], "%m"))), frequency = 12)
      descomp <- decompose(x, type = "additive")
      vr <- var(descomp$random, na.rm = TRUE)
      ve <- var(descomp$random + descomp$seasonal, na.rm = TRUE)
      vt <- var(descomp$random + descomp$trend, na.rm = TRUE)
      ano <- as.integer(format(df$fecha, "%Y"))
      v19 <- sum(df$viajeros[ano == 2019])
      v20 <- sum(df$viajeros[ano == 2020])
      caida <- if (sum(ano == 2019) == 12 && sum(ano == 2020) == 12 && v19 > 0)
        (v20 / v19 - 1) * 100 else NA_real_
      clave <- paste(nombre, ventana)
      indicadores[[clave]] <- data.frame(
        serie = nombre, ventana = ventana, inicio = min(df$fecha), fin = max(df$fecha),
        fuerza_estacional = if (ve > 0) max(0, 1 - vr / ve) else NA_real_,
        fuerza_tendencia = if (vt > 0) max(0, 1 - vr / vt) else NA_real_,
        volatilidad_cv = if (mean(x) > 0) sd(x) / mean(x) else NA_real_,
        caida_pandemia_pct = caida, meses_imputados = sum(df$imputado_cero)
      )
      componente <- as.numeric(descomp$figure)
      # figure starts at the first calendar month of the ts, not necessarily January.
      meses <- ((as.integer(format(df$fecha[1], "%m")) - 1 + 0:11) %% 12) + 1
      estacionales[[clave]] <- data.frame(
        serie = nombre, ventana = ventana, mes = meses, componente = componente,
        pico = componente == max(componente), valle = componente == min(componente)
      )
    }
    extremos <- anual[anual$ano %in% c(2009, 2019), ]
    if (nrow(extremos) != 2 || any(extremos$meses != 12) || any(extremos$viajeros <= 0)) {
      stop("Extremos anuales invalidos para crecimiento: ", nombre)
    }
    crecimiento[[nombre]] <- data.frame(
      serie = nombre, ano_inicial = 2009, ano_final = 2019,
      total_inicial = extremos$viajeros[extremos$ano == 2009],
      total_final = extremos$viajeros[extremos$ano == 2019],
      crecimiento_pct = (extremos$viajeros[2] / extremos$viajeros[1] - 1) * 100,
      cagr_pct = ((extremos$viajeros[2] / extremos$viajeros[1])^(1 / 10) - 1) * 100
    )
  }
  anuales <- do.call(rbind, unname(anuales))
  general <- anuales[anuales$serie == "General", ]
  valor <- function(ano) {
    fila <- general[general$ano == ano, ]
    if (nrow(fila) != 1 || fila$meses != 12) stop("Falta ano completo: ", ano)
    fila$viajeros
  }
  semestres <- list()
  for (nombre in names(preparadas$series)) {
    df <- preparadas$series[[nombre]]$mensual
    df <- df[as.integer(format(df$fecha, "%m")) <= 6, ]
    df$ano <- as.integer(format(df$fecha, "%Y"))
    agregado <- aggregate(viajeros ~ ano, df, sum)
    agregado$meses <- as.integer(table(df$ano)[as.character(agregado$ano)])
    agregado$serie <- nombre
    semestres[[nombre]] <- agregado
  }
  list(
    anuales = anuales,
    semestres = do.call(rbind, unname(semestres)),
    indicadores = do.call(rbind, unname(indicadores)),
    estacionalidad = do.call(rbind, unname(estacionales)),
    crecimiento = do.call(rbind, unname(crecimiento)),
    kpis = data.frame(
      indicador = c("total_2019", "total_2020", "caida_2019_2020_pct", "total_2022",
                    "recuperacion_2022_sobre_2019_pct"),
      valor = c(valor(2019), valor(2020), (valor(2020) / valor(2019) - 1) * 100,
                valor(2022), valor(2022) / valor(2019) * 100)
    ),
    procedencia = preparadas$procedencia
  )
}

main_insumos <- function(args = commandArgs(trailingOnly = TRUE)) {
  if (identical(args, "--help")) {
    cat("Uso: Rscript scripts/calcular_insumos.R [directorio_salida]\n")
    return(invisible(NULL))
  }
  if (length(args) > 1 || any(startsWith(args, "--"))) stop("Argumentos invalidos; usar --help.")
  salida <- if (length(args)) args[1] else "salidas"
  preparadas <- readRDS(file.path(salida, "series_preparadas.rds"))
  resultado <- calcular_insumos(preparadas)
  saveRDS(resultado, file.path(salida, "insumos.rds"))
  for (nombre in setdiff(names(resultado), "procedencia")) {
    write.csv(resultado[[nombre]], file.path(salida, paste0(nombre, ".csv")),
              row.names = FALSE, fileEncoding = "UTF-8")
  }
  capture.output(sessionInfo(), file = file.path(salida, "sesion_insumos_R.txt"))
  print(resultado$kpis, row.names = FALSE)
  print(resultado$crecimiento, row.names = FALSE)
  invisible(resultado)
}

if (sys.nframe() == 0L) main_insumos()
