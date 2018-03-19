function [Y, fScale]  = fftScale(x, fs)
%  y - спектр,
%  f - частотная шкала
%  t - временные отсчеты
%  s - отсчеты сигналов
% 
L = length(x) - rem(length(x),2); % делаем кол-во отсчетов четн
x = x(1:L);

y = fft(x);
Y = abs(y/L);
Y = fftshift(Y);

fPos = fs*(0:L/2)/L;
fNeg = -flip(fPos(2:end-1));
fScale = [fNeg  fPos];


