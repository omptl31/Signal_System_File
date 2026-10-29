clc;
clear;
close all;

% 1. Sine and Cosine Waves
t = -2*pi:0.01:2*pi;    % -2pi to 2 pi with increment of 0.01
A = 2;                  % amplitude
f = 1;                  % frequency(hz)
x1 = A*sin(2*pi*f*t);
x2 = A*cos(2*pi*f*t);

figure(1);
subplot(2,1,1);
plot(t, x1, 'b');       
ylabel('amplitude');
title('sine wave');
grid on;

subplot(2,1,2);
plot(t, x2, 'r');
xlabel('time');
ylabel('amplitude');
title('cosine wave');
grid on;

% 2. Sinc Function
figure(2);             
t1 = -10:0.01:10;
x3 = sin(pi*t1)./(pi*t1); 
x3(t1==0) = 1;          
plot(t1, x3, 'r');
xlabel('time');
ylabel('amplitude');
title('sinc function');
grid on;

% 3. Triangular Waveform
figure(3);
t2 = -2:0.001:2;        
x4 = 2*abs(2*(t2-floor(t2+0.5))) - 1;
plot(t2, x4, 'b');
xlabel('time');
ylabel('amplitude');
title('triangular function');
grid on;

% 4. Rectangular Pulse
figure(4);
t3 = -2*pi:0.01:2*pi;   
x5 = double(abs(t3) <= 0.5); 
plot(t3, x5, 'b', 'LineWidth', 2);
xlabel('time');
ylabel('amplitude');
title('Rectangular Pulse'); 
grid on;

% 5. Sawtooth Waveform
figure(5);
t4 = -2:0.001:2;        
x6 = 2*(t4-floor(t4+0.5)); 
plot(t4, x6, 'r');
xlabel('time');
ylabel('amplitude');
title('sawtooth function');
grid on;

% 6. Decaying Exponential
figure(6);
t5 = 0:0.001:5;
a = -1;                 
x7 = exp(a*t5);         
plot(t5, x7, 'b');
xlabel('time');
ylabel('amplitude');
title('decaying exponential function');
grid on;

% 7. Increasing Exponential
figure(7);
t6 = 0:0.001:5;
a = 1.5;                
x8 = exp(a*t6);        
plot(t6, x8, 'r');
xlabel('time');
ylabel('amplitude');
title('increasing exponential function');
grid on;