function examples = getexamples(this)
%GETEXAMPLES Get the examples.

%   Copyright 2007 The MathWorks, Inc.

examples = {{ ...
    'Design a halfband lowpass equiripple filter with increased stopband attenuation.', ...
    'TW = 0.1; % Transition Width', ...
    'Ast = 80; % Stopband Attenuation (dB)', ...
    'h  = fdesign.halfband(''Type'',''Lowpass'',''TW,Ast'',TW,Ast);', ...
    'Hd = design(h, ''equiripple'', ''StopbandShape'',''linear'',''StopbandDecay'',50);', ...
    'fvtool(Hd)'}};


% [EOF]
