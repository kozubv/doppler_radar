classdef TargetHelium < Target
    %TARGET
    %   posArr[n][x y z]
    %
    
    properties
        bladeSize_  = 1;
        rotFreq_    = 10;
    end
    
    
    methods
        % --- Initialisation 
        function obj = TargetHelium( bladeSize, rotFreq,...
                position, traceType )
            if nargin == 2
                position = [0 0 0];
                traceType = TraceReclinear;
            end
            obj = obj@Target( position, traceType );
            
            obj.bladeSize_  = bladeSize;
            obj.rotFreq_    = rotFreq;
        end
        
        
        % --- Overloading 
        function posArr = pointState( obj, t )
            if size( t, 2 )~=1
                warning('lols')
                t = t';
            end
            posArr = zeros(size(t, 1), 2, 3);
            posArr(:, 1, :) = [   cos( 2*pi*obj.rotFreq_*t ) ...
                sin( 2*pi*obj.rotFreq_*t ) ...
                zeros(size(t)) ] * obj.bladeSize_;
            posArr(:, 2, :) = [   cos( 2*pi*obj.rotFreq_*t ) ...
                sin( 2*pi*obj.rotFreq_*t ) ...
                zeros(size(t)) ] * -obj.bladeSize_;
        end
        
        
        % --- 
        function draw( obj, t, ax )
            % Helium target state drawning
            posArr = squeeze( obj.getPosition( t(1,1) ) );
            
            obj.handlePlot_(end + 1) = plot3(ax, posArr(:,1), ...
                                        posArr(:,2), ...
                                        posArr(:,3), 'ok', ...
                                        'markerfacecolor', 'b', ...
                                        'markersize', 5);   
        end
        
        
    end
    
end





















