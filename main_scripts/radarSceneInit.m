function  [ tg, rd ] = radarSceneInit( tgOpt, rdOpt )
%   Возвращает инициализированные объекты модели.
%
%     % параметры цели
%     tgOpt.targetType    = 2;
%     tgOpt.targetOpt1    = 3;
%     tgOpt.targetOpt2    = 10;
%     tgOpt.absVelocity   = 1;
%     tgOpt.traceType     = 2;
%     tgOpt.traceOpt1     = 5;
%     tgOpt.traceOpt2     = 1;
%     tgOpt.position      = [500 0 0];
%
%     % параметры РЛС
%     rdOpt.carrierFreq   = 9e9;
%     rdOpt.pulseRate     = 2000;
%     rdOpt.pulseFormId   = 1;
%     rdOpt.rangeResolution   = 1;
%     rdOpt.rangeLim      = [ 100 300 ];
%     rdOpt.frameBufferImageTimeLim   = 1;
% rdOpt.lenSpertrAccum    = 2048;
% rdOpt.windowsFftLen     = 128;

% --- target initialization
switch tgOpt.traceType
    case 'TraceCircle'
        % tg.Opt1 - радиус окужности.
        tg.trace = TraceCircle( tgOpt.absVelocity, tgOpt.traceRadius);
    case 'TraceReclinear'
        V = [tgOpt.absVelocity * [cosd(tgOpt.traceAz)  sind(tgOpt.traceAz)] 0];
        tg.trace = TraceReclinear( V, tgOpt.traceRotation);
    otherwise
        error('No traceClass')
end

switch tgOpt.targetType
    case 'Target'
        tg.target = Target( tgOpt.position, tg.trace );
    case 'TargetCopter'
        tg.target = TargetCopter( tgOpt.numBlade, tgOpt.rotFreq, ...
            tgOpt.position, tg.trace );
    case 'TargetHuman'
        tg.target = TargetHuman( tgOpt.absVelocity, 1.7, ...
            tgOpt.position, tg.trace );
    otherwise
        error('No traceClass')
end


% --- radar initialization
rd.transmiter = Transmitter( 1 / rdOpt.pulseRate,...
    rdOpt.rangeResolution, ...
    rdOpt.pulseFormId );
rd.radar = Radar( rd.transmiter, rdOpt.rangeLim, rdOpt.carrierFreq);
rd.radarImager = RadarImaging( rdOpt.rangeLim, rdOpt.lenSpertrAccum, ...
                               rdOpt.windowsFftLen, 1 / rdOpt.pulseRate, ...
                               rdOpt.frameBufferImageTimeLim );
end





















