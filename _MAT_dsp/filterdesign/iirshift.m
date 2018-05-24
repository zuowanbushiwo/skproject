function [num, den, allpassnum, allpassden] = iirshift(b, a, wo, wt)
%IIRSHIFT IIR real shift frequency transformation.
%   [Num,Den,AllpassNum,AllpassDen] = IIRSHIFT(B,A,Wo,Wt) returns numerator and
%   denominator vectors, NUM and DEN of the transformed lowpass digital filter.
%   It also returns the numerator, ALLPASSNUM, and the denominator of the
%   allpass mapping filter, ALLPASSDEN. The prototype lowpass filter is given
%   with the numerator specified by B and the denominator specified by A.
%
%   Inputs:
%     B          - Numerator of the prototype lowpass filter
%     A          - Denominator of the prototype lowpass filter
%     Wo         - Frequency value to be transformed from the prototype filter.
%     Wt         - Desired frequency location in the transformed target filter.
%   Outputs:
%     Num        - Numerator of the target filter
%     Den        - Denominator of the target filter
%     AllpassNum - Numerator of the mapping filter
%     AllpassDen - Denominator of the mapping filter
%
%   Frequencies must be normalized to be between 0 and 1, with 1 corresponding
%   to half the sample rate.
%
%   Example:
%        [b, a]     = ellip(3, 0.1, 30, 0.409); 
%        [num, den] = iirshift(b, a, 0.5, 0.75);
%        fvtool(b, a, num, den);
%
%   See also IIRFTRANSF, ALLPASSSHIFT and ZPKSHIFT.

%   Author(s): Dr. Artur Krukowski, University of Westminster, London, UK.
%   Copyright 1999-2005 The MathWorks, Inc.

% --------------------------------------------------------------------

% Check for number of input arguments
error(nargchk(4,4,nargin,'struct'));

% Calculate the mapping filter
[allpassnum, allpassden] = allpassshift(wo, wt);

% Perform the transformation
[num, den]               = iirftransf(b, a, allpassnum, allpassden);
