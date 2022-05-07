%% Import data from text file
% Script for importing data from the following text file:
%    filename: C:\Users\adri5\OneDrive - UPV\Clase\TFG\Matlab\Data\Consumos.csv
projectFolder = fileparts(pwd);
scriptFolder=strcat(projectFolder,"\Scripts");
dataFolder=strcat(projectFolder,"\Data");
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Fecha", "Dia", "Var3", "MiConsumo"];
opts.SelectedVariableNames = ["Fecha", "Dia", "MiConsumo"];
opts.VariableTypes = ["datetime", "double", "string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Var3", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var3", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Fecha", "InputFormat", "dd/MM/yyyy HH:mm");

% Import the data
folder=strcat(dataFolder,"\Consumos.csv");
Consumos = readtable(folder, opts);
dataConsumos = table2array(Consumos(:,3));

%% Clear temporary variables
clear opts
clear folder
clear Consumos