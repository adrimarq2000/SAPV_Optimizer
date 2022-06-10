%% Import data from text file
% Script for importing data from the following text file:
%    filename: C:\Users\adri5\OneDrive - UPV\Clase\TFG\Matlab\Data\TTF_TTR.csv

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["TTF", "TTR"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
folder=strcat(dataFolder,"\TTF_TTR.csv");
TTF_TTR = readtable(folder, opts);
TTF = table2array(TTF_TTR(:,1));
TTR = table2array(TTF_TTR(:,2));
%% Clear temporary variables
clear opts
clear folder
clear TTF_TTR