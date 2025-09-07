% Q2.m – Questions 2a and 2b: ERP and Frequency-Domain Analysis
clear; clc; close all;

%% --- Question 2a: ERP in the Time Domain ---
% Load EEG data
load('Q2_Data.mat');  % EEG structure is loaded

% Basic info
fs = EEG.srate;           % Sampling frequency
times = EEG.times;        % Time vector
data = EEG.data;          % Dimensions: channels x time x trials

% Compute ERP for channel 1
erp = mean(squeeze(data(1, :, :)), 2);  % ERP is time x 1

% Plot ERP waveform
figure;
plot(times, erp, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude (\muV)');
title('ERP - Channel 1 (Q2\_Data.mat)');
grid on;

%% --- Question 2b: Frequency-Domain Comparison ---
% 1. Power spectrum of the first single trial
x1 = squeeze(data(1, :, 1));
n = length(x1);
freqs = (0:n-1)*(fs/n);
psd1 = abs(fft(x1)).^2;

% 2. Power spectrum of the time-averaged ERP
psd2 = abs(fft(erp)).^2;

% 3. Average power spectrum across trials
n_trials = size(data, 3);
fft_trials = fft(squeeze(data(1, :, :)), [], 1);  % time x trials
psd3 = mean(abs(fft_trials).^2, 2);               % mean across trials

% Keep only positive frequencies
half = floor(n/2);
freqs = freqs(1:half);
psd1 = psd1(1:half);
psd2 = psd2(1:half);
psd3 = psd3(1:half);

% Plot all 3 spectra
figure;

subplot(1,3,1)
plot(freqs, psd1, 'LineWidth', 1.2);
title('Single Trial Power Spectrum');
xlabel('Frequency (Hz)');
ylabel('Power');
xlim([0 100]);
grid on;

subplot(1,3,2)
plot(freqs, psd2, 'LineWidth', 1.2);
title('ERP Spectrum');
xlabel('Frequency (Hz)');
xlim([0 100]);
grid on;

subplot(1,3,3)
plot(freqs, psd3, 'LineWidth', 1.2);
title('Avg. of Trial-wise FFTs');
xlabel('Frequency (Hz)');
xlim([0 100]);
grid on;

sgtitle('Power Spectrum Comparison - Channel 1');
