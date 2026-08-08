clc;
clear;
close all;

Length = 300;
n = 0:Length-1;
s = sin(2*pi*0.02*n);

rng(43);
x = randn(Length,1);
alpha = 0.8;
d = s' + alpha * x + 0.05*randn(Length,1);

figure;
plot(n, s, 'b', 'LineWidth', 1.5);
title('Original Clean Signal s[n]');
xlabel('Sample Index'); ylabel('Amplitude');
grid on;

figure;
plot(n, d, 'r', 'LineWidth', 1.5);
title('Noisy Signal d[n] = s[n] + Noise');
xlabel('Sample Index'); ylabel('Amplitude');
grid on;

M = 16;
mu = 0.01;
iterations = Length;

w = zeros(M,1);
y = zeros(iterations,1);
e = zeros(iterations,1);

for k = M:iterations
    x_vec = x(k:-1:k-M+1);
    y(k) = w' * x_vec;
    e(k) = d(k) - y(k);
    w = w + mu * e(k) * x_vec;
end

figure;
plot(e.^2, 'LineWidth', 1.3);
title(['LMS Squared Error, M = ', num2str(M), ', \mu = ', num2str(mu)]);
xlabel('Sample Index'); ylabel('Error^2');
grid on;

figure;
subplot(3,1,1);
plot(d, 'r');
title('Noisy Signal d[n]');
xlabel('Sample Index'); ylabel('Amplitude');

subplot(3,1,2);
plot(y, 'm');
title('Estimated Noise y[n]');
xlabel('Sample Index'); ylabel('Amplitude');

subplot(3,1,3);
plot(e, 'g'); hold on;
plot(s, 'b--');
title(['Filtered Signal e[n] vs Original s[n], M=', num2str(M), ', \mu=', num2str(mu)]);
xlabel('Sample Index'); ylabel('Amplitude');
legend('Filtered Signal (e[n])', 'Original Signal (s[n])');

mse = mean(e.^2);
snr_out = 10*log10( sum(s.^2) / sum((e' - s).^2) );
fprintf('Mean Squared Error: %.4f\n', mse);
fprintf('Output SNR: %.2f dB\n', snr_out);
