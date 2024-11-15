tic;
clc; clear;

%% Changing the input parameters
Heatflux = 20005;
temperature = 10;

% creating new journal file
% Open and read the template journal file, replacing placeholders
fid  = fopen('new journal.wbjn', 'r');
if fid == -1
    error('File "new journal.wbjn" not found.');
end
f = fread(fid, '*char')';
fclose(fid);
f = strrep(f, 'Heatflux', num2str(Heatflux));
f = strrep(f, 'temperature', num2str(temperature));

% Write the updated journal file for ANSYS
fid  = fopen('finaljournal.wbjn', 'w');
fprintf(fid, '%s', f);
fclose(fid);

%% Calculations in ANSYS with input parameters
% Define the correct path for ANSYS RunWB2 executable
ansysPath = 'E:\ANSYS Inc\ANSYS Student\v241\Framework\bin\Win64\RunWB2.exe';
if ~isfile(ansysPath)
    error('ANSYS executable not found at specified path: %s', ansysPath);
end

% Run ANSYS Workbench with the journal file, enclosing the path in quotes
system(['"', ansysPath, '" -B -R finaljournal.wbjn']);

% Allow time for ANSYS to generate the CSV file
pause(5);  % Adjust this pause duration as needed

% Check if the file was generated
if isfile('export data.csv')
    disp('CSV file generated successfully.');
else
    error('CSV file "export data.csv" not found. Verify ANSYS output settings.');
end

%% Saving the output parameter
% Define the correct path for the output CSV file
csvFile = fullfile(pwd, 'export data.csv');

% Read the specific cell from the output CSV file
heatfluxmaximum = xlsread(csvFile, 'export data', 'D8');
toc;
