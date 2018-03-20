clear, clc, close all
% проверка корректности работы самописной спектрограммы, 
% (спекрограмму писал сам - т.к. встроенная не отображает отрицательных частот)

% signal parameters
xlen = 1024 * 2 + 10;                   
fs = 1e3;

t = (0:xlen-1)/fs;                  
x = chirp(t,100,1,200);

% define the analysis and synthesis parameters
wlen = 64*4;
hop = ceil(wlen*0.08);  % перекрытие оконн
nfft = wlen;
% perform time-frequency analysis and resynthesis of the original signal
[stft, F, T] = stftFullSc(x, wlen, hop, nfft, fs);

subplot(1,2,1)
% imagesc направляет ось У вниз, поэтому изображение перевернуто
% т.к. сигнал не комплексный ожидаем увидеть зеркальный спектр, у
% комплексного фаза будет определена точно. (в случае квадратурного представления)
imagesc([F(1) F(end)],[T(1) T(end)], log10(abs(stft')))
subplot(1,2,2)
spectrogram(x, hamming(wlen), wlen-hop, [], 1e3);