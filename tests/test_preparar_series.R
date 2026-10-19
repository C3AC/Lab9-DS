# Synthetic data only. Run from the repository root with Rscript.
source("scripts/preparar_series.R")

fechas <- seq(as.Date("2009-01-01"), by = "month", length.out = 60)
datos <- expand.grid(indice = seq_along(fechas), segmento = 1:3)
datos$ano <- as.integer(format(fechas[datos$indice], "%Y"))
datos$mes_cod <- as.integer(format(fechas[datos$indice], "%m"))
datos$viajero <- datos$segmento * 10
datos$pais <- c("El Salvador", "Guatemala", "Estados Unidos de Am\u00e9rica")[datos$segmento]
datos$via <- c("A\u00e9rea", "Terrestre", "Mar\u00edtima")[datos$segmento]
datos <- datos[c("ano", "mes_cod", "viajero", "pais", "via")]

resultado <- preparar_series(datos[nrow(datos):1, ])
stopifnot(length(resultado$series) == 7,
          all(resultado$cobertura$meses == 60),
          all(resultado$cobertura$meses_train == 42),
          all(resultado$cobertura$meses_test == 18),
          all(resultado$cobertura$meses_imputados == 0),
          nrow(resultado$huecos) == 0,
          all(resultado$series$General$mensual$viajeros == 60),
          frequency(resultado$series$General$train$ts) == 12,
          identical(resultado$series$General$mensual$fecha, fechas),
          max(resultado$series$General$train$df$fecha) <
            min(resultado$series$General$test$df$fecha))

debe_fallar <- function(expr, patron) {
  error <- tryCatch({ force(expr); NULL }, error = identity)
  stopifnot(inherits(error, "error"), grepl(patron, conditionMessage(error)))
}
debe_fallar(preparar_series(datos[, -1]), "Faltan columnas")
debe_fallar(preparar_series(datos[FALSE, ]), "vacia")
debe_fallar(preparar_series(rbind(datos, datos[1, ])), "duplicadas")
malos <- datos
malos$viajero[1] <- NA_real_
debe_fallar(preparar_series(malos), "faltantes")
malos$viajero[1] <- -1
debe_fallar(preparar_series(malos), "no negativos")
malos$viajero[1] <- Inf
debe_fallar(preparar_series(malos), "finita")
malos <- datos
malos$mes_cod[1] <- 13
debe_fallar(preparar_series(malos), "meses invalidos")
debe_fallar(preparar_series(datos[datos$pais != "Guatemala", ]), "sin registros")
debe_fallar(preparar_series(datos[datos$ano == 2009, ]), "insuficiente")

con_hueco <- datos[!(datos$ano == 2010 & datos$mes_cod == 2), ]
debe_fallar(preparar_series(con_hueco), "Meses sin registros")
imputado <- preparar_series(con_hueco, completar_ceros = TRUE)
stopifnot(all(imputado$cobertura$meses_imputados == 1),
          nrow(imputado$huecos) == 7,
          imputado$series$General$mensual$viajeros[14] == 0,
          imputado$series$General$mensual$imputado_cero[14])

# An observed zero is not a missing month and must not be marked as imputed.
ceros <- datos
ceros$viajero[ceros$ano == 2010 & ceros$mes_cod == 2] <- 0
observado <- preparar_series(ceros)
stopifnot(observado$series$General$mensual$viajeros[14] == 0,
          !observado$series$General$mensual$imputado_cero[14])
cat("Pruebas de preparacion: OK (datos sinteticos).\n")
