function maxSpeccR = spcc(a,b)

if size(a,2) ~= size(b,2)
    error('time length do not match');
end

N = size(a,2);

repSize = 1;
aRep = repmat(a, [1, repSize]);
bRep = repmat(b, [1, repSize]);

repN = size(aRep, 2);
spccR = [];
for i = 1:2:N/2
    aCorr = aRep(:,i:repN);
    bCorr = bRep(:,1:(repN-i+1));
    spccR = [spccR, corr(aCorr(:), bCorr(:))];
end

maxSpeccR = max(spccR);

