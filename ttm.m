tic;
clc; clear;

%% Define input parameter sets
inputSets = [ ...
    -250, 10000;  % First set of temperature and heatflux
    -150, 8000;   % Second set
    -50, 6000;    % Third set
    % Add more sets as needed
];

% Initialize array to store output results
Total_Heat_Flux_Averages = zeros(size(inputSets, 1), 1);  % Array to store outputs

% Define paths
journalTemplatePath = 'C:\Users\HP\Desktop\an+mat\old.wbjn';
outputJournalPath = 'C:\Users\HP\Desktop\an+mat\old.wbjn';
csvFile = 'C:\Users\HP\Desktop\an+mat\strong.csv';
ansysPath = 'E:\ANSYS Inc\ANSYS Student\v241\Framework\bin\Win64\RunWB2.exe';

%% Loop through each input set
for i = 1:size(inputSets, 1)
    % Set current parameters
    temperature = inputSets(i, 1);
    heatflux = inputSets(i, 2);
    
    %% Creating new journal file for each input set
    % Read and modify the journal template
    fid = fopen(journalTemplatePath, 'r');
    if fid == -1
        error('File "old.wbjn" not found.');
    end
    f = fread(fid, '*char')';
    fclose(fid);
    f = strrep(f, 'temperature', num2str(temperature));
    f = strrep(f, 'heatflux', num2str(heatflux));
    
    % Write the updated journal file for ANSYS
    fid = fopen(outputJournalPath, 'w');
    fprintf(fid, '%s', f);
    fclose(fid);
    
    %% Run ANSYS Workbench with the journal file
    if ~isfile(ansysPath)
        error('ANSYS executable not found at specified path: %s', ansysPath);
    end
    
    % Run ANSYS
    system(['"', ansysPath, '" -B -R "', outputJournalPath, '"']);
    
    % Allow time for ANSYS to generate the CSV file
    pause(5);  % Adjust as needed

    % Check if the CSV file was generated
    if ~isfile(csvFile)
        error('CSV file "strong.csv" not found. Verify ANSYS output settings.');
    end

    %% Read and store the output parameter from the CSV file
    csvData = readmatrix(csvFile);
    if size(csvData, 1) >= 8 && size(csvData, 2) >= 4
        Total_Heat_Flux_Averages(i) = csvData(8, 4);  % Store output for this input set
        disp(['Total Heat Flux Average for Set ', num2str(i), ': ', num2str(Total_Heat_Flux_Averages(i))]);
    else
        error('The CSV file does not contain the expected data format in row 8, column 4.');
    end
end

%% Display all results
disp('All Total Heat Flux Averages:');
disp(Total_Heat_Flux_Averages);
toc;
