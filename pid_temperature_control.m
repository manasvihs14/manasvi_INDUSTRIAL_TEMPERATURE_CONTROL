%% pid_temperature_control.m
% Industrial Temperature Control System
% Transfer Function: G(s) = 2 / (10s + 1)
% -------------------------------------------------

clc; clear; close all;

%% Plant Transfer Function
num = 2;
den = [10 1];
G   = tf(num, den);
disp('Plant Transfer Function:'); G

%% PID Controller Parameters
Kp  = 3;
Ki  = 0.5;
Kd  = 1;
PID = pid(Kp, Ki, Kd);
disp('PID Controller:'); PID

%% Closed-Loop System
sys_PID = feedback(PID * G, 1);
disp('Closed-Loop Transfer Function:'); sys_PID

%% Step Response
figure('Name','Step Response','Color','w');
step(sys_PID, 30);
grid on;
title('Closed-Loop Step Response');
xlabel('Time (seconds)');
ylabel('Amplitude');

%% Performance Analysis
info = stepinfo(sys_PID);

%% Steady-State Error
[y, ~] = step(sys_PID);
final_value = y(end);
ess = abs(1 - final_value);

fprintf('\n-----------------------------------\n');
fprintf('Steady-State Error  = %.4f\n', ess);
fprintf('Overshoot           = %.2f %%\n', info.Overshoot);
fprintf('Settling Time       = %.2f s\n',  info.SettlingTime);
fprintf('Rise Time           = %.2f s\n',  info.RiseTime);
fprintf('Peak Time           = %.2f s\n',  info.PeakTime);
fprintf('-----------------------------------\n');

%% Disturbance Rejection (disturbance at t = 15 s)
t = 0:0.1:50;
d = zeros(size(t));
d(t >= 15) = -0.3;

figure('Name','Disturbance Rejection','Color','w');
lsim(sys_PID, d, t);
grid on;
title('Disturbance Rejection Response');
xlabel('Time (seconds)');
ylabel('Temperature Output');

%% Bode Plot (Open Loop)
figure('Name','Bode Plot','Color','w');
bode(PID * G);
grid on;
title('Open-Loop Bode Plot');

%% Root Locus
figure('Name','Root Locus','Color','w');
rlocus(G);
grid on;
title('Root Locus of Plant');

disp('Simulation Completed Successfully');
