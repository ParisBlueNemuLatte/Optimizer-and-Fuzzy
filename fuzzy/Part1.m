clc
clear
close all
% Initialize Fuzzy Inference System
fis = mamfis('Name', 'AssistiveCareFLC');

% Define Input: Temperature
fis = addInput(fis, [0 40], 'Name', 'Temperature');
fis = addMF(fis, 'Temperature', 'trimf', [0 0 20], 'Name', 'Cold');
fis = addMF(fis, 'Temperature', 'trimf', [10 20 30], 'Name', 'Warm');
fis = addMF(fis, 'Temperature', 'trimf', [20 40 40], 'Name', 'Hot');

% Define Input: Humidity
fis = addInput(fis, [0 100], 'Name', 'Humidity');
fis = addMF(fis, 'Humidity', 'trimf', [0 0 50], 'Name', 'Dry');
fis = addMF(fis, 'Humidity', 'trimf', [30 50 70], 'Name', 'Comfortable');
fis = addMF(fis, 'Humidity', 'trimf', [50 100 100], 'Name', 'Humid');

% Define Input: Light Level
fis = addInput(fis, [0 1000], 'Name', 'LightLevel');
fis = addMF(fis, 'LightLevel', 'trimf', [0 0 500], 'Name', 'Dark');
fis = addMF(fis, 'LightLevel', 'trimf', [250 500 750], 'Name', 'Dim');
fis = addMF(fis, 'LightLevel', 'trimf', [500 1000 1000], 'Name', 'Bright');

% Define Output: Heater Power
fis = addOutput(fis, [0 100], 'Name', 'HeaterPower');
fis = addMF(fis, 'HeaterPower', 'trimf', [0 0 25], 'Name', 'Off');
fis = addMF(fis, 'HeaterPower', 'trimf', [0 25 50], 'Name', 'Low');
fis = addMF(fis, 'HeaterPower', 'trimf', [25 50 75], 'Name', 'Medium');
fis = addMF(fis, 'HeaterPower', 'trimf', [50 100 100], 'Name', 'High');

% Define Output: Fan Speed
fis = addOutput(fis, [0 100], 'Name', 'FanSpeed');
fis = addMF(fis, 'FanSpeed', 'trimf', [0 0 25], 'Name', 'Off');
fis = addMF(fis, 'FanSpeed', 'trimf', [0 25 50], 'Name', 'Low');
fis = addMF(fis, 'FanSpeed', 'trimf', [25 50 75], 'Name', 'Medium');
fis = addMF(fis, 'FanSpeed', 'trimf', [50 100 100], 'Name', 'High');

% Define Output: Blind Position
fis = addOutput(fis, [0 100], 'Name', 'BlindPosition');
fis = addMF(fis, 'BlindPosition', 'trimf', [0 0 50], 'Name', 'Closed');
fis = addMF(fis, 'BlindPosition', 'trimf', [0 50 100], 'Name', 'Half-open');
fis = addMF(fis, 'BlindPosition', 'trimf', [50 100 100], 'Name', 'Open');

% Define Fuzzy Rules
ruleList = [
    "If (Temperature is Cold) and (Humidity is Dry) then (HeaterPower is High) (FanSpeed is Off)";
    "If (Temperature is Warm) and (LightLevel is Dark) then (BlindPosition is Open)";
    "If (Temperature is Hot) and (Humidity is Humid) then (FanSpeed is High) (HeaterPower is Off)";
    % Add more rules as needed
];

for i = 1:length(ruleList)
    fis = addRule(fis, ruleList(i));
end

% Display FIS structure
disp(fis);

% Plot Membership Functions
figure;
subplot(3,1,1);
plotmf(fis, 'input', 1);
title('Temperature Membership Functions');
subplot(3,1,2);
plotmf(fis, 'input', 2);
title('Humidity Membership Functions');
subplot(3,1,3);
plotmf(fis, 'input', 3);
title('Light Level Membership Functions');

% Evaluate FIS
temp = 25; % Example temperature input
humidity = 60; % Example humidity input
light = 300; % Example light level input

output = evalfis(fis, [temp, humidity, light]);
disp('FIS Output:');
disp(output);

% Plot Control Surface
figure;
gensurf(fis);
title('Control Surface');
