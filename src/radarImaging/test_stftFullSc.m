clear, clc, close all

% music program (stochastic non-stationary signal)
%[x, fs] = audioread('track.wav');   

% x = x(:, 1);                                  

% signal parameters
xlen = 1024 * 2 + 10;                   
fs = 1e3;

t = (0:xlen-1)/fs;                  
%x = exp(1i*2*pi*100*t);
x = chirp(t,100,1,200);


% define the analysis and synthesis parameters
wlen = 128*4;
hop = wlen/2;
nfft = 10*wlen;
% perform time-frequency analysis and resynthesis of the original signal
[stft, F, T] = stftFullSc(x, wlen, hop, nfft, fs);

subplot(1,2,1)
imagesc([T(1) T(end)], [F(1) F(end)], log10(abs(stft)))
subplot(1,2,2)
spectrogram(x, wlen, hop, [], 1e3);