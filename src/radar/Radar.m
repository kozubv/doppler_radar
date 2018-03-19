classdef Radar < handle
    %RADAR - Control of the pulse cycle 
    
    properties
        transmitter_        % 
        rangeLim_
        tRec_
        f0_
        fadc_ = 100e6;        % fs ADC 
    end
    properties ( Constant )
        c_light = 3e8;
    end
    
    
    methods
        % ---
        function obj = Radar(transmitter, rangeLim, carrierFreq )
            if nargin == 1
                rangeLim = [0.3e3 1e3];
                carrierFreq = 9e9;
            end
            obj.transmitter_ = transmitter;
            obj.rangeLim_ = rangeLim;
            obj.f0_ = carrierFreq;
            
            obj.fadc_ = 5 / transmitter.pulseDuration_ ;
            obj.tRec_ = 2*rangeLim(1)/obj.c_light:1/obj.fadc_:2*rangeLim(2)/obj.c_light;
        end
        
        
        % --- 
        function tracePulses = echoComplexTarget( obj, t, complexTarget_Ref )
            if isempty(complexTarget_Ref)
                getTargRange = @genTarg;
            else
                getTargRange = @complexTarget_Ref.getTargetDistanse;
            end
            % t = [ minT  maxT ]
            % size(posArr) = [length(Time) ] x [length(Point)]
            % tSample [ timePositionVector ] x [ timeSignalSampleVector ]
            % distArr [ timePositionVector ] x [ pointDistance ]
            
            % accumulating time sample array
            d = obj.transmitter_.pulseTrigger( [t(1) t(end)] );
            tPulseRec = d;
            tSample = repmat( obj.tRec_, size(tPulseRec) ) + tPulseRec;
            distArr = getTargRange( tSample(:,1) );
            
            tracePulses = zeros(size( tSample ));
            tracePoint = tracePulses;
            for k = 1 : size( distArr, 1)
                % tSample(k,:)' - time sample 'column' recaive pulse
                % distArr(k, :) - target distanse 'line'
                tracePoint = obj.echoSimpleTarget( tSample(k,:)', distArr(k, :) );
                tracePulses(k,:) = sum(tracePoint, 2)';
            end
            tracePulses = tracePulses';
        end
        
        
        % --- echo from target array
        function s_doplerShift = echoSimpleTarget( obj, t, R )
            % size(R) = [1] x [N]
            tDeley = 2 * R / obj.c_light;
            s = obj.transmitter_.sigEnvelope( t - tDeley);
            ph_doplerShift = exp( 1i*2*pi * tDeley*obj.f0_);
            s_doplerShift = s .* ph_doplerShift;
        end
        
        
        % --- recave process moment
        function rec = recTrigger( obj, t )
            % --- соответствующие моменты излучения 
            d = obj.transmitter_.pulseTrigger( [t(1) t(end)] );
            rec = d + 2 * obj.rangeLim_(1) / obj.c_light ;
        end
        
        
        % ---
        function imageTrace( obj, tracePulses )
            imagesc( obj.rangeLim_, ...
                     [ 0  size(tracePulses,1) ] * obj.transmitter_.period_, ...
                     real(tracePulses))
        end
        
    end
    
end
 

















