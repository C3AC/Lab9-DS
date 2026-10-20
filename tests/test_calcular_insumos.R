source("scripts/preparar_series.R")
source("scripts/calcular_insumos.R")

fechas <- seq(as.Date("2009-01-01"), by = "month", length.out = 210)
d <- expand.grid(indice = seq_along(fechas), segmento = 1:3)
d$ano <- as.integer(format(fechas[d$indice], "%Y"))
d$mes_cod <- as.integer(format(fechas[d$indice], "%m"))
d$viajero <- d$segmento * 100 * 1.05^(d$ano - 2009) * (1 + d$mes_cod / 100)
d$pais <- c("El Salvador", "Guatemala", "Estados Unidos de Am\u00e9rica")[d$segmento]
d$via <- c("A\u00e9rea", "Terrestre", "Mar\u00edtima")[d$segmento]
d <- d[c("ano", "mes_cod", "viajero", "pais", "via")]
r <- calcular_insumos(preparar_series(d))
stopifnot(
  nrow(r$indicadores) == 14,
  nrow(r$estacionalidad) == 168,
  all(abs(r$crecimiento$cagr_pct - 5) < 1e-10),
  all(abs(r$crecimiento$crecimiento_pct - (1.05^10 - 1) * 100) < 1e-10),
  all(subset(r$anuales, ano == 2026)$meses == 6),
  all(r$semestres$meses == 6),
  all(is.na(subset(r$indicadores, ventana == "comun_2009_2019")$caida_pandemia_pct)),
  abs(r$kpis$valor[r$kpis$indicador == "caida_2019_2020_pct"] - 5) < 1e-10,
  abs(r$kpis$valor[r$kpis$indicador == "recuperacion_2022_sobre_2019_pct"] -
        1.05^3 * 100) < 1e-10
)
sin_cobertura <- preparar_series(d[d$ano != 2009, ])
error <- tryCatch({ calcular_insumos(sin_cobertura); NULL }, error = identity)
stopifnot(inherits(error, "error"), grepl("cobertura comun", conditionMessage(error)))
cat("Pruebas de insumos: OK (datos sinteticos).\n")
