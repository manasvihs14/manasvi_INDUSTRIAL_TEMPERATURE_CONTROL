%% build_simulink_model.m
% Programmatically creates the Simulink model for the
% Industrial Temperature PID Control System
% Run this script once to generate: TempControl_PID.slx

modelName = 'TempControl_PID';

% Close if already open
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end

% Create new model
new_system(modelName);
open_system(modelName);

%% -------- Add Blocks --------

% 1. Step Input (Setpoint)
add_block('simulink/Sources/Step', [modelName '/Setpoint']);
set_param([modelName '/Setpoint'], ...
    'Time',       '0', ...
    'Before',     '0', ...
    'After',      '1', ...
    'Position',   '[50 130 80 160]');

% 2. Sum (error = setpoint - feedback)
add_block('simulink/Math Operations/Sum', [modelName '/Sum']);
set_param([modelName '/Sum'], ...
    'Inputs',   '+-', ...
    'Position', '[150 125 175 165]');

% 3. PID Controller
add_block('simulink/Continuous/PID Controller', [modelName '/PID_Controller']);
set_param([modelName '/PID_Controller'], ...
    'P',          '3', ...
    'I',          '0.5', ...
    'D',          '1', ...
    'N',          '100', ...
    'Position',   '[220 115 310 175]');

% 4. Plant Transfer Function  G(s) = 2/(10s+1)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/Plant']);
set_param([modelName '/Plant'], ...
    'Numerator',   '[2]', ...
    'Denominator', '[10 1]', ...
    'Position',    '[360 120 460 170]');

% 5. Disturbance (Step at t=15)
add_block('simulink/Sources/Step', [modelName '/Disturbance']);
set_param([modelName '/Disturbance'], ...
    'Time',     '15', ...
    'Before',   '0', ...
    'After',    '-0.3', ...
    'Position', '[340 230 370 260]');

% 6. Sum2 (plant output + disturbance)
add_block('simulink/Math Operations/Sum', [modelName '/Sum_Dist']);
set_param([modelName '/Sum_Dist'], ...
    'Inputs',   '++', ...
    'Position', '[490 125 515 165]');

% 7. Scope — Output
add_block('simulink/Sinks/Scope', [modelName '/Scope_Output']);
set_param([modelName '/Scope_Output'], ...
    'NumInputPorts', '2', ...
    'Position',      '[580 120 620 170]');

% 8. To Workspace — log output
add_block('simulink/Sinks/To Workspace', [modelName '/To_Workspace']);
set_param([modelName '/To_Workspace'], ...
    'VariableName', 'simOut', ...
    'SaveFormat',   'Array', ...
    'Position',     '[580 195 640 225]');

%% -------- Connect Blocks --------

% Setpoint → Sum(+)
add_line(modelName, 'Setpoint/1',      'Sum/1',          'autorouting','on');
% Sum → PID
add_line(modelName, 'Sum/1',           'PID_Controller/1','autorouting','on');
% PID → Plant
add_line(modelName, 'PID_Controller/1','Plant/1',         'autorouting','on');
% Plant → Sum_Dist(+)
add_line(modelName, 'Plant/1',         'Sum_Dist/1',      'autorouting','on');
% Disturbance → Sum_Dist(+)
add_line(modelName, 'Disturbance/1',   'Sum_Dist/2',      'autorouting','on');
% Sum_Dist → Scope port 1
add_line(modelName, 'Sum_Dist/1',      'Scope_Output/1',  'autorouting','on');
% Sum_Dist → To Workspace
add_line(modelName, 'Sum_Dist/1',      'To_Workspace/1',  'autorouting','on');
% Setpoint → Scope port 2 (for reference overlay)
add_line(modelName, 'Setpoint/1',      'Scope_Output/2',  'autorouting','on');
% Sum_Dist (feedback) → Sum(-)
add_line(modelName, 'Sum_Dist/1',      'Sum/2',           'autorouting','on');

%% -------- Simulation Settings --------
set_param(modelName, 'Solver',   'ode45');
set_param(modelName, 'StopTime', '60');
set_param(modelName, 'StartTime','0');

%% -------- Save --------
save_system(modelName, [modelName '.slx']);
fprintf('\nSimulink model saved as: %s.slx\n', modelName);
fprintf('Open with: open_system(''%s'')\n\n', modelName);
fprintf('Run simulation: sim(''%s'')\n', modelName);
