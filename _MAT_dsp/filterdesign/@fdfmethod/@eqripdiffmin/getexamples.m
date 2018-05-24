function examples = getexamples(this)
%GETEXAMPLES   Get the examples.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

examples = {{ ...
    'Design a type IV equiripple differentiator with a passband ripple of 0.1 dB.', ...
    'h  = fdesign.differentiator(''Ap'', .1);', ...
    'Hd = design(h, ''equiripple'', ''FilterStructure'', ''dfasymfir'');', ...
    'fvtool(Hd, ''MagnitudeDisplay'',''Magnitude'')'}};

% [EOF]
