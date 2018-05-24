function [z2, p2, k2, allpassnum, allpassden] = zpklp2bsc(z, p, k, wo, wt)
%ZPKLP2BSC Zero-pole-gain lowpass to complex bandstop frequency transformation.
%   [Z2,P2,K2,AllpassNum,AllpassDen] = ZPKLP2BSC(Z,P,K,Wo,Wt) returns zeros,
%   Z2, poles, P2, and gain factor, K2, of the transformed lowpass digital
%   filter as well as the numerator, ALLPASSNUM, and the denominator,
%   ALLPASSDEN, of the allpass mapping filter. The prototype lowpass filter is
%   given with zeros, Z, poles, P, and gain factor, K.
%
%   Inputs:
%     Z          - Zeros of the prototype lowpass filter
%     P          - Poles of the prototype lowpass filter
%     K          - Gain factor of the prototype lowpass filter
%     Wo         - Frequency value to be transformed from the prototype filter.
%                  The frequency should be normalized to be between 0 and 1,
%                  with 1 corresponding to half the sample rate.
%     Wt         - Desired frequency location in the transformed target filter.
%                  The frequency should be normalized to be between -1 and 1,
%                  with 1 corresponding to half the sample rate.
%   Outputs:
%     Z2         - Zeros of the target filter
%     P2         - Poles of the target filter
%     K2         - Gain factor of the target filter
%     AllpassNum - Numerator of the mapping filter
%     AllpassDen - Denominator of the mapping filter
%
%   Example:
%        [b, a]     = ellip(3,0.1,30,0.409);      
%        z          = roots(b);
%        p          = roots(a);
%        k          = b(1);
%        [z2,p2,k2] = zpklp2bsc(z, p, k, 0.5, [0.2, 0.3]);
%        fvtool(b, a, k2*poly(z2), poly(p2));
%
%   See also ZPKFTRANSF.

%   Author(s): Dr. Artur Krukowski, University of Westminster, London, UK.
%   Copyright 1999-2005 The MathWorks, Inc.

% --------------------------------------------------------------------

% Check for number of input arguments
error(nargchk(5, 5, nargin,'struct'));

% Calculate the mapping filter
[allpassnum, allpassden] = allpasslp2bsc(wo, wt);

% Perform the transformation
[z2, p2, k2]             = zpkftransf(z, p, k, allpassnum, allpassden);
