function ax = setAxesPlan( XYo, ax )
%SETAXESPLAN 
if nargin == 1
    ax = axes;
    XYo = [0 0];
end

set(ax, 'NextPlot', 'add');
cla(ax)
grid(ax, 'on');
view(ax, [-90 90])
%box(ax1, 'on')
Lim = 10;
xlim(ax, [- Lim  Lim ] * 1.1 + XYo(1))
ylim(ax, [- Lim  Lim ] * 1.1 + XYo(2))
zlim(ax, [0  Lim ] * 1.1 )

xlabel(ax, 'X, [ m ]')
ylabel(ax, 'Y, [ m ]')

daspect(ax, [1 1 1])
GlobAxis(ax);
view(ax, [-30 30])
end

