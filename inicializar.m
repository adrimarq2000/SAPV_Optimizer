projectFolder = pwd;
scriptFolder=strcat(projectFolder,"\Scripts");
dataFolder=strcat(projectFolder,"\Data");
cd (scriptFolder);

importar_curvas;
importar_consumos;
importar_TTFTTR;
[genrand, ONOFF]=aleatorizargeneracion(generacion,TTF,TTR);

cd (projectFolder);
