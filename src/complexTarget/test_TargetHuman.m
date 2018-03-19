clear
clc


trace1 = TraceCircle(3, 2);
t1 = TargetHuman(3, 1.7, [3 0 0], trace1);

for t = 0:1e-2:5
    tic
    t1.drawObj([1 1.01]' * t);
    toc
    pause(0.01)
    drawnow
end


t = 0:1e-2:5;
r = t1.getTargetDistanse( t' );








  