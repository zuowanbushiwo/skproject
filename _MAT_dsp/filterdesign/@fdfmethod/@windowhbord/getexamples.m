function examples = getexamples(this)
%GETEXAMPLES Get the examples.

%   Copyright 2007 The MathWorks, Inc.

examples = {{ ...
    'Design a lowpass halfband Windowed FIR filter with a Hamming window.', ...
    'h  = fdesign.halfband(''Type'',''Lowpass'',''N'', 90);', ...
    'Hd = design(h, ''window'', ''Window'', @hamming);', ...
    'fvtool(Hd)'},
    { ...
    'Design a lowpass halfband Windowed FIR filter with a Chebyshev window.', ...
    'h  = fdesign.halfband(''Type'',''Lowpass'',''N'', 90);', ...
    'Hd = design(h, ''window'', ''Window'', {@chebwin,70});', ...
    'fvtool(Hd)'}};

% [EOF]
