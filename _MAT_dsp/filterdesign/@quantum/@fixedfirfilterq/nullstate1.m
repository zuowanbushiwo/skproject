function S = nullstate1(q)
%NULLSTATE1   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

inWL = q.InputWordLength;
inFL = q.InputFracLength;
F = fimath('RoundMode', 'round', 'OverflowMode' , 'saturate');
if isempty(inWL),
    S = fi(0);
else
    S = fi(0, 'Signed', true, 'WordLength', inWL, ...
        'FractionLength', inFL, 'fimath', F);
end

% [EOF]
