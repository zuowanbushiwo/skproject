function thisreset(Hm)
%THISRESET Reset the private "memory" of the filter.

% This should be a private method - do not use!

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

% Reset the InputOffset properties.
Hm.InputOffset = 0;

% [EOF]
