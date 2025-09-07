% Q4.m – Questions 4a and 4b: ERP and STFT Analysis of Transient Burst
clear; clc; close all;

%% --- Question 4a: ERP in the Time Domain ---
% Load EEG data
load('Q4_Data.mat');  % EEG structure is loaded

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
title('ERP - Channel 1 (Q4\_Data.mat)');
grid on;

%% --- Question 4b: Time–Frequency Analysis with STFT ---
% Spectrogram parameters
window = hamming(128);       % Window shape
nfft = 512;                  % FFT size
noverlap = 96;               % Overlap between segments

% Spectrogram computation
[S,F,T] = spectrogram(erp, window, noverlap, nfft, fs, 'psd');

% Convert to dB
S_dB = 10*log10(abs(S));

% Plot spectrogram
figure;
imagesc(T, F, S_dB);
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('ERP Spectrogram - Q4\_Data.mat');
colorbar;
ylim([0 100]);

% Interpretation:
% The transient burst is clearly visible between ~0.6 and ~0.9 seconds.
% The peak frequency is around 25–30 Hz with a bandwidth of roughly 15 Hz.
