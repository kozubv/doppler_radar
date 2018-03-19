% 
clc
clear
close all

% -------------------------------------------------------------------------
% --- Initialisation

% параметры цели  
% 'Target' OR 'TargetCopter' OR 'TargetHuman'
tgOpt.targetType    = 'TargetCopter'; 
% --- TargetCopter оptions
tgOpt.numBlade    = 2;                  % кол-во пропеллеров у мультикоптера
tgOpt.rotFreq     = 100;                  % частота вращения пропеллера
% --- moving options
tgOpt.absVelocity   = 100;                % модуль скорости 
tgOpt.traceType     = 'TraceReclinear'; % 'TraceReclinear' OR 'TraceCircle' 
% --- options TraceRecliniar 
tgOpt.traceAz       = 60;                % направление скорости от оси X
tgOpt.traceRotation = [0 0]; % [Azimut Elevation] % угловая скорость вращения относительно центра
% --- options TraceCircle 
tgOpt.traceRadius   = 5;                % радиус окружности для круговой траектории
tgOpt.position      = [500 0 0];% начальные координаты цели. 


% параметры РЛС
rdOpt.carrierFreq       = 19e9;          % рабочая частота радара
rdOpt.pulseRate         = 100e3;         % частота следования импульсов
rdOpt.pulseFormId       = 1;            % только прямоуголная форма импульсов.
rdOpt.rangeResolution   = 30;           % разрешение по дальности
rdOpt.rangeLim          = sqrt(sum(tgOpt.position.^2)) + [ -1 1 ]*50;
rdOpt.frameBufferImageTimeLim   = 0.002;  % временной отрезок, отображаемого сигнала в 'Pulse accumulation long-time frame'
rdOpt.lenSpertrAccum    = 1024/2;     % колво импусов Short-time Fourier transform
rdOpt.windowsFftLen     = 128/2;          % размер окна в STFT



[ tg, rf ] = radarSceneInit( tgOpt, rdOpt );
% tg - структура с указателями на объект цели
% rf - структура с указателями на объекты радиолокационной системя

% ---
dRadc = 3e8 / rf.radar.fadc_ / 2;       % дискрет дальности в отсчете АЦП
% номер канала дальности с целью
tgChen = ceil( ( sqrt(sum(tgOpt.position.^2)) - rdOpt.rangeLim(1)) / dRadc );
meanFreq = 2*tgOpt.absVelocity / (3e8 / rdOpt.carrierFreq )



% -------------------------------------------------------------------------
% --- Execution
timeSimulation = 8/tgOpt.rotFreq;                 % время моделирования 


% временной шаг моделирования
timeStep = 16 / rdOpt.pulseRate;
tPause = 0.1;

if max(tgOpt.traceRotation) > 0     % если цель вращяется
    dt = 2 / rdOpt.pulseRate;
    tPause = 0;
end

tBias = 1e-9;
T = 0 : timeStep : timeSimulation;

hAx = demoWindow;
lastSampleSpectrumPlot = 0;

for n = 1 : (length(T)-1)
    t1 = T(n);
    t2 = T(n+1) - tBias;
    w = rf.radar.echoComplexTarget( [ t1 t2 ], tg.target);
    rf.radarImager.pushBuffer( w );
    
    rf.radarImager.imageBuffer( hAx.ax2);
    tg.target.drawObj(t1, hAx.ax1);
    
    rf.radarImager.trackSpectrum( tgChen )
    if rf.radarImager.numPulses_ - lastSampleSpectrumPlot > rdOpt.windowsFftLen
        rf.radarImager.imageSpecgramm( hAx.ax3 );
        lastSampleSpectrumPlot = rf.radarImager.numPulses_;
    end
    
    pause(tPause)
    drawnow    
end






