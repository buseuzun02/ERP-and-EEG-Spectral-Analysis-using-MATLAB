% Q1.m – Questions 1b and 1c: ERP and Noise Type Identification
clear; clc; close all;

%% --- Question 1b: ERP and Power Spectrum (Q1_Data1 only) ---
% Load EEG data
load('Q1_Data1.mat');  % EEG structure is loaded

% Basic info
fs = EEG.srate;           % Sampling frequency
times = EEG.times;        % Time vector
data = EEG.data;          % Dimensions: channels x time x trials

% Compute ERP for channel 1
erp = mean(squeeze(data(1, :, :)), 2);  % ERP is time x 1

% Method 1: FFT of ERP
n = length(erp);
frequencies = (0:n-1)*(fs/n);
fft_erp = fft(erp);
psd_erp = abs(fft_erp).^2;

% Method 2: FFT of each trial and averaging
n_trials = size(data, 3);
fft_trials = fft(squeeze(data(1, :, :)), [], 1);  % time x trials
psd_trials = mean(abs(fft_trials).^2, 2);         % average power

% Keep only positive frequencies
half = floor(n/2);
frequencies = frequencies(1:half);
psd_erp = psd_erp(1:half);
psd_trials = psd_trials(1:half);

% Plot ERP and both spectra
figure;
subplot(1,2,1)
plot(times, erp, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude (\muV)');
title('ERP - Channel 1 (Q1\_Data1)');

subplot(1,2,2)
plot(frequencies, psd_erp, 'b', 'LineWidth', 1.2); hold on;
plot(frequencies, psd_trials, 'r--', 'LineWidth', 1.2);
xlabel('Frequency (Hz)');
ylabel('Power');
legend('FFT of ERP', 'Average of FFTs');
title('Power Spectrum - Channel 1');
grid on;

%% --- Question 1c: Noise Type Identification (All 3 datasets) ---
% This section compares the ERP power spectra of the three datasets
% to help determine their underlying noise type (white, pink, uniform)

files = {'Q1_Data1.mat', 'Q1_Data2.mat', 'Q1_Data3.mat'};
colors = {'b', 'r', 'g'};
labels = {'Q1\_Data1', 'Q1\_Data2', 'Q1\_Data3'};

figure;
hold on;

for i = 1:length(files)
    load(files{i});  % Load EEG structure
    fs = EEG.srate;
    data = EEG.data;

    % ERP of channel 1
    erp = mean(squeeze(data(1, :, :)), 2);

    % Power spectrum of ERP
    n = length(erp);
    freqs = (0:n-1)*(fs/n);
    fft_erp = fft(erp);
    psd = abs(fft_erp).^2;

    % Only positive frequencies
    half = floor(n/2);
    freqs = freqs(1:half);
    psd = psd(1:half);
    psd = psd / max(psd);  % normalize

    % Plot
    plot(freqs, psd, 'Color', colors{i}, 'DisplayName', labels{i}, 'LineWidth', 1.5);
end

xlabel('Frequency (Hz)');
ylabel('Normalized Power');
title('ERP Power Spectrum Comparison');
legend('show');
grid on;
xlim([0 100]);
