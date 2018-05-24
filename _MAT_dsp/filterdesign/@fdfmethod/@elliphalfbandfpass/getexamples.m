function examples = getexamples(this)
%GETEXAMPLES Get the examples.

%   Copyright 2007 The MathWorks, Inc.

examples = {{ ...
    'Design an elliptic lowpass halfband IIR filter of 11th order',...
    '% and with a transition width of .05.',...
    'N = 11; % Filter order must be odd',...
    'TW = .05;',...
    'd = fdesign.halfband(''Type'',''Lowpass'',''N,TW'',N,TW);',...
    'Hd = design(d,''ellip'');',...
    'fvtool(Hd)'}};

% [EOF]
