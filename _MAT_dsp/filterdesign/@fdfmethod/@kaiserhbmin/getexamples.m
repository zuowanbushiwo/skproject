function examples = getexamples(this)
%GETEXAMPLES Get the examples.

%   Copyright 2007 The MathWorks, Inc.

examples = {{ ...
    'Design a minimum order halfband lowpass Kaiser windowed filter.', ...
    'TW = 0.1; % Transition Width', ...
    'Ast = 80; % Stopband Attenuation (dB)', ...
    'h  = fdesign.halfband(''Type'',''Lowpass'',''TW,Ast'',TW,Ast);', ...
    'Hd = design(h,''kaiserwin'');', ...
    'fvtool(Hd)'}};
