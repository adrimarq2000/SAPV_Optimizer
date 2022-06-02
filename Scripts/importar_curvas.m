%% Import data from text file

projectFolder = fileparts(pwd);
scriptFolder=strcat(projectFolder,"\Scripts");
dataFolder=strcat(projectFolder,"\Data");
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 47, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47"];
opts.VariableTypes = ["datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double", "string", "datetime", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["VarName4", "VarName8", "VarName12", "VarName16", "VarName20", "VarName24", "VarName28", "VarName32", "VarName36", "VarName40", "VarName44"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName4", "VarName8", "VarName12", "VarName16", "VarName20", "VarName24", "VarName28", "VarName32", "VarName36", "VarName40", "VarName44"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "VarName1", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName5", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName9", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName13", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName17", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName21", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName25", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName29", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName33", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName37", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName41", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, "VarName45", "InputFormat", "dd/MM/yyyy HH:mm");
opts = setvaropts(opts, ["VarName2", "VarName3","VarName6", "VarName7","VarName10", "VarName11","VarName14", "VarName15","VarName18", "VarName19","VarName22", "VarName23","VarName26", "VarName27","VarName30", "VarName31","VarName34", "VarName35","VarName38","VarName39", "VarName42","VarName43","VarName46","VarName47"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["VarName2", "VarName3","VarName6", "VarName7","VarName10", "VarName11","VarName14", "VarName15","VarName18", "VarName19","VarName22", "VarName23","VarName26", "VarName27","VarName30", "VarName31","VarName34", "VarName35","VarName38","VarName39", "VarName42","VarName43","VarName46","VarName47"], "ThousandsSeparator", ",");

% Import the data
folder=strcat(dataFolder,"\Curvas.csv");
Curvas = readtable(folder, opts);
dataGeneracion = table2array(Curvas(:,[3,7,11,15,19,23,27,31,35,39,43,47]));
dataGeneracion = dataGeneracion.*(1/max(max(dataGeneracion)));
%% Clear temporary variables
clear opts
clear folder
clear Curvas