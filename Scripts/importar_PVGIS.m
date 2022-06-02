%% Import data from text file

projectFolder = fileparts(pwd);
scriptFolder=strcat(projectFolder,"\Scripts");
dataFolder=strcat(projectFolder,"\Data");
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [10, 8769];
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Var1", "Irradiancia", "Var3", "Temperatura", "Var5", "Var6"];
opts.SelectedVariableNames = ["Irradiancia", "Temperatura"];
opts.VariableTypes = ["string", "double", "string", "double", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var3", "Var5", "Var6"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var3", "Var5", "Var6"], "EmptyFieldRule", "auto");

% Import the data
folder=strcat(dataFolder,"\PVGIS.csv");
PVGIS = readtable(folder, opts);

diasmes= [31,28,31,30,31,30,31,31,30,31,30,31];
ref = 0;
irradiancia = zeros(744,12);
temperatura = zeros(744,12);
for mes = 1:12
    for d = 1:diasmes(mes)
        for h = 1:24
            irradiancia((d-1)*24+h,mes) = PVGIS.Irradiancia((ref*24)+(24*(d-1))+h);
            temperatura((d-1)*24+h,mes) = PVGIS.Temperatura((ref*24)+(24*(d-1))+h);  
        end
    end
    ref=ref+diasmes(mes);    
end
ref = 0;
for mes = 1:12
    for d = 1:diasmes(mes)
        for h = 1:24
            tc = temperatura((d-1)*24+h,mes) + 0.03125*irradiancia((d-1)*24+h,mes);
            dataGeneracion((d-1)*24+h,mes) = (irradiancia((d-1)*24+h,mes)/1000)*(1+((ktempPotencia/100)*(tc-25)));
        end
    end
    ref=ref+diasmes(mes);    
end

%% Clear temporary variables
clear opts
clear folder
clear ref mes d h diasmes PVGIS temperatura irradiacion tc