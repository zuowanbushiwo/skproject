function s = getbestprecision(q)
%GETBESTPRECISION Return best precision for Product and Accumulator

%   Author(s): V. Pellissier
%   Copyright 1988-2006 The MathWorks, Inc.

qc = copy(q);
qc.FilterInternals = 'FullPrecision';
s = get(qc);



% [EOF]
