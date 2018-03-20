clc
clear
close all

tr = Transmitter( 0.001+0.0003 );
rdr = Radar( tr );
rIm = RadarImaging(rdr.rangeLim_, tr.period_, 1);


dt = 1e-9;
T = 0 : 0.1 : 6.5;


for n = 1 : (length(T)-1)
    t1 = T(n);
    t2 = T(n+1) - dt;
    tic
    w = rdr.echoComplexTarget( [ t1 t2 ], [] );
    toc
    rIm.pushBuffer( w );
    %rdr.imageTrace( rIm.frameBuffer_ );
    rIm.imageBuffer;
    
    pause(0.05)
    drawnow
end

