classdef RadarImaging < handle
    %RADARIMAGING
    % frameBufer_   : содержит импульсы накопления
    %      - line   : echo signal
    %      - colomn : range channel
    
    
    properties
        rangeLim_
        pulsePeriod_
        plotTimeLim_
        
        frameBuffer_    = [];      % [1 : numRangeChan_] x [1 : numPulses]
        numRangeChan_   = 0;
        numPulses_      = 0;
        
        spectrum_
        lenSpertrAccum_  = 2048;
        lastSpectrPulse_ = 1;
        windLen_
        
        axHandle_
    end
    
    methods
        
        function obj = RadarImaging( rangeLim, lenSpertrAccum, windLen, ... 
                                       pulsePeriod, plotTimeLim )
            if nargin == 4
                plotTimeLim = 0.5;
            end
            obj.lenSpertrAccum_ = lenSpertrAccum;
            obj.windLen_ = windLen;
            obj.rangeLim_   = rangeLim;
            obj.pulsePeriod_ = pulsePeriod;
            obj.plotTimeLim_ = plotTimeLim;
        end
        
        
        % ---
        function pushBuffer( obj, subFrame )
            if size(subFrame, 1) ~= obj.numRangeChan_ && ~isempty(obj.frameBuffer_)
                error('Error subFrame trace signal size')
            elseif isempty(obj.frameBuffer_)
                obj.numRangeChan_ = size(subFrame, 1);
            end
            obj.frameBuffer_ = [ obj.frameBuffer_  subFrame ];
            obj.numPulses_   =  size( obj.frameBuffer_, 2 );
        end
        
        
        % ---
        function trackSpectrum( obj , numChannel )
            if (obj.numPulses_ - obj.lastSpectrPulse_) < obj.lenSpertrAccum_
                return
            else
                S = obj.frameBuffer_(numChannel, obj.lastSpectrPulse_ : end) ;
                obj.lastSpectrPulse_ = obj.numPulses_;
            end
            % Spectrogramm
            % s = spectrogram(S,128,120,128, 1/obj.pulsePeriod_ );
            wlen = obj.windLen_;
            hop = ceil(wlen*0.25);
            nfft = wlen;
            % perform time-frequency analysis and resynthesis of the original signal
            [stft, ~, ~] = stftFullSc(S, wlen, hop, nfft, 1/obj.pulsePeriod_);
            obj.spectrum_ = [obj.spectrum_ stft];
        end
        
        
        % --- imaging caurrent state frameBuffer
        function imageBuffer( obj, ax )
            if nargin == 1 && isempty(obj.axHandle_)
                obj.axHandle_ = axes;
                ax = obj.axHandle_;
            elseif nargin == 2 && isempty(obj.axHandle_)
                obj.axHandle_ = ax;
            end            
            %tic
            pulsePlotNumber = floor( obj.plotTimeLim_ / obj.pulsePeriod_ );
            tAccum = obj.numPulses_ * obj.pulsePeriod_;
            
            if obj.numPulses_ < pulsePlotNumber
                tScale = [0 tAccum];
                imagesc(obj.axHandle_, tScale, obj.rangeLim_, real(obj.frameBuffer_) )
                
            else
                tScale = [tAccum - obj.plotTimeLim_ tAccum];
                imagesc(obj.axHandle_, tScale, obj.rangeLim_,...
                    real( obj.frameBuffer_(:, end - pulsePlotNumber + 1 : end)) )
            end
            view(ax, 0,-90);
            title(ax, 'Pulse accumulation long-time frame. Real part.')
            xlabel(ax,'Time, [ sec ]')
            ylabel(ax,'Range, [ m ] ')
        end
        
        
        % ---
        function imageSpecgramm( obj, axSp )
            tAccum = obj.numPulses_ * obj.pulsePeriod_;
            imagesc(axSp, [0 tAccum], [-1 1]*(0.5/obj.pulsePeriod_), ...
                            log10(abs(obj.spectrum_) ))
           view(axSp,0,-90);
           title(axSp, 'Micro-Doppler Spectrogramm')
           xlabel(axSp,'Time, [sec]')
           ylabel(axSp,'Frequency, [Hz] ')
        end
        
    end
    
end























