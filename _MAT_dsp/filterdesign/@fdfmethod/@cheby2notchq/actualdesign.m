function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

% Design a Cheby1 filter even though it looks like a Cheby2 given the
% stopband ripple
F0 = hs.F0;
Q =  hs.Q;
BW = F0/Q;

[s,g] = designbwparameq(this,hs.FilterOrder,0,-200,-hs.Astop,...
    10*log10(.5),F0*pi,BW*pi,1);

coeffs = {s,g};

% [EOF]
