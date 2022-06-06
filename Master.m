clc;
clear all;

capacidadMax = 13000;
potenciaNominal = 550;      %potencia nominal del panel fotovoltaico
ktempPotencia = -0.35;      %coeficiente de temperatura porcentual de las celdas /datos tomados de JAsolar JAM72S30-550
npaneles = 12;

Pdmax = 3000;               %potencia máxima en instalación de demanda
%% Definición problema
% Parametros sistema
rendIn=0.9;
rendOut=0.9;
fiabilidadExigible = 90;

% Parametros costes
precioW=0.4;                % precio de los paneles por W instalado
vidaPv = 25;
precioWh=0.5;               % precio de la bateria por Wh de capacidad
vidaBat = 15;
precioInversor = 800;
precioRegulador = 400;
consumoGrupo = 0.5;         %l/kWh
precioCombustible = 1.4;    %€/l
costeMantenimiento = 300;
tasaInteres = 0.05;

% Parametros simulacion
aleatorizar = 1;
iteraciones = 500;
    %método adquisicion de datos 0
    %metodo datos irradiancia 1
metodo = 1;
optimizacion = 0;

inicializar                 % toma datos de consumos, generación y distribuciones de fallo
%% Optimización por el camino de la mejora óptima
if optimizacion == 0
    % Sistema inicial
    version = 1;
    Sistema(version).pg = PgBasemax;
    Sistema(version).cap = capacidadMax;
    
    simulacionMontecarlo;
    
    Sistema(version).fiabilidad = fiabilidad;
    Sistema(version).costeAnual = costeAnual;
    Sistema(version).LCOE = LCOE;
    
    if Sistema(version).fiabilidad < fiabilidadExigible
        error('ERROR. El sistema inicial no cumple el requisito de fiabilidad.');
    end
    % Mejora continua
    % Definicion de las mejoras y calculo. Decisión de la que optimiza más el sistema.
    while 1 == 1
        Mejora(1).pg = Sistema(version).pg + potenciaNominal;
        Mejora(1).cap = Sistema(version).cap;
        Mejora(2).pg = Sistema(version).pg;
        Mejora(2).cap = Sistema(version).cap + 500;
        Mejora(3).pg = Sistema(version).pg - potenciaNominal;
        Mejora(3).cap = Sistema(version).cap;
        Mejora(4).pg = Sistema(version).pg;
        Mejora(4).cap = Sistema(version).cap - 500;
        
        for x = 1:4
            PgBasemax = Mejora(x).pg;
            capacidadMax = Mejora(x).cap;
            simulacionMontecarlo;
            Mejora(x).fiabilidad = fiabilidad;
            Mejora(x).costeAnual = costeAnual;
            Mejora(x).LCOE = LCOE;
        end
        
        version = version + 1
        Sistema(version).pg = Mejora(1).pg;
        Sistema(version).cap = Mejora(1).cap;
        Sistema(version).fiabilidad = Mejora(1).fiabilidad;
        Sistema(version).costeAnual = Mejora(1).costeAnual;
        Sistema(version).LCOE = Mejora(1).LCOE;
        
        for x = 2:4
            if Mejora(x).fiabilidad > fiabilidadExigible && (Mejora(x).costeAnual < Sistema(version).costeAnual)
                Sistema(version).pg = Mejora(x).pg;
                Sistema(version).cap = Mejora(x).cap;
                Sistema(version).fiabilidad = Mejora(x).fiabilidad;
                Sistema(version).costeAnual = Mejora(x).costeAnual;
                Sistema(version).LCOE = Mejora(x).LCOE;
            end
        end
        clear x;
        if Sistema(version).costeAnual > Sistema(version-1).costeAnual
            break
        end
    end
    
    % Escribir solucion final
    Final.pg = Sistema(version-1).pg;
    Final.cap = Sistema(version-1).cap;
    Final.fiabilidad = Sistema(version-1).fiabilidad;
    Final.costeAnual = Sistema(version-1).costeAnual;
    Final.LCOE = Sistema(version-1).LCOE
end

%% Optimización método PSO



