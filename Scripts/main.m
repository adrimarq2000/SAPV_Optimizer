tic;
clc;
PgBasemax = potenciaNominal*npaneles;
inicializar                 % toma datos de consumos, generación y distribuciones de fallo
%% Optimización por el camino de la mejora óptima
if optimizacion == 0 || optimizacion == 2
    % Sistema inicial
    iteraciones = 1000;
    Resultados = table('Size', [iteraciones 8],'VariableTypes',{'single','double','double','double','double','double','double','double'});
    Resultados.Properties.VariableNames = {'Iteracion','ENA','HNA','ENS','LOLE','nF','nIDG','LOLP'};
    version = 1;
    Sistema(version).pg = PgBasemax;
    Sistema(version).cap = capacidadMax;
    
    simulacionMontecarlo;
    
    Sistema(version).fiabilidad = fiabilidad;
    Sistema(version).costeAnual = costeAnual;
    Sistema(version).LCOE = LCOE;
    
    if Sistema(version).fiabilidad < fiabilidadExigible
        cd(projectFolder);
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
        
        version = version + 1;
        disp(version);
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
    Final.LCOE = Sistema(version-1).LCOE;
    disp('Algoritmo camino óptimo');
    disp(Final);
end  
%% Optimización método PSO

if optimizacion == 1 || optimizacion == 2
    iteraciones = 100;
    clear Resultados;
    Resultados = table('Size', [iteraciones 8],'VariableTypes',{'single','double','double','double','double','double','double','double'});
    Resultados.Properties.VariableNames = {'Iteracion','ENA','HNA','ENS','LOLE','nF','nIDG','LOLP'};
    % Definition
    nVar = 2;
    VarSize = [1 nVar];
    Var1Min = potenciaNominal;
    Var1Max = 20000;
    Var2Min = 500;
    Var2Max = 35000;
    
    
    % PSO Parameters
    MaxIt = 20;   % Maximum Number of Iterations
    nPop = 30;     % Population Size (Swarm Size)
    w = 1;           % Intertia Coefficient
    wdamp = 0.90;   % Damping Ratio of Inertia Coefficient
    c1 = 2;         % Personal Acceleration Coefficient
    c2 = 2;         % Social Acceleration Coefficient
    ShowIterInfo = 1;
    
    % Initialization
    % The Particle Template
    empty_particle.Position = [];
    empty_particle.HistoricPosX = [];
    empty_particle.HistoricPosY = [];
    empty_particle.Velocity = [];
    empty_particle.Cost = [];
    empty_particle.Reliability = [];
    empty_particle.Best.Position = [];
    empty_particle.Best.Reliability = [];
    empty_particle.Best.Cost = [];
    % Create Population Array
    particle = repmat(empty_particle, nPop, 1);
    % Initialize Global Best
    GlobalBest.Cost = inf;
    % Initialize Population Members
    for p=1:nPop
        
        % Generate Random Solution
        particle(p).Position(1) = unifrnd(Var1Min, Var1Max);
        particle(p).Position(2) = unifrnd(Var2Min, Var2Max);
        
        % Initialize Velocity
        particle(p).Velocity = zeros(VarSize);
        
        % Evaluation
        PgBasemax = particle(p).Position(1);
        capacidadMax = particle(p).Position(2);
        simulacionMontecarlo;
        particle(p).Cost = costeAnual;
        particle(p).Reliability = fiabilidad;
        
        % Update the Personal Best
        particle(p).Best.Position = particle(p).Position;
        particle(p).Best.Reliability = particle(p).Reliability;
        particle(p).Best.Cost = particle(p).Cost;
        
        % Update Global Best
        if (particle(p).Best.Cost < GlobalBest.Cost) && (particle(p).Best.Reliability > fiabilidadExigible)
            GlobalBest = particle(p).Best;
        end
        
    end
    % Array to Hold Best Cost Value on Each Iteration
    BestCosts = zeros(MaxIt, 1);
    
    
    % Main Loop of PSO
    for it=1:MaxIt
        for p=1:nPop
            % Update Velocity
            particle(p).Velocity = w*particle(p).Velocity ...
                + c1*rand(VarSize).*(particle(p).Best.Position - particle(p).Position) ...
                + c2*rand(VarSize).*(GlobalBest.Position - particle(p).Position);
            % Update Position
            particle(p).HistoricPosX(it) = particle(p).Position(1);
            particle(p).HistoricPosY(it) = particle(p).Position(2);
            particle(p).Position = particle(p).Position + particle(p).Velocity;
            % Apply Lower and Upper Bound Limits
            particle(p).Position(1) = max(particle(p).Position(1), Var1Min);
            particle(p).Position(1) = min(particle(p).Position(1), Var1Max);
            particle(p).Position(2) = max(particle(p).Position(2), Var2Min);
            particle(p).Position(2) = min(particle(p).Position(2), Var2Max);
            % Evaluation
            PgBasemax = particle(p).Position(1);
            capacidadMax = particle(p).Position(2);
            simulacionMontecarlo;
            particle(p).Cost = costeAnual;
            particle(p).Reliability = fiabilidad;
            % Update Personal Best
            if (particle(p).Cost < particle(p).Best.Cost)
                particle(p).Best.Position = particle(p).Position;
                particle(p).Best.Reliability = particle(p).Reliability;
                particle(p).Best.Cost = particle(p).Cost;
                % Update Global Best
                if (particle(p).Best.Cost < GlobalBest.Cost) && (particle(p).Best.Reliability > fiabilidadExigible)
                    GlobalBest = particle(p).Best;
                end
            end
            
        end
        
        % Store the Best Cost Value
        BestCosts(it) = GlobalBest.Cost;
        
        % Display Iteration Information
        if ShowIterInfo
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
        end
        
        % Damping Inertia Coefficient
        w = w * wdamp;
        
    end
    
    out.pop = particle;
    out.BestSol = GlobalBest;
    out.BestCosts = BestCosts;
    disp('Algoritmo PSO');
    disp('Best System: ');
    disp(['Power = ' num2str(out.BestSol.Position(1)) ' W']);
    disp(['Battery = ' num2str(out.BestSol.Position(2)) ' Wh']);
    disp(['Annual Approx. Cost = ' num2str(out.BestSol.Cost) ' ' moneda]);
    disp(['Supply Reliability = ' num2str(out.BestSol.Reliability) ' %']);
    
end
toc
cd(projectFolder);
