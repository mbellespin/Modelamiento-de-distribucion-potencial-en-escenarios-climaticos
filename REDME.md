# Modelamiento espacial para distribución potencial en escenarios climáticos CMIP6

Repositorio oficial del proyecto de investigación sobre modelamiento espacial de la distribución de anfibios (familia Dendrobatidae) en la Amazonía del Ecuador.
Con el fin de proyectar y prever el impacto de escenarios de cambio climático en la distribución potencial de estas especies.

## 📂 Estructura del Repositorio

* `Scripts/` -> Contiene el código fuente principal en R Markdown (`Metodologia_Modelamiento.Rmd`) con todo el flujo de análisis estadístico, preparación de variables bioclimáticas y modelamiento.
* `Resultados_UCB/` / `Resultados_Finales/` -> Salidas procesadas del modelo (tablas de métricas y validaciones).

## ⚙️ Metodología y Reproducibilidad

El análisis se desarrolló íntegramente en el entorno de **R** (versión 4.5.2), utilizando librerías especializadas para análisis geoespacial como `terra`, `raster`, `dismo`, `geodata` , `sf`, entre otras.

> **Nota sobre archivos pesados:** Por políticas de tamaño y buenas prácticas de control de versiones en GitHub, las capas ráster originales (`.tif`) y shapefiles pesados no se encuentran alojados en este repositorio (controlados mediante `.gitignore`). Sin embargo, el script metodológico detalla el proceso completo para su carga y procesamiento local.