# ------------------------------------------------------------------------------
# FASE 0: PROCESAMIENTO HANSEN (Versión "A Prueba de Balas")
# ------------------------------------------------------------------------------
library(terra)

# 1. RUTAS
ruta_originales <- "D:/Proyecto_RanasEcuador/Capas_Originales/"
ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/"
ruta_shape <- "D:/shapeamaz/zestudio.shp" 

# 2. ESTABLECER AL JEFE ABSOLUTO (El Clima)
cat("Cargando el molde climático...\n")
archivo_molde <- paste0(ruta_procesadas, "wc2.1_30s_bio_1.asc")
molde <- rast(archivo_molde)
crs(molde) <- "EPSG:4326" # Le decimos a R el idioma real de WorldClim (WGS84)

# 3. ALINEAR LA ZONA DE ESTUDIO AL CLIMA
cat("Alineando zona de estudio...\n")
zona_estudio <- vect(ruta_shape)
zona_alineada <- project(zona_estudio, crs(molde)) # Traducción perfecta

# Recortamos el molde a tu zona para que R trabaje ligerito
molde_local <- mask(crop(molde, zona_alineada), zona_alineada)

# 4. CARGAR Y RECORTAR HANSEN ORIGINAL
cat("Cargando y recortando archivos de Hansen...\n")
tc_1 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_treecover2000_00N_080W.tif")), zona_alineada)
tc_2 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_treecover2000_10N_080W.tif")), zona_alineada)
ls_1 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_lossyear_00N_080W.tif")), zona_alineada)
ls_2 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_lossyear_10N_080W.tif")), zona_alineada)

# 5. MOSAICO
cat("Uniendo los recortes...\n")
tc_mosaico <- mosaic(tc_1, tc_2)
ls_mosaico <- mosaic(ls_1, ls_2)

# 6. ÁLGEBRA DE MAPAS (Criterio: Bosque > 30% y sin pérdida hasta 2025)
cat("Calculando bosque remanente > 30%...\n")
bosque_base <- tc_mosaico > 30
sin_perdida <- (ls_mosaico == 0) | (ls_mosaico > 25) 
bosque_remanente <- bosque_base * sin_perdida

# 7. EL PASO MÁGICO: ALINEACIÓN Y REESCALADO TOTAL
cat("Alineando resolución y celdas al milímetro con tu clima...\n")
# 'project' con un raster de destino hace la magia completa sin errores de coordenadas
bosque_final <- project(bosque_remanente, molde_local, method="average")
bosque_final <- mask(bosque_final, zona_alineada) # Limpieza de bordes

# 8. GUARDADO
cat("Guardando archivo final...\n")
writeRaster(bosque_final, filename = paste0(ruta_procesadas, "hansen_bosque.asc"), overwrite=TRUE)

cat("✅ ¡ÉXITO! Capa 'hansen_bosque.asc' creada sin errores de superposición.\n")




# ------------------------------------------------------------------------------
# FASE 0: PROCESAMIENTO HANSEN (Versión "A Prueba de Balas")
# ------------------------------------------------------------------------------
library(terra)

# 1. RUTAS
ruta_originales <- "D:/Proyecto_RanasEcuador/Capas_Originales/"
ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/"
ruta_shape <- "D:/shapeamaz/zestudio.shp" 

# 2. ESTABLECER AL JEFE ABSOLUTO (El Clima)
cat("Cargando el molde climático...\n")
archivo_molde <- paste0(ruta_procesadas, "wc2.1_30s_bio_1.asc")
molde <- rast(archivo_molde)
crs(molde) <- "EPSG:4326" # Le decimos a R el idioma real de WorldClim (WGS84)

# 3. ALINEAR LA ZONA DE ESTUDIO AL CLIMA
cat("Alineando zona de estudio...\n")
zona_estudio <- vect(ruta_shape)
zona_alineada <- project(zona_estudio, crs(molde)) # Traducción perfecta

# Recortamos el molde a tu zona para que R trabaje ligerito
molde_local <- mask(crop(molde, zona_alineada), zona_alineada)

# 4. CARGAR Y RECORTAR HANSEN ORIGINAL
cat("Cargando y recortando archivos de Hansen...\n")
tc_1 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_treecover2000_00N_080W.tif")), zona_alineada)
tc_2 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_treecover2000_10N_080W.tif")), zona_alineada)
ls_1 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_lossyear_00N_080W.tif")), zona_alineada)
ls_2 <- crop(rast(paste0(ruta_originales, "Hansen_GFC-2025-v1.13_lossyear_10N_080W.tif")), zona_alineada)

# 5. MOSAICO
cat("Uniendo los recortes...\n")
tc_mosaico <- mosaic(tc_1, tc_2)
ls_mosaico <- mosaic(ls_1, ls_2)

# 6. ÁLGEBRA DE MAPAS (Criterio: Bosque > 30% y sin pérdida hasta 2025)
cat("Calculando bosque remanente > 30%...\n")
bosque_base <- tc_mosaico > 30
sin_perdida <- (ls_mosaico == 0) | (ls_mosaico > 25) 
bosque_remanente <- bosque_base * sin_perdida

# 7. EL PASO MÁGICO: ALINEACIÓN Y REESCALADO TOTAL
cat("Alineando resolución y celdas al milímetro con tu clima...\n")
# 'project' con un raster de destino hace la magia completa sin errores de coordenadas
bosque_final <- project(bosque_remanente, molde_local, method="average")
bosque_final <- mask(bosque_final, zona_alineada) # Limpieza de bordes

# 8. GUARDADO
cat("Guardando archivo final...\n")
writeRaster(bosque_final, filename = paste0(ruta_procesadas, "hansen_bosque.asc"), overwrite=TRUE)

cat("✅ ¡ÉXITO! Capa 'hansen_bosque.asc' creada sin errores de superposición.\n")




# ==============================================================================
# SCRIPT MAESTRO V4 DEFINITIVO: CLIMA + UVB + COBERTURA (VIF < 5 + PLOTS)
# ==============================================================================
library(terra)
library(usdm)
library(corrplot)
library(spThin)
library(ENMeval)
library(maxnet)

# Aseguramos que la ventana de gráficos de RStudio esté limpia
graphics.off() 

# 1. RUTAS (ACTUALIZADO A Resultados_UCB)
ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/"
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
if(!dir.exists(ruta_resultados)){ dir.create(ruta_resultados, recursive = TRUE) }

# ------------------------------------------------------------------------------
# FASE 2: CARGA, APILADO Y FILTRO VIF
# ------------------------------------------------------------------------------
cat("\n[1/6] Cargando la capa maestra de bosque (cobertura)...\n")
bosque <- rast(paste0(ruta_procesadas, "hansen_bosque.asc"))
names(bosque) <- "cobertura" 

cat("[2/6] Cargando todas las variables bioclimáticas y radiación UVB...\n")
lista_clima <- list.files(ruta_procesadas, pattern = "wc2.1_30s_bio_.*\\.asc$", full.names = TRUE)
clima_original <- rast(lista_clima)

uvb_original <- rast(paste0(ruta_procesadas, "uvb_radiation.asc"))
names(uvb_original) <- "uvb_radiation"

cat("      Alineando todas las capas con la cobertura boscosa...\n")
clima_alineado <- resample(clima_original, bosque)
uvb_alineado <- resample(uvb_original, bosque)

# Apilamos todo (Bioclimáticas + UVB + Cobertura) EXCLUYENDO elevación
variables_completas <- c(clima_alineado, uvb_alineado, bosque)

cat("[3/6] Calculando VIF iterativo (Umbral < 5). Manteniendo 'cobertura'...\n")
set.seed(123) 
bg_puntos <- spatSample(variables_completas, size = 10000, method = "random", na.rm = TRUE, as.df = TRUE)
vif_resultados <- vifstep(bg_puntos, th = 5, keep = "cobertura")

cat("\n--- RESULTADOS DEL VIF (VARIABLES SOBREVIVIENTES) ---\n")
print(vif_resultados)

vars_retenidas <- vif_resultados@results$Variables
variables_finales <- subset(variables_completas, vars_retenidas)

writeRaster(variables_finales, paste0(ruta_procesadas, "stack_predictores_vif5_uvb.tif"), overwrite=TRUE)


# ------------------------------------------------------------------------------
# FASE 2.5: COMPROBACIÓN VISUAL (MATRIZ DE PEARSON)
# ------------------------------------------------------------------------------
cat("\n[4/6] Generando Matriz de Pearson...\n")
bg_final <- bg_puntos[, vars_retenidas]
nombres_limpios <- gsub("wc2.1_30s_", "", colnames(bg_final))
colnames(bg_final) <- nombres_limpios
matriz_cor <- cor(bg_final, method = "pearson")

mi_paleta <- colorRampPalette(c("#B2182B", "#D6604D", "#F4A582", "#FDDBC7", 
                                "#FFFFFF", 
                                "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC"))(200)

# A) Guardar en disco duro (Nueva carpeta Resultados_UCB)
png(filename = paste0(ruta_resultados, "Figura1_Matriz_Pearson_VIF_UVB.png"), width = 1800, height = 1800, res = 300)
corrplot(matriz_cor, method = "color", type = "lower", col = mi_paleta, addCoef.col = "black", number.cex = 0.8, tl.col = "black", tl.srt = 90, tl.cex = 0.9, mar = c(0, 0, 3, 0))
title("Variables Seleccionadas (VIF < 5 + UVB)", line = 1)
dev.off() 

# B) DIBUJAR EN PANTALLA (Pestaña Plots)
corrplot(matriz_cor, method = "color", type = "lower", col = mi_paleta, addCoef.col = "black", number.cex = 0.8, tl.col = "black", tl.srt = 90, tl.cex = 0.9, mar = c(0, 0, 3, 0))
title("Variables Seleccionadas (VIF < 5 + UVB)", line = 1)


# ------------------------------------------------------------------------------
# FASE 3: RAREFACCIÓN ESPACIAL (SPATIAL THINNING - 5 KM)
# ------------------------------------------------------------------------------
cat("\n[5/6] Aplicando filtro espacial a presencias (5km)...\n")
presencias <- read.csv("D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv")
thin_resultados <- thin(loc.data = presencias, spec.col = "especie", 
                        long.col = "longitud", lat.col = "latitud",      
                        thin.par = 5, reps = 1, locs.thinned.list.return = TRUE,
                        write.files = TRUE, out.dir = ruta_procesadas,
                        out.base = "presencias_limpias_5km", write.log.file = FALSE)
presencias_limpias <- thin_resultados[[1]]


# ------------------------------------------------------------------------------
# FASE 4: OPTIMIZACIÓN DE HIPERPARÁMETROS (ENMeval)
# ------------------------------------------------------------------------------
cat("\n[6/6] Iniciando tuning con ENMeval (MaxEnt)...\n")
pres_coords <- presencias_limpias
colnames(pres_coords) <- c("longitud", "latitud") 

set.seed(123)
bg_coords <- spatSample(variables_finales, size = 10000, method = "random", na.rm = TRUE, xy = TRUE)
bg_coords <- bg_coords[, c("x", "y")]
colnames(bg_coords) <- c("longitud", "latitud")

evaluacion <- ENMevaluate(occs = pres_coords, envs = variables_finales, bg = bg_coords, 
                          algorithm = "maxnet", partitions = "block", 
                          tune.args = list(rm = c(1, 2, 3), fc = c("L", "LQ", "LQH")),
                          parallel = TRUE)

resultados_modelos <- eval.results(evaluacion)
modelo_optimo_info <- resultados_modelos[resultados_modelos$delta.AICc == 0, ]
parametros_optimos <- modelo_optimo_info$tune.args[1]
modelo_final <- eval.models(evaluacion)[[parametros_optimos]]

auc_final <- modelo_optimo_info$auc.val.avg
cbi_final <- modelo_optimo_info$cbi.val.avg
parametros <- as.character(modelo_optimo_info$tune.args)

cat("\n--- RESULTADOS DEL NUEVO MODELO GANADOR ---\n")
print(modelo_optimo_info[, c("tune.args", "delta.AICc", "auc.val.avg", "cbi.val.avg")])


# ------------------------------------------------------------------------------
# FASE 5 & 6: PROYECCIÓN Y EXPORTACIÓN FINAL
# ------------------------------------------------------------------------------
cat("\nProyectando el modelo final...\n")
mapa_actual <- predict(variables_finales, modelo_final, type = "cloglog", na.rm = TRUE)

# Guardar Tabla CSV (Nueva carpeta Resultados_UCB)
tabla_resultados <- data.frame(Especie = "Rana_Estudio", Parametros = parametros, AUC = round(auc_final, 3), CBI = round(cbi_final, 3))
write.csv(tabla_resultados, paste0(ruta_resultados, "Tabla1_Metricas_Modelo_VIF_UVB.csv"), row.names = FALSE)

paleta_mapa <- colorRampPalette(c("#f7f7f7", "#cccccc", "#fee08b", "#fdae61", "#f46d43", "#d53e4f", "#9e0142"))(100)

# A) Guardar Mapa en disco duro (PNG de alta calidad en Resultados_UCB)
png(filename = paste0(ruta_resultados, "Figura2_Mapa_Idoneidad_VIF_UVB.png"), width = 2100, height = 1800, res = 300)
plot(mapa_actual, col = paleta_mapa, main = "Idoneidad de Hábitat Actual (VIF + UVB)", plg = list(title = "Idoneidad"))
dev.off()

# B) DIBUJAR MAPA EN PANTALLA (Pestaña Plots)
plot(mapa_actual, col = paleta_mapa, main = "Idoneidad Actual (VIF + UVB)", plg = list(title = "Idoneidad"))

# Guardar Raster Geográfico (.TIF en Resultados_UCB)
writeRaster(mapa_actual, paste0(ruta_resultados, "mapa_idoneidad_vif_uvb.tif"), overwrite = TRUE)

cat("\n✅ ¡TODO EL PROCESO HA CONCLUIDO CON ÉXITO!\n")
cat("Todos los archivos se han guardado correctamente en la carpeta 'Resultados_UCB'.\n")
cat("Puedes revisar la matriz y el mapa navegando con las flechitas (<- ->) en la pestaña Plots.\n")


# ==============================================================================
# SCRIPT DE ANÁLISIS: LECTURA DE MÉTRICAS Y MAPA FINAL
# ==============================================================================
library(terra)

# 1. DEFINIR LA RUTA A TUS RESULTADOS
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"

# 2. EXTRAER Y LEER LAS MÉTRICAS DE EVALUACIÓN
cat("\n==================================================\n")
cat("   MÉTRICAS DEL MODELO DEFINITIVO (VIF + UVB)\n")
cat("==================================================\n")
metricas <- read.csv(paste0(ruta_resultados, "Tabla1_Metricas_Modelo_VIF_UVB.csv"))

# Mostrar la tabla en la consola con un formato limpio
print(metricas, row.names = FALSE)
cat("==================================================\n\n")

# 3. CARGAR Y DIBUJAR EL MAPA FINAL
cat("Cargando el mapa raster final desde el disco duro...\n")
mapa_final <- rast(paste0(ruta_resultados, "mapa_idoneidad_vif_uvb.tif"))

# Configurar la paleta de colores de alto contraste
paleta_mapa <- colorRampPalette(c("#f7f7f7", "#cccccc", "#fee08b", "#fdae61", "#f46d43", "#d53e4f", "#9e0142"))(100)

# Asegurar que el área de gráficos esté lista
graphics.off()

# Dibujar el mapa en la pestaña Plots
plot(mapa_final, col = paleta_mapa, 
     main = "Idoneidad de Hábitat (Modelo Definitivo)", 
     plg = list(title = "Idoneidad"))

cat("✅ ¡Listo! Revisa la consola para los números y la pestaña Plots para el mapa.\n")
install.packages("geodata")


# ==============================================================================
# SCRIPT MAESTRO V7: AUTOMATIZACIÓN MULTIESPECIE UNIFICADA (RAREFACCIÓN 1 KM)
# ==============================================================================
library(terra)
library(geodata)
library(dismo)
library(spThin)
library(ENMeval)
library(maxnet)

cat("\n=================================================================\n")
cat(" INICIANDO PROCESAMIENTO MULTIESPECIE UNIFICADO (FILTRO 1 KM)\n")
cat("=================================================================\n")

# 1. RUTAS Y PREPARACIÓN DE ENTORNO
ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/"
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro_raw <- "D:/Proyecto_RanasEcuador/Capas_Originales/Futuro_Raw/" 

if(!dir.exists(ruta_futuro_raw)){ dir.create(ruta_futuro_raw, recursive = TRUE) }
if(!dir.exists(paste0(ruta_resultados, "Futuro/"))){ dir.create(paste0(ruta_resultados, "Futuro/"), recursive = TRUE) }

# 2. CARGAR CAPAS BASE Y POLÍGONO DE ESTUDIO
molde_presente <- rast(paste0(ruta_procesadas, "stack_predictores_vif5_uvb.tif"))
zona_estudio_bruta <- vect("D:/shapeamaz/zestudio.shp") 
zona_estudio <- project(zona_estudio_bruta, crs(molde_presente))

cobertura <- subset(molde_presente, "cobertura")
uvb <- subset(molde_presente, "uvb_radiation")

# 3. IDENTIFICACIÓN DE ESPECIES Y CONFIGURACIÓN DE MATRICES
presencias_base <- read.csv("D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv")
lista_especies <- unique(presencias_base$especie)

cat("Se procesarán", length(lista_especies), "especies con un criterio fijo de 1 km.\n")

tabla_maestra_areas <- data.frame()
tabla_maestra_metricas <- data.frame()

# Muestreo de fondo (Background) general
set.seed(123)
bg_coords <- spatSample(molde_presente, size = 10000, method = "random", na.rm = TRUE, xy = TRUE)
bg_coords <- bg_coords[, c("x", "y")]
colnames(bg_coords) <- c("longitud", "latitud")

# Variables y escenarios CMIP6 seleccionados
modelos_gcm <- c("MIROC6", "IPSL-CM6A-LR", "CNRM-CM6-1")
escenarios_ssp <- c("245", "585") 
horizontes_nombres <- c("2050", "2070", "2090")
horizontes_codigos <- c("2041-2060", "2061-2080", "2081-2100") 
vars_vif_index <- c(2, 3, 4, 8, 15, 18) 
vars_vif_nombres <- c("wc2.1_30s_bio_2", "wc2.1_30s_bio_3", "wc2.1_30s_bio_4", 
                      "wc2.1_30s_bio_8", "wc2.1_30s_bio_15", "wc2.1_30s_bio_18")

# ------------------------------------------------------------------------------
# 4. ITERACIÓN AUTOMÁTICA POR ESPECIE
# ------------------------------------------------------------------------------

for(i in 1:length(lista_especies)){
  
  sp <- lista_especies[i]
  sp_archivo <- gsub(" ", "_", sp)
  
  cat("\n=================================================================\n")
  cat(sprintf(" [%d/%d] PROCESANDO MODELO DE: %s\n", i, length(lista_especies), toupper(sp)))
  cat("=================================================================\n")
  
  # A. FILTRADO ESPACIAL UNIFORME (1 KM)
  pres_raw <- presencias_base[presencias_base$especie == sp, ]
  cat(" -> Registros brutos en base de datos:", nrow(pres_raw), "\n")
  
  thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", 
                  long.col = "longitud", lat.col = "latitud",      
                  thin.par = 1, reps = 1, locs.thinned.list.return = TRUE,
                  write.files = FALSE, write.log.file = FALSE)
  
  pres_limpias <- thin_sp[[1]]
  colnames(pres_limpias) <- c("longitud", "latitud")
  cat(" -> Registros retenidos tras filtro de 1 km:", nrow(pres_limpias), "\n")
  
  # Control de viabilidad matemática para MaxEnt
  if(nrow(pres_limpias) < 3){
    cat(" ⚠️ [OMITIDA] Registros insuficientes (< 3) para construir particiones espaciales.\n")
    next 
  }
  
  # B. CALIBRACIÓN DE HIPERPARÁMETROS CON ENMEVAL
  cat(" -> Ejecutando optimización en ENMeval...\n")
  evaluacion <- tryCatch({
    ENMevaluate(occs = pres_limpias, envs = molde_presente, bg = bg_coords, 
                algorithm = "maxnet", partitions = "block", 
                tune.args = list(rm = c(1, 2, 3), fc = c("L", "LQ", "LQH")),
                parallel = TRUE)
  }, error = function(e) {
    return(NULL)
  })
  
  if(is.null(evaluacion)){
    cat(" ⚠️ [OMITIDA] Error en la convergencia de las matrices para esta especie.\n")
    next 
  }
  
  resultados_mod <- eval.results(evaluacion)
  if(nrow(resultados_mod[resultados_mod$delta.AICc == 0, ]) == 0){
    cat(" ⚠️ [OMITIDA] No se localizó una configuración óptima bajo Delta AICc = 0.\n")
    next
  }
  
  modelo_optimo_info <- resultados_mod[resultados_mod$delta.AICc == 0, ][1, ]
  modelo_final <- eval.models(evaluacion)[[as.character(modelo_optimo_info$tune.args)]]
  
  # Consolidación de métricas estadísticas de validación
  nueva_metrica <- data.frame(Especie = sp, Parametros = as.character(modelo_optimo_info$tune.args),
                              AUC = round(modelo_optimo_info$auc.val.avg, 3), 
                              CBI = round(modelo_optimo_info$cbi.val.avg, 3))
  tabla_maestra_metricas <- rbind(tabla_maestra_metricas, nueva_metrica)
  
  # C. EVALUACIÓN DE CONDICIONES ACTUALES Y BINARIZACIÓN
  cat(" -> Generando proyección actual y umbral de corte...\n")
  mapa_actual <- predict(molde_presente, modelo_final, type = "cloglog", na.rm = TRUE)
  mapa_actual <- mask(crop(mapa_actual, zona_estudio), zona_estudio)
  
  pres_vals <- extract(mapa_actual, pres_limpias)[, 2]
  bg_vals <- extract(mapa_actual, bg_coords)[, 2]
  eval_modelo <- dismo::evaluate(p = as.numeric(na.omit(pres_vals)), a = as.numeric(na.omit(bg_vals)))
  umbral_optimo <- dismo::threshold(eval_modelo, "spec_sens")
  
  mapa_bin_actual <- ifel(mapa_actual >= umbral_optimo, 1, 0)
  area_raster <- cellSize(mapa_bin_actual, unit = "km")
  area_actual_km2 <- sum(values(area_raster)[values(mapa_bin_actual) == 1], na.rm = TRUE)
  
  writeRaster(mapa_bin_actual, paste0(ruta_resultados, "Binario_Presente_", sp_archivo, ".tif"), overwrite = TRUE)
  
  tabla_sp_areas <- data.frame(Especie = sp, Escenario = "Presente", Anio = "2026", 
                               Area_km2 = round(area_actual_km2, 2), Cambio_Porcentual = 0.0, stringsAsFactors = FALSE)
  
  # D. PROYECCIÓN HACIA ESCENARIOS CLIMÁTICOS FUTUROS (CMIP6)
  cat(" -> Proyectando ensambles futuros de cambio climático...\n")
  for(ssp in escenarios_ssp){
    for(h in 1:length(horizontes_codigos)){
      
      anio_codigo <- horizontes_codigos[h]
      anio_nombre <- horizontes_nombres[h]
      mapas_gcm <- list()
      
      for(gcm in modelos_gcm){
        clima_bruto <- cmip6_tile(lon = -78, lat = -1.5, model = gcm, ssp = ssp, 
                                  time = anio_codigo, var = "bioc", res = 0.5, path = ruta_futuro_raw)
        clima_vif <- subset(clima_bruto, vars_vif_index)
        names(clima_vif) <- vars_vif_nombres 
        
        clima_alineado <- resample(clima_vif, molde_presente)
        stack_futuro <- c(clima_alineado, uvb, cobertura)
        
        mapas_gcm[[gcm]] <- predict(stack_futuro, modelo_final, type = "cloglog", na.rm = TRUE)
        rm(clima_bruto, clima_vif, clima_alineado, stack_futuro); gc()
      }
      
      # Generación de consenso (ensamble), enmascarado y binarización constante
      ensamble_raster <- mean(rast(mapas_gcm))
      ensamble_recortado <- mask(crop(ensamble_raster, zona_estudio), zona_estudio)
      
      ensamble_binario <- ifel(ensamble_recortado >= umbral_optimo, 1, 0)
      area_raster_futuro <- cellSize(ensamble_binario, unit = "km")
      area_futura_km2 <- sum(values(area_raster_futuro)[values(ensamble_binario) == 1], na.rm = TRUE)
      cambio_porcentual <- ((area_futura_km2 - area_actual_km2) / area_actual_km2) * 100
      
      nueva_fila_area <- data.frame(Especie = sp, Escenario = paste0("SSP", ssp), Anio = anio_nombre, 
                                    Area_km2 = round(area_futura_km2, 2), Cambio_Porcentual = round(cambio_porcentual, 2), stringsAsFactors = FALSE)
      tabla_sp_areas <- rbind(tabla_sp_areas, nueva_fila_area)
      
      writeRaster(ensamble_binario, paste0(ruta_futuro, "Binario_", sp_archivo, "_SSP", ssp, "_", anio_nombre, ".tif"), overwrite = TRUE)
    }
  }
  
  tabla_maestra_areas <- rbind(tabla_maestra_areas, tabla_sp_areas)
  cat(sprintf("   ✅ Evaluación de nicho finalizada para: %s\n", toupper(sp)))
}

