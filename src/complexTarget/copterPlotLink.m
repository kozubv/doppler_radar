function link = copterPlotLink( N )
%COPTERPLOTLINK 
%   направление обхода точек :
%   первая - центра
%   дальше по возрастанию угла

% posArr = [r1 r0 r2 ... c0]

num = N;

for k = 1 : num 
    link{k} = (k - 1) * 3 + [1 2 3] ;
end


end

