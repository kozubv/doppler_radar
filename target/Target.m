classdef Target < handle
    %TARGET
    
    properties
        position_
        orientation_
        traceType_
        handlePlot_
        handleAxes_
    end
    
    
    methods (Access = public)
        
        function obj = Target( position, traceType )
            if nargin == 1
                traceType = TraceReclinear;
            end
            obj.traceType_ = traceType;
            obj.position_ = position;
            obj.orientation_ = [0 0];
            
        end
        
        
        % ---
        function ptArr = getPosition( obj, t )
            ptArr = obj.pointState( t );
            
            % Rotation ( Only for first andle in frame -- for t(1) )
            %t
            ang = obj.traceType_.orientation( t(1) );
            ang = ang + obj.orientation_;
            AEM = angle2dcm( deg2rad(ang(1)), deg2rad(ang(2)), 0 );
            for k = 1 : size(ptArr, 2)
                if length(t) == 1   % т.к. SQUEEZE не имеет параметра указывающего размерность 
                                    % усечения. 
                    ptArr(:,k,:) = reshape(squeeze(ptArr(:,k,:))' * AEM, size(ptArr(:,k,:)));
                else
                    ptArr(:,k,:) = reshape(squeeze(ptArr(:,k,:)) * AEM, size(ptArr(:,k,:)));
                end
            end
            
            % Translation
            pos = obj.traceType_.location( t );
            %posArr = ptArrRot + reshape(pos, [1 1 3]);
            for k = 1 : size(ptArr, 2)
                ptArr(:,k,:) = ptArr(:,k,:)  + ...
                                reshape(pos + obj.position_, [size(pos,1) 1 3]);
            end
        end
        
        
        % ---
        function ax = drawObj( obj, t, ax )
            %
            if nargin == 2
                if isempty(obj.handleAxes_)
                    ax =  setAxesPlan( obj.position_([1 2]) );
                    obj.handleAxes_ = ax;
                else
                    ax = obj.handleAxes_;
                end
            elseif nargin == 3 && isempty( obj.handleAxes_ )
                ax = setAxesPlan( [500 0], ax );
                obj.handleAxes_ = ax;
            end
            %
            delete(obj.handlePlot_)
            % Location of the center
            pos = obj.traceType_.location( t(1, 1) ) + obj.position_;
            obj.handlePlot_ = plot3(ax, pos(1), pos(2), pos(3), 'ok', ...
                'markerfacecolor', 'k', ...
                'markersize', 5);
            % Orientation array
            ang = obj.traceType_.orientation( t(1, 1) );
            obj.handlePlot_(end + 1) = plot3(ax, ...
                pos(1) + [ 0 cosd(ang(1)) ], ...
                pos(2) + [ 0 sind(ang(1)) ], ...
                pos(3) + [0 0], 'r', 'linewidth', 2);
            obj.draw(t, ax);
        end
        
        
        %---
        function draw( obj, t, ax)
            % 
        end
        
        
        % --- for ones point target
        function ptArr = pointState( obj, t )        
            ptArr = zeros(size(t, 1), 1, 3);  
        end
        
        
        % ---
        function R = getTargetDistanse( obj, t )
            if size(t, 2) ~= 1
               error('Timea array should be column') 
            end
            loc = obj.getPosition( t );
            R = sqrt(sum(loc.^2,3));
        end
        
    end
    
end


