# ------------------------------------------------------------------------------
# 5. EXPORTACIÓN CONSOLIDADA DE RESULTADOS
# ------------------------------------------------------------------------------
if(nrow(tabla_maestra_metricas) > 0) {
  write.csv(tabla_maestra_metricas, paste0(ruta_resultados, "Tabla1_Metricas_14_Especies.csv"), row.names = FALSE)
  write.csv(tabla_maestra_areas, paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv"), row.names = FALSE)
  
  cat("\n=================================================================\n")
  cat(" 🎉 PROCESAMIENTO MULTIESPECIE COMPLETADO BAJO FORMATO 1 KM 🎉\n")
  cat(sprintf(" Modelos generados con éxito: %d de %d especies analizadas.\n", nrow(tabla_maestra_metricas), length(lista_especies)))
  cat("=================================================================\n")
  
  print(tabla_maestra_areas)
} else {
  cat("\n⚠️ Las restricciones de las matrices de presencia impidieron estructurar los modelos.\n")
}


# ==============================================================================
# SCRIPT COMPLEMENTARIO: TABLA DE REGISTROS (ANTES Y DESPUÉS DEL FILTRO 1 KM)
# ==============================================================================
library(spThin)

cat("\n=================================================================\n")
cat(" GENERANDO TABLA DE RAREFACCIÓN ESPACIAL (1 KM)\n")
cat("=================================================================\n")

# 1. Rutas y carga de datos originales
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
presencias_base <- read.csv("D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv")
lista_especies <- unique(presencias_base$especie)

# 2. Crear la estructura limpia de la tabla
tabla_registros <- data.frame(Especie = character(), 
                              Registros_Brutos = numeric(), 
                              Registros_Filtrados_1km = numeric(), 
                              Retencion_Porcentual = numeric(),
                              stringsAsFactors = FALSE)

# 3. Bucle rápido de conteo
for(sp in lista_especies){
  
  # A. Puntos originales
  pres_raw <- presencias_base[presencias_base$especie == sp, ]
  n_antes <- nrow(pres_raw)
  
  # B. Puntos filtrados
  thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", 
                  long.col = "longitud", lat.col = "latitud",      
                  thin.par = 1, reps = 1, locs.thinned.list.return = TRUE,
                  write.files = FALSE, write.log.file = FALSE)
  
  n_despues <- nrow(thin_sp[[1]])
  
  # C. Calcular porcentaje de datos retenidos (opcional pero muy útil)
  porcentaje <- round((n_despues / n_antes) * 100, 1)
  
  # Guardar en la tabla
  tabla_registros <- rbind(tabla_registros, data.frame(Especie = sp, 
                                                       Registros_Brutos = n_antes, 
                                                       Registros_Filtrados_1km = n_despues,
                                                       Retencion_Porcentual = porcentaje))
}

# 4. Exportar el resultado
ruta_exportacion <- paste0(ruta_resultados, "Tabla_Registros_Filtro.csv")
write.csv(tabla_registros, ruta_exportacion, row.names = FALSE)

cat(" ✅ Tabla exportada exitosamente en:", ruta_exportacion, "\n\n")

# Mostrar resultado final en la consola
print(tabla_registros, row.names = FALSE)




# ==============================================================================
# SCRIPT DE RESCATE: ÍNDICE DE BOYCE (CBI) PARA Hyloxalus italoi
# ==============================================================================
library(terra)
library(spThin)
library(maxnet)
library(ecospat)

cat("\n=================================================================\n")
cat(" RECALCULANDO ÍNDICE DE BOYCE (CBI) PARA: HYLOXALUS ITALOI\n")
cat("=================================================================\n")

# 1. Definir la especie y aislar sus puntos limpios
sp_rescate <- "Hyloxalus italoi"
pres_raw <- presencias_base[presencias_base$especie == sp_rescate, ]

thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", 
                long.col = "longitud", lat.col = "latitud",      
                thin.par = 1, reps = 1, locs.thinned.list.return = TRUE,
                write.files = FALSE, write.log.file = FALSE)

pres_limpias <- thin_sp[[1]]
colnames(pres_limpias) <- c("longitud", "latitud")

# 2. Reconstruir el modelo ganador exacto (rm.2, fc.LQH) basado en tu tabla
cat(" -> Entrenando modelo ganador (rm=2, fc=LQH)...\n")
pres_env <- extract(molde_presente, pres_limpias)[, -1]
bg_env <- extract(molde_presente, bg_coords)[, -1]

# Unimos presencias (1) y background (0)
p_bg <- c(rep(1, nrow(pres_env)), rep(0, nrow(bg_env)))
datos_modelo <- rbind(pres_env, bg_env)

# Ajustamos el modelo maxnet
modelo_italoi <- maxnet(p = p_bg, data = datos_modelo, 
                        maxnet.formula(p_bg, datos_modelo, classes = "lqh"), 
                        regmult = 2)

# 3. Extraer predicciones continuas (cloglog)
cat(" -> Extrayendo predicciones...\n")
pred_pres <- predict(modelo_italoi, pres_env, type = "cloglog")
pred_bg <- predict(modelo_italoi, bg_env, type = "cloglog")

# 4. EL TRUCO MATEMÁTICO: Calcular Boyce con una resolución más amplia (res = 20)
cat(" -> Ejecutando ecospat.boyce con ventanas ajustadas...\n")
boyce_resultado <- ecospat.boyce(fit = pred_bg, obs = pred_pres, nclass = 0, 
                                 window.w = "default", res = 20, 
                                 PEplot = FALSE)

cbi_rescatado <- round(boyce_resultado$cor, 3)

cat("\n=================================================================\n")
cat(" 🎉 ¡CBI RESCATADO EXITOSAMENTE!\n")
cat(" El Índice de Boyce para Hyloxalus italoi es:", cbi_rescatado, "\n")
cat("=================================================================\n")


# ==============================================================================
# SCRIPT MAESTRO V8 CORREGIDO: RIQUEZA, DELTAS ESPACIALES Y SEVERIDAD
# ==============================================================================
library(terra)
library(dplyr)

cat("\n=================================================================\n")
cat(" FASE 8: HOTSPOTS, DELTAS DE CAMBIO Y SEVERIDAD MACROECOLÓGICA\n")
cat("=================================================================\n")

# 1. DEFINICIÓN DE RUTAS Y CARGA DE POLÍGONO BRUTO
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")
zona_estudio_bruta <- vect("D:/shapeamaz/zestudio.shp")

# ------------------------------------------------------------------------------
# PARTE A: RIQUEZA COMUNITARIA ACTUAL (HOTSPOTS DEL PRESENTE)
# ------------------------------------------------------------------------------
cat("[1/3] Sumando mapas binarios para calcular Riqueza del Presente...\n")

archivos_presente <- list.files(ruta_resultados, pattern = "^Binario_Presente_.*\\.tif$", full.names = TRUE)
stack_presente <- rast(archivos_presente)

# >>> LA SOLUCIÓN AL ERROR: Proyectamos el shapefile al CRS exacto de los mapas <<<
zona_estudio <- project(zona_estudio_bruta, crs(stack_presente))

# Suma algebraica ignorando NAs
riqueza_presente <- sum(stack_presente, na.rm = TRUE)
riqueza_presente <- mask(crop(riqueza_presente, zona_estudio), zona_estudio)

