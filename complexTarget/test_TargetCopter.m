clear
clc


trace1 = TraceCircle(10, 5);
%trace1 = TraceReclinear([1 0 0], [90 0]);

t1 = TargetCopter(6, 10, [0 0 0], trace1);

t1.pointState((1)');
t1.drawObj(1);


for t = 0:1e-2:10
    tic
    t1.drawObj(t);
    toc
    pause(0.01)
    drawnow
end

% t = 0:1e-2:5;
% r = t1.getTargetDistanse( t' );