function examples = getexamples(this)
%GETEXAMPLES   Get the examples.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


examples = {{ ...
    'Design a quasi linear phase halfband lowpass IIR filter of 32nd order ',...
    '% and a transition width of 0.2.',...
    'N = 32; % Must be a multiple of 4',...
    'TW = 0.2;',...
    'd = fdesign.halfband(''Type'',''Lowpass'',''N,TW'',N,TW);',...
    'Hd = design(d,''iirlinphase'');',...
    'fvtool(Hd)'}};

% [EOF]
