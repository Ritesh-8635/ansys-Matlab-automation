tic;
clc; clear;

%% Changing the input parameters
temperature = -150;
heatflux = 52200;

% Creating new journal file
% Open and read the template journal file, replacing placeholders
fid = fopen('C:\Users\HP\Desktop\an+mat\old.wbjn', 'r');
if fid == -1
    error('File "old.wbjn" not found.');
end
f = fread(fid, '*char')';
fclose(fid);
f = strrep(f, 'temperature', num2str(temperature));
f = strrep(f, 'heatflux', num2str(heatflux));

% Write the updated journal file for ANSYS
fid = fopen('C:\Users\HP\Desktop\an+mat\old.wbjn', 'w');
fprintf(fid, '%s', f);
fclose(fid);

%% Calculations in ANSYS with input parameters
% Define the correct path for ANSYS RunWB2 executable
ansysPath = 'E:\ANSYS Inc\ANSYS Student\v241\Framework\bin\Win64\RunWB2.exe';
if ~isfile(ansysPath)
    error('ANSYS executable not found at specified path: %s', ansysPath);
end

% Run ANSYS Workbench with the journal file, enclosing the path in quotes
system(['"', ansysPath, '" -B -R "C:\Users\HP\Desktop\an+mat\finaljournal.wbjn"']);

% Allow time for ANSYS to generate the CSV file
pause(5);  % Adjust this pause duration as needed

% Check if the CSV file was generated
csvFile = 'C:\Users\HP\Desktop\an+mat\strong.csv';
if isfile(csvFile)
    disp('CSV file generated successfully.');
else
    error('CSV file "strong.csv" not found. Verify ANSYS output settings.');
end

%% Saving the output parameter
% Read the specific cell from the output CSV file using readmatrix

toc;
