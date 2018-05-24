function examples = getexamples(~)
%GETEXAMPLES   Get the examples.

%   Copyright 2010 The MathWorks, Inc.

examples = {{ ...
    'Group delay equalization of a lowpass elliptic filter.', ...
    'Hellip = design(fdesign.lowpass(''N,Fp,Ap,Ast'',4,0.2,1,40),''ellip'');',...
    'f = 0:0.001:0.2;',...
    'g = grpdelay(Hellip,f,2); % samples',...;
    'g1 = max(g)-g;',...       
    '% Design an arbitrary group delay allpass filter to equalize the ',...
    '% group delay of the lowpass filter. Use an 8 order multiband design ',...
    '% and specify a single band.',...
    'hgd = fdesign.arbgrpdelay(''N,B,F,Gd'',8,1,f,g1);',...
    'Hgd = design(hgd,''iirlpnorm'');',...
    'Hcascade = cascade(Hellip,Hgd);',...
    'hfvt = fvtool(Hellip,Hgd,Hcascade,''Analysis'',''grpdelay'',''legend'',''on'');',...
    },...
    {'Group delay equalization of a bandstop Chebyshev filter operating ',...
'%           with a sampling frequency of 1 KHz.',...
    'Fs = 1e3;',...
    'Hcheby2 = design(fdesign.bandstop(''N,Fst1,Fst2,Ast'',6,150,400,1,Fs),''cheby2'');',...    
    'f1 = 0.0:0.5:150; % Hz',...
    'g1 = grpdelay(Hcheby2,f1,Fs).''/Fs; % seconds',...
    'f2 = 400:0.5:500; % Hz',...
    'g2 = grpdelay(Hcheby2,f2,Fs).''/Fs; % seconds',...
    'maxg = max([g1 g2]);',...
    '% Design an arbitrary group delay allpass filter to equalize the ',...
    '% group delay of the bandstop filter. Use a 14 order multiband design ',...
    '% and specify two bands.',...  
    'hgd = fdesign.arbgrpdelay(''N,B,F,Gd'',14,2,f1,maxg-g1,f2,maxg-g2,Fs);',...
    'Hgd = design(hgd,''iirlpnorm'',''MaxPoleRadius'',0.95);',...
    'Hcascade = cascade(Hcheby2,Hgd);',...
    'hfvt = fvtool(Hcheby2,Hgd,Hcascade,''Analysis'',''grpdelay'',''legend'',''on'');',...
    }};


% [EOF]
