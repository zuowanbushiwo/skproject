function examples = getexamples(this)
%GETEXAMPLES   Get the examples.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

examples = {{ ...
    'Design a minimum order type IV Hilbert Transformer.',...
    'd = fdesign.hilbert(''TW,Ap'',.2,.5);', ...
    'Hd = design(d,''equiripple'', ''FIRType'', ''4'');', ...
    'fvtool(Hd,''MagnitudeDisplay'',''Zero-phase'',''FrequencyRange'',''[-pi, pi)'')'}, ...
    { ...
    'Design a minimum order type III Hilbert Transformer.',...
    'd = fdesign.hilbert(''TW,Ap'',.2,.5);', ...
    'Hd = design(d,''equiripple'', ''FIRType'', ''3'');', ...
    'fvtool(Hd,''MagnitudeDisplay'',''Zero-phase'',''FrequencyRange'',''[-pi, pi)'')'}};


% [EOF]