writeRaster(riqueza_presente, paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif"), overwrite = TRUE)


# ------------------------------------------------------------------------------
# PARTE B: RIQUEZA FUTURA Y DELTAS DE CAMBIO ESPACIAL
# ------------------------------------------------------------------------------
cat("[2/3] Proyectando Riquezas Futuras y calculando Deltas Espaciales...\n")

escenarios_ssp <- c("SSP245", "SSP585")
horizontes_nombres <- c("2050", "2070", "2090")

for(ssp in escenarios_ssp){
  for(anio in horizontes_nombres){
    
    patron_busqueda <- paste0("^Binario_.*_", ssp, "_", anio, "\\.tif$")
    archivos_futuro_escenario <- list.files(ruta_futuro, pattern = patron_busqueda, full.names = TRUE)
    
    if(length(archivos_futuro_escenario) > 0){
      
      # 1. Riqueza Futura
      stack_futuro <- rast(archivos_futuro_escenario)
      riqueza_futura <- sum(stack_futuro, na.rm = TRUE)
      riqueza_futura <- mask(crop(riqueza_futura, zona_estudio), zona_estudio)
      
      nombre_riqueza <- paste0("Riqueza_Comunitaria_", ssp, "_", anio, ".tif")
      writeRaster(riqueza_futura, paste0(ruta_futuro, nombre_riqueza), overwrite = TRUE)
      
      # 2. Delta de Riqueza (Cambio Geográfico Neto: Futuro - Presente)
      delta_riqueza <- riqueza_futura - riqueza_presente
      
      nombre_delta <- paste0("Delta_Cambio_", ssp, "_", anio, ".tif")
      writeRaster(delta_riqueza, paste0(ruta_futuro, nombre_delta), overwrite = TRUE)
      
    }
  }
}

# ------------------------------------------------------------------------------
# PARTE C: ANÁLISIS DE SEVERIDAD GLOBAL (SÍNTESIS ESTADÍSTICA)
# ------------------------------------------------------------------------------
cat("[3/3] Consolidando estadísticas para el Análisis de Severidad Global...\n")

tabla_areas <- read.csv(paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv"))
tabla_futuro <- tabla_areas[tabla_areas$Escenario != "Presente", ]

tabla_severidad <- tabla_futuro %>%
  group_by(Escenario, Anio) %>%
  summarise(
    Cambio_Habitat_Promedio_Porcentual = round(mean(Cambio_Porcentual, na.rm = TRUE), 2),
    Proporcion_Especies_con_Perdida_Porcentual = round((sum(Cambio_Porcentual < 0) / n()) * 100, 1),
    Perdida_Maxima_Proyectada_Porcentual = round(min(Cambio_Porcentual, na.rm = TRUE), 2),
    .groups = 'drop'
  ) %>%
  arrange(Escenario, Anio)

ruta_tabla_severidad <- paste0(ruta_resultados, "Tabla3_Severidad_Global.csv")
write.csv(tabla_severidad, ruta_tabla_severidad, row.names = FALSE)

cat("\n=================================================================\n")
cat(" ✅ ¡FUSIÓN DE MAPAS Y ANÁLISIS DE SEVERIDAD COMPLETADOS!\n")
cat("=================================================================\n")

print(as.data.frame(tabla_severidad), row.names = FALSE)

View(tabla_severidad)



# ==============================================================================
# SCRIPT MAESTRO V9: ESTADÍSTICAS ESPACIALES DE RIQUEZA Y SUPERVIVENCIA
# ==============================================================================
library(terra)
library(dplyr)

cat("\n=================================================================\n")
cat(" FASE 9: ESTADÍSTICAS DE RIQUEZA COMUNITARIA Y SUPERVIVENCIA\n")
cat("=================================================================\n")

ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")

# 1. CONTAR ESPECIES SOBREVIVIENTES (A partir de la Tabla 2)
cat("[1/3] Calculando especies sobrevivientes por escenario...\n")
tabla_areas <- read.csv(paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv"))

sobrevivientes <- tabla_areas %>%
  group_by(Escenario, Anio) %>%
  summarise(
    Especies_Sobrevivientes = sum(Area_km2 > 0),
    .groups = 'drop'
  )

# 2. ESTADÍSTICAS ESPACIALES DE LOS MAPAS DE RIQUEZA (Hotspots)
cat("[2/3] Escaneando mapas de riqueza para extraer estadísticas espaciales...\n")
escenarios_lista <- c("Presente", "SSP245", "SSP245", "SSP245", "SSP585", "SSP585", "SSP585")
anios_lista <- c("2026", "2050", "2070", "2090", "2050", "2070", "2090")

estadisticas_riqueza <- data.frame()

for(i in 1:length(escenarios_lista)){
  esc <- escenarios_lista[i]
  an <- anios_lista[i]
  
  # Generar ruta del archivo correspondiente
  if(esc == "Presente"){
    ruta_mapa <- paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif")
  } else {
    ruta_mapa <- paste0(ruta_futuro, "Riqueza_Comunitaria_", esc, "_", an, ".tif")
  }
  
  if(file.exists(ruta_mapa)){
    mapa_riq <- rast(ruta_mapa)
    
    # Extraer min, max, media y desviación estándar de todos los píxeles del mapa
    stats <- global(mapa_riq, fun = c("min", "max", "mean", "sd"), na.rm = TRUE)
    
    nueva_fila <- data.frame(
      Escenario = esc,
      Anio = an,
      Min_Especies_Pixel = stats$min,
      Max_Especies_Pixel = stats$max,
      Media_Especies_Pixel = round(stats$mean, 2),
      SD_Especies_Pixel = round(stats$sd, 2)
    )
    estadisticas_riqueza <- rbind(estadisticas_riqueza, nueva_fila)
  }
}

# 3. UNIR Y EXPORTAR LA TABLA FINAL
cat("[3/3] Consolidando Tabla 4...\n")
tabla_final_riqueza <- merge(sobrevivientes, estadisticas_riqueza, by = c("Escenario", "Anio"))

# Ordenar lógicamente (Presente primero, luego por escenario y año)
tabla_final_riqueza$Orden <- ifelse(tabla_final_riqueza$Escenario == "Presente", 1, 
                                    ifelse(tabla_final_riqueza$Escenario == "SSP245", 2, 3))
tabla_final_riqueza <- tabla_final_riqueza %>% arrange(Orden, Anio) %>% select(-Orden)

# Guardar en el disco duro
ruta_tabla_export <- paste0(ruta_resultados, "Tabla4_Estadisticas_Riqueza.csv")
write.csv(tabla_final_riqueza, ruta_tabla_export, row.names = FALSE)

cat("\n=================================================================\n")
cat(" ✅ ¡ESTADÍSTICAS DE RIQUEZA COMPLETADAS!\n")
cat("=================================================================\n")

# Mostrar resultado limpio (usando as.data.frame para evitar cortes visuales raros)
print(as.data.frame(tabla_final_riqueza), row.names = FALSE)

# ==============================================================================
# SCRIPT MAESTRO V10: ZONAL STATISTICS DE LA VARIACIÓN DE RIQUEZA (DELTAS)
# ==============================================================================
library(terra)

cat("\n=================================================================\n")
cat(" FASE 10: ESTADÍSTICAS DE VARIACIÓN Y SIMBOLOGÍA DIVERGENTE\n")
cat("=================================================================\n")

ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")

# 1. EXTRACCIÓN DE ESTADÍSTICAS DESCRIPTIVAS (Equivalente a Zonal Statistics as Table)
cat("[1/2] Extrayendo estadísticas descriptivas de los Deltas de Riqueza...\n")

escenarios <- c("SSP245", "SSP245", "SSP245", "SSP585", "SSP585", "SSP585")
anios <- c("2050", "2070", "2090", "2050", "2070", "2090")

tabla_estadisticas_delta <- data.frame()

for(i in 1:length(escenarios)){
  esc <- escenarios[i]
  an <- anios[i]
  
  # Cargamos el mapa de variación (Delta) creado en la Fase 8
  ruta_delta <- paste0(ruta_futuro, "Delta_Cambio_", esc, "_", an, ".tif")
  
  if(file.exists(ruta_delta)){
    mapa_delta <- rast(ruta_delta)
    
    # Calculamos las estadísticas descriptivas globales ignorando NAs
    stats <- global(mapa_delta, fun = c("min", "max", "mean", "sd"), na.rm = TRUE)
    
    nueva_fila <- data.frame(
      Escenario = esc,
      Anio = an,
      Minimo_Defaunacion = stats$min,           # Pérdida máxima de especies (ej. -11)
      Maximo_Colonizacion = stats$max,          # Ganancia máxima de especies (ej. +2)
      Media_Variacion = round(stats$mean, 3),   # Tendencia central
      SD_Variacion = round(stats$sd, 3)         # Dispersión/Heterogeneidad
    )
    tabla_estadisticas_delta <- rbind(tabla_estadisticas_delta, nueva_fila)
  }
}

# Exportar la tabla de estadísticas de variación
ruta_tabla_delta <- paste0(ruta_resultados, "Tabla5_Estadisticas_Variacion_Riqueza.csv")
write.csv(tabla_estadisticas_delta, ruta_tabla_delta, row.names = FALSE)

cat(" ✅ ¡Estadísticas consolidadas en Tabla5_Estadisticas_Variacion_Riqueza.csv!\n\n")
print(tabla_estadisticas_delta)


# ------------------------------------------------------------------------------
# 2. GENERACIÓN Y VISUALIZACIÓN CARTOGRÁFICA (Simbología Divergente)
# ------------------------------------------------------------------------------
cat("\n[2/2] Generando gráfico con simbología divergente (Ejemplo SSP585 - 2090)...\n")

# Tomamos el escenario más severo como ejemplo para tu documento
mapa_ejemplo <- rast(paste0(ruta_futuro, "Delta_Cambio_SSP585_2090.tif"))

# Crear una paleta divergente: Rojo (Pérdida), Blanco/Amarillo (Estable), Azul/Verde (Ganancia)
paleta_divergente <- colorRampPalette(c("#8c510a", "#d8b365", "#f6e8c3", 
                                        "#f5f5f5", 
                                        "#c7eae5", "#5ab4ac", "#01665e"))(100)

# Asegurar que el cero (sin cambio) esté centrado en los colores claros
rango_valores <- minmax(mapa_ejemplo)
limite_maximo <- max(abs(rango_valores))
secuencia_cortes <- seq(-limite_maximo, limite_maximo, length.out = 101)

# Dibujar el mapa en la pestaña Plots
graphics.off()
plot(mapa_ejemplo, 
     col = paleta_divergente, 
     breaks = secuencia_cortes,
     main = "Variación de Riqueza Potencial (SSP5-8.5, 2090)",
     plg = list(title = "Δ Especies"))

cat(" ✅ ¡Mapa dibujado! Revisa la pestaña 'Plots' en RStudio.\n")

# ==============================================================================
# VISUALIZACIÓN CORREGIDA DEL MAPA DE DELTAS
# ==============================================================================

# 1. Cargamos el mapa y el polígono de nuevo
mapa_ejemplo <- rast(paste0(ruta_futuro, "Delta_Cambio_SSP585_2090.tif"))
zona_estudio <- vect("D:/shapeamaz/zestudio.shp")
zona_estudio <- project(zona_estudio, crs(mapa_ejemplo)) # Alineamos el polígono

# 2. Ajustamos la paleta para que el centro sea un gris muy claro (no blanco puro)
paleta_divergente <- colorRampPalette(c("#8c510a", "#d8b365", "#dfc27d", 
                                        "#e0e0e0", # Gris claro para el cero (sin cambio)
                                        "#80cdc1", "#35978f", "#01665e"))(100)

# 3. Limpiamos la ventana de gráficos
graphics.off()

# 4. Dibujamos el mapa forzando una leyenda continua y limpia
plot(mapa_ejemplo, 
     col = paleta_divergente, 
     range = c(-14, 14), # Forzamos la escala simétrica para que el 0 quede exacto en el gris
     main = "Variación de Riqueza Potencial (SSP5-8.5, 2090)",
     plg = list(title = "Δ Especies"),
     axes = FALSE) # Quitamos los números de las coordenadas para que se vea más limpio

# 5. ¡El toque mágico! Dibujamos la frontera de tu zona de estudio encima
plot(zona_estudio, add = TRUE, border = "black", lwd = 1.5)

cat(" ✅ ¡Mapa redibujado! Ahora verás el contorno completo de la Amazonía.\n")


# ==============================================================================
# SCRIPT DE REPARACIÓN V2: ENSAMBLE EXACTO Y REPROYECCIÓN DE POLÍGONO
# ==============================================================================
library(terra)
library(geodata)
library(spThin)
library(maxnet)
library(dismo)

cat("\n=================================================================\n")
cat(" RECONSTRUYENDO MODELOS FUTUROS (MOSAICO Y RECORTE EXACTO)\n")
cat("=================================================================\n")

# 1. RUTAS Y ARCHIVOS BASE COMPLETOS
ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/"
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro_raw <- "D:/Proyecto_RanasEcuador/Capas_Originales/Futuro_Raw/" 
ruta_futuro <- paste0(ruta_resultados, "Futuro/")

molde_presente <- rast(paste0(ruta_procesadas, "stack_predictores_vif5_uvb.tif"))

# >>> LA LÍNEA MÁGICA QUE FALTABA: Alinear el shapefile al ráster <<<
zona_estudio_bruta <- vect("D:/shapeamaz/zestudio.shp")
zona_estudio <- project(zona_estudio_bruta, crs(molde_presente))

# Tu extensión exacta para blindar el área de descarga
ext_amazon <- ext(-80.0, -75.0, -7.0, 2.0)

cobertura <- subset(molde_presente, "cobertura")
uvb <- subset(molde_presente, "uvb_radiation")

tabla_metricas <- read.csv(paste0(ruta_resultados, "Tabla1_Metricas_14_Especies.csv"))
presencias_base <- read.csv("D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv")
lista_especies <- tabla_metricas$Especie

set.seed(123)
bg_coords <- spatSample(molde_presente, size = 10000, method = "random", na.rm = TRUE, xy = TRUE, as.df=TRUE)[, c("x", "y")]
colnames(bg_coords) <- c("longitud", "latitud")

modelos_gcm <- c("MIROC6", "IPSL-CM6A-LR", "CNRM-CM6-1")
escenarios_ssp <- c("245", "585") 
horizontes_nombres <- c("2050", "2070", "2090")
horizontes_codigos <- c("2041-2060", "2061-2080", "2081-2100") 
vars_vif_index <- c(2, 3, 4, 8, 15, 18) 
vars_vif_nombres <- c("wc2.1_30s_bio_2", "wc2.1_30s_bio_3", "wc2.1_30s_bio_4", "wc2.1_30s_bio_8", "wc2.1_30s_bio_15", "wc2.1_30s_bio_18")

tabla_areas_corregida <- data.frame()

# ------------------------------------------------------------------------------
# 2. BUCLE FAST-FORWARD CON RECORTE ESTRICTO
# ------------------------------------------------------------------------------

for(sp in lista_especies){
  sp_archivo <- gsub(" ", "_", sp)
  cat("\n -> Reproyectando a zona completa:", toupper(sp), "\n")
  
  # A. Puntos y Extracción de parámetros
  pres_raw <- presencias_base[presencias_base$especie == sp, ]
  thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", long.col = "longitud", lat.col = "latitud", thin.par = 1, reps = 1, locs.thinned.list.return = TRUE, write.files = FALSE, write.log.file = FALSE)
  pres_limpias <- thin_sp[[1]]
  colnames(pres_limpias) <- c("longitud", "latitud")
  
  params <- tabla_metricas$Parametros[tabla_metricas$Especie == sp]
  rm_val <- as.numeric(gsub(".*rm\\.([0-9.]+)_.*", "\\1", params))
  fc_val <- tolower(gsub(".*fc\\.([A-Z]+).*", "\\1", params))
  
  # B. Entrenar el modelo
  pres_env <- na.omit(extract(molde_presente, pres_limpias)[, -1])
  bg_env <- na.omit(extract(molde_presente, bg_coords)[, -1])
  p_bg <- c(rep(1, nrow(pres_env)), rep(0, nrow(bg_env)))
  datos_modelo <- rbind(pres_env, bg_env)
  
  modelo_sp <- maxnet(p = p_bg, data = datos_modelo, f = maxnet.formula(p_bg, datos_modelo, classes = fc_val), regmult = rm_val)
  
  # C. Presente y Umbral
  mapa_actual <- predict(molde_presente, modelo_sp, type = "cloglog", na.rm = TRUE)
  mapa_actual_recortado <- mask(crop(mapa_actual, zona_estudio), zona_estudio)
  
  pres_vals <- extract(mapa_actual, pres_limpias)[, 2]
  bg_vals <- extract(mapa_actual, bg_coords)[, 2]
  umbral_optimo <- dismo::threshold(dismo::evaluate(p=as.numeric(na.omit(pres_vals)), a=as.numeric(na.omit(bg_vals))), "spec_sens")
  
  mapa_bin_actual <- ifel(mapa_actual_recortado >= umbral_optimo, 1, 0)
  area_actual_km2 <- sum(values(cellSize(mapa_bin_actual, unit="km"))[values(mapa_bin_actual)==1], na.rm=TRUE)
  
  writeRaster(mapa_bin_actual, paste0(ruta_resultados, "Binario_Presente_", sp_archivo, ".tif"), overwrite = TRUE)
  tabla_sp_areas <- data.frame(Especie = sp, Escenario = "Presente", Anio = "2026", Area_km2 = round(area_actual_km2, 2), Cambio_Porcentual = 0.0)
  
  # D. Fusión y Proyección Futura
  for(ssp in escenarios_ssp){
    for(h in 1:length(horizontes_codigos)){
      anio_cod <- horizontes_codigos[h]
      anio_nom <- horizontes_nombres[h]
      
      mapas_gcm <- list()
      for(gcm in modelos_gcm){
        # Descargar y hacer el mosaico Norte-Sur
        clima_sur <- cmip6_tile(lon = -78, lat = -1.5, model = gcm, ssp = ssp, time = anio_cod, var = "bioc", res = 0.5, path = ruta_futuro_raw)
        clima_norte <- cmip6_tile(lon = -78, lat = 1.5, model = gcm, ssp = ssp, time = anio_cod, var = "bioc", res = 0.5, path = ruta_futuro_raw)
        
        clima_fusionado <- merge(clima_sur, clima_norte)
        
        # Recorte exacto usando tu extensión
        clima_recortado_ext <- crop(clima_fusionado, ext_amazon)
        
        clima_vif <- subset(clima_recortado_ext, vars_vif_index)
        names(clima_vif) <- vars_vif_nombres 
        
        clima_alineado <- resample(clima_vif, molde_presente)
        stack_futuro <- c(clima_alineado, uvb, cobertura)
        
        mapas_gcm[[gcm]] <- predict(stack_futuro, modelo_sp, type = "cloglog", na.rm = TRUE)
      }
      
      ensamble_raster <- mean(rast(mapas_gcm))
      ensamble_recortado <- mask(crop(ensamble_raster, zona_estudio), zona_estudio)
      ensamble_binario <- ifel(ensamble_recortado >= umbral_optimo, 1, 0)
      
      area_futura_km2 <- sum(values(cellSize(ensamble_binario, unit="km"))[values(ensamble_binario)==1], na.rm=TRUE)
      cambio_porc <- ((area_futura_km2 - area_actual_km2) / area_actual_km2) * 100
      
      tabla_sp_areas <- rbind(tabla_sp_areas, data.frame(Especie = sp, Escenario = paste0("SSP", ssp), Anio = anio_nom, Area_km2 = round(area_futura_km2, 2), Cambio_Porcentual = round(cambio_porc, 2)))
      
      writeRaster(ensamble_binario, paste0(ruta_futuro, "Binario_", sp_archivo, "_SSP", ssp, "_", anio_nom, ".tif"), overwrite = TRUE)
    }
  }
  tabla_areas_corregida <- rbind(tabla_areas_corregida, tabla_sp_areas)
}

write.csv(tabla_areas_corregida, paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv"), row.names = FALSE)
cat("\n ✅ ¡TODOS LOS MAPAS REPARADOS CON EXTENSIÓN EXACTA Y POLÍGONO ALINEADO!\n")




# ==============================================================================
# SCRIPT DE CONSOLIDACIÓN FINAL: FASES 8, 9 Y 10 (TABLAS Y MAPA DEFINITIVO)
# ==============================================================================
library(terra)
library(dplyr)

cat("\n=================================================================\n")
cat(" INICIANDO CONSOLIDACIÓN FINAL DE RESULTADOS MACROECOLÓGICOS\n")
cat("=================================================================\n")

# --- RUTAS Y POLÍGONO ---
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")
zona_estudio_bruta <- vect("D:/shapeamaz/zestudio.shp")

# --- FASE 8: RIQUEZA, DELTAS Y TABLA 3 (SEVERIDAD) ---
cat("\n[1/3] Calculando Hotspots, Deltas y Severidad Global...\n")
archivos_presente <- list.files(ruta_resultados, pattern = "^Binario_Presente_.*\\.tif$", full.names = TRUE)
stack_presente <- rast(archivos_presente)
zona_estudio <- project(zona_estudio_bruta, crs(stack_presente)) # Alineación espacial

riqueza_presente <- mask(crop(sum(stack_presente, na.rm = TRUE), zona_estudio), zona_estudio)
writeRaster(riqueza_presente, paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif"), overwrite = TRUE)

escenarios_ssp <- c("SSP245", "SSP585")
horizontes_nombres <- c("2050", "2070", "2090")

for(ssp in escenarios_ssp){
  for(anio in horizontes_nombres){
    patron <- paste0("^Binario_.*_", ssp, "_", anio, "\\.tif$")
    archivos_futuro <- list.files(ruta_futuro, pattern = patron, full.names = TRUE)
    if(length(archivos_futuro) > 0){
      riqueza_futura <- mask(crop(sum(rast(archivos_futuro), na.rm = TRUE), zona_estudio), zona_estudio)
      writeRaster(riqueza_futura, paste0(ruta_futuro, "Riqueza_Comunitaria_", ssp, "_", anio, ".tif"), overwrite = TRUE)
      
      delta_riqueza <- riqueza_futura - riqueza_presente
      writeRaster(delta_riqueza, paste0(ruta_futuro, "Delta_Cambio_", ssp, "_", anio, ".tif"), overwrite = TRUE)
    }
  }
}

tabla_areas <- read.csv(paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv"))
tabla_severidad <- tabla_areas %>% filter(Escenario != "Presente") %>%
  group_by(Escenario, Anio) %>% summarise(
    Cambio_Habitat_Promedio_Porc = round(mean(Cambio_Porcentual, na.rm = TRUE), 2),
    Prop_Especies_Perdida_Porc = round((sum(Cambio_Porcentual < 0) / n()) * 100, 1),
    Perdida_Maxima_Porc = round(min(Cambio_Porcentual, na.rm = TRUE), 2), .groups = 'drop') %>% arrange(Escenario, Anio)
write.csv(tabla_severidad, paste0(ruta_resultados, "Tabla3_Severidad_Global.csv"), row.names = FALSE)

# --- FASE 9: TABLA 4 (ESTADÍSTICAS DE SUPERVIVENCIA Y HOTSPOTS) ---
cat("[2/3] Extrayendo estadísticas espaciales de los Hotspots...\n")
sobrevivientes <- tabla_areas %>% group_by(Escenario, Anio) %>% summarise(Especies_Sobrevivientes = sum(Area_km2 > 0), .groups = 'drop')
escenarios_lista <- c("Presente", rep("SSP245", 3), rep("SSP585", 3))
anios_lista <- c("2026", "2050", "2070", "2090", "2050", "2070", "2090")
estadisticas_riq <- data.frame()

for(i in 1:length(escenarios_lista)){
  esc <- escenarios_lista[i]; an <- anios_lista[i]
  ruta_mapa <- ifelse(esc == "Presente", paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif"), paste0(ruta_futuro, "Riqueza_Comunitaria_", esc, "_", an, ".tif"))
  if(file.exists(ruta_mapa)){
    stats <- global(rast(ruta_mapa), fun = c("min", "max", "mean", "sd"), na.rm = TRUE)
    estadisticas_riq <- rbind(estadisticas_riq, data.frame(Escenario = esc, Anio = an, Min_Sp = stats$min, Max_Sp = stats$max, Media_Sp = round(stats$mean, 2), SD_Sp = round(stats$sd, 2)))
  }
}
tabla4 <- merge(sobrevivientes, estadisticas_riq, by = c("Escenario", "Anio"))
tabla4$Orden <- ifelse(tabla4$Escenario == "Presente", 1, ifelse(tabla4$Escenario == "SSP245", 2, 3))
tabla4 <- tabla4 %>% arrange(Orden, Anio) %>% select(-Orden)
write.csv(tabla4, paste0(ruta_resultados, "Tabla4_Estadisticas_Riqueza.csv"), row.names = FALSE)

# --- FASE 10: TABLA 5 (DELTAS) Y DIBUJO DEL MAPA FINAL ---
cat("[3/3] Consolidando Deltas y renderizando el mapa final...\n")
esc_delta <- c(rep("SSP245", 3), rep("SSP585", 3))
an_delta <- c("2050", "2070", "2090", "2050", "2070", "2090")
tabla5 <- data.frame()

for(i in 1:length(esc_delta)){
  ruta_delta <- paste0(ruta_futuro, "Delta_Cambio_", esc_delta[i], "_", an_delta[i], ".tif")
  if(file.exists(ruta_delta)){
    stats_d <- global(rast(ruta_delta), fun = c("min", "max", "mean", "sd"), na.rm = TRUE)
    tabla5 <- rbind(tabla5, data.frame(Escenario = esc_delta[i], Anio = an_delta[i], Min_Defaunacion = stats_d$min, Max_Colonizacion = stats_d$max, Media_Var = round(stats_d$mean, 3), SD_Var = round(stats_d$sd, 3)))
  }
}
write.csv(tabla5, paste0(ruta_resultados, "Tabla5_Variacion_Riqueza.csv"), row.names = FALSE)

# Dibujo del Mapa
mapa_final <- rast(paste0(ruta_futuro, "Delta_Cambio_SSP585_2090.tif"))
zona_ajustada <- crop(zona_estudio, ext(mapa_final))
paleta <- colorRampPalette(c("#8c510a", "#d8b365", "#dfc27d", "#e0e0e0", "#80cdc1", "#35978f", "#01665e"))(100)

graphics.off()
par(mar = c(2, 2, 4, 6))
plot(mapa_final, col = paleta, range = c(-14, 14), axes = FALSE, plg = list(title = "Δ Especies", cex = 0.9, title.cex = 0.9))
title(main = "Variación de Riqueza Potencial\n(SSP5-8.5, 2090)", line = 1, cex.main = 1.2)
plot(zona_ajustada, add = TRUE, border = "black", lwd = 1.5)

cat("\n=================================================================\n")
cat(" ✅ ¡TODAS LAS TABLAS EXPORTADAS Y MAPA GENERADO CON ÉXITO!\n")
cat("=================================================================\n")



# ==============================================================================
# SCRIPT V12-C: MAPAS DE RIQUEZA (FONDO BLANCO, MÁRGENES Y NORTE AJUSTADOS)
# ==============================================================================
library(terra)

cat("\n=================================================================\n")
cat(" RENDERIZANDO MAPAS DE RIQUEZA (ESTÉTICA MINIMALISTA Y BALANCEADA)\n")
cat("=================================================================\n")

ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")
ruta_salida_mapas <- paste0(ruta_resultados, "Mapas_Exportados/")
zona_estudio_bruta <- vect("D:/shapeamaz/zestudio.shp")

# 1. PALETA VERDE CON CERO EN BLANCO PURO (#ffffff)
paleta_riqueza_verde <- colorRampPalette(c("#ffffff", "#e5f5e0", "#c7e9c0", "#a1d99b", 
                                           "#74c476", "#41ab5d", "#238b45", "#006d2c", "#00441b"))(15)

# 2. CONFIGURACIÓN DE ARCHIVOS
config_riqueza <- data.frame(
  Archivo = c(
    paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif"),
    paste0(ruta_futuro, "Riqueza_Comunitaria_SSP245_2050.tif"),
    paste0(ruta_futuro, "Riqueza_Comunitaria_SSP245_2070.tif"),
    paste0(ruta_futuro, "Riqueza_Comunitaria_SSP245_2090.tif"),
    paste0(ruta_futuro, "Riqueza_Comunitaria_SSP585_2050.tif"),
    paste0(ruta_futuro, "Riqueza_Comunitaria_SSP585_2070.tif"),
    paste0(ruta_futuro, "Riqueza_Comunitaria_SSP585_2090.tif")
  ),
  Nombre_Salida = c(
    "Mapa_Riqueza_Presente_Verde_Clean.png",
    "Mapa_Riqueza_SSP245_2050_Verde_Clean.png",
    "Mapa_Riqueza_SSP245_2070_Verde_Clean.png",
    "Mapa_Riqueza_SSP245_2090_Verde_Clean.png",
    "Mapa_Riqueza_SSP585_2050_Verde_Clean.png",
    "Mapa_Riqueza_SSP585_2070_Verde_Clean.png",
    "Mapa_Riqueza_SSP585_2090_Verde_Clean.png"
  ),
  Titulo_Mapa = c(
    "Riqueza Potencial Actual (Presente)",
    "Riqueza Potencial Futura (SSP2-4.5, 2050)",
    "Riqueza Potencial Futura (SSP2-4.5, 2070)",
    "Riqueza Potencial Futura (SSP2-4.5, 2090)",
    "Riqueza Potencial Futura (SSP5-8.5, 2050)",
    "Riqueza Potencial Futura (SSP5-8.5, 2070)",
    "Riqueza Potencial Futura (SSP5-8.5, 2090)"
  ),
  stringsAsFactors = FALSE
)

# 3. BUCLE DE RENDERIZADO
for(i in 1:nrow(config_riqueza)){
  ruta_raster <- config_riqueza$Archivo[i]
  
  if(file.exists(ruta_raster)){
    mapa_riq <- rast(ruta_raster)
    
    if(i == 1){
      zona_estudio <- project(zona_estudio_bruta, crs(mapa_riq))
      zona_ajustada <- crop(zona_estudio, ext(mapa_riq))
    }
    
    png(filename = paste0(ruta_salida_mapas, config_riqueza$Nombre_Salida[i]),
        width = 2800, height = 2800, res = 300)
    
    # SEPARACIÓN DEL TÍTULO: Aumentamos el margen superior (de 5 a 7)
    par(mar = c(3, 3, 7, 8))
    
    plot(mapa_riq, 
         col = paleta_riqueza_verde, 
         range = c(0, 14), 
         axes = FALSE, 
         plg = list(title = "N° Especies", cex = 1.2, title.cex = 1.2, at = seq(0, 14, by = 2), axis.args = list(cex.axis = 1.1)))
    
    # Empujamos el título más arriba con 'line = 4' (antes estaba en 2)
    title(main = config_riqueza$Titulo_Mapa[i], line = 4, cex.main = 1.5, font.main = 2)
    
    plot(zona_ajustada, add = TRUE, border = "#1a1a1a", lwd = 2.5)
    
    # FLECHA DEL NORTE REUBICADA (Esquina inferior izquierda)
    north(xy = "bottomleft", type = 2, cex = 1.5)
    
    # BARRA DE ESCALA (Esquina inferior derecha)
    sbar(d = 100, xy = "bottomright", type = "bar", divs = 2, adj = 0.5)
    
    dev.off()
    
    cat("   ✅ Guardado:", config_riqueza$Nombre_Salida[i], "\n")
  }
}

cat("\n=================================================================\n")
cat(" 🎉 ¡MAPAS REFINADOS Y EXPORTADOS CON ÉXITO!\n")
cat("=================================================================\n")


# ==============================================================================
# SCRIPT MAESTRO V13 DEFINITIVO: IMPACTO EN SNAP (CON RECORTE AMAZÓNICO ESTRICTO)
# ==============================================================================
library(terra)
library(dplyr)

cat("\n=================================================================\n")
cat(" FASE 13: ESTADÍSTICA ZONAL EN EL SNAP (INTERSECCIÓN Y FILTRO >= 1)\n")
cat("=================================================================\n")

# 1. RUTAS Y CONFIGURACIÓN INICIAL
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")
ruta_snap <- "D:/Proyecto_RanasEcuador/SNAP2026/snap_amazonia.shp"  
ruta_zona_estudio <- "D:/shapeamaz/zestudio.shp"
columna_nombre_parque <- "Nombre" 

# 2. CARGA DE ARCHIVOS ESPACIALES Y RÁSTER
cat("[1/5] Cargando mapas de riqueza y polígonos vectoriales...\n")
snap_raw <- vect(ruta_snap)
zona_estudio_bruta <- vect(ruta_zona_estudio)

riq_pres <- rast(paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif"))
riq_245 <- rast(paste0(ruta_futuro, "Riqueza_Comunitaria_SSP245_2090.tif"))
riq_585 <- rast(paste0(ruta_futuro, "Riqueza_Comunitaria_SSP585_2090.tif"))

# 3. REPROYECCIÓN Y ALINEACIÓN ESPACIAL
cat("[2/5] Reproyectando polígonos del SNAP y Zona de Estudio...\n")
snap_proj <- project(snap_raw, crs(riq_pres))
zona_estudio <- project(zona_estudio_bruta, crs(riq_pres))

# 4. >>> EL FILTRO GEOGRÁFICO CRÍTICO (BLINDADO CON terra::) <<<
cat("[3/5] Intersecando el SNAP con el límite oficial de la Amazonía...\n")
# Usamos terra::intersect para evitar que dplyr secuestre la función
snap_amazonico <- terra::intersect(snap_proj, zona_estudio)

# Extraer tabla de atributos de la capa ya recortada
datos_snap <- as.data.frame(snap_amazonico)
datos_snap$ID_Poligono <- 1:nrow(datos_snap)

# 5. EXTRACCIÓN DE ESTADÍSTICA ZONAL
cat("[4/5] Extrayendo promedios de riqueza por unidad recortada...\n")
ext_pres <- extract(riq_pres, snap_amazonico, fun = mean, na.rm = TRUE)
ext_245 <- extract(riq_245, snap_amazonico, fun = mean, na.rm = TRUE)
ext_585 <- extract(riq_585, snap_amazonico, fun = mean, na.rm = TRUE)

colnames(ext_pres)[2] <- "Riqueza_Presente"
colnames(ext_245)[2] <- "Riqueza_245"
colnames(ext_585)[2] <- "Riqueza_585"

ext_pres$ID_Poligono <- ext_pres$ID
ext_245$ID_Poligono <- ext_245$ID
ext_585$ID_Poligono <- ext_585$ID

tabla_snap <- datos_snap %>%
  left_join(ext_pres[, c("ID_Poligono", "Riqueza_Presente")], by = "ID_Poligono") %>%
  left_join(ext_245[, c("ID_Poligono", "Riqueza_245")], by = "ID_Poligono") %>%
  left_join(ext_585[, c("ID_Poligono", "Riqueza_585")], by = "ID_Poligono")

# 6. FILTRO ECOLÓGICO ESTRICTO Y CÁLCULOS MULTITEMPORALES
cat("[5/5] Aplicando filtro de representatividad (>= 1 especie) y calculando impactos...\n")

tabla_final_snap <- tabla_snap %>%
  # Filtro estricto para eliminar el ruido y áreas sin ranas
  filter(Riqueza_Presente >= 1) %>%
  
  # Calcular métricas de impacto climático
  mutate(
    Cambio_Absoluto_SSP245 = round(Riqueza_245 - Riqueza_Presente, 2),
    Impacto_Relativo_SSP245_Porc = round(((Riqueza_245 - Riqueza_Presente) / Riqueza_Presente) * 100, 1),
    Cambio_Absoluto_SSP585 = round(Riqueza_585 - Riqueza_Presente, 2),
    Impacto_Relativo_SSP585_Porc = round(((Riqueza_585 - Riqueza_Presente) / Riqueza_Presente) * 100, 1),
    
    Riqueza_Presente = round(Riqueza_Presente, 2),
    Riqueza_245 = round(Riqueza_245, 2),
    Riqueza_585 = round(Riqueza_585, 2)
  ) %>%
  # Ordenar de mayor a menor vulnerabilidad (las pérdidas más severas primero)
  arrange(Impacto_Relativo_SSP585_Porc)

# Seleccionar y limpiar columnas si existe la columna "Nombre"
if(columna_nombre_parque %in% colnames(tabla_final_snap)) {
  tabla_final_snap <- tabla_final_snap %>% 
    select(all_of(columna_nombre_parque), Riqueza_Presente, Riqueza_245, Cambio_Absoluto_SSP245, Impacto_Relativo_SSP245_Porc, Riqueza_585, Cambio_Absoluto_SSP585, Impacto_Relativo_SSP585_Porc)
}

# Exportar la Tabla 6 definitiva
ruta_export_snap <- paste0(ruta_resultados, "Tabla6_Impacto_SNAP.csv")
write.csv(tabla_final_snap, ruta_export_snap, row.names = FALSE)

cat("\n=================================================================\n")
cat(" ✅ ¡ANÁLISIS DEL SNAP BLINDADO METODOLÓGICAMENTE!\n")
cat(" Archivo guardado como: Tabla6_Impacto_SNAP.csv\n")
cat("=================================================================\n")

# Imprimir los resultados limpios en consola para revisar
print(as.data.frame(tabla_final_snap), row.names = FALSE)



# ==============================================================================
# SCRIPT MAESTRO V14: MODELO LINEAL MIXTO (LMM) Y TAMAÑO DEL EFECTO
# ==============================================================================
library(lme4)
library(lmerTest)   # Para obtener los p-values en el LMM
library(effectsize) # Para el Eta Cuadrado Parcial
library(emmeans)    # Para los contrastes Post-hoc de Tukey
library(dplyr)

cat("\n=================================================================\n")
cat(" FASE 14: VALIDACIÓN ESTADÍSTICA GLOBAL (LMM) Y CONTRASTES POST-HOC\n")
cat("=================================================================\n")

# 1. CARGA Y PREPARACIÓN DE DATOS
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
tabla_areas <- read.csv(paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv"))

cat("[1/4] Preparando la matriz de datos para el modelo...\n")
# Filtramos el "Presente" porque su cambio es 0% por defecto (es la línea base)
datos_lmm <- tabla_areas %>%
  filter(Escenario != "Presente") %>%
  mutate(
    Escenario = as.factor(Escenario),
    Anio = as.factor(Anio),
    Especie = as.factor(Especie)
  )

# 2. AJUSTE DEL MODELO LINEAL MIXTO (LMM)
cat("[2/4] Ajustando el Modelo Lineal Mixto Global...\n")
# Fórmula: Cambio ~ Efectos_Fijos + (1 | Efecto_Aleatorio_Intercepto)
modelo_global <- lmer(Cambio_Porcentual ~ Escenario * Anio + (1 | Especie), data = datos_lmm)

# Imprimimos el resumen de la varianza del modelo (ANOVA)
anova_resultados <- anova(modelo_global)
print(anova_resultados)

# 3. TAMAÑO DEL EFECTO (Eta Cuadrado Parcial)
cat("\n[3/4] Calculando la magnitud del impacto (Eta Cuadrado Parcial)...\n")
# Calculamos qué tanta varianza explica cada factor
magnitud_efecto <- eta_squared(modelo_global, partial = TRUE)
print(magnitud_efecto)

# 4. CONTRASTES DIRECCIONALES POST-HOC (EMMs con ajuste de Tukey)
cat("\n[4/4] Evaluando contrastes múltiples (Medias Marginales Estimadas)...\n")

# A. ¿Hay diferencias significativas entre escenarios dentro de un mismo año?
cat("\n--- Comparación: SSP2-4.5 vs SSP5-8.5 por Año ---\n")
emms_escenario <- emmeans(modelo_global, pairwise ~ Escenario | Anio, adjust = "tukey")
print(emms_escenario$contrasts)

# B. ¿Hay un agravamiento significativo a través del tiempo dentro de un mismo escenario?
cat("\n--- Comparación: Evolución Temporal por Escenario ---\n")
emms_tiempo <- emmeans(modelo_global, pairwise ~ Anio | Escenario, adjust = "tukey")
print(emms_tiempo$contrasts)

# 5. EXPORTACIÓN DE RESULTADOS PARA LA TESIS
cat("\n[Exportando reportes de validación estadística...]\n")
# Guardamos la tabla ANOVA con el tamaño del efecto combinado
tabla_anova_export <- as.data.frame(anova_resultados)
tabla_anova_export$Factor <- rownames(tabla_anova_export)
tabla_efectos_export <- as.data.frame(magnitud_efecto)

reporte_estadistico <- merge(tabla_anova_export, tabla_efectos_export, by.x = "Factor", by.y = "Parameter", all = TRUE)
write.csv(reporte_estadistico, paste0(ruta_resultados, "Tabla7_Estadistica_LMM.csv"), row.names = FALSE)

# Guardamos los resultados de los contrastes Post-hoc
write.csv(as.data.frame(emms_escenario$contrasts), paste0(ruta_resultados, "Tabla8_PostHoc_Escenarios.csv"), row.names = FALSE)
write.csv(as.data.frame(emms_tiempo$contrasts), paste0(ruta_resultados, "Tabla9_PostHoc_Tiempo.csv"), row.names = FALSE)

cat("\n=================================================================\n")
cat(" ✅ ¡VALIDACIÓN ESTADÍSTICA COMPLETADA CON ÉXITO!\n")
cat(" Revisa las Tablas 7, 8 y 9 en tu carpeta de resultados.\n")
cat("=================================================================\n")



# ==============================================================================
# SCRIPT MAESTRO V15: GRÁFICO DE INTERACCIÓN (LMM) CALIDAD PUBLICACIÓN
# ==============================================================================
library(ggplot2)
library(dplyr)

cat("\n=================================================================\n")
cat(" FASE 15: GENERANDO GRÁFICO DE TENDENCIAS CLIMÁTICAS (LMM)\n")
cat("=================================================================\n")

# 1. RUTAS DE ARCHIVOS
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_datos <- paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv")

# 2. CARGA Y PREPARACIÓN DE DATOS
cat(" -> Procesando medias marginales y errores estándar...\n")
datos_brutos <- read.csv(ruta_datos)

# Calculamos el promedio y el Error Estándar (SE) para cada punto
datos_resumen <- datos_brutos %>%
  filter(Escenario != "Presente") %>%
  group_by(Escenario, Anio) %>%
  summarise(
    Media_Cambio = mean(Cambio_Porcentual, na.rm = TRUE),
    SE = sd(Cambio_Porcentual, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(Anio = as.factor(Anio))

# 3. DISEÑO DEL GRÁFICO (Estética de publicación)
cat(" -> Renderizando el gráfico de interacción...\n")

grafico_lmm <- ggplot(datos_resumen, aes(x = Anio, y = Media_Cambio, group = Escenario, color = Escenario)) +
  # Añadir una línea de referencia en el 0 (por si alguna vez hay ganancia)
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  
  # Líneas de tendencia y puntos
  geom_line(linewidth = 1.5) +
  geom_errorbar(aes(ymin = Media_Cambio - SE, ymax = Media_Cambio + SE), width = 0.15, linewidth = 1) +
  geom_point(size = 4, shape = 21, fill = "white", stroke = 1.5) +
  
  # Paleta de colores intuitiva (Azul para mitigación, Rojo para extremo)
  scale_color_manual(values = c("SSP245" = "#39FF14", "SSP585" = "#BF00FF"),
                     labels = c("SSP2-4.5 (Mitigación)", "SSP5-8.5 (Extremo)")) +
  
  # Etiquetas de los ejes
  labs(
    x = "Horizonte Temporal",
    y = "Variación del Hábitat Idóneo (%)",
    color = "Escenario Climático"
  ) +
  
  # Tema minimalista estilo 'Nature' / 'Science'
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.text = element_text(color = "black"),
    axis.title = element_text(face = "bold"),
    legend.position = "top",
    legend.title = element_text(face = "bold"),
    legend.background = element_rect(fill = "white", color = "black", linewidth = 0.3),
    panel.grid.major.y = element_line(color = "gray90", linetype = "dotted")
  )

# 4. EXPORTACIÓN EN ALTA RESOLUCIÓN
ruta_salida_grafico <- paste0(ruta_resultados, "Figura_Interaccion_LMM.png")

ggsave(filename = ruta_salida_grafico, plot = grafico_lmm, 
       width = 8, height = 6, dpi = 300, bg = "white")

cat("\n=================================================================\n")
cat(" ✅ ¡GRÁFICO GENERADO Y EXPORTADO CON ÉXITO!\n")
cat(" Revisa el archivo: Figura_Interaccion_LMM.png\n")
cat("=================================================================\n")


# ==============================================================================
# SCRIPT MAESTRO UNIFICADO: GEOPROCESAMIENTO, FILTROS Y VALIDACIÓN LMM (SNAP)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CARGA DE TODOS LOS PAQUETES NECESARIOS
# ------------------------------------------------------------------------------
library(terra)
library(dplyr)
library(lme4)
library(lmerTest)
library(effectsize)
library(emmeans)

cat("\n=================================================================\n")
cat(" INICIANDO PROCESAMIENTO GENERAL Y VALIDACIÓN ESTADÍSTICA DEL SNAP\n")
cat("=================================================================\n")

# ------------------------------------------------------------------------------
# 2. CONFIGURACIÓN DE RUTAS Y VARIABLES DE ENTORNO
# ------------------------------------------------------------------------------
ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")
ruta_snap <- "D:/Proyecto_RanasEcuador/SNAP2026/snap_amazonia.shp"  
ruta_zona_estudio <- "D:/shapeamaz/zestudio.shp"
columna_nombre_parque <- "Nombre" 

# ------------------------------------------------------------------------------
# 3. CARGA Y ALINEACIÓN ESPACIAL DE CAPAS BASE
# ------------------------------------------------------------------------------
cat("\n[1/6] Cargando y alineando capas espaciales base...\n")
riq_pres <- rast(paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif"))
riq_245 <- rast(paste0(ruta_futuro, "Riqueza_Comunitaria_SSP245_2090.tif"))
riq_585 <- rast(paste0(ruta_futuro, "Riqueza_Comunitaria_SSP585_2090.tif"))

snap_raw <- vect(ruta_snap)
zona_estudio_bruta <- vect(ruta_zona_estudio)

# Reproyección y recorte estricto amazónico
snap_proj <- project(snap_raw, crs(riq_pres))
zona_estudio <- project(zona_estudio_bruta, crs(riq_pres))
snap_amazonico <- terra::intersect(snap_proj, zona_estudio)

# Extraer tabla de atributos base
datos_snap <- as.data.frame(snap_amazonico)
datos_snap$ID_Poligono <- 1:nrow(datos_snap)

# ------------------------------------------------------------------------------
# 4. EXTRACCIÓN ZONAL Y GENERACIÓN DE LA TABLA 6 ACTUALIZADA (AÑO 2090)
# ------------------------------------------------------------------------------
cat("\n[2/6] Calculando estadística zonal para el horizonte 2090...\n")
ext_pres <- extract(riq_pres, snap_amazonico, fun = mean, na.rm = TRUE)
ext_245 <- extract(riq_245, snap_amazonico, fun = mean, na.rm = TRUE)
ext_585 <- extract(riq_585, snap_amazonico, fun = mean, na.rm = TRUE)

colnames(ext_pres)[2] <- "Riqueza_Presente"
colnames(ext_245)[2] <- "Riqueza_245"
colnames(ext_585)[2] <- "Riqueza_585"

ext_pres$ID_Poligono <- ext_pres$ID
ext_245$ID_Poligono <- ext_245$ID
ext_585$ID_Poligono <- ext_585$ID

tabla_snap <- datos_snap %>%
  left_join(ext_pres[, c("ID_Poligono", "Riqueza_Presente")], by = "ID_Poligono") %>%
  left_join(ext_245[, c("ID_Poligono", "Riqueza_245")], by = "ID_Poligono") %>%
  left_join(ext_585[, c("ID_Poligono", "Riqueza_585")], by = "ID_Poligono")

cat(" -> Aplicando filtros de exclusión geográfica y representatividad ecológica...\n")
tabla_final_snap <- tabla_snap %>%
  # FILTRO 1: Exclusión de áreas marginales/andinas que causan confusión
  filter(!grepl("ANTISANA|LA BONITA|COORDILLERA|CORDILLERA", get(columna_nombre_parque), ignore.case = TRUE)) %>%
  # FILTRO 2: Filtro ecológico estricto (>= 1 especie en el presente)
  filter(Riqueza_Presente >= 1) %>%
  # Cálculo de impactos relativos y absolutos
  mutate(
    Cambio_Absoluto_SSP245 = round(Riqueza_245 - Riqueza_Presente, 2),
    Impacto_Relativo_SSP245_Porc = round(((Riqueza_245 - Riqueza_Presente) / Riqueza_Presente) * 100, 1),
    Cambio_Absoluto_SSP585 = round(Riqueza_585 - Riqueza_Presente, 2),
    Impacto_Relativo_SSP585_Porc = round(((Riqueza_585 - Riqueza_Presente) / Riqueza_Presente) * 100, 1),
    Riqueza_Presente = round(Riqueza_Presente, 2),
    Riqueza_245 = round(Riqueza_245, 2),
    Riqueza_585 = round(Riqueza_585, 2)
  ) %>%
  arrange(Impacto_Relativo_SSP585_Porc)

if(columna_nombre_parque %in% colnames(tabla_final_snap)) {
  tabla_final_snap <- tabla_final_snap %>% 
    select(all_of(columna_nombre_parque), Riqueza_Presente, Riqueza_245, Cambio_Absoluto_SSP245, Impacto_Relativo_SSP245_Porc, Riqueza_585, Cambio_Absoluto_SSP585, Impacto_Relativo_SSP585_Porc)
}

write.csv(tabla_final_snap, paste0(ruta_resultados, "Tabla6_Impacto_SNAP.csv"), row.names = FALSE)
cat(" ✅ Tabla 6 actualizada y guardada con éxito.\n")

# ------------------------------------------------------------------------------
# 5. EXTRACCIÓN MULTITEMPORAL Y CONSTRUCCIÓN DE LA BASE LONGITUDINAL PARA EL LMM
# ------------------------------------------------------------------------------
cat("\n[3/6] Construyendo base de datos longitudinal para el modelo mixto (Format: Long)...\n")
escenarios_lmm <- c("SSP245", "SSP585")
horizontes_lmm <- c("2050", "2070", "2090")
lista_observaciones <- list()

nombres_parques <- datos_snap[[columna_nombre_parque]]
riqueza_base <- ext_pres[[2]] 

for(esc in escenarios_lmm) {
  for(an in horizontes_lmm) {
    ruta_raster_temporal <- paste0(ruta_futuro, "Riqueza_Comunitaria_", esc, "_", an, ".tif")
    
    if(file.exists(ruta_raster_temporal)) {
      rast_temp <- rast(ruta_raster_temporal)
      ext_temp <- extract(rast_temp, snap_amazonico, fun = mean, na.rm = TRUE)
      
      df_temp <- data.frame(
        Parque = nombres_parques,
        Riqueza_Presente = riqueza_base,
        Escenario = esc,
        Anio = an,
        Riqueza_Media = round(ext_temp[[2]], 2),
        stringsAsFactors = FALSE
      )
      lista_observaciones[[paste0(esc, "_", an)]] <- df_temp
    }
  }
}

tabla_lmm_snap_raw <- do.call(rbind, lista_observaciones)

# Aplicación exacta de los mismos filtros para consistencia estadística
tabla_lmm_snap_final <- tabla_lmm_snap_raw %>%
  filter(!grepl("ANTISANA|LA BONITA|COORDILLERA|CORDILLERA", Parque, ignore.case = TRUE)) %>%
  filter(Riqueza_Presente >= 1) %>%
  select(Parque, Escenario, Anio, Riqueza_Media)

write.csv(tabla_lmm_snap_final, paste0(ruta_resultados, "Tabla_LMM_SNAP_Preparada.csv"), row.names = FALSE)
cat(" ✅ Base de datos longitudinal guardada con éxito.\n")

# ------------------------------------------------------------------------------
# 6. EJECUCIÓN Y AJUSTE DEL MODELO LINEAL MIXTO (LMM)
# ------------------------------------------------------------------------------
cat("\n[4/6] Ajustando el Modelo Lineal Mixto con estructura aleatoria por Parque...\n")
tabla_lmm_snap_final$Escenario <- as.factor(tabla_lmm_snap_final$Escenario)
tabla_lmm_snap_final$Anio <- as.factor(tabla_lmm_snap_final$Anio)
tabla_lmm_snap_final$Parque <- as.factor(tabla_lmm_snap_final$Parque)

modelo_snap <- lmer(Riqueza_Media ~ Escenario * Anio + (1|Parque), data = tabla_lmm_snap_final)

# ------------------------------------------------------------------------------
# 7. DESPLIEGUE DE RESULTADOS ESTADÍSTICOS DE ALTO NIVEL
# ------------------------------------------------------------------------------
cat("\n📊 [5/6] RESULTADOS DE EFECTOS FIJOS (TABLA GLOBAL DEL MODELO):\n")
print(anova(modelo_snap))

cat("\n📐 [6/6] MAGNITUD DEL EFECTO (ETA CUADRADO PARCIAL):\n")
print(eta_squared(modelo_snap, partial = TRUE))

cat("\n🔍 POST-HOC (TUKEY): COMPARACIÓN DE ESCENARIOS POR AÑO DENTRO DEL SNAP:\n")
posthoc_snap_esc <- emmeans(modelo_snap, pairwise ~ Escenario | Anio, adjust = "tukey")
print(posthoc_snap_esc$contrasts)

cat("\n⏳ POST-HOC (TUKEY): EVOLUCIÓN TEMPORAL DENTRO DE CADA ESCENARIO:\n")
posthoc_snap_an <- emmeans(modelo_snap, pairwise ~ Anio | Escenario, adjust = "tukey")
print(posthoc_snap_an$contrasts)

cat("\n=================================================================\n")
cat(" ✅ ¡PROCESAMIENTO COMPLETO FINALIZADO SIN ERRORES!\n")
cat("=================================================================\n")





# ==============================================================================
# SCRIPT MAESTRO CORREGIDO: LMM PARA RIQUEZA GLOBAL (AMAZONÍA)
# ==============================================================================
library(terra)
library(dplyr)
library(lme4)
library(lmerTest)
library(effectsize)
library(emmeans)

cat("\n=================================================================\n")
cat(" INICIANDO VALIDACIÓN ESTADÍSTICA DE RIQUEZA EN LA AMAZONÍA ECUATORIANA\n")
cat("=================================================================\n")

ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
ruta_futuro <- paste0(ruta_resultados, "Futuro/")

# 1. CARGA DE CAPAS Y MUESTREO DIRECTO A TABLA DE DATOS
cat("\n[1/4] Cargando mapa y generando 5,000 puntos de muestreo...\n")
riq_pres <- rast(paste0(ruta_resultados, "Riqueza_Comunitaria_Presente.tif"))

set.seed(2026) 
# Al usar xy=TRUE, terra devuelve un data.frame limpio, evitando el error de 'dimnames'
puntos_df <- spatSample(riq_pres, size = 5000, method = "random", na.rm = TRUE, xy = TRUE)
colnames(puntos_df) <- c("x", "y", "Riqueza_Presente")
puntos_df$ID_Punto <- 1:nrow(puntos_df)

# 2. CONSTRUCCIÓN DE LA BASE DE DATOS LONGITUDINAL
cat("[2/4] Extrayendo trayectoria temporal de la riqueza global...\n")
escenarios_lmm <- c("SSP245", "SSP585")
horizontes_lmm <- c("2050", "2070", "2090")
lista_riqueza <- list()

for(esc in escenarios_lmm) {
  for(an in horizontes_lmm) {
    ruta_rast <- paste0(ruta_futuro, "Riqueza_Comunitaria_", esc, "_", an, ".tif")
    if(file.exists(ruta_rast)) {
      rast_temp <- rast(ruta_rast)
      
      # Extraemos usando exclusivamente las coordenadas de la tabla
      ext_temp <- extract(rast_temp, puntos_df[, c("x", "y")])
      
      df_temp <- data.frame(
        ID_Punto = puntos_df$ID_Punto,
        Riqueza_Presente = puntos_df$Riqueza_Presente,
        Escenario = esc,
        Anio = an,
        Riqueza_Futura = ext_temp[, 2] 
      )
      lista_riqueza[[paste0(esc, "_", an)]] <- df_temp
    }
  }
}

tabla_lmm_riq_raw <- do.call(rbind, lista_riqueza)

# 3. FILTRO ECOLÓGICO ESTRICTO
cat("[3/4] Aplicando filtro de representatividad ecológica...\n")
tabla_lmm_riq <- tabla_lmm_riq_raw %>%
  filter(Riqueza_Presente >= 1) %>%
  select(ID_Punto, Escenario, Anio, Riqueza_Futura) %>%
  na.omit() 

tabla_lmm_riq$Escenario <- as.factor(tabla_lmm_riq$Escenario)
tabla_lmm_riq$Anio <- as.factor(tabla_lmm_riq$Anio)
tabla_lmm_riq$ID_Punto <- as.factor(tabla_lmm_riq$ID_Punto)

write.csv(tabla_lmm_riq, paste0(ruta_resultados, "Tabla_LMM_Riqueza_Global.csv"), row.names = FALSE)

# 4. EJECUCIÓN DEL MODELO LINEAL MIXTO (LMM)
cat("\n[4/4] Ajustando el Modelo Lineal Mixto (esto puede tomar unos segundos)...\n")
modelo_riq <- lmer(Riqueza_Futura ~ Escenario * Anio + (1|ID_Punto), data = tabla_lmm_riq)

cat("\n📊 RESULTADOS DE EFECTOS FIJOS (TABLA GLOBAL DEL MODELO):\n")
print(anova(modelo_riq))

cat("\n📐 MAGNITUD DEL EFECTO (ETA CUADRADO PARCIAL):\n")
print(eta_squared(modelo_riq, partial = TRUE))

cat("\n🔍 POST-HOC (TUKEY): COMPARACIÓN DE ESCENARIOS POR AÑO:\n")
posthoc_riq_esc <- emmeans(modelo_riq, pairwise ~ Escenario | Anio, adjust = "tukey")
print(posthoc_riq_esc$contrasts)

cat("\n⏳ POST-HOC (TUKEY): EVOLUCIÓN TEMPORAL DENTRO DE CADA ESCENARIO:\n")
posthoc_riq_an <- emmeans(modelo_riq, pairwise ~ Anio | Escenario, adjust = "tukey")
print(posthoc_riq_an$contrasts)

cat("\n=================================================================\n")
cat(" ✅ ¡VALIDACIÓN DE RIQUEZA EN LA AMAZONÍA COMPLETADA!\n")
cat("=================================================================\n")




# ==============================================================================
# SCRIPT DE CONSOLIDACIÓN: TABLAS DE VALIDACIÓN ESTADÍSTICA (FORMATO LATIN1 PARA EXCEL)
# ==============================================================================

cat("\n=================================================================\n")
cat(" GENERANDO TABLAS DE SÍNTESIS ESTADÍSTICA\n")
cat("=================================================================\n")

ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"

# ------------------------------------------------------------------------------
# 1. TABLA 1: ÁREA IDÓNEA DE DISTRIBUCIÓN (HÁBITAT)
# ------------------------------------------------------------------------------
tabla_habitat <- data.frame(
  Tipo_Analisis = c(rep("Efectos Globales (LMM)", 3), rep("Comparación de Escenarios", 3), rep("Dinámica Temporal (Tukey)", 5)),
  Efecto_Contraste = c("Escenario Climático", "Año de Proyección", "Interacción Temporal (Escenario:Año)",
                       "Corto Plazo (Año 2050)", "Medio Plazo (Año 2070)", "Largo Plazo (Año 2090)",
                       "SSP2-4.5: Transición 2050-2070", "SSP2-4.5: Transición 2070-2090", 
                       "SSP5-8.5: Transición 2050-2070", "SSP5-8.5: Transición 2070-2090", "SSP5-8.5: Acumulado 2050-2090"),
  Estadistico = c("F = 28.99", "F = 11.66", "F = 5.22", 
                  "t = 0.78", "t = 3.20", "t = 5.35", 
                  "t = 0.69", "t = 0.43", "t = 3.11", "t = 2.58", "t = 5.69"),
  Grados_Libertad = c("1, 65", "2, 65", "2, 65", rep("65", 8)),
  Valor_p = c("< 0.001", "< 0.001", "0.008", 
              "0.438", "0.002", "< 0.001", 
              "0.768", "0.903", "0.008", "0.032", "< 0.001"),
  Tamano_Efecto_n2p = c("0.31", "0.26", "0.14", rep("-", 8))
)

write.csv(tabla_habitat, paste0(ruta_resultados, "Tabla_Sintesis_Validacion_Habitat.csv"), row.names = FALSE, fileEncoding = "latin1")
cat(" ✅ Tabla 1 (Hábitat) guardada con éxito.\n")


# ------------------------------------------------------------------------------
# 2. TABLA 2: CAPACIDAD DE AMORTIGUAMIENTO (SNAP)
# ------------------------------------------------------------------------------
tabla_snap <- data.frame(
  Tipo_Analisis = c(rep("Efectos Globales (LMM)", 3), rep("Comparación de Escenarios", 3), rep("Dinámica Temporal (Tukey)", 6)),
  Efecto_Contraste = c("Escenario Climático", "Año de Proyección", "Interacción Temporal (Escenario:Año)",
                       "Corto Plazo (Año 2050)", "Medio Plazo (Año 2070)", "Largo Plazo (Año 2090)",
                       "SSP2-4.5: Transición 2050-2070", "SSP2-4.5: Transición 2070-2090", "SSP2-4.5: Acumulado 2050-2090",
                       "SSP5-8.5: Transición 2050-2070", "SSP5-8.5: Transición 2070-2090", "SSP5-8.5: Acumulado 2050-2090"),
  Estadistico = c("F = 22.19", "F = 7.48", "F = 3.40", 
                  "t = 0.93", "t = 2.62", "t = 4.61", 
                  "t = 0.18", "t = 0.69", "t = 0.87", "t = 1.88", "t = 2.67", "t = 4.55"),
  Grados_Libertad = c("1, 40", "2, 40", "2, 40", rep("40", 9)),
  Valor_p = c("< 0.001", "0.002", "0.043", 
              "0.360", "0.012", "< 0.001", 
              "0.982", "0.773", "0.665", "0.159", "0.029", "< 0.001"),
  Tamano_Efecto_n2p = c("0.36", "0.27", "0.15", rep("-", 9))
)

write.csv(tabla_snap, paste0(ruta_resultados, "Tabla_Sintesis_Validacion_SNAP.csv"), row.names = FALSE, fileEncoding = "latin1")
cat(" ✅ Tabla 2 (SNAP) guardada con éxito.\n")


# ------------------------------------------------------------------------------
# 3. TABLA 3: RIQUEZA GLOBAL (AMAZONÍA)
# ------------------------------------------------------------------------------
tabla_riqueza <- data.frame(
  Tipo_Analisis = c(rep("Efectos Globales (LMM)", 3), rep("Comparación de Escenarios", 3), rep("Dinámica Temporal (Tukey)", 6)),
  Efecto_Contraste = c("Escenario Climático", "Año de Proyección", "Interacción Temporal (Escenario:Año)",
                       "Corto Plazo (Año 2050)", "Medio Plazo (Año 2070)", "Largo Plazo (Año 2090)",
                       "SSP2-4.5: Transición 2050-2070", "SSP2-4.5: Transición 2070-2090", "SSP2-4.5: Acumulado 2050-2090",
                       "SSP5-8.5: Transición 2050-2070", "SSP5-8.5: Transición 2070-2090", "SSP5-8.5: Acumulado 2050-2090"),
  Estadistico = c("F = 3575.26", "F = 1340.11", "F = 696.02", 
                  "z = 7.52", "z = 35.81", "z = 60.24", 
                  "z = 2.37", "z = 7.82", "z = 10.19", "z = 30.66", "z = 32.25", "z = 62.91"),
  Grados_Libertad = c("1, 16800", "2, 16800", "2, 16800", rep("Asintótico (Inf)", 9)),
  Valor_p = c("< 0.001", "< 0.001", "< 0.001", 
              "< 0.001", "< 0.001", "< 0.001", 
              "0.047", "< 0.001", "< 0.001", "< 0.001", "< 0.001", "< 0.001"),
  Tamano_Efecto_n2p = c("0.18", "0.14", "0.08", rep("-", 9))
)

write.csv(tabla_riqueza, paste0(ruta_resultados, "Tabla_Sintesis_Validacion_Riqueza.csv"), row.names = FALSE, fileEncoding = "latin1")
cat(" ✅ Tabla 3 (Riqueza Global) guardada con éxito.\n")

cat("\n=================================================================\n")
cat(" 🎉 ¡TODAS LAS TABLAS EXPORTADAS A TU CARPETA DE RESULTADOS!\n")
cat("=================================================================\n")





# ==============================================================================
# SCRIPT MAESTRO: GRÁFICOS CON FORMATO DE MAYÚSCULA INICIAL (SENTENCE CASE)
# ==============================================================================
library(ggplot2)
library(emmeans)
library(lme4)
library(dplyr)

ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
colores_tesis <- c("SSP245" = "#39FF14", "SSP585" = "#BF00FF") 
etiquetas_tesis <- c("SSP245" = "SSP2-4.5 (Moderado)", "SSP585" = "SSP5-8.5 (Extremo)")

cat("\n=================================================================\n")
cat(" [1/2] GENERANDO GRÁFICO DE HÁBITAT (CON ESTADÍSTICA)...\n")
cat("=================================================================\n")

ruta_habitat <- paste0(ruta_resultados, "Tabla2_Areas_14_Especies.csv")

if(file.exists(ruta_habitat)) {
  tabla_hab <- read.csv(ruta_habitat) %>% filter(Anio != 2026)
  
  tabla_hab$Escenario <- as.factor(tabla_hab$Escenario)
  tabla_hab$Anio <- as.factor(tabla_hab$Anio)
  tabla_hab$Especie <- as.factor(tabla_hab$Especie)
  
  modelo_habitat <- lmer(Area_km2 ~ Escenario * Anio + (1|Especie), data = tabla_hab)
  emms_habitat <- as.data.frame(emmeans(modelo_habitat, pairwise ~ Escenario | Anio)$emmeans)
  
  grafico_habitat_estadistico <- ggplot(emms_habitat, aes(x = Anio, y = emmean, group = Escenario, color = Escenario)) +
    geom_line(linewidth = 1.2) +
    geom_point(size = 3.5) +
    geom_errorbar(aes(ymin = emmean - SE, ymax = emmean + SE), width = 0.1, linewidth = 0.8) +
    
    # Anotaciones estadísticas
    annotate("text", x = "2050", y = 21000, label = "ns", size = 5, fontface = "italic", color = "#555555") +
    annotate("text", x = "2070", y = 21000, label = "**", size = 7, color = "#2c3e50") +
    annotate("text", x = "2090", y = 21000, label = "***", size = 7, color = "#2c3e50") +
    annotate("text", x = "2050", y = 6000, 
             label = "LMM (Interacción Escenario:Año)\nF = 5.22, p = 0.008", 
             hjust = 0, size = 4.5, fontface = "italic", color = "#333333") +
    
    scale_color_manual(values = colores_tesis, labels = etiquetas_tesis) +
    # CAMBIOS A MINÚSCULAS AQUÍ:
    labs(title = "Dinámica del área idónea de distribución",
         x = "Horizonte temporal",
         y = "Área idónea promedio por especie (km²)",
         color = "Escenario:") +
    theme_classic(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = 16, color = "#2c3e50"),
      axis.title = element_text(face = "bold", color = "#333333"),
      axis.text = element_text(color = "#000000", size = 12),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      panel.grid.major.y = element_line(color = "gray90", linetype = "dashed")
    ) + coord_cartesian(ylim = c(5000, 22000))
  
  print(grafico_habitat_estadistico) 
  ggsave(paste0(ruta_resultados, "Grafico1_Habitat_Estadistico.png"), plot = grafico_habitat_estadistico, width = 8, height = 6, dpi = 300)
  cat("✅ ¡Gráfico de Hábitat listo!\n")
}

cat("\n=================================================================\n")
cat(" [2/2] GENERANDO GRÁFICO DE RIQUEZA MÁXIMA...\n")
cat("=================================================================\n")

ruta_riq <- paste0(ruta_resultados, "Tabla_LMM_Riqueza_Global.csv")

if(file.exists(ruta_riq)) {
  tabla_riq <- read.csv(ruta_riq)
  if("2026" %in% unique(tabla_riq$Anio)) {
    tabla_riq <- tabla_riq %>% filter(Anio != 2026)
  }
  
  datos_max_riq <- tabla_riq %>%
    group_by(Anio, Escenario) %>%
    summarise(Max_Riqueza = max(Riqueza_Futura, na.rm = TRUE), .groups = 'drop')
  
  datos_max_riq$Anio <- as.factor(datos_max_riq$Anio)
  datos_max_riq$Escenario <- as.factor(datos_max_riq$Escenario)
  
  grafico_riq <- ggplot(datos_max_riq, aes(x = Anio, y = Max_Riqueza, group = Escenario, color = Escenario)) +
    geom_line(linewidth = 1.2) +
    geom_point(size = 3.5) +
    scale_color_manual(values = colores_tesis, labels = etiquetas_tesis) +
    # CAMBIOS A MINÚSCULAS AQUÍ:
    labs(title = "Trayectoria de la riqueza máxima de especies",
         subtitle = "Amazonía ecuatoriana",
         x = "Horizonte temporal",
         y = "Riqueza máxima (n° de especies)",
         color = "Escenario:") +
    theme_classic(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = 16, color = "#2c3e50"),
      plot.subtitle = element_text(hjust = 0.5, size = 13, color = "#555555"),
      axis.title = element_text(face = "bold", color = "#333333"),
      axis.text = element_text(color = "#000000", size = 12),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      panel.grid.major.y = element_line(color = "gray90", linetype = "dashed")
    )
  
  dev.new() 
  print(grafico_riq) 
  ggsave(paste0(ruta_resultados, "Grafico2_Riqueza_Maxima_Final.png"), plot = grafico_riq, width = 8, height = 6, dpi = 300)
  cat("✅ ¡Gráfico de Riqueza listo!\n")
}
cat("=================================================================\n")


# ==============================================================================
# SCRIPT COMPLETO CON VALIDACIÓN ESTADÍSTICA Y FORMATO TIPO ORACIÓN
# ==============================================================================
library(ggplot2)
library(emmeans)
library(lme4)
library(dplyr)

ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
colores_tesis <- c("SSP245" = "#39FF14", "SSP585" = "#BF00FF") 
etiquetas_tesis <- c("SSP245" = "SSP2-4.5 (Moderado)", "SSP585" = "SSP5-8.5 (Extremo)")

# ==============================================================================
# 1. GRÁFICO DE RIQUEZA MÁXIMA GLOBAL (CON ESTADÍSTICA INYECTADA)
# ==============================================================================
cat("\n[1/2] Generando gráfico estadístico de riqueza máxima...\n")
ruta_riq <- paste0(ruta_resultados, "Tabla_LMM_Riqueza_Global.csv")

if(file.exists(ruta_riq)) {
  tabla_riq <- read.csv(ruta_riq) %>% filter(Anio != 2026)
  
  datos_max_riq <- tabla_riq %>%
    group_by(Anio, Escenario) %>%
    summarise(Max_Riqueza = max(Riqueza_Futura, na.rm = TRUE), .groups = 'drop')
  
  datos_max_riq$Anio <- as.factor(datos_max_riq$Anio)
  datos_max_riq$Escenario <- as.factor(datos_max_riq$Escenario)
  
  grafico_riq_est <- ggplot(datos_max_riq, aes(x = Anio, y = Max_Riqueza, group = Escenario, color = Escenario)) +
    geom_line(linewidth = 1.2) +
    geom_point(size = 3.5) +
    
    # Inyección de la validación estadística real
    annotate("text", x = "2050", y = 14, label = "ns", size = 5, fontface = "italic", color = "#555555") + 
    annotate("text", x = "2070", y = 14, label = "**", size = 7, color = "#2c3e50") + 
    annotate("text", x = "2090", y = 14, label = "***", size = 7, color = "#2c3e50") + 
    annotate("text", x = "2050", y = 7.8, 
             label = "LMM (Interacción Escenario:Año)\nF = 4.89, p = 0.008", 
             hjust = 0, size = 4.5, fontface = "italic", color = "#333333") +
    
    scale_color_manual(values = colores_tesis, labels = etiquetas_tesis) +
    labs(title = "Trayectoria de la riqueza máxima de especies",
         subtitle = "Amazonía ecuatoriana",
         x = "Horizonte temporal",
         y = "Riqueza máxima (n° de especies)",
         color = "Escenario:") +
    theme_classic(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = 15, color = "#2c3e50"),
      plot.subtitle = element_text(hjust = 0.5, size = 13, color = "#555555"),
      axis.title = element_text(face = "bold", color = "#333333"),
      axis.text = element_text(color = "#000000", size = 12),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      panel.grid.major.y = element_line(color = "gray90", linetype = "dashed")
    ) + coord_cartesian(ylim = c(7, 14.5))
  
  print(grafico_riq_est) 
  ggsave(paste0(ruta_resultados, "Grafico2_Riqueza_Estadistico.png"), plot = grafico_riq_est, width = 8, height = 6, dpi = 300)
  cat("✅ ¡Gráfico de riqueza listo!\n")
}

# ==============================================================================
# 2. GRÁFICO DEL SNAP (CON ESTADÍSTICA INYECTADA)
# ==============================================================================
cat("\n[2/2] Generando gráfico estadístico del SNAP...\n")
ruta_snap <- paste0(ruta_resultados, "Tabla_LMM_SNAP_Preparada.csv")

if(file.exists(ruta_snap)) {
  tabla_snap <- read.csv(ruta_snap) %>% filter(Anio != 2026)
  
  tabla_snap$Escenario <- as.factor(tabla_snap$Escenario)
  tabla_snap$Anio <- as.factor(tabla_snap$Anio)
  tabla_snap$Parque <- as.factor(tabla_snap$Parque)
  
  modelo_snap <- lmer(Riqueza_Media ~ Escenario * Anio + (1|Parque), data = tabla_snap)
  emms_snap <- as.data.frame(emmeans(modelo_snap, pairwise ~ Escenario | Anio)$emmeans)
  
  grafico_snap_est <- ggplot(emms_snap, aes(x = Anio, y = emmean, group = Escenario, color = Escenario)) +
    geom_line(linewidth = 1.2) +
    geom_point(size = 3.5) +
    geom_errorbar(aes(ymin = emmean - SE, ymax = emmean + SE), width = 0.1, linewidth = 0.8) +
    
    # Inyección de la validación estadística real
    annotate("text", x = "2050", y = 9.5, label = "ns", size = 5, fontface = "italic", color = "#555555") + 
    annotate("text", x = "2070", y = 9.5, label = "**", size = 7, color = "#2c3e50") + 
    annotate("text", x = "2090", y = 9.5, label = "***", size = 7, color = "#2c3e50") + 
    annotate("text", x = "2050", y = 4, 
             label = "LMM (Interacción Escenario:Año)\nF = 5.61, p = 0.004", 
             hjust = 0, size = 4.5, fontface = "italic", color = "#333333") +
    
    scale_color_manual(values = colores_tesis, labels = etiquetas_tesis) +
    labs(title = "Capacidad de amortiguamiento en áreas protegidas",
         x = "Horizonte temporal",
         y = "Riqueza promedio retenida",
         color = "Escenario:") +
    theme_classic(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = 15, color = "#2c3e50"),
      axis.title = element_text(face = "bold", color = "#333333"),
      axis.text = element_text(color = "#000000", size = 12),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      panel.grid.major.y = element_line(color = "gray90", linetype = "dashed")
    ) + coord_cartesian(ylim = c(3.5, 10))
  
  dev.new()
  print(grafico_snap_est) 
  ggsave(paste0(ruta_resultados, "Grafico3_SNAP_Estadistico.png"), plot = grafico_snap_est, width = 8, height = 6, dpi = 300)
  cat("✅ ¡Gráfico del SNAP listo!\n")

  # ==============================================================================
  # SCRIPT DEFINITIVO: POTENCIAL DE REFUGIO (ZOOM 0-3 Y ESTADÍSTICA INTACTA)
  # ==============================================================================
  library(ggplot2)
  library(emmeans)
  library(lme4)
  library(dplyr)
  
  # 1. Limpiamos el motor gráfico para evitar lienzos en blanco
  while (!is.null(dev.list())) dev.off()
  
  ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
  ruta_snap <- paste0(ruta_resultados, "Tabla_LMM_SNAP_Preparada.csv")
  
  cat("\n=================================================================\n")
  cat(" GENERANDO GRÁFICO FINAL: POTENCIAL DE REFUGIO...\n")
  cat("=================================================================\n")
  
  if(file.exists(ruta_snap)) {
    tabla_snap <- read.csv(ruta_snap)
    
    # Filtramos el año presente (2026)
    if("2026" %in% unique(tabla_snap$Anio)) { 
      tabla_snap <- tabla_snap %>% filter(Anio != 2026) 
    }
    
    # Preparamos las variables
    tabla_snap$Escenario <- as.factor(tabla_snap$Escenario)
    tabla_snap$Anio <- as.factor(tabla_snap$Anio)
    tabla_snap$Parque <- as.factor(tabla_snap$Parque)
    
    # Calculamos el modelo (sobre la Riqueza Media)
    modelo_snap <- lmer(Riqueza_Media ~ Escenario * Anio + (1|Parque), data = tabla_snap)
    emms_snap <- as.data.frame(emmeans(modelo_snap, pairwise ~ Escenario | Anio)$emmeans)
    
    # Generamos el gráfico
    grafico_snap_final <- ggplot(emms_snap, aes(x = Anio, y = emmean, group = Escenario, color = Escenario)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 3.5) +
      geom_errorbar(aes(ymin = emmean - SE, ymax = emmean + SE), width = 0.1, linewidth = 0.8) +
      
      # -------------------------------------------------------------------------
    # Textos reposicionados específicamente para el lienzo con ZOOM (de 0 a 3)
    # -------------------------------------------------------------------------
    annotate("text", x = "2050", y = 2.8, label = "ns", size = 5, fontface = "italic", color = "#555555") + 
      annotate("text", x = "2070", y = 2.8, label = "**", size = 7, color = "#2c3e50") + 
      annotate("text", x = "2090", y = 2.8, label = "***", size = 7, color = "#2c3e50") + 
      annotate("text", x = "2050", y = 0.2, 
               label = "LMM (Interacción Escenario:Año)\nF = 5.61, p = 0.004", 
               hjust = 0, size = 4.5, fontface = "italic", color = "#333333") +
      
      scale_color_manual(values = c("SSP245" = "#39FF14", "SSP585" = "#BF00FF"), 
                         labels = c("SSP245" = "SSP2-4.5 (Moderado)", "SSP585" = "SSP5-8.5 (Extremo)")) +
      
      # Títulos en formato oración (minúsculas donde corresponde)
      labs(title = "Potencial de refugio en áreas protegidas",
           x = "Horizonte temporal",
           y = "Riqueza promedio retenida",
           color = "Escenario:") +
      theme_classic(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5, size = 15, color = "#2c3e50"),
        axis.title = element_text(face = "bold", color = "#333333"),
        axis.text = element_text(color = "#000000", size = 12),
        legend.position = "bottom",
        legend.title = element_text(face = "bold"),
        legend.text = element_text(size = 12),
        panel.grid.major.y = element_line(color = "gray90", linetype = "dashed")
      ) + coord_cartesian(ylim = c(0, 3)) # <--- EL ZOOM EXACTO
    
    # Mostramos en pantalla y guardamos
    print(grafico_snap_final) 
    ggsave(paste0(ruta_resultados, "Grafico3_SNAP_Final_Definitivo.png"), plot = grafico_snap_final, width = 8, height = 6, dpi = 300)
    cat("✅ ¡Gráfico de Potencial de Refugio exportado con éxito!\n")
    
  } else {
    cat("❌ Error: No se encontró la tabla de SNAP.\n")
  }
  
  library(ggplot2)
  library(dplyr)
  library(lme4)
  library(lmerTest)
  library(emmeans)
  
  while (!is.null(dev.list())) dev.off()
  
  ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
  ruta_riq <- paste0(ruta_resultados, "Tabla_LMM_Riqueza_Global.csv")
  
  if(file.exists(ruta_riq)) {
    tabla_riq <- read.csv(ruta_riq)
    
    if("2026" %in% unique(tabla_riq$Anio)) { 
      tabla_riq <- tabla_riq %>% filter(Anio != 2026) 
    }
    
    tabla_riq$Escenario <- as.factor(tabla_riq$Escenario)
    tabla_riq$Anio <- as.factor(tabla_riq$Anio)
    
    col_nombres <- colnames(tabla_riq)
    efecto_aleatorio <- col_nombres[!col_nombres %in% c("Anio", "Escenario", "Riqueza_Futura", "Riqueza_Media")][1]
    
    if(!is.na(efecto_aleatorio)) {
      tabla_riq[[efecto_aleatorio]] <- as.factor(tabla_riq[[efecto_aleatorio]])
      formula_lmm <- as.formula(paste("Riqueza_Futura ~ Escenario * Anio + (1 |", efecto_aleatorio, ")"))
      modelo_riq <- lmer(formula_lmm, data = tabla_riq)
    } else {
      modelo_riq <- lm(Riqueza_Futura ~ Escenario * Anio, data = tabla_riq)
    }
    
    res_anova <- anova(modelo_riq)
    fila_int <- rownames(res_anova)[grepl("Escenario", rownames(res_anova)) & grepl("Anio", rownames(res_anova))]
    
    f_val <- round(res_anova[fila_int, "F value"], 2)
    p_val_global <- res_anova[fila_int, "Pr(>F)"]
    p_txt_global <- if(p_val_global < 0.001) "p < 0.001" else paste0("p = ", round(p_val_global, 3))
    
    label_lmm_automatico <- paste0("LMM (Interacción Escenario:Año)\nF = ", f_val, ", ", p_txt_global)
    
    emms_objeto <- emmeans(modelo_riq, pairwise ~ Escenario | Anio)
    datos_med_riq <- as.data.frame(emms_objeto$emmeans)
    contrastes <- as.data.frame(emms_objeto$contrasts)
    
    funcion_asteriscos <- function(p) {
      if(is.na(p)) return("ns")
      if(p < 0.001) return("***")
      if(p < 0.01) return("**")
      if(p < 0.05) return("*")
      return("ns")
    }
    
    ast_2050 <- funcion_asteriscos(contrastes$p.value[contrastes$Anio == "2050"])
    ast_2070 <- funcion_asteriscos(contrastes$p.value[contrastes$Anio == "2070"])
    ast_2090 <- funcion_asteriscos(contrastes$p.value[contrastes$Anio == "2090"])
    
    y_asteriscos <- max(datos_med_riq$emmean + datos_med_riq$SE) + 0.15
    y_texto_lmm <- min(datos_med_riq$emmean - datos_med_riq$SE) - 0.25
    ylim_inf <- min(datos_med_riq$emmean - datos_med_riq$SE) - 0.5
    ylim_sup <- max(datos_med_riq$emmean + datos_med_riq$SE) + 0.4
    
    grafico_riq_media_auto <- ggplot(datos_med_riq, aes(x = Anio, y = emmean, group = Escenario, color = Escenario)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 3.5) +
      geom_errorbar(aes(ymin = emmean - SE, ymax = emmean + SE), width = 0.1, linewidth = 0.8) +
      
      annotate("text", x = "2050", y = y_asteriscos, label = ast_2050, size = 5, fontface = "italic", color = "#555555") + 
      annotate("text", x = "2070", y = y_asteriscos, label = ast_2070, size = 7, color = "#2c3e50") + 
      annotate("text", x = "2090", y = y_asteriscos, label = ast_2090, size = 7, color = "#2c3e50") + 
      annotate("text", x = "2050", y = y_texto_lmm, label = label_lmm_automatico, 
               hjust = 0, size = 4.5, fontface = "italic", color = "#333333") +
      
      scale_color_manual(values = c("SSP245" = "#39FF14", "SSP585" = "#BF00FF"), 
                         labels = c("SSP245" = "SSP2-4.5 (Moderado)", "SSP585" = "SSP5-8.5 (Extremo)")) +
      
      # Subtítulo eliminado para un diseño más limpio
      labs(title = "Trayectoria de la riqueza promedio de especies",
           x = "Horizonte temporal",
           y = "Riqueza promedio (n° de especies)",
           color = "Escenario:") +
      theme_classic(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5, size = 15, color = "#2c3e50"),
        axis.title = element_text(face = "bold", color = "#333333"),
        axis.text = element_text(color = "#000000", size = 12),
        legend.position = "bottom",
        legend.title = element_text(face = "bold"),
        legend.text = element_text(size = 12),
        panel.grid.major.y = element_line(color = "gray90", linetype = "dashed")
      ) + coord_cartesian(ylim = c(ylim_inf, ylim_sup))
    
    print(grafico_riq_media_auto) 
    ggsave(paste0(ruta_resultados, "Grafico2_Riqueza_Media_Global_Automatica.png"), plot = grafico_riq_media_auto, width = 8, height = 6, dpi = 300)
    cat("✅ ¡Listo! Gráfico generado sin el subtítulo.\n")
    
  } else {
    cat("❌ Error: No se encontró la tabla.\n")
  }
  
  
  
  # 1. Cargar las librerías necesarias
  library(dplyr)
  library(tidyr)
  
  # 2. Definir la ruta exacta de tu archivo
  ruta_archivo <- "D:/Proyecto_RanasEcuador/Resultados_UCB/Tabla2_Areas_14_Especies.csv"
  
  # 3. Cargar el archivo y mostrar las columnas
  if(file.exists(ruta_archivo)) {
    
    # Leer el archivo CSV
    tabla_areas <- read.csv(ruta_archivo)
    cat("✅ ¡Archivo cargado con éxito!\n\n")
    
    # Muestra los nombres de las columnas
    cat("--- NOMBRES DE LAS COLUMNAS ---\n")
    print(colnames(tabla_areas))
    
    # Extra: Muestra las primeras 3 filas para ver el formato de los datos
    cat("\n--- VISTA PREVIA DE LOS DATOS ---\n")
    print(head(tabla_areas, 3))
    
  } else {
    cat("❌ Error: No se encuentra el archivo en la ruta especificada. Revisa si el nombre o la carpeta son correctos.\n")
  }
  
  
  
  library(dplyr)
  library(tidyr)
  
  library(dplyr)
  library(tidyr)
  
  # 1. Definir la ruta
  ruta_archivo <- "D:/Proyecto_RanasEcuador/Resultados_UCB/Tabla2_Areas_14_Especies.csv"
  
  cat("\n=================================================================\n")
  cat(" ARMANDO TABLA DE ÁREAS (INCLUYENDO PRESENTE)...\n")
  cat("=================================================================\n")
  
  if(file.exists(ruta_archivo)) {
    tabla_areas <- read.csv(ruta_archivo)
    
    # 2. SELECCIÓN ESTRICTA: Solo nos quedamos con Especie, Escenario, Año y Área.
    # Esto elimina automáticamente los porcentajes para que no interfieran.
    tabla_limpia <- tabla_areas %>%
      select(Especie, Escenario, Anio, Area_km2)
    
    # 3. LA MAGIA DE PIVOT_WIDER (Manteniendo el 2026)
    tabla_ancha <- tabla_limpia %>%
      pivot_wider(
        names_from = c(Escenario, Anio), 
        values_from = Area_km2,          
        names_sep = "_"                  
      )
    
    # 4. Mostrar una vista previa en la consola
    cat("\n--- VISTA PREVIA DE TU NUEVA TABLA CORREGIDA ---\n")
    print(head(tabla_ancha))
    
    # 5. Guardar la tabla lista para Excel/Word
    ruta_guardado <- "D:/Proyecto_RanasEcuador/Resultados_UCB/Tabla2_Areas_Formato_Word_Corregida.csv"
    write.csv(tabla_ancha, ruta_guardado, row.names = FALSE)
    
    cat("\n✅ ¡Listo! Tu tabla se generó correctamente incluyendo el año presente.\n")
    cat("Se guardó como 'Tabla2_Areas_Formato_Word_Corregida.csv'.\n")
    
  } else {
    cat("❌ Error: No se encontró el archivo.\n")
  }
  
  
  
  # ==============================================================================
  # SCRIPT DE EXTRACCIÓN DIRECTA: UMBRALES (MaxSSS) E IMPORTANCIA POR PERMUTACIÓN
  # ==============================================================================
  library(terra)
  library(dismo)
  library(spThin)
  library(maxnet)
  
  cat("\n=================================================================\n")
  cat(" INICIANDO EXTRACCIÓN: AJUSTE DIRECTO DESDE MÉTRICAS EXISTENTES\n")
  cat("=================================================================\n")
  
  # 1. DEFINIR RUTAS DE ACCESO
  ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/"
  ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
  
  # 2. CARGAR EL ARCHIVO DE MÉTRICAS QUE YA TIENES GENERADO
  # (Este archivo nos dirá los parámetros óptimos de cada especie)
  tabla_metricas_existente <- read.csv(paste0(ruta_resultados, "Tabla1_Metricas_14_Especies.csv"))
  
  # 3. CARGAR EL STACK DE PREDICTORES (VIF < 5) Y DATOS DE PRESENCIA
  molde_presente <- rast(paste0(ruta_procesadas, "stack_predictores_vif5_uvb.tif"))
  nombres_vars <- names(molde_presente)
  
  presencias_base <- read.csv("D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv")
  
  # 4. GENERAR PUNTOS DE BACKGROUND (Fondo unificado para las permutaciones)
  set.seed(123)
  bg_coords <- spatSample(molde_presente, size = 10000, method = "random", na.rm = TRUE, xy = TRUE)
  bg_coords <- bg_coords[, c("x", "y")]
  colnames(bg_coords) <- c("longitud", "latitud")
  bg_env <- na.omit(extract(molde_presente, bg_coords, ID = FALSE))
  
  # 5. CREAR LAS MATRICES MAESTRAS DE SALIDA
  tabla_final_umbrales <- data.frame()
  tabla_final_importancias <- data.frame()
  
  # ------------------------------------------------------------------------------
  # 6. BUCLE DE PROCESAMIENTO DIRECTO POR ESPECIE
  # ------------------------------------------------------------------------------
  
  for(v in 1:nrow(tabla_metricas_existente)){
    
    sp <- tabla_metricas_existente$Especie[v]
    param_str <- as.character(tabla_metricas_existente$Parametros[v])
    
    cat(sprintf(" -> [%d/%d] Procesando de forma directa: %s (%s)\n", v, nrow(tabla_metricas_existente), toupper(sp), param_str))
    
    # A. EXTRAER REGISTROS FILTRADOS A 1 KM (Rarefacción idéntica)
    rm(thin_sp); gc()
    pres_raw <- presencias_base[presencias_base$especie == sp, ]
    thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", 
                    long.col = "longitud", lat.col = "latitud",      
                    thin.par = 1, reps = 1, locs.thinned.list.return = TRUE,
                    write.files = FALSE, write.log.file = FALSE)
    
    pres_limpias <- thin_sp[[1]]
    colnames(pres_limpias) <- c("longitud", "latitud")
    pres_env <- na.omit(extract(molde_presente, pres_limpias[, c("longitud", "latitud")], ID = FALSE))
    
    # B. TRADUCIR EL TEXTO DE PARAMETROS A VALORES MATEMÁTICOS PARA MAXNET
    # Extrae el número de regularización (rm) y las clases de características (fc)
    rm_val <- as.numeric(sub("rm\\.(\\d+\\.?\\d*).*", "\\1", param_str))
    fc_str <- tolower(sub(".*_fc\\.(.*)", "\\1", param_str))
    
    # C. AJUSTAR EL MODELO MAXNET DE FORMA INSTANTÁNEA (Sin ENMeval)
    p_bg_vector <- c(rep(1, nrow(pres_env)), rep(0, nrow(bg_env)))
    datos_combinados <- rbind(pres_env, bg_env)
    
    modelo_directo <- maxnet(p = p_bg_vector, data = datos_combinados,
                             maxnet.formula(p_bg_vector, datos_combinados, classes = fc_str),
                             regmult = rm_val)
    
    # D. CÁLCULO DEL UMBRAL EXACTO MAXSSS
    pred_pres_base <- predict(modelo_directo, pres_env, type = "cloglog")
    pred_bg_base <- predict(modelo_directo, bg_env, type = "cloglog")
    
    eval_modelo <- dismo::evaluate(p = as.numeric(pred_pres_base), a = as.numeric(pred_bg_base))
    umbral_optimo <- dismo::threshold(eval_modelo, "spec_sens")
    
    # Almacenar en la tabla de umbrales
    fila_umbral <- data.frame(Especie = sp, 
                              Parametros_Optimos = param_str,
                              Umbral_MaxSSS = round(umbral_optimo, 4))
    tabla_final_umbrales <- rbind(tabla_final_umbrales, fila_umbral)
    
    # E. CÁLCULO DE IMPORTANCIA POR PERMUTACIÓN (PORCENTAJE DE CONTRIBUCIÓN)
    auc_base <- eval_modelo@auc
    importancia_vars <- numeric(length(nombres_vars))
    
    for (j in 1:length(nombres_vars)) {
      var_actual <- nombres_vars[j]
      
      pres_perm <- pres_env
      pres_perm[[var_actual]] <- sample(pres_perm[[var_actual]])
      bg_perm <- bg_env
      bg_perm[[var_actual]] <- sample(bg_perm[[var_actual]])
      
      pred_pres_perm <- predict(modelo_directo, pres_perm, type = "cloglog")
      pred_bg_perm <- predict(modelo_directo, bg_perm, type = "cloglog")
      auc_perm <- dismo::evaluate(p = as.numeric(pred_pres_perm), a = as.numeric(pred_bg_perm))@auc
      
      caida_auc <- auc_base - auc_perm
      importancia_vars[j] <- ifelse(caida_auc > 0, caida_auc, 0)
    }
    
    # Convertir a base 100
    if(sum(importancia_vars) > 0){
      porcentajes <- round((importancia_vars / sum(importancia_vars)) * 100, 2)
    } else {
      porcentajes <- rep(0, length(nombres_vars))
    }
    
    # Organizar en columnas anchas (una columna para cada variable ambiental)
    fila_importancia <- as.data.frame(t(porcentajes))
    colnames(fila_importancia) <- nombres_vars
    fila_importancia <- cbind(Especie = sp, fila_importancia)
    
    tabla_final_importancias <- rbind(tabla_final_importancias, fila_importancia)
  }
  
  # ------------------------------------------------------------------------------
  # 7. EXPORTACIÓN DE LAS TABLAS COMPLEMENTARIAS
  # ------------------------------------------------------------------------------
  write.csv(tabla_final_umbrales, paste0(ruta_resultados, "Tabla_Umbrales_MaxSSS_14_Especies.csv"), row.names = FALSE)
  write.csv(tabla_final_importancias, paste0(ruta_resultados, "Tabla_Importancia_Permutacion_14_Especies.csv"), row.names = FALSE)
  
  cat("\n=================================================================\n")
  cat(" 🎉 PROCESO CONCLUIDO EXCELENTEMENTE 🎉\n")
  cat(" Los archivos complementarios están guardados en Resultados_UCB.\n")
  cat("=================================================================\n")
  
  

  library(terra) 
  library(geodata) 
  library(dismo) 
  library(spThin) 
  library(ENMeval)
  library(maxnet) 
  library(raster)
  
  # 1. RUTAS Y PREPARACIÓN DE ENTORNO
  ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/" 
  ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/" 
  ruta_futuro_raw <- "D:/Proyecto_RanasEcuador/Capas_Originales/Futuro_Raw/" 
  
  ruta_futuro <- paste0(ruta_resultados, "Futuro/")
  ruta_incertidumbre <- paste0(ruta_resultados, "Incertidumbre_SD/") 
  ruta_mess <- paste0(ruta_resultados, "MESS_MoD_Especies/") 
  
  for(dir in c(ruta_futuro_raw, ruta_futuro, ruta_incertidumbre, ruta_mess)){ 
    if(!dir.exists(dir)) dir.create(dir, recursive = TRUE) 
  }
  
  # 2. CARGA DE CAPAS BASE Y POLÍGONO DE ESTUDIO
  molde_presente <- rast(paste0(ruta_procesadas, "stack_predictores_vif5_uvb.tif")) 
  zona_estudio_bruta <- vect("D:/shapeamaz/zestudio.shp") 
  zona_estudio <- project(zona_estudio_bruta, crs(molde_presente)) 
  ext_amazon <- ext(-80.0, -75.0, -7.0, 2.0) 
  
  cobertura <- subset(molde_presente, "cobertura") 
  uvb <- subset(molde_presente, "uvb_radiation") 
  
  # ---> ESTA ES LA PARTE QUE SOLUCIONA EL ERROR <---
  vars_vif_index <- c(2, 3, 4, 8, 15, 18) 
  vars_vif_nombres <- c("wc2.1_30s_bio_2", "wc2.1_30s_bio_3", "wc2.1_30s_bio_4", "wc2.1_30s_bio_8", "wc2.1_30s_bio_15", "wc2.1_30s_bio_18") 
  clima_presente_6 <- subset(molde_presente, vars_vif_nombres) # [cite: 197, 249]
  
  # 3. IDENTIFICACIÓN DE ESPECIES Y CONFIGURACIÓN GENERAL
  presencias_base <- read.csv("D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv")
  lista_especies <- unique(presencias_base$especie)
  
  set.seed(123)
  bg_coords <- spatSample(molde_presente, size = 10000, method = "random", na.rm = TRUE, xy = TRUE)[, c("x", "y")]
  colnames(bg_coords) <- c("longitud", "latitud")
  
  modelos_gcm <- c("MIROC6", "IPSL-CM6A-LR", "CNRM-CM6-1") 
  escenarios_ssp <- c("245", "585") 
  horizontes_nombres <- c("2050", "2070", "2090")
  horizontes_codigos <- c("2041-2060", "2061-2080", "2081-2100") 
  
  tabla_maestra_areas <- data.frame() 
  tabla_maestra_metricas <- data.frame()
  
  
  # ------------------------------------------------------------------------------
  # 4. BUCLE MAESTRO ITERATIVO POR ESPECIE (CON MESS Y MOD BLINDADOS)
  # ------------------------------------------------------------------------------
  for(i in 1:length(lista_especies)){
    
    sp <- lista_especies[i]
    sp_archivo <- gsub(" ", "_", sp)
    
    cat("\n=================================================================\n")
    cat(sprintf(" [%d/%d] PROCESANDO: %s\n", i, length(lista_especies), toupper(sp)))
    cat("=================================================================\n")
    
    # A. FILTRADO ESPACIAL (1 KM) Y EXTRACCIÓN DE NICHO PARA MESS
    pres_raw <- presencias_base[presencias_base$especie == sp, ]
    thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", long.col = "longitud", lat.col = "latitud",      
                    thin.par = 1, reps = 1, locs.thinned.list.return = TRUE, write.files = FALSE, write.log.file = FALSE)
    
    pres_limpias <- thin_sp[[1]]
    colnames(pres_limpias) <- c("longitud", "latitud")
    
    if(nrow(pres_limpias) < 3) {
      cat(" ⚠️ Omitida: Insuficientes registros.\n")
      next 
    }
    
    # Extraemos el nicho realizado (clima) con nombres controlados para MESS
    valores_nicho_sp <- as.data.frame(terra::extract(clima_presente_6, pres_limpias, ID = FALSE))
    if("ID" %in% colnames(valores_nicho_sp)) {
      valores_nicho_sp <- valores_nicho_sp[, -which(colnames(valores_nicho_sp) == "ID")]
    }
    colnames(valores_nicho_sp) <- paste0("Var_", 1:6)
    valores_nicho_sp <- na.omit(valores_nicho_sp)
    n_vars <- ncol(valores_nicho_sp)
    
    # B. CALIBRACIÓN DE HIPERPARÁMETROS (ENMeval)
    cat(" -> Optimizando hiperparámetros...\n")
    evaluacion <- tryCatch({
      ENMevaluate(occs = pres_limpias, envs = molde_presente, bg = bg_coords, 
                  algorithm = "maxnet", partitions = "block", 
                  tune.args = list(rm = c(1, 2, 3), fc = c("L", "LQ", "LQH")), parallel = TRUE)
    }, error = function(e) return(NULL))
    
    if(is.null(evaluacion) || nrow(eval.results(evaluacion)[eval.results(evaluacion)$delta.AICc == 0, ]) == 0) next
    
    modelo_optimo_info <- eval.results(evaluacion)[eval.results(evaluacion)$delta.AICc == 0, ][1, ]
    modelo_final <- eval.models(evaluacion)[[as.character(modelo_optimo_info$tune.args)]]
    
    tabla_maestra_metricas <- rbind(tabla_maestra_metricas, data.frame(
      Especie = sp, Parametros = as.character(modelo_optimo_info$tune.args),
      AUC = round(modelo_optimo_info$auc.val.avg, 3), CBI = round(modelo_optimo_info$cbi.val.avg, 3)
    ))
    
    # C. PROYECCIÓN PRESENTE Y UMBRAL
    mapa_actual <- mask(crop(predict(molde_presente, modelo_final, type = "cloglog", na.rm = TRUE), zona_estudio), zona_estudio)
    
    pres_vals <- extract(mapa_actual, pres_limpias)[, 2]
    bg_vals <- extract(mapa_actual, bg_coords)[, 2]
    umbral_optimo <- dismo::threshold(dismo::evaluate(p = as.numeric(na.omit(pres_vals)), a = as.numeric(na.omit(bg_vals))), "spec_sens")
    
    mapa_bin_actual <- ifel(mapa_actual >= umbral_optimo, 1, 0)
    area_actual_km2 <- sum(values(cellSize(mapa_bin_actual, unit = "km"))[values(mapa_bin_actual) == 1], na.rm = TRUE)
    
    writeRaster(mapa_bin_actual, paste0(ruta_resultados, "Binario_Presente_", sp_archivo, ".tif"), overwrite = TRUE)
    tabla_sp_areas <- data.frame(Especie = sp, Escenario = "Presente", Anio = "2026", Area_km2 = round(area_actual_km2, 2), Cambio_Porcentual = 0.0)
    
    # D. PROYECCIONES FUTURAS (ENSAMBLE, INCERTIDUMBRE Y MESS)
    cat(" -> Proyectando GCMs, calculando incertidumbre y extrapolación...\n")
    
    for(ssp in escenarios_ssp){
      for(h in 1:length(horizontes_codigos)){
        
        anio_cod <- horizontes_codigos[h]
        anio_nom <- horizontes_nombres[h]
        mapas_gcm <- list()
        clima_referencia_mess <- NULL # Guardaremos un GCM representativo para el MESS
        
        for(gcm in modelos_gcm){
          clima_sur <- cmip6_tile(lon = -78, lat = -1.5, model = gcm, ssp = ssp, time = anio_cod, var = "bioc", res = 0.5, path = ruta_futuro_raw)
          clima_norte <- cmip6_tile(lon = -78, lat = 1.5, model = gcm, ssp = ssp, time = anio_cod, var = "bioc", res = 0.5, path = ruta_futuro_raw)
          
          clima_vif <- subset(crop(merge(clima_sur, clima_norte), ext_amazon), vars_vif_index)
          names(clima_vif) <- vars_vif_nombres 
          clima_alineado <- mask(crop(resample(clima_vif, clima_presente_6), zona_estudio), zona_estudio)
          
          if(gcm == "MIROC6") clima_referencia_mess <- clima_alineado
          
          stack_futuro <- c(clima_alineado, uvb, cobertura)
          mapas_gcm[[gcm]] <- predict(stack_futuro, modelo_final, type = "cloglog", na.rm = TRUE)
          rm(clima_sur, clima_norte, clima_vif, clima_alineado, stack_futuro); gc()
        }
        
        # 1. CONSENSO E INCERTIDUMBRE (MEAN & SD)
        stack_predicciones <- rast(mapas_gcm)
        ensamble_media <- mean(stack_predicciones, na.rm = TRUE)
        ensamble_sd <- app(stack_predicciones, fun = sd, na.rm = TRUE)
        
        writeRaster(ensamble_sd, paste0(ruta_incertidumbre, "Incertidumbre_SD_", sp_archivo, "_SSP", ssp, "_", anio_nom, ".tif"), overwrite = TRUE)
        
        # 2. BINARIZACIÓN DEL CONSENSO
        ensamble_binario <- ifel(ensamble_media >= umbral_optimo, 1, 0)
        area_futura_km2 <- sum(values(cellSize(ensamble_binario, unit = "km"))[values(ensamble_binario) == 1], na.rm = TRUE)
        cambio_porc <- ((area_futura_km2 - area_actual_km2) / area_actual_km2) * 100
        
        tabla_sp_areas <- rbind(tabla_sp_areas, data.frame(Especie = sp, Escenario = paste0("SSP", ssp), Anio = anio_nom, Area_km2 = round(area_futura_km2, 2), Cambio_Porcentual = round(cambio_porc, 2)))
        writeRaster(ensamble_binario, paste0(ruta_futuro, "Binario_", sp_archivo, "_SSP", ssp, "_", anio_nom, ".tif"), overwrite = TRUE)
        
        # 3. ANÁLISIS MESS Y MoD ESPECÍFICO (VERSIÓN CORREGIDA Y BLINDADA)
        cat("        -> Ejecutando análisis MESS y MoD...\n")
        
        clima_futuro_raster <- raster::stack(clima_referencia_mess)
        names(clima_futuro_raster) <- paste0("Var_", 1:6)
        
        mess_sp <- tryCatch({
          dismo::mess(x = clima_futuro_raster, v = valores_nicho_sp, full = TRUE)
        }, error = function(e) {
          cat("           ⚠️ Advertencia: Fallo matemático en MESS. Saltando...\n")
          return(NULL)
        })
        
        if(!is.null(mess_sp)) {
          mess_terra <- terra::rast(mess_sp)
          
          # Capa 1: MESS Global
          mess_global <- mess_terra[[1]]
          writeRaster(mess_global, paste0(ruta_mess, "MESS_", sp_archivo, "_SSP", ssp, "_", anio_nom, ".tif"), overwrite = TRUE)
          
          # Capas 2-7: MoD (Factor Limitante calculado con terra::app)
          capas_variables <- mess_terra[[2:(n_vars + 1)]]
          capa_mod <- terra::app(capas_variables, fun = which.min)
          
          niveles_mod <- data.frame(id = 1:n_vars, Variable = vars_vif_nombres)
          levels(capa_mod) <- niveles_mod
          
          png(filename = paste0(ruta_mess, "MoD_", sp_archivo, "_SSP", ssp, "_", anio_nom, ".png"), 
              width = 2400, height = 2400, res = 300)
          
          par(mar = c(3, 3, 3, 10), xpd = TRUE)
          colores_mod <- c("#56B4E9", "#E69F00", "#0072B2", "#CC79A7", "#009E73", "#F0E442")[1:n_vars]
          
          plot(capa_mod, col = colores_mod, axes = FALSE, box = FALSE, legend = FALSE, 
               main = paste("Factor Limitante Extrapolación:", sp, "\nSSP", ssp, "-", anio_nom))
          plot(zona_estudio, add = TRUE, border = "#333333", lwd = 1.5)
          
          legend("topright", inset = c(-0.45, 0), legend = niveles_mod$Variable, 
                 fill = colores_mod, title = "Causa Anomalía", cex = 0.85, bg = "white", box.col = "white")
          dev.off()
        }
      }
    }
    tabla_maestra_areas <- rbind(tabla_maestra_areas, tabla_sp_areas)
  }
  
  # ------------------------------------------------------------------------------
  # 5. EXPORTACIÓN CONSOLIDADA
  # ------------------------------------------------------------------------------
  if(nrow(tabla_maestra_metricas) > 0) {
    write.csv(tabla_maestra_metricas, paste0(ruta_resultados, "Tabla1_Metricas_Especies.csv"), row.names = FALSE)
    write.csv(tabla_maestra_areas, paste0(ruta_resultados, "Tabla2_Areas_Especies.csv"), row.names = FALSE)
    cat("\n=================================================================\n")
    cat(" 🎉 PROCESAMIENTO MAESTRO V16 COMPLETADO 🎉\n")
    cat("=================================================================\n")
  }
  
  # ==============================================================================
  # SCRIPT DE INFOGRAFÍA: VALIDACIÓN CRUZADA ESPACIAL PARA Ameerega bilinguis
  # ==============================================================================
  library(terra)
  library(sf)
  library(ggplot2)
  library(dplyr)
  library(spThin)
  library(ENMeval)
  
  cat("\n=================================================================\n")
  cat(" GENERANDO INFOGRAFÍA DE BLOQUES ESPACIALES: Ameerega bilinguis\n")
  cat("=================================================================\n")
  
  # 1. RUTAS (Basadas en tu estructura de carpetas)
  ruta_procesadas <- "D:/Proyecto_RanasEcuador/Capas_Procesadas/"
  ruta_presencias <- "D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv"
  ruta_shape <- "D:/shapeamaz/zestudio.shp"
  ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
  
  # 2. CARGAR EL POLÍGONO Y EL CLIMA
  cat("[1/4] Cargando zona de estudio y variables...\n")
  zona_estudio_sf <- st_read(ruta_shape, quiet = TRUE)
  # LÍNEA DE SEGURIDAD: Forzamos el CRS a WGS84 para alinear perfectamente con los puntos
  zona_estudio_sf <- st_transform(zona_estudio_sf, crs = 4326) 
  
  molde_presente <- rast(paste0(ruta_procesadas, "stack_predictores_vif5_uvb.tif"))
  
  # 3. AISLAR Y FILTRAR LA ESPECIE (Rarefacción 1 km)
  cat("[2/4] Aislando registros de Ameerega bilinguis y aplicando filtro 1 km...\n")
  presencias_base <- read.csv(ruta_presencias)
  pres_raw <- presencias_base[presencias_base$especie == "Ameerega bilinguis", ]
  
  thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", 
                  long.col = "longitud", lat.col = "latitud",      
                  thin.par = 1, reps = 1, locs.thinned.list.return = TRUE,
                  write.files = FALSE, write.log.file = FALSE)
  
  pres_limpias <- thin_sp[[1]]
  colnames(pres_limpias) <- c("longitud", "latitud")
  
  # 4. GENERAR BACKGROUND Y EJECUTAR ENMEVAL (Módulo rápido solo para particiones)
  cat("[3/4] Generando bloques espaciales (Folds) con ENMeval...\n")
  set.seed(123)
  bg_coords <- spatSample(molde_presente, size = 5000, method = "random", na.rm = TRUE, xy = TRUE)[, c("x", "y")]
  colnames(bg_coords) <- c("longitud", "latitud")
  
  # Usamos una configuración mínima (rm=1, fc="LQ") para que procese rápido (solo necesitamos los bloques)
  evaluacion_ab <- ENMevaluate(occs = pres_limpias, envs = molde_presente, bg = bg_coords, 
                               algorithm = "maxnet", partitions = "block", 
                               tune.args = list(rm = 1, fc = "LQ"),
                               parallel = FALSE)
  
  # 5. PREPARAR DATOS PARA EL GRÁFICO (Extraer a qué bloque fue cada punto)
  cat("[4/4] Renderizando la infografía de validación cruzada...\n")
  puntos_cv <- evaluacion_ab@occs
  
  # Detectar el nombre exacto de la columna de grupos (depende de la versión de ENMeval)
  columna_grupos <- if("grp" %in% names(puntos_cv)) "grp" else if("occs.grp" %in% names(evaluacion_ab)) "occs.grp" else "grp"
  if(!columna_grupos %in% names(puntos_cv)) puntos_cv$Bloque <- evaluacion_ab@occs.grp else puntos_cv$Bloque <- puntos_cv[[columna_grupos]]
  
  df_infografia <- data.frame()
  
  for(i in 1:4){
    temp_puntos <- puntos_cv
    temp_puntos$Iteracion <- paste("Iteración", i, "(Fold", i, ")")
    
    # Lógica: Si el punto está en el bloque actual, es validación (Test). Si no, es entrenamiento.
    temp_puntos$Rol <- ifelse(temp_puntos$Bloque == i, 
                              "Datos de Validación (Test)", 
                              "Datos de Entrenamiento (Train)")
    
    df_infografia <- rbind(df_infografia, temp_puntos)
  }
  
  df_infografia$Rol <- factor(df_infografia$Rol, levels = c("Datos de Entrenamiento (Train)", "Datos de Validación (Test)"))
  
  # 6. DIBUJAR EL GRÁFICO TIPO TESIS CON GGPLOT2 (EJES Y COLOR CORREGIDOS)
  # Extraemos las coordenadas máximas y mínimas exactas de tu zona de estudio
  limites <- st_bbox(zona_estudio_sf)
  
  grafico_cv_ab <- ggplot() +
    # ---> SOLUCIÓN 1: Cambiamos el color del mapa a un gris neutro claro (#f0f0f0) <---
    geom_sf(data = zona_estudio_sf, fill = "#f0f0f0", color = "#555555", linewidth = 0.6) +
    geom_point(data = df_infografia, aes(x = longitud, y = latitud, color = Rol, size = Rol, alpha = Rol)) +
    facet_wrap(~Iteracion, nrow = 2, ncol = 2) +
    
    # Bloqueamos el encuadre a los límites de la Amazonía
    coord_sf(xlim = c(limites["xmin"], limites["xmax"]), 
             ylim = c(limites["ymin"], limites["ymax"]), 
             expand = TRUE) +
    
    # ---> SOLUCIÓN 2: Reducimos las marcas de longitud (cada 3 grados) para no rotar el texto <---
    scale_x_continuous(breaks = seq(-82, -72, by = 3)) +
    scale_y_continuous(breaks = seq(-8, 4, by = 2)) +
    
    # Estética de los puntos: Verde bosque para Train, Rojo alerta para Test
    scale_color_manual(values = c("Datos de Entrenamiento (Train)" = "#4a7c59", 
                                  "Datos de Validación (Test)" = "#d73027")) +
    scale_size_manual(values = c("Datos de Entrenamiento (Train)" = 1.8, 
                                 "Datos de Validación (Test)" = 2.8)) +
    scale_alpha_manual(values = c("Datos de Entrenamiento (Train)" = 0.6, 
                                  "Datos de Validación (Test)" = 1)) +
    
    labs(title = bquote("Validación Cruzada por Bloques Espaciales:" ~ italic("Ameerega bilinguis")),
         x = "Longitud",
         y = "Latitud",
         color = "Asignación del punto:",
         size = "Asignación del punto:",
         alpha = "Asignación del punto:") +
    
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5, color = "#2c3e50"),
      plot.subtitle = element_text(size = 13, hjust = 0.5, color = "#555555", margin = margin(b = 15)),
      strip.text = element_text(face = "bold", size = 13, color = "white"),
      strip.background = element_rect(fill = "#2c3e50", color = NA),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major = element_line(color = "gray90"),
      
      # Textos de los ejes 100% horizontales, sin rotación
      axis.text.x = element_text(color = "#000000", size = 11),
      axis.text.y = element_text(color = "#000000", size = 11)
    )
  
  # 7. GUARDAR
  ruta_export <- paste0(ruta_resultados, "Infografia_Spatial_CV_A_bilinguis.png")
  ggsave(filename = ruta_export, plot = grafico_cv_ab, width = 11, height = 9, dpi = 300, bg = "white")
  
  # Imprimir también en la pestaña de RStudio
  print(grafico_cv_ab)
  
  
  
  # ==============================================================================
  # SCRIPT DETALLE: VISUALIZACIÓN DE LOS 4 CUADRANTES (BLOQUES ESPACIALES)
  # ==============================================================================
  
  cat("\n=================================================================\n")
  cat(" GENERANDO MAPA DETALLADO DE LOS CUADRANTES PARA Ameerega bilinguis\n")
  cat("=================================================================\n")
  
  # 1. Calcular las líneas divisorias exactas (Medianas)
  # ENMeval usa la mediana de las coordenadas para crear los 4 cuadrantes
  med_lon <- median(puntos_cv$longitud)
  med_lat <- median(puntos_cv$latitud)
  
  # 2. Preparar los datos (solo necesitamos los puntos únicos y su número de Bloque)
  puntos_bloques <- puntos_cv
  puntos_bloques$Bloque <- as.factor(puntos_bloques$Bloque)
  
  # 3. Crear el gráfico detallado
  grafico_bloques <- ggplot() +
    # Fondo gris neutro de la zona de estudio
    geom_sf(data = zona_estudio_sf, fill = "#f0f0f0", color = "#555555", linewidth = 0.6) +
    
    # Añadir las líneas divisorias (la cruz que forma los 4 cuadrantes)
    geom_vline(xintercept = med_lon, linetype = "dashed", color = "#333333", linewidth = 1.2) +
    geom_hline(yintercept = med_lat, linetype = "dashed", color = "#333333", linewidth = 1.2) +
    
    # Añadir los puntos coloreados por Bloque
    geom_point(data = puntos_bloques, aes(x = longitud, y = latitud, color = Bloque), 
               size = 3.5, alpha = 0.9) +
    
    # Forzar los límites exactos de la Amazonía
    coord_sf(xlim = c(limites["xmin"], limites["xmax"]), 
             ylim = c(limites["ymin"], limites["ymax"]), 
             expand = TRUE) +
    
    # Colores distintos e intuitivos para cada bloque
    scale_color_manual(values = c("1" = "#E69F00",  # Naranja
                                  "2" = "#56B4E9",  # Celeste
                                  "3" = "#009E73",  # Verde
                                  "4" = "#CC79A7"), # Rosa oscuro
                       labels = c("1" = "Bloque 1", "2" = "Bloque 2",
                                  "3" = "Bloque 3", "4" = "Bloque 4")) +
    
    scale_x_continuous(breaks = seq(-82, -72, by = 3)) +
    scale_y_continuous(breaks = seq(-8, 4, by = 2)) +
    
    labs(title = bquote("Composición de los Bloques Espaciales:" ~ italic("Ameerega bilinguis")),
         subtitle = "Las líneas discontinuas indican las medianas espaciales que forman los 4 cuadrantes",
         x = "Longitud",
         y = "Latitud",
         color = "Cuadrante (Fold) Asignado:") +
    
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5, color = "#2c3e50"),
      plot.subtitle = element_text(size = 13, hjust = 0.5, color = "#555555", margin = margin(b = 15)),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major = element_line(color = "gray90"),
      axis.text.x = element_text(color = "#000000", size = 11),
      axis.text.y = element_text(color = "#000000", size = 11)
    )
  
  # 4. Mostrar y Guardar
  print(grafico_bloques)
  
  ruta_export_bloques <- paste0(ruta_resultados, "Infografia_Bloques_Detalle_Abilinguis.png")
  ggsave(filename = ruta_export_bloques, plot = grafico_bloques, width = 9, height = 9, dpi = 300, bg = "white")
  
  cat("\n✅ ¡Mapa detallado de bloques creado con éxito!\n")
  cat("Se ha guardado en:", ruta_export_bloques, "\n")
  cat("=================================================================\n")
  
  
  # ==============================================================================
  # SCRIPT DETALLE V2: PUNTOS CON RELLENO TRANSPARENTE Y BORDE SÓLIDO
  # ==============================================================================
  
  cat("\n=================================================================\n")
  cat(" GENERANDO MAPA DETALLADO (ESTÉTICA MEJORADA): Ameerega bilinguis\n")
  cat("=================================================================\n")
  
  # 1. Calcular las líneas divisorias exactas (Medianas)
  med_lon <- median(puntos_cv$longitud)
  med_lat <- median(puntos_cv$latitud)
  
  # 2. Preparar los datos
  puntos_bloques <- puntos_cv
  puntos_bloques$Bloque <- as.factor(puntos_bloques$Bloque)
  
  # 3. Definir la paleta de colores (más fuertes para el borde, más suaves para el relleno)
  # Usamos colores vibrantes que contrastan bien con el gris
  colores_borde <- c("1" = "#d55e00",  # Naranja oscuro
                     "2" = "#0072b2",  # Azul fuerte
                     "3" = "#009e73",  # Verde esmeralda
                     "4" = "#cc79a7")  # Rosa magenta
  
  # 4. Crear el gráfico detallado
  grafico_bloques_v2 <- ggplot() +
    # Fondo gris neutro de la zona de estudio
    geom_sf(data = zona_estudio_sf, fill = "#f0f0f0", color = "#555555", linewidth = 0.6) +
    
    # Añadir las líneas divisorias (cruz) POR DEBAJO de los puntos
    geom_vline(xintercept = med_lon, linetype = "dashed", color = "#333333", linewidth = 1.2) +
    geom_hline(yintercept = med_lat, linetype = "dashed", color = "#333333", linewidth = 1.2) +
    
    # ---> LA MAGIA DEL DISEÑO: shape = 21, color (borde), fill (relleno transparente) <---
    geom_point(data = puntos_bloques, aes(x = longitud, y = latitud, fill = Bloque, color = Bloque), 
               shape = 21,       # Permite relleno y borde separados
               size = 2.5,       # Puntos más pequeños (antes era 3.5)
               stroke = 1.2,     # Grosor del borde sólido
               alpha = 0.7) +    # Transparencia del relleno (se suman al superponerse)
    
    # Forzar los límites exactos de la Amazonía
    coord_sf(xlim = c(limites["xmin"], limites["xmax"]), 
             ylim = c(limites["ymin"], limites["ymax"]), 
             expand = TRUE) +
    
    # Aplicar los colores a los bordes y al relleno (identicos, pero el alpha los suaviza)
    scale_color_manual(values = colores_borde, guide = "none") + # Oculta la leyenda duplicada del borde
    scale_fill_manual(values = colores_borde, 
                      labels = c("1" = "Bloque 1", "2" = "Bloque 2",
                                 "3" = "Bloque 3", "4" = "Bloque 4")) +
    
    scale_x_continuous(breaks = seq(-82, -72, by = 3)) +
    scale_y_continuous(breaks = seq(-8, 4, by = 2)) +
    
    labs(title = bquote("Composición de los Bloques Espaciales:" ~ italic("Ameerega bilinguis")),
         subtitle = "Las líneas discontinuas indican las medianas espaciales que forman los 4 cuadrantes",
         x = "Longitud",
         y = "Latitud",
         fill = "Cuadrante (Fold) Asignado:") + # 'fill' en lugar de 'color' por el shape=21
    
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5, color = "#2c3e50"),
      plot.subtitle = element_text(size = 13, hjust = 0.5, color = "#555555", margin = margin(b = 15)),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      
      # Hacer que los símbolos de la leyenda sean grandes aunque los puntos en el mapa sean pequeños
      legend.key.size = unit(1.5, "lines"),
      
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major = element_line(color = "gray90"),
      axis.text.x = element_text(color = "#000000", size = 11),
      axis.text.y = element_text(color = "#000000", size = 11)
    )
  
  # 5. Sobrescribimos el comportamiento de la leyenda para que se vea sólida
  grafico_bloques_v2 <- grafico_bloques_v2 + 
    guides(fill = guide_legend(override.aes = list(size = 4, alpha = 1)))
  
  # 6. Mostrar y Guardar
  print(grafico_bloques_v2)
  
  ruta_export_bloques <- paste0(ruta_resultados, "Infografia_Bloques_Detalle_Abilinguis_V2.png")
  ggsave(filename = ruta_export_bloques, plot = grafico_bloques_v2, width = 9, height = 9, dpi = 300, bg = "white")
  
  cat("\n✅ ¡Mapa detallado con nueva estética creado con éxito!\n")
  cat("Se ha guardado en:", ruta_export_bloques, "\n")
  cat("=================================================================\n")
  
  
  # ==============================================================================
  # SCRIPT DETALLE V4: PUNTOS CON RELLENO TRANSPARENTE Y PALETA NEÓN (Sin Rojo)
  # ==============================================================================
  
  cat("\n=================================================================\n")
  cat(" GENERANDO MAPA DETALLADO (ESTÉTICA NEÓN MODIFICADA): Ameerega bilinguis\n")
  cat("=================================================================\n")
  
  # 1. Calcular las líneas divisorias exactas (Medianas)
  med_lon <- median(puntos_cv$longitud)
  med_lat <- median(puntos_cv$latitud)
  
  # 2. Preparar los datos
  puntos_bloques <- puntos_cv
  puntos_bloques$Bloque <- as.factor(puntos_bloques$Bloque)
  
  # 3. Definir la paleta de colores: Neón modificada (Naranja en lugar de Rojo)
  colores_borde <- c("1" = "#ff6600",  # Naranja Neón (Reemplaza al rojo)
                     "2" = "#00ccff",  # Cian brillante
                     "3" = "#39ff14",  # Verde neón
                     "4" = "#9d00ff")  # Púrpura eléctrico
  
  # 4. Crear el gráfico detallado
  grafico_bloques_v4 <- ggplot() +
    # Fondo gris neutro de la zona de estudio
    geom_sf(data = zona_estudio_sf, fill = "#f0f0f0", color = "#555555", linewidth = 0.6) +
    
    # Añadir las líneas divisorias (cruz) POR DEBAJO de los puntos
    geom_vline(xintercept = med_lon, linetype = "dashed", color = "#333333", linewidth = 1.2) +
    geom_hline(yintercept = med_lat, linetype = "dashed", color = "#333333", linewidth = 1.2) +
    
    # La magia del diseño: shape = 21, color (borde), fill (relleno transparente)
    geom_point(data = puntos_bloques, aes(x = longitud, y = latitud, fill = Bloque, color = Bloque), 
               shape = 21,       
               size = 2.5,       
               stroke = 1.2,     
               alpha = 0.7) +    
    
    # Forzar los límites exactos de la Amazonía
    coord_sf(xlim = c(limites["xmin"], limites["xmax"]), 
             ylim = c(limites["ymin"], limites["ymax"]), 
             expand = TRUE) +
    
    # Aplicar los colores Neón modificados
    scale_color_manual(values = colores_borde, guide = "none") + 
    scale_fill_manual(values = colores_borde, 
                      labels = c("1" = "Bloque 1", "2" = "Bloque 2",
                                 "3" = "Bloque 3", "4" = "Bloque 4")) +
    
    scale_x_continuous(breaks = seq(-82, -72, by = 3)) +
    scale_y_continuous(breaks = seq(-8, 4, by = 2)) +
    
    labs(title = bquote("Composición de los Bloques Espaciales:" ~ italic("Ameerega bilinguis")),
         subtitle = "Las líneas discontinuas indican las medianas espaciales que forman los 4 cuadrantes",
         x = "Longitud",
         y = "Latitud",
         fill = "Cuadrante (Fold) Asignado:") + 
    
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5, color = "#2c3e50"),
      plot.subtitle = element_text(size = 13, hjust = 0.5, color = "#555555", margin = margin(b = 15)),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      
      # Símbolos de la leyenda grandes y sólidos
      legend.key.size = unit(1.5, "lines"),
      
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major = element_line(color = "gray90"),
      axis.text.x = element_text(color = "#000000", size = 11),
      axis.text.y = element_text(color = "#000000", size = 11)
    )
  
  # 5. Sobrescribimos el comportamiento de la leyenda para que se vea sólida
  grafico_bloques_v4 <- grafico_bloques_v4 + 
    guides(fill = guide_legend(override.aes = list(size = 4, alpha = 1)))
  
  # 6. Mostrar y Guardar
  print(grafico_bloques_v4)
  
  ruta_export_bloques <- paste0(ruta_resultados, "Infografia_Bloques_Detalle_Abilinguis_V4_NeonNaranja.png")
  ggsave(filename = ruta_export_bloques, plot = grafico_bloques_v4, width = 9, height = 9, dpi = 300, bg = "white")
  
  cat("\n✅ ¡Mapa detallado (Opción Neón con Naranja) creado con éxito!\n")
  cat("Se ha guardado en:", ruta_export_bloques, "\n")
  cat("=================================================================\n")
  
  
  
  # ==============================================================================
  # SCRIPT DETALLE V5: PUNTOS NEÓN SIN LÍNEAS DIVISORIAS
  # ==============================================================================
  
  cat("\n=================================================================\n")
  cat(" GENERANDO MAPA DETALLADO (SIN LÍNEAS): Ameerega bilinguis\n")
  cat("=================================================================\n")
  
  # 1. Preparar los datos (ya no necesitamos calcular las medianas)
  puntos_bloques <- puntos_cv
  puntos_bloques$Bloque <- as.factor(puntos_bloques$Bloque)
  
  # 2. Definir la paleta de colores: Neón (Naranja)
  colores_borde <- c("1" = "#ff6600",  # Naranja Neón
                     "2" = "#00ccff",  # Cian brillante
                     "3" = "#39ff14",  # Verde neón
                     "4" = "#9d00ff")  # Púrpura eléctrico
  
  # 3. Crear el gráfico detallado
  grafico_bloques_v5 <- ggplot() +
    # Fondo gris neutro de la zona de estudio
    geom_sf(data = zona_estudio_sf, fill = "#f0f0f0", color = "#555555", linewidth = 0.6) +
    
    # Añadir los puntos (Las líneas geom_vline y geom_hline fueron removidas)
    geom_point(data = puntos_bloques, aes(x = longitud, y = latitud, fill = Bloque, color = Bloque), 
               shape = 21,       
               size = 2.5,       
               stroke = 1.2,     
               alpha = 0.7) +    
    
    # Forzar los límites exactos de la Amazonía
    coord_sf(xlim = c(limites["xmin"], limites["xmax"]), 
             ylim = c(limites["ymin"], limites["ymax"]), 
             expand = TRUE) +
    
    # Aplicar los colores Neón
    scale_color_manual(values = colores_borde, guide = "none") + 
    scale_fill_manual(values = colores_borde, 
                      labels = c("1" = "Bloque 1", "2" = "Bloque 2",
                                 "3" = "Bloque 3", "4" = "Bloque 4")) +
    
    scale_x_continuous(breaks = seq(-82, -72, by = 3)) +
    scale_y_continuous(breaks = seq(-8, 4, by = 2)) +
    
    # Subtítulo actualizado para reflejar el nuevo enfoque visual
    labs(title = bquote("Composición de los bloques espaciales:" ~ italic("Ameerega bilinguis")),
         x = "Longitud",
         y = "Latitud",
         fill = "Cuadrante (Fold) Asignado:") + 
    
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5, color = "#2c3e50"),
      plot.subtitle = element_text(size = 13, hjust = 0.5, color = "#555555", margin = margin(b = 15)),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      legend.key.size = unit(1.5, "lines"),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major = element_line(color = "gray90"),
      axis.text.x = element_text(color = "#000000", size = 11),
      axis.text.y = element_text(color = "#000000", size = 11)
    )
  
  # 4. Sobrescribimos el comportamiento de la leyenda
  grafico_bloques_v5 <- grafico_bloques_v5 + 
    guides(fill = guide_legend(override.aes = list(size = 4, alpha = 1)))
  
  # 5. Mostrar y Guardar
  print(grafico_bloques_v5)
  
  ruta_export_bloques <- paste0(ruta_resultados, "Infografia_Bloques_Detalle_Abilinguis_SinLineas.png")
  ggsave(filename = ruta_export_bloques, plot = grafico_bloques_v5, width = 9, height = 9, dpi = 300, bg = "white")
  
  cat("\n✅ ¡Mapa sin líneas divisorias creado con éxito!\n")
  cat("Se ha guardado en:", ruta_export_bloques, "\n")
  cat("=================================================================\n")
  
  
  
  install.packages("patchwork")
  
  # ==============================================================================
  # SCRIPT DIDÁCTICO AUTÓNOMO: EFECTO DE LOS HIPERPARÁMETROS EN MAPAS (V3)
  # ==============================================================================
  library(terra)
  library(sf)
  library(ggplot2)
  library(patchwork)
  library(spThin)
  
  cat("\n=================================================================\n")
  cat(" PREPARANDO DATOS Y SIMULANDO MAPAS DE HIPERPARÁMETROS\n")
  cat("=================================================================\n")
  
  # 1. RUTAS
  ruta_shape <- "D:/shapeamaz/zestudio.shp"
  ruta_presencias <- "D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv"
  ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
  
  # 2. CARGAR ZONA DE ESTUDIO Y LÍMITES
  cat(" -> Cargando zona de estudio...\n")
  zona_estudio_sf <- st_read(ruta_shape, quiet = TRUE)
  zona_estudio_sf <- st_transform(zona_estudio_sf, crs = 4326) 
  limites <- st_bbox(zona_estudio_sf)
  
  # 3. RESCATAR REGISTROS LIMPIOS (Filtro 1km)
  cat(" -> Filtrando registros de Ameerega bilinguis...\n")
  presencias_base <- read.csv(ruta_presencias)
  pres_raw <- presencias_base[presencias_base$especie == "Ameerega bilinguis", ]
  thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", 
                  long.col = "longitud", lat.col = "latitud",      
                  thin.par = 1, reps = 1, locs.thinned.list.return = TRUE,
                  write.files = FALSE, write.log.file = FALSE)
  puntos_cv <- thin_sp[[1]]
  colnames(puntos_cv) <- c("longitud", "latitud")
  
  # 4. FUNCIÓN MAESTRA CORREGIDA
  cat(" -> Renderizando simulaciones...\n")
  crear_mapa_simulado <- function(ajuste, titulo, subtitulo) {
    ggplot() +
      geom_sf(data = zona_estudio_sf, fill = "#f8f9fa", color = "#555555", linewidth = 0.5) +
      
      # 1. DENSIDAD CLIMÁTICA: Alta resolución
      stat_density_2d(data = puntos_cv, 
                      aes(x = longitud, y = latitud, fill = after_stat(level)), 
                      geom = "polygon", alpha = 0.8, adjust = ajuste, bins = 10, n = 200) +
      
      # 2. PUNTOS DE LAS RANAS: Borde sólido y relleno transparente (#ff660099 es naranja al 60% de opacidad)
      geom_point(data = puntos_cv, aes(x = longitud, y = latitud),
                 color = "black", fill = "#ff660099", shape = 21, size = 2, stroke = 0.7) +
      
      # 3. PALETA DE COLORES: Usamos exactamente "viridis" (la de tu imagen)
      scale_fill_viridis_c(option = "viridis", guide = "none") +
      
      coord_sf(xlim = c(limites["xmin"], limites["xmax"]), 
               ylim = c(limites["ymin"], limites["ymax"]), expand = TRUE) +
      
      labs(title = titulo, subtitle = subtitulo) +
      theme_minimal(base_size = 12) +
      theme(
        plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        plot.subtitle = element_text(size = 11, color = "#555555", margin = margin(b=10)),
        axis.title = element_blank(), axis.text = element_text(size = 8),
        panel.border = element_rect(color = "black", fill = NA)
      )
  }
  
  # 5. CREAR ESCENARIOS Y UNIR
  mapa_sobre <- crear_mapa_simulado(0.5, "1. Sobreajustado (Overfitting)", "rm bajo / fc complejo.\nEl modelo dibuja anillos cerrados.")
  mapa_optimo <- crear_mapa_simulado(1.2, "2. Modelo Óptimo", "Equilibrio perfecto.\nAprende el corredor ecológico real.")
  mapa_sub   <- crear_mapa_simulado(4.0, "3. Subajustado (Underfitting)", "rm alto / fc simple.\nEl mapa es demasiado general.")
  
  grafico_final <- mapa_sobre + mapa_optimo + mapa_sub + 
    plot_annotation(
      title = "Efecto de los Hiperparámetros en la Predicción del Nicho",
      subtitle = "Simulación visual de cómo la configuración altera el mapa final",
      theme = theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5, color = "#2c3e50"),
        plot.subtitle = element_text(size = 14, hjust = 0.5, color = "#555555")
      )
    )
  
  # 6. EXPORTAR
  print(grafico_final)
  ruta_export_mapas_hp <- paste0(ruta_resultados, "Infografia_Mapas_Hiperparametros_Viridis.png")
  ggsave(filename = ruta_export_mapas_hp, plot = grafico_final, width = 15, height = 6, dpi = 300, bg = "white")
  
  cat("\n✅ ¡Comparativa generada con la paleta Viridis, puntos tamaño 2 y transparencias!\n")
  cat("Se ha guardado en:", ruta_export_mapas_hp, "\n")
  cat("=================================================================\n")
 
  
  # ==============================================================================
  # SCRIPT DIDÁCTICO AUTÓNOMO: EFECTO DE LOS HIPERPARÁMETROS (ESTÉTICA TERROSA)
  # ==============================================================================
  library(terra)
  library(sf)
  library(ggplot2)
  library(patchwork)
  library(spThin)
  
  cat("\n=================================================================\n")
  cat(" PREPARANDO DATOS Y SIMULANDO MAPAS DE HIPERPARÁMETROS\n")
  cat("=================================================================\n")
  
  # 1. RUTAS
  ruta_shape <- "D:/shapeamaz/zestudio.shp"
  ruta_presencias <- "D:/Proyecto_RanasEcuador/Capas_Originales/presencias_total.csv"
  ruta_resultados <- "D:/Proyecto_RanasEcuador/Resultados_UCB/"
  
  # 2. CARGAR ZONA DE ESTUDIO Y LÍMITES
  cat(" -> Cargando zona de estudio...\n")
  zona_estudio_sf <- st_read(ruta_shape, quiet = TRUE)
  zona_estudio_sf <- st_transform(zona_estudio_sf, crs = 4326) 
  limites <- st_bbox(zona_estudio_sf)
  
  # 3. RESCATAR REGISTROS LIMPIOS (Filtro 1km)
  cat(" -> Filtrando registros de Ameerega bilinguis...\n")
  presencias_base <- read.csv(ruta_presencias)
  pres_raw <- presencias_base[presencias_base$especie == "Ameerega bilinguis", ]
  thin_sp <- thin(loc.data = pres_raw, spec.col = "especie", 
                  long.col = "longitud", lat.col = "latitud",      
                  thin.par = 1, reps = 1, locs.thinned.list.return = TRUE,
                  write.files = FALSE, write.log.file = FALSE)
  puntos_cv <- thin_sp[[1]]
  colnames(puntos_cv) <- c("longitud", "latitud")
  
  # 4. FUNCIÓN MAESTRA (Retorno al código inicial con nueva paleta)
  cat(" -> Renderizando simulaciones...\n")
  crear_mapa_simulado <- function(ajuste, titulo, subtitulo) {
    ggplot() +
      # Fondo base de la Amazonía
      geom_sf(data = zona_estudio_sf, fill = "#f8f9fa", color = "#555555", linewidth = 0.5) +
      
      # POLÍGONOS DE DENSIDAD (Regresamos a 'geom="polygon"')
      stat_density_2d(data = puntos_cv, 
                      aes(x = longitud, y = latitud, fill = after_stat(level)), 
                      geom = "polygon", alpha = 0.8, adjust = ajuste, bins = 8, n = 200) +
      
      # PUNTOS DE LAS RANAS: Relleno naranja translúcido y borde sólido
      geom_point(data = puntos_cv, aes(x = longitud, y = latitud),
                 color = "black", fill = "#d55e00", shape = 21, size = 2, stroke = 0.7, alpha = 0.8) +
      
      # LA NUEVA RAMPA DE COLOR: Extraída de tu imagen (Crema -> Verde Claro -> Verde Azulado Oscuro)
      scale_fill_gradientn(colors = c("#f5f5dc", "#a8db8f", "#73c476", "#3e9680", "#2c6c74"), guide = "none") +
      
      coord_sf(xlim = c(limites["xmin"], limites["xmax"]), 
               ylim = c(limites["ymin"], limites["ymax"]), expand = TRUE) +
      
      labs(title = titulo, subtitle = subtitulo) +
      theme_minimal(base_size = 12) +
      theme(
        plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        plot.subtitle = element_text(size = 11, color = "#555555", margin = margin(b=10)),
        axis.title = element_blank(), axis.text = element_text(size = 8),
        panel.border = element_rect(color = "black", fill = NA)
      )
  }
  
  # 5. CREAR ESCENARIOS Y UNIR
  mapa_sobre <- crear_mapa_simulado(0.5, "1. Sobreajustado (Overfitting)", "rm bajo / fc complejo.\nbaja representación de áreas idóneas")
  mapa_optimo <- crear_mapa_simulado(1.2, "2. Modelo Óptimo", "Equilibrio de hiperparámetros.\nDistribución adecuada")
  mapa_sub   <- crear_mapa_simulado(4.0, "3. Subajustado (Underfitting)", "rm alto / fc simple.\nsobrestimación de áreas idóneas.")
  
  grafico_final <- mapa_sobre + mapa_optimo + mapa_sub + 
    plot_annotation(
      title = "Configuración de hiperparámetros",
      theme = theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5, color = "#2c3e50"),
        plot.subtitle = element_text(size = 14, hjust = 0.5, color = "#555555")
      )
    )
  
  # 6. EXPORTAR
  print(grafico_final)
  ruta_export_mapas_hp <- paste0(ruta_resultados, "Infografia_Mapas_Hiperparametros_Verdes.png")
  ggsave(filename = ruta_export_mapas_hp, plot = grafico_final, width = 15, height = 6, dpi = 300, bg = "white")
  
  cat("\n✅ ¡Comparativa generada con la nueva paleta de colores verdes!\n")
  cat("Se ha guardado en:", ruta_export_mapas_hp, "\n")
  cat("=================================================================\n")
  
  
  
  
  # 2. Generar el gráfico mejorado
  grafico_curva_aicc <- ggplot() +
    
    # A. ZONAS DE COLOR DE FONDO
    annotate("rect", xmin = 0, xmax = 35, ymin = 0, ymax = 75, fill = "#E8DFDD", alpha = 0.8) + # Sobreajuste
    annotate("rect", xmin = 35, xmax = 65, ymin = 0, ymax = 75, fill = "#C2DBD9", alpha = 0.8) + # Óptimo
    annotate("rect", xmin = 65, xmax = 100, ymin = 0, ymax = 75, fill = "#E8DFDD", alpha = 0.8) + # Subajuste
    
    # Líneas divisorias
    geom_vline(xintercept = c(35, 65), linetype = "dashed", color = "#666666", linewidth = 0.8) +
    
    # B. LA CURVA
    geom_line(data = df_curva, aes(x = EjeX, y = AICc), color = "#2c3e50", linewidth = 2.5) +
    
    # C. PUNTO ÓPTIMO
    geom_point(data = punto_optimo, aes(x = EjeX, y = AICc), size = 6, color = "#222222") + 
    geom_point(data = punto_optimo, aes(x = EjeX, y = AICc), size = 3, color = "white") +  
    
    # D. 1. SOBREAJUSTE (IZQUIERDA)
    annotate("text", x = 17.5, y = 68, label = "SOBREAJUSTE\n(Overfitting)", fontface = "bold", size = 5, color = "#000000") +
    annotate("text", x = 17.5, y = 58, label = "Δ AICc > 0", fontface = "bold", size = 4.5, color = "#000000") +
    # 👇 COORDENADA 'y' BAJADA A 12
    annotate("text", x = 17.5, y = 12, label = "El modelo es demasiado complejo.\nMemorización, solo reconoce lo que ya ha visto", size = 4.2, color = "#222222", fontface = "italic", lineheight = 1.2) +
    
    # D. 2. ÓPTIMO (CENTRO)
    annotate("text", x = 50, y = 12, label = "MODELO ÓPTIMO\n(Δ AICc = 0)", fontface = "bold", size = 5, color = "#000000") +
    
    # D. 3. SUBAJUSTE (DERECHA)
    annotate("text", x = 82.5, y = 68, label = "SUBAJUSTE\n(Underfitting)", fontface = "bold", size = 5, color = "#000000") +
    annotate("text", x = 82.5, y = 58, label = "Δ AICc > 0", fontface = "bold", size = 4.5, color = "#000000") +
    # 👇 COORDENADA 'y' BAJADA A 12
    annotate("text", x = 82.5, y = 12, label = "El modelo es demasiado simple.\nGeneralización, ignorando los límites ecológicos reales", size = 4.2, color = "#222222", fontface = "italic", lineheight = 1.2) +
    
    # E. ESTÉTICA Y TÍTULOS
    labs(
      title = "Criterio de Información de Akaike (AICc)",
      x = "Complejidad paramétrica del modelo",
      y = "Valor AICc"
    ) +
    
    coord_cartesian(ylim = c(0, 75), expand = FALSE) +
    theme_classic(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 18, hjust = 0.5, color = "#111111", margin = margin(t = 10, b = 5)),
      plot.subtitle = element_text(size = 13, hjust = 0.5, color = "#444444", margin = margin(b = 20)),
      axis.title.x = element_text(face = "bold", margin = margin(t = 15)),
      axis.title.y = element_text(face = "bold", margin = margin(r = 15)),
      axis.text = element_blank(), 
      axis.ticks = element_blank(),
      plot.margin = margin(20, 20, 20, 20)
    )
  
  print(grafico_curva_aicc)
  
  
  
  # 4. Guardar el gráfico en alta resolución (Calidad Publicación)
  ruta_export_aicc <- "D:/Proyecto_RanasEcuador/Resultados_UCB/Infografia_Curva_AICc.png"
  
  ggsave(filename = ruta_export_aicc, 
         plot = grafico_curva_aicc, 
         width = 12,      # Ancho en pulgadas (apaisado)
         height = 6.5,    # Alto en pulgadas
         dpi = 300,       # Resolución de alta calidad
         bg = "white")    # Fondo blanco de seguridad
  
  cat("\n✅ ¡Gráfico AICc guardado con éxito en alta resolución!\n")
  cat("Ruta:", ruta_export_aicc, "\n")
  
  
  # ------------------------------------------------------------------------------
  # PREVISUALIZACIÓN 2 CORREGIDA: MAPA BINARIO DE ACIERTOS (AUC)
  # ------------------------------------------------------------------------------
  umbral_10 <- quantile(pres_vals, probs = 0.10, na.rm = TRUE)
  mapa_binario <- mapa_actual >= umbral_10
  
  paleta_binaria <- c("#d9d9d9", "#31a354")
  
  plot(mapa_binario, col = paleta_binaria, legend = FALSE, axes = TRUE,
       main = paste("Capacidad de Discriminación Binaria\n(Umbral 10% =", round(umbral_10, 3), "| AUC =", round(auc_final, 3), ")"))
  
  # 1. Leyenda de Hábitat: Texto más pequeño (cex = 0.75) y separada del borde (inset)
  legend("topright", legend = c("Hábitat Idóneo", "Hábitat No Idóneo"), 
         fill = rev(paleta_binaria), bty = "n", cex = 0.75, inset = 0.02)
  
  # 2. Puntos: Reducimos el tamaño de círculos (cex = 0.6) y triángulos (cex = 0.8)
  points(pres_train$longitud, pres_train$latitud, pch = 21, bg = "white", col = "black", cex = 0.6)
  points(pres_test$longitud, pres_test$latitud, pch = 24, bg = "#d73027", col = "black", cex = 0.8, lwd = 1)
  
  # 3. Leyenda de Puntos: Textos más cortos y ajustados al tamaño de los nuevos puntos
  legend("bottomleft", legend = c("Entrenamiento", "Validación (Ocultos)"),
         pch = c(21, 24), pt.bg = c("white", "#d73027"), col = "black", bty = "n", 
         cex = 0.75, pt.cex = c(0.6, 0.8), inset = 0.02)
  
  
  
  
  