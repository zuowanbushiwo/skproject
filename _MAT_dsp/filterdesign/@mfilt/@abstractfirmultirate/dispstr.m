function s = dispstr(Hd, varargin)
%DISPSTR Display string of coefficients.
%   DISPSTR(Hd) returns a string that can be used to display the coefficients
%   of discrete-time filter Hd.
%

%   Copyright 2007 The MathWorks, Inc.

s = char({[getString(message('signal:dfilt:dfilt:Numerator')) ':']
    dispstr(Hd.filterquantizer, Hd.privpolym(:), varargin{:})});

% [EOF]
