function [p, v] = info(this)
%INFO   Return the info for the object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:Numerator')), ...
     getString(message('signal:dfilt:info:Denominator')), ...
     getString(message('signal:dfilt:info:Input')), ...
     getString(message('signal:dfilt:info:Output')), ...
     getString(message('signal:dfilt:info:NumeratorProd')), ...
     getString(message('signal:dfilt:info:DenominatorProd')), ...
     getString(message('signal:dfilt:info:NumeratorAccum')), ...
     getString(message('signal:dfilt:info:DenominatorAccum')), ...
     getString(message('signal:dfilt:info:RoundMode')), ...
     getString(message('signal:dfilt:info:OverflowMode'))};

if this.Signed
    pre = 's';
else
    pre = 'u';
end

v = {formatinfo(this,pre,this.CoeffWordLength, ...
this.NumFracLength), ...
formatinfo(this,pre,this.CoeffWordLength, ...
this.DenFracLength), ...
formatinfo(this,'s',this.InputWordLength, ...
this.InputFracLength), ...
formatinfo(this,'s',this.OutputWordLength, ...
this.OutputFracLength), ...
formatinfo(this,'s',this.ProductWordLength, ...
this.NumProdFracLength), ...
formatinfo(this,'s',this.ProductWordLength, ...
this.DenProdFracLength), ...
formatinfo(this,'s',this.AccumWordLength, ...
this.NumAccumFracLength), ...
formatinfo(this,'s',this.AccumWordLength, ...
this.DenAccumFracLength), ...
this.RoundMode, ...
this.OverflowMode};

if ~strcmpi(this.AccumMode, 'FullPrecision')
    p{end+1} = getString(message('signal:dfilt:info:CastBeforeSum'));
    v{end+1} = mat2str(this.CastBeforeSum);
end

% [EOF]
