projectFolder = pwd;
scriptFolder=strcat(projectFolder,"\Scripts");
dataFolder=strcat(projectFolder,"\Data");
cd (scriptFolder);

importar_curvas;
importar_consumos;
importar_TTFTTR;

cd (projectFolder);

Resultados = table('Size', [iteraciones 8],'VariableTypes',{'single','double','double','double','double','double','double','double'});
Resultados.Properties.VariableNames = {'Iteracion','ENA','HNA','ENS','LOLE','nF','nIDG','LOLP'};