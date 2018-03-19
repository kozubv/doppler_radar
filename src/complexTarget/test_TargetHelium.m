clear
clc


t1 = TargetHelium(1, 10);
%t1 = Target([0 0 0])

for t = 0:1e-3:0.1
    tic
    t1.drawObj(t);
    toc
    pause(0.01)
    drawnow
end




