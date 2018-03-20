classdef TargetHuman < Target
    %TARGETHUMAN
    
    properties %(Access = private)
        % human discription
        V_
        L_ = {  [1 5], ...
            [5 12],...
            [2 3 4 5 6 7 8],...
            [9 10 11 12 13 14 15]   };  % Links
        
        %
        fps_ = 120;    % 120 fps when s(1)=1
        t_ = 0;
        omega_
        dt_
        
        %
        fileName_ = 'track.mat';
    end
    
    
    properties (Access = public)
        height_ = 1.7;
        period_ = 1;   % time for 2 step of wolking
    end
    
    
    methods
        % --- Initialisation
        function obj = TargetHuman( absV, height, position, traceType )
            if nargin == 0
                absV = 1;
                height = 1.7;
                position = [0 0 0];
                traceType = TraceReclinear;
            end
            obj = obj@Target( position, traceType );
            obj.period_ = 1 / absV;
            obj.height_ = height;
            
            load targethuman  % Load F and M, Females and Males -- and a surprise.
            obj.V_ = (M + F) / 2;  % Coefficient matrix.
            obj.omega_ = 2*pi/obj.period_;
            obj.dt_ = 2*pi/obj.omega_/obj.fps_;
        end
        
        
        % --- Overloading
        function pX = pointState( obj, t )
            if size(t,2) ~=1
               error('lol T - should be column') 
            end
            c = [   ones(size(t))       ...
                    sin(obj.omega_*t)   ...
                    cos(obj.omega_*t)   ...
                    sin(2*obj.omega_*t) ... 
                    cos(2*obj.omega_*t)     ]' ;
            
            X = reshape((obj.V_ * c)', size(t,1), 15, 3) / 1000;
            pX = X;
            pX(:,:,1) = X(:,:,2);
            pX(:,:,2) = X(:,:,1);
            %pX = pX(:,1,:);
            %posArr(1,:,:) = pX;
        end
        
        
        % ---
        function drawState( obj, posArr, ax )
            posArr = squeeze(posArr);
            L = obj.L_;
            qx = nan(length(L{3}),length(L));
            qy = nan(size(qx));
            qz = nan(size(qx));
            
            for k = 1:4
                qx(1:length(L{k}),k) = posArr(L{k},1);
                qy(1:length(L{k}),k) = posArr(L{k},2);
                qz(1:length(L{k}),k) = posArr(L{k},3);
            end
            
             hp = plot3(ax, qx, qy, qz,'bo-',...
                'markerfacecolor', 'b', ...
                'markersize', 2);
            obj.handlePlot_ = [obj.handlePlot_  hp'];
        end
         
        
        
        % ---
        function draw( obj, t, ax )
            posArr =  squeeze( obj.getPosition( t(1, 1) ) );
            
            L = obj.L_;
            qx = nan(length(L{3}),length(L));
            qy = nan(size(qx));
            qz = nan(size(qx));
            
            for k = 1:4
                qx(1:length(L{k}),k) = posArr(L{k},1);
                qy(1:length(L{k}),k) = posArr(L{k},2);
                qz(1:length(L{k}),k) = posArr(L{k},3);
            end
            
             hp = plot3(ax, qx, qy, qz,'bo-',...
                'markerfacecolor', 'b', ...
                'markersize', 2);
            obj.handlePlot_ = [obj.handlePlot_  hp'];
        end
        
    end
    
    
end





































