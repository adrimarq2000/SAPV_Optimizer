almacenamiento = zeros([8760 1]);
ENS = zeros([8760 1]);
ENA = zeros([8760 1]);
SOC = zeros([8760 1]);
nF = zeros([8760 1]);
nIDG = zeros([8760 1]);

% aleatorizar generación y disponibilidad de la instalción fotovoltaica
if aleatorizar
    cd (scriptFolder);
    [genrand, ONOFF]=aleatorizargeneracion(dataGeneracion,metodo,TTF,TTR);
    cd (projectFolder);
end
 % normalizar valores de datos a la instalacion de ensayo
demanda=dataConsumos/max(dataConsumos)*Pdmax;
generacion=genrand.*ONOFF/max(genrand)*PgBasemax;

%% calcular primer punto con parámetros iniciales
n=1;
if generacion(n) >= demanda(n)
    almacenamiento(n) = min(capInicial + (generacion(n) - demanda(n))*rendIn , capacidadMax);
elseif generacion(n) < demanda(n)
    almacenamiento(n) = max(capacidadMin, capInicial - (demanda(n) - generacion(n))/rendOut);
else
    disp('ERROR en datos de generacion/demanda');
    return;
end

if demanda(n) < generacion(n)
    ENS(n) = 0;
else    
    ENS(n) = demanda(n) - generacion(n) + (almacenamiento(n)-capInicial)*rendOut;
end

if almacenamiento(n) < capacidadMax
    ENA(n) = 0;
else    
    ENA(n) = (generacion(n) - demanda(n))*rendIn - (almacenamiento(n) - capInicial);
end

SOC(n)=100*almacenamiento(n)/capacidadMax;

if ONOFF(n) == 0
    nF(n) = 1;
else
    nF(n) = 0;
end

if almacenamiento(n) == capacidadMin
    nIDG(n) = 1;
else
    nIDG(n) = 0;
end

%% calcular resto de puntos
for n = 2:8760
    if generacion(n) >= demanda(n)
            almacenamiento(n) = min(capacidadMax, almacenamiento(n-1) + (generacion(n) - demanda(n))*rendIn);
    elseif generacion(n) < demanda(n)
        almacenamiento(n) = max(capacidadMin, almacenamiento(n-1) - (demanda(n) - generacion(n))/rendOut);
    else
        disp('ERROR en datos de generacion/demanda');
        return;
    end
    
    if demanda(n) < generacion(n)
        ENS(n) = 0;
    else    
        ENS(n) = demanda(n) - generacion(n) + (almacenamiento(n) - almacenamiento(n-1))*rendOut;
    end
    
    if almacenamiento(n) < capacidadMax
        ENA(n) = 0;
    else    
        ENA(n) = (generacion(n) - demanda(n))*rendIn - (almacenamiento(n) - almacenamiento(n-1));
    end
    
    SOC(n)=100*almacenamiento(n)/capacidadMax;
    
    if (ONOFF(n) == 0) && (ONOFF(n-1)==1)
        nF(n) = nF(n-1) + 1;
    else
        nF(n) = nF(n-1);
    end
    
    if (almacenamiento(n) == capacidadMin) && (almacenamiento(n-1) > capacidadMin)
        nIDG(n) = nIDG(n-1) + 1;
    else
        nIDG(n) = nIDG(n-1);
    end
end
%% Saca resultados totales
ENAt = sum(ENA);
ENSt = sum(ENS);
HNA=0;
HNS=0;
for i = 1:8760
    if ENA(i)> 0.01
        HNA = HNA+1;
    else
        HNA = HNA;
    end
end
for i = 1:8760
    if ENS(i) > 0.01
        HNS = HNS+1;
    else
        HNS = HNS;
    end
end
LOLE=HNS;
LOLP = LOLE/87.6;
nFt=max(nF);
nIDGt=max(nIDG);

clear i;
clear n;