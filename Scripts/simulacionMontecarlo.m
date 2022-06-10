capacidadMin=0.2*capacidadMax;
capInicial=0.8*capacidadMax;

for iteracion = 1:iteraciones
    calcularPuntos;                 % aleatoriza datos de generación, fallos y hace los cálculos para obtener parámetros en cada iteración
    almacenarResultados;            % almacena los resultados principales de cada iteración
end
costePaneles=precioW*PgBasemax;
costeBateria=precioWh*capacidadMax*vidaPv/vidaBat;
litrosCombustible=mean(Resultados.ENS)*consumoGrupo/1000;
costeCombustible=precioCombustible*litrosCombustible;

inversionInicial = costePaneles + costeBateria + precioInversor + precioRegulador;
costeVariable = costeCombustible + costeMantenimiento;
ANF = (tasaInteres * (1 + tasaInteres))/((1 + tasaInteres) - 1);
LCOE = 1000*((inversionInicial*ANF) + costeVariable)/(sum(genrand)*PgBasemax-mean(Resultados.ENA));
costeAnual = costePaneles/vidaPv + costeBateria/vidaBat + costeCombustible;

fiabilidad = 100-mean(Resultados.LOLP);