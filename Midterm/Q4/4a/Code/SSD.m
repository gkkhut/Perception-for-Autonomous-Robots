function [SSD] = SSD( L, R )
intL = int16(L);
intR = int16(R);
% SSDmatrix = -(L-R).^2;
SSDmatrix = (intL-intR);
SSD = sumsqr(SSDmatrix);
SSD = 0 - SSD;
end