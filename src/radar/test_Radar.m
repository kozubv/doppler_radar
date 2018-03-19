clc
clear
close all

tr = Transmitter( 0.001+0.0003 );
rdr = Radar( tr );

t = (0 : 0.1e-6 : 100e-6)';

% a = tr.pulseEmergence( t )

%s1 = tr.sigEnvelope( t );
% s2 = rdr.echoSimpleTarget( t, [0:1e-3:3e-3 4501] + 1.5e3 * 1.03331 );
%plot(t, real(s2), '.-')


%% ------------------------------------------------
w = rdr.echoComplexTarget( [ 0 1.3 ], [] );

%imagesc([0 2e3],[0 1],real(w))

rdr.imageTrace( w )






