clc;
clear;
close all; 

t = -4:0.01:4;
k = 3;
a = 2;
b = 5;

s1 = [1, 2, -3, 4];
s2 = [2, -2, 5, 4, 6];

y1 = exp(s1); % y1=e^s1
y2 = exp(s2); % y2=e^s2

l1 = length(s1);
l2 = length(s2);

s11 = [s1, zeros(1, l2)];
s12 = [s2, zeros(1, l1)];

out1 = exp(a*s11 + b*s12); % eqn-1=(e^a*s1+b*s2)
out2 = a*exp(s11) + b*exp(s12); % y=a*exp(s11)+b*exp(s12)

tol = 0.0001;

if sum(abs(out2 - out1)) < tol
    disp('the system is linear');
else
    disp('the system is nonlinear');
end

subplot(2, 2, 1);
n_out1 = 0:length(out1)-1;
stem(n_out1, out1);
xlabel('samples');
ylabel('amplitude');
title('T(a*s1 + b*s2)');

subplot(2, 2, 2);
n_out2 = 0:length(out2)-1;
stem(n_out2, out2);
xlabel('samples');
ylabel('amplitude');
title('a*T(s1) + b*T(s2)');

% Time Invariant Testing
s3 = [1, -2, -3, 4, 5, 6];
u = exp(s3);

% Delayed Output
v = [zeros(1, k), u];

% Delayed Input
out3 = [zeros(1, k), s3];
w = exp(out3);
n2 = 0:length(w)-1;

tol = 0.0001;
if sum(abs(w - v)) < tol
    disp('the system is Time Invariant');
else
    disp('the system is Time Variant');
end

subplot(2, 2, 3);
n1 = 0:length(v)-1;
stem(n1, v);
xlabel('samples');
ylabel('amplitude');
title('Delayed Output: y(n-k)');
grid on;

subplot(2, 2, 4);
n2 = 0:length(w)-1;
stem(n2, w);
xlabel('samples');
ylabel('amplitude');
title('System Response to Delayed Input: T[x(n-k)]');
grid on;