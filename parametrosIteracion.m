costePaneles=precioW*PgBasemax/periodoVidaPan;
costeBateria=precioWh*capacidadMax/periodoVidaBat;
litrosCombustible=mean(Resultados.ENS)*consumoGrupo/1000;
costeCombustible=precioCombustible*litrosCombustible;

costeTotal(sistema) = costePaneles + costeBateria + costeCombustible;
fiabilidad(sistema) = 100-mean(Resultados.LOLP);