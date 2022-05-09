almacenamiento = zeros([8760 1]);
ENS = zeros([8760 1]);
ENA = zeros([8760 1]);
SOC = zeros([8760 1]);
nF = zeros([8760 1]);
nIDG = zeros([8760 1]);

if aleatorizar
    cd (scriptFolder);
    [genrand, ONOFF]=aleatorizargeneracion(dataGeneracion,TTF,TTR);
    cd (projectFolder);
end

demanda=dataConsumos/max(dataConsumos)*Pdmax;
generacion=genrand.*ONOFF/max(genrand)*PgBasemax;

%% calcular primer punto con parámetros iniciales
n=1;
if generacion(n) >= demanda(n)
    almacenamiento(n) = min(capacidadMax, capInicial + (generacion(n) - demanda(n))*rendIn);
elseif generacion(n) < demanda(n)
    almacenamiento(n) = max(capacidadMin, capInicial + (generacion(n) - demanda(n))*rendOut);
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

SOC(n)=almacenamiento(n)/capacidadMax;

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
        almacenamiento(n) = max(capacidadMin, almacenamiento(n-1) + (generacion(n) - demanda(n))*rendOut);
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
    
    SOC(n)=almacenamiento(n)/capacidadMax;
    
    if (ONOFF(n) == 0) && (ONOFF(n-1)==1)
        nF(n) = nF(n-1) + 1;
    else
        nF(n) = 0;
    end
    
    if (almacenamiento(n) == capacidadMin) && (almacenamiento(n-1) > capacidadMin)
        nIDG(n) = nIDG(n-1) + 1;
    else
        nIDG(n) = 0;
    end
end
%% Sacar estadísticas totales
ENAt = sum(ENA);
ENSt = sum(ENS);
HNA = find(ENA);
HNA = numel(HNA);
HNS = find(ENS);
LOLE = numel(HNS);
LOLP = LOLE/8.76;
nFt=max(nF);
nIDGt=max(nIDG);