# Modelamiento espacial para distribución potencial en escenarios climáticos CMIP6

Repositorio del proyecto de investigación sobre modelamiento espacial de la distribución de especies de la familia Dendrobatidae en la Amazonía ecuatoriana.
La finalidad es la de estimar y prever el impacto de diferentes escenarios de cambio climático en la distribución potencial de estas especies.

## 📂 Estructura del Repositorio

* `Scripts/` -> Contiene el código fuente principal en R Markdown (`Metodologia_Modelamiento.Rmd`) con todo el flujo de análisis estadístico, preparación de variables bioclimáticas y modelamiento.
* `Resultados_UCB/` / `Resultados_Finales/` -> Salidas procesadas del modelo (tablas de métricas y validaciones).

## ⚙️ Metodología y Reproducibilidad

El análisis se desarrolló en el entorno de **R** (versión 4.5.2), utilizando librerías especializadas para análisis geoespacial como `terra`, `raster`, `dismo`, `geodata` , `sf`, entre otras.

> **Nota sobre archivos pesados:** Por políticas de tamaño y buenas prácticas de control de versiones en GitHub, las capas ráster originales (`.tif`) y shapefiles pesados no se encuentran alojados en este repositorio (controlados mediante `.gitignore`). Sin embargo, el script metodológico detalla el proceso completo para su carga y procesamiento local.

> **Nota sobre el alcance del código:** Este repositorio contiene exclusivamente los scripts desarrollados en R para el modelamiento espacial de la distribución de especies y el análisis estadístico. El análisis de la variación espacial de la riqueza de especies, y el procesamiento cartográfico final que incluye la edición y composición de mapas se realizó utilizando el software especializado de información geográfica ArcGIS Pro v3.3, por lo que dichos pasos no forman parte del código script proporcionado en este repositorio.
