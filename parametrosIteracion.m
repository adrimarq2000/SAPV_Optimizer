costePaneles=precioW*PgBasemax/periodoVidaPan;
costeBateria=precioWh*capacidadMax/periodoVidaBat;
litrosCombustible=ENS/(consumoGrupo/1000);
costeCombustible=precioCombustible*litrosCombustible;
costeTotal[sistema] = costePaneles + costeBateria + costeCombustible;
fiabilidad[sistema] = 100-LOLP;