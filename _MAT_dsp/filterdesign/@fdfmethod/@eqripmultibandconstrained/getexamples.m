function examples = getexamples(~)
%GETEXAMPLES Get the examples.

%   Copyright 2011 The MathWorks, Inc.

examples = {{ ...
    'Design an unconstrained highpass filter. Add a constraint to increase the',...
    '%           stopband attenuation. Force the response at 0.15*pi rad/sample to to 0 dB.',...
    'd = fdesign.arbmag(''N,B,F,A,C'',82,2);',...
    'd.B1Frequencies = [0 0.06 .1];',...
    'd.B1Amplitudes = [0 0 0];',...
    'd.B2Frequencies = [.15 1];',...
    'd.B2Amplitudes = [1 1];',...    
    'Hd1 = design(d,''equiripple'',''B2ForcedFrequencyPoints'',0.15);',...
    '% Specify the first band as a constrained band. Specify a ripple of 0.001.',...
    'd.B1Constrained = true;',...
    'd.B1Ripple = 0.001;',...
    'Hd2 = design(d,''equiripple'',''B2ForcedFrequencyPoints'',0.15);',...
    'fvtool(Hd1,Hd2,''legend'',''on'')'}};       

% [EOF]


% [EOF]
