classdef GlobAxis < handle
    
    properties (Constant)
        ax_x = [-1 0 0; 1 0 0];
        ax_y = [0 -1 0; 0 1 0];
        ax_z = [0 0 -1; 0 0 1];
    end
    
    properties
        x; y; z; alph; bet; gam;
        ax; ay; az;
        px; py; pz;     % указатели на плоты осей
        lenAx;
        with = 1;
        cl = 'k';
        
        % контейнер дочерних объектов
        
        
        
    end % properties
    
    
    methods
        % constructor
        function obj = GlobAxis(axs)

            obj.ax = obj.ax_x * axs.XLim(2);
            obj.ay = obj.ax_y * axs.YLim(2);
            obj.az = obj.ax_z * axs.ZLim(2);
            
            drawAx(obj, axs)
        end % constructor
        
       
        % отображение осей на графике
        function drawAx(obj, axs)
            obj.px = plot3(axs, obj.ax(:,1), obj.ax(:,2), obj.ax(:,3), obj.cl,...
                'LineWidth', obj.with);
            obj.py = plot3(axs, obj.ay(:,1), obj.ay(:,2), obj.ay(:,3), obj.cl,...
                'LineWidth', obj.with);
            obj.pz = plot3(axs, obj.az(:,1), obj.az(:,2), obj.az(:,3), obj.cl,...
                'LineWidth', obj.with);    
            % подпись осей X Y Z
            text(axs, axs.XLim(2), 0, 0, ['X']);
            text(axs, 0, axs.YLim(2), 0, ['Y']);
            text(axs, 0, 0, axs.ZLim(2), ['Z']);
        end
        
      
    end % methods
    
end













