classdef TraceCircle < handle
    %TRACECIRCLE 
    
    properties
        absV_
        radius_
        W_
    end
    
    methods
        
        function obj = TraceCircle(absV, R)
            if nargin == 1
               R = 10;
            end
            obj.absV_ = absV;
            obj.radius_ = R;
            obj.W_ = absV / R;
        end
        
        
        % --- linear moving
        function pos = location( obj, t )
            pos = obj.radius_ * [ cos(obj.W_ * t)  sin(obj.W_ * t)  t*0 ];
        end
        
        
        % --- [ az el ] rotation
        function ang = orientation( obj, t )
            ang = [ rad2deg(obj.W_ * t) + 90   zeros(size(t)) ];
        end
        
        
    end
    
end

