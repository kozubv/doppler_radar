classdef TargetCopter < Target
    %TARGETCOPTER
    
    properties
        bladeSize_  = 0.3;
        rotFreq_    = 9;
        baseLen_    = 1;
        numBlade_   = 2;
        
        link_
        centerPos_
    end
    
    
    methods
        
        % --- Initialisation
        function obj = TargetCopter(num, rotFreq, position, traceType)
            if nargin == 1
                rotFreq = 9;
                position = [0 0 0];
                traceType = TraceReclinear([0.5 0 0], [0 180]);
            end
            obj = obj@Target( position, traceType );
            %
            obj.numBlade_ = num;
            obj.rotFreq_ = rotFreq;
            ang = linspace(0, 360, num+1)';
            ang(end) = [];
            obj.centerPos_ = [cosd(ang) sind(ang) zeros(size(ang))] * obj.baseLen_;
            
            obj.link_ = copterPlotLink(num);
            
        end
        
        
        % --- Overloading
        function posArr = pointState( obj, t )
            posArr = zeros(size(t, 1), obj.numBlade_ * 3, 3);
            for k = 1 : obj.numBlade_
                posArr(:, (k-1) * 3 + [1 2 3], :) = obj.bladeSize_*bladePoint(obj.rotFreq_, t, k*deg2rad(33)) + ...
                    reshape(obj.centerPos_(k, :), [1 1 3]);
                
            end
        end
        
        
        % ---
        function draw( obj, t, ax )
            posArr = squeeze( obj.getPosition( t(1,1) ) );
            L = obj.link_;
            for k = 1:length(obj.link_)
                hp(k) = plot3(ax, posArr(L{k},1), posArr(L{k},2), posArr(L{k},3), 'b-o',...
                    'markerfacecolor', 'b', ...
                    'markersize', 2 );
            end
            obj.handlePlot_ = [ obj.handlePlot_ hp];
        end
        
        
    end
    
    
end


function posArr = bladePoint( f, t, phase )
posArr = zeros(size(t,1), 3, 3);

posArr(:, 1, [1 2] ) = [ cos(2*pi*f*t + phase)  sin(2*pi*f*t + phase) ];
posArr(:, 3, 1 ) =  -posArr(:, 1, 1 );
posArr(:, 3, 2 ) =  -posArr(:, 1, 2 );
end




















