classdef Transmitter < handle
    %TRANSMITTER 
    
    properties
        rate_               % частота зондирования 
        period_             % период повторения 
        pulseDuration_      % длительность сигнала
        pulseForm_
    end
    
    properties ( Access = private )
       accuracy_ = 1e-9;
    end
    
    
    methods
        function obj = Transmitter( period, rangeResolution, pulseFormID )
            if nargin == 1
                rangeResolution = 10;
                pulseFormID = 1;
            end
            
            % pulse form definition
            switch pulseFormID
                case 1
                    obj.pulseForm_  = 'rectpuls';
                case 2
                    obj.pulseForm_ = 'sign';
                otherwise
                    error('Lols signal type'); 
            end
            obj.pulseDuration_ = rangeResolution / 3e8;
            
            obj.rate_ = 1 / period;
            obj.period_ = period;
        end
        
        
        % ---
        function S = transSignal( obj, t )
            %
        end
        
        
        % --- envelope
        function s = sigEnvelope( obj, t )
            d = obj.pulseTrigger( [t(1, :); t(end, :)]' );
            s = pulstran(t - obj.pulseDuration_/2*0, d, obj.pulseForm_, obj.pulseDuration_);
        end
        
        
        % --- pulse sequence start positions in 't' series
        function d = pulseTrigger( obj, t)
            for k = 1:size(t, 1)
                d = (ceil( t(k,1)/obj.period_ ) * obj.period_ : obj.period_ : t(k,end) )';
                if ~isempty(d) 
                    return
                end
            end
        end

        
    end
    
end















