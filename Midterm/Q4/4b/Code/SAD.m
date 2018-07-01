function [SAD] = SAD( L, R )
intL = int16(L);
intR = int16(R);
%  SAD = abs(L-R);
SAD = abs(intL-intR);
 SAD = sumsqr(SAD);
 SAD = 0 - SAD;
end

