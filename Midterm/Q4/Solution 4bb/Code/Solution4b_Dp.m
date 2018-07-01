clc
clear all
imgL =imread('tsukuba_l.png');
imgR =imread('tsukuba_r.png');
s = 7; %define disparity range
scale = 1; %define size of block
dMap = zeros(size(imgL), 'single'); %empty disparity map
[mr, mc] = size(imgL); %image dimensions
MW = 1e3; %false infinity
% Initialize a 'disparity cost' matrix.
dC = MW * ones(mc, 2 * s + 1, 'single'); %disparity cost
dP = 0.1; % disparity penalty

for m = 1: mr
disp(['Processing image - row ',num2str(m), ' of ', num2str(mr)]);
% Re-initialize the disparity cost matrix.
dC(:) = MW;
minr = max(1, m - scale); %min/max row
maxr = min(mr, m + scale);

for (n = 1 : mc)
minc = max(1, n - scale); %min/max col
maxc = min(mc, n + scale);
dmin = max(-s, 1 - minc); %minimum limit for search
dmax = min( s, mc - maxc); %maximum limit for search
		
for (d = dmin : dmax)
% Left image disparity.
dC(n, d + s + 1) = ... 
sum(sum(abs(imgR(minr:maxr,(minc:maxc)+d) ... %SAD calculation
- imgL(minr:maxr,minc:maxc))));			
end
end

maxI = zeros(size(dC), 'single'); %optimal indices
cp = dC(end, :);
for (j = mc-1:-1:1)
cMW = (mc - j + 1) * MW; 
%v - row vector with min values.
%ix - row vector with row index of min for each column.
[v,ix] = min([cMW cMW cp(1:end-4)+3*dP;
cMW cp(1:end-3)+2*dP;
cp(1:end-2)+dP;
cp(2:end-1);
cp(3:end)+dP;
cp(4:end)+2*dP cMW;
cp(5:end)+3*dP cMW cMW],[],1);
cp = [cMW dC(j,2:end-1)+v cMW];
maxI(j, 2:end-1) = (2:size(dC,2)-1) + (ix - 4);
end
% Recover optimal route.
[~,ix] = min(cp);
dMap(m,1) = ix;

%For each of the remaining pixels in the row...
for (k = 1:(mc-1))
dMap(m,k+1) = maxI(k, ...
max(1, min(size(maxI,2), round(dMap(m,k)) ) ) );
end
end
dMap = dMap - s - 1;
%display
figure(1)
imshow(dMap);
colormap (gca,jet);
figure(2)
depth = 1./dMap;
imshow(depth)
colormap (gca,jet);