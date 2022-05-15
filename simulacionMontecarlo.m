capacidadMin=0.2*capacidadMax;
capInicial=0.8*capacidadMax;

for iteracion = 1:iteraciones
    calcularPuntos;                 % aleatoriza datos de generación, fallos y hace los cálculos para obtener parámetros en cada iteración
    almacenarResultados;            % almacena los resultados principales de cada iteración
end
costePaneles=precioW*PgBasemax/periodoVidaPan;
costeBateria=precioWh*capacidadMax/periodoVidaBat;
litrosCombustible=mean(Resultados.ENS)*consumoGrupo/1000;
costeCombustible=precioCombustible*litrosCombustible;

costeTotal = costePaneles + costeBateria + costeCombustible;
fiabilidad = 100-mean(Resultados.LOLP);