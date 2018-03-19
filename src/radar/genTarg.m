function distArr = genTarg( t )

r0 = [ 500 550 450 ];
v0 = [ 50 ] / 100;

distArr = v0 .* t + r0 + 0*randn(size(r0));

end

