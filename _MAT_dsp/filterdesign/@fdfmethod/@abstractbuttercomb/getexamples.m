function examples = getexamples(this)
%GETEXAMPLES   Get the examples.

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

examples = {{ ...
    '% Design a notching comb filter with 7 notches and a notch quality factor',...
    '% of 25. Return the filter with a default df2 structure',...
    'N = 7;',...
    'Q = 25;',...
    'd = fdesign.comb(''notch'',''N,Q'',N,Q);',...
    'Hd = design(d,''butter'');',...
    'fvtool(Hd)'}
    {
    '% Design a peaking comb filter with 15 peaks, a peak bandwidth of 0.01',...
    '% referenced to a -5 dB gain, and a shelving filter order of 5.',...
    '% Return the filter with a df1t structure',...
    'L = 15;',...
    'BW = 0.01;',...
    'GBW = -5;',...
    'Nsh = 5;',...
    'd = fdesign.comb(''peak'',''L,BW,GBW,Nsh'',L,BW,GBW,Nsh);',...
    'Hd = design(d,''butter'',''FilterStructure'',''df1t'');',...
    'fvtool(Hd)'}    
    };


% [EOF]
