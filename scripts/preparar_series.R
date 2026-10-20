# Run from the repository root. Source this file to test without reading data.
preparar_series <- function(datos, completar_ceros = FALSE) {
  requeridas <- c("ano", "mes_cod", "viajero", "pais", "via")
  faltantes <- setdiff(requeridas, names(datos))
  if (length(faltantes)) {
    stop("Faltan columnas: ", paste(faltantes, collapse = ", "))
  }
  if (!nrow(datos)) stop("La base esta vacia.")
  for (columna in requeridas) {
    if (anyNA(datos[[columna]])) stop("Valores faltantes en: ", columna)
  }
  for (columna in c("ano", "mes_cod", "viajero")) {
    x <- datos[[columna]]
    if (!is.numeric(x) || any(!is.finite(x))) {
      stop("La columna debe ser numerica y finita: ", columna)
    }
  }
  if (any(datos$ano != floor(datos$ano) | datos$ano < 1 | datos$ano > 9999) ||
      any(datos$mes_cod != floor(datos$mes_cod) |
          datos$mes_cod < 1 | datos$mes_cod > 12)) {
    stop("Anos o meses invalidos.")
  }
  if (any(datos$viajero < 0)) {
    stop("viajero debe contener valores no negativos.")
  }
  for (columna in c("pais", "via")) {
    if (!is.character(datos[[columna]]) || any(!nzchar(trimws(datos[[columna]])))) {
      stop("Categorias vacias o no textuales en: ", columna)
    }
  }
  if (anyDuplicated(datos)) stop("Hay filas duplicadas; revisarlas antes de continuar.")

  datos$fecha <- as.Date(sprintf("%04d-%02d-01", datos$ano, datos$mes_cod))
  # Unicode escapes keep the source portable without changing Excel categories.
  filtros <- setNames(list(
    rep(TRUE, nrow(datos)),
    datos$pais == "El Salvador",
    datos$pais == "Guatemala",
    datos$pais == "Estados Unidos de Am\u00e9rica",
    datos$via == "A\u00e9rea",
    datos$via == "Terrestre",
    datos$via == "Mar\u00edtima"
  ), c(
    "General", "El Salvador", "Guatemala", "Estados Unidos",
    "V\u00eda A\u00e9rea", "V\u00eda Terrestre", "V\u00eda Mar\u00edtima"
  ))
  series <- list()
  cobertura <- list()
  huecos <- list()
  for (nombre in names(filtros)) {
    parte <- datos[filtros[[nombre]], , drop = FALSE]
    if (!nrow(parte)) stop("Serie sin registros: ", nombre)
    mensual <- aggregate(viajero ~ fecha, data = parte, FUN = sum)
    names(mensual)[2] <- "viajeros"
    calendario <- data.frame(fecha = seq(min(mensual$fecha), max(mensual$fecha), by = "month"))
    mensual <- merge(calendario, mensual, by = "fecha", all.x = TRUE, sort = TRUE)
    mensual$imputado_cero <- is.na(mensual$viajeros)
    fechas_huecos <- mensual$fecha[mensual$imputado_cero]
    if (length(fechas_huecos) && !completar_ceros) {
      stop("Meses sin registros en ", nombre, ": ",
           paste(fechas_huecos, collapse = ", "),
           ". Revisar la fuente o autorizar --completar-ceros explicitamente.")
    }
    mensual$viajeros[mensual$imputado_cero] <- 0
    n_train <- floor(nrow(mensual) * 0.7)
    if (n_train < 24 || n_train >= nrow(mensual)) {
      stop("Historia insuficiente para entrenamiento de dos ciclos anuales: ", nombre)
    }
    mensual$conjunto <- ifelse(seq_len(nrow(mensual)) <= n_train, "train", "test")
    train <- mensual[mensual$conjunto == "train", , drop = FALSE]
    test <- mensual[mensual$conjunto == "test", , drop = FALSE]
    series[[nombre]] <- list(
      mensual = mensual,
      train = list(df = train, ts = ts(train$viajeros,
        start = c(as.integer(format(train$fecha[1], "%Y")),
                  as.integer(format(train$fecha[1], "%m"))), frequency = 12)),
      test = list(df = test, ts = ts(test$viajeros,
        start = c(as.integer(format(test$fecha[1], "%Y")),
                  as.integer(format(test$fecha[1], "%m"))), frequency = 12))
    )
    cobertura[[nombre]] <- data.frame(
      serie = nombre, inicio = min(mensual$fecha), fin = max(mensual$fecha),
      meses = nrow(mensual), meses_train = nrow(train), meses_test = nrow(test),
      fin_train = max(train$fecha), inicio_test = min(test$fecha),
      meses_imputados = length(fechas_huecos)
    )
    huecos[[nombre]] <- data.frame(serie = rep(nombre, length(fechas_huecos)), fecha = fechas_huecos)
  }
  list(series = series, cobertura = do.call(rbind, unname(cobertura)),
       huecos = do.call(rbind, unname(huecos)))
}

main <- function(args = commandArgs(trailingOnly = TRUE)) {
  uso <- paste("Uso: Rscript scripts/preparar_series.R archivo.xlsx",
               "[directorio_salida] [--completar-ceros]")
  if (identical(args, "--help")) {
    cat(uso, "\n")
    return(invisible(NULL))
  }
  completar_ceros <- "--completar-ceros" %in% args
  posiciones <- args[args != "--completar-ceros"]
  if (length(posiciones) < 1 || length(posiciones) > 2 ||
      any(startsWith(posiciones, "--"))) stop(uso)
  entrada <- normalizePath(posiciones[1], mustWork = TRUE)
  salida <- if (length(posiciones) == 2) posiciones[2] else "salidas"
  if (!grepl("\\.xlsx$", entrada, ignore.case = TRUE)) stop("La entrada debe ser .xlsx")
  for (paquete in c("readxl", "janitor")) {
    if (!requireNamespace(paquete, quietly = TRUE)) {
      stop("Falta el paquete ", paquete, ". Instalarlo antes de ejecutar; ver README.md.")
    }
  }
  datos <- janitor::clean_names(as.data.frame(readxl::read_excel(entrada)))
  resultado <- preparar_series(datos, completar_ceros)
  resultado$procedencia <- list(
    archivo = basename(entrada), md5 = unname(tools::md5sum(entrada)),
    filas = nrow(datos), valores_fraccionarios = sum(datos$viajero != floor(datos$viajero)),
    train_size = 0.7, completar_ceros = completar_ceros,
    generado_utc = format(Sys.time(), tz = "UTC", usetz = TRUE)
  )
  if (!dir.exists(salida) && !dir.create(salida, recursive = TRUE)) {
    stop("No se pudo crear el directorio de salida.")
  }
  saveRDS(resultado, file.path(salida, "series_preparadas.rds"))
  write.csv(resultado$cobertura, file.path(salida, "cobertura.csv"), row.names = FALSE,
            fileEncoding = "UTF-8")
  write.csv(resultado$huecos, file.path(salida, "meses_imputados.csv"), row.names = FALSE,
            fileEncoding = "UTF-8")
  capture.output(sessionInfo(), file = file.path(salida, "sesion_R.txt"))
  print(resultado$cobertura, row.names = FALSE)
  message("Preparacion completada. Resultados locales en: ", salida)
  invisible(resultado)
}

if (sys.nframe() == 0L) main()
