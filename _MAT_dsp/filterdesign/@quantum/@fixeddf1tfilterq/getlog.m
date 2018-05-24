function [ol,nstl,dstl,multl,npl,dpl,naccl,daccl] = getlog(this, ...
    y,nstates,dstates,multiplicand,num,den,numAcc,denAcc,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

ol  = get(getqloggerstruct(y,0)); 
ol.Range = double(range(y));

nstl  = get(getqloggerstruct(nstates,0)); 
nstl.Range = double(range(nstates));

dstl  = get(getqloggerstruct(dstates,0)); 
dstl.Range = double(range(dstates));

multl  = get(getqloggerstruct(multiplicand,0)); 
multl.Range = double(range(multiplicand));

npl = get(getqloggerstruct(num,2));
npl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

if length(den)>1,
    dpl = get(getqloggerstruct(den,2));
else
    resetlog(den);
    dpl = get(getqloggerstruct(den,0));
end
dpl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath2.ProductFractionLength])));

naccl = get(getqloggerstruct(numAcc,0)); 
naccl.Range = double(range(numAcc));

daccl = get(getqloggerstruct(denAcc,0)); 
daccl.Range = double(range(denAcc));

% Number of Operations
numcoeffs = prod(size(num));
dencoeffs = prod(size(den));
ol.NOperations = prod(size(y));
npl.NOperations = numcoeffs*ol.NOperations;
naccl.NOperations = max((numcoeffs-1),1)*ol.NOperations;
dpl.NOperations = (dencoeffs-1)*ol.NOperations;
daccl.NOperations = max((dencoeffs-1),1)*ol.NOperations;

% Complex cases
if ~isreal(y),
    ol.NOperations = 2*ol.NOperations;
end
nstl.NOperations = (numcoeffs-1)*ol.NOperations;
dstl.NOperations = (dencoeffs-1)*ol.NOperations;
multl.NOperations = ol.NOperations;

if ((isreal(den) && ~isreal(x)) || ...
        (isreal(x) && ~isreal(den))),
    % Real coeff/Complex input or Complex coeff/Real input
    dpl.NOperations = 2*dpl.NOperations;
    daccl.NOperations = 2*daccl.NOperations;
    if isreal(num),
        npl.NOperations = 2*npl.NOperations;
        naccl.NOperations = 2*naccl.NOperations;
    else
        naccl.NOperations = 2*naccl.NOperations + 2*npl.NOperations;
        npl.NOperations = 4*npl.NOperations;
    end
elseif ~isreal(den) && ~isreal(x),
    daccl.NOperations = 2*daccl.NOperations + 2*dpl.NOperations;
    dpl.NOperations = 4*dpl.NOperations;  
    if isreal(num),
        npl.NOperations = 2*npl.NOperations;
        naccl.NOperations = 2*naccl.NOperations;
    else
        naccl.NOperations = 2*naccl.NOperations + 2*npl.NOperations;
        npl.NOperations = 4*npl.NOperations;        
    end
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
naccl.NOverflows = min(naccl.NOverflows,naccl.NOperations);
daccl.NOverflows = min(daccl.NOverflows,daccl.NOperations);

% [EOF]


