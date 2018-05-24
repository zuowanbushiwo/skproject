function [lo,mo] = euclidfactors(Hm)
%EUCLIDFACTORS Integer factors based on Euclid's theorem.
%   [lo,mo] = EUCLIDFACTORS(Hm) returns the integer factors lo and mo such
%   that lo*L-mo*M = -1.  L and M are relatively prime, and represent the
%   interpolation and decimation factors of the multirate filter Hm.
%
% See also MFILT/NSTATES, MFILT/POLYPHASE.

%   Author: P. Pacheco
%   Copyright 1999-2002 The MathWorks, Inc.

Pdelays = Hm.PolyphaseDelays;
lo = Pdelays(1);
mo = Pdelays(2);

% [EOF]