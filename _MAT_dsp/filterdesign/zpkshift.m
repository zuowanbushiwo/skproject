function [z2, p2, k2, allpassnum, allpassden] = zpkshift(z, p, k, wo, wt)
%ZPKSHIFT Zero-pole-gain real shift frequency transformation.
%   [Z2,P2,K2,AllpassNum,AllpassDen] = ZPKSHIFT(Z,P,K,Wo,Wt) returns zeros, Z2,
%   poles, P2, and gain factor, K2, of the transformed lowpass digital filter.
%   It also returns the numerator, ALLPASSNUM, and the denominator of the
%   allpass mapping filter, ALLPASSDEN. The prototype lowpass filter is
%   given with zeros, Z, poles, P, and gain factor, K.
%
%   Inputs:
%     Z          - Zeros of the prototype lowpass filter
%     P          - Poles of the prototype lowpass filter
%     K          - Gain factor of the prototype lowpass filter
%     Wo         - Frequency value to be transformed from the prototype filter.
%     Wt         - Desired frequency location in the transformed target filter.
%   Outputs:
%     Z2         - Zeros of the target filter
%     P2         - Poles of the target filter
%     K2         - Gain factor of the target filter
%     AllpassNum - Numerator of the mapping filter
%     AllpassDen - Denominator of the mapping filter
%
%   Frequencies must be normalized to be between 0 and 1, with 1 corresponding
%   to half the sample rate.
%
%   Example:
%        [b, a]     = ellip(3,0.1,30,0.409);      
%        z          = roots(b);
%        p          = roots(a);
%        k          = b(1);
%        [z2,p2,k2] = zpkshift(z, p, k, 0.5, 0.25);
%        fvtool(b, a, k2*poly(z2), poly(p2));
%
%   See also ZPKFTRANSF.

%   Author(s): Dr. Artur Krukowski, University of Westminster, London, UK.
%   Copyright 1999-2005 The MathWorks, Inc.

% --------------------------------------------------------------------

% Check for number of input arguments
error(nargchk(5,5,nargin,'struct'));

% Calculate the mapping filter
[allpassnum, allpassden] = allpassshift(wo, wt);

% Perform the transformation
[z2, p2, k2]             = zpkftransf(z, p, k, allpassnum, allpassden);
